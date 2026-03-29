Flow Description:

FunctionHandler

ValidateSqsEvent: Checks that SQSEvent.Records is not null and not empty. Throws ArgumentException(KeyStore.ErrorConstants.InvalidSqsEvent) if invalid.
SetLogSettings: Loads log configuration from IConfigurationProvider — sets IsTraceLog, IsApiLog, IsExceptionLog on AllocationCallContext.
Read EntityType: Reads MessageAttributes["EntityType"] from each SQS message to determine which promo entity the event represents.
Decompress Message Body: Calls StringHelper.DecompressString(sqsMessage.Body) — messages are compressed before being placed on the queue.
Deserialize to DataLakeMessage<T>: Uses JsonConvert.DeserializeObject<DataLakeMessage<T>> with NullValueHandling.Ignore. Throws ClientSideError.InvalidRequest() if null or wrong type.
Switch on EntityType — 4 supported types:
PromoEntity → DataLakeMessage<PromoResource>
PromoParticipantEntity → DataLakeMessage<Participant>
PromoUsageEntity → DataLakeMessage<PromoUsageResource>
ProvisioningEntity → DataLakeMessage<PromoProvisioningResource>
Any other value → throws InvalidOperationException("Unsupported event type")
Push to DataMesh: Calls _dataForwarderCore.PushEventDataToDataMeshAsync(data, headers, additionalParams). Forwards the event to DataMesh platform via Kinesis for business insights generation.
Log Success / Failure: Logs DataForwarderLambdaSuccess on success. On exception: LogHelper.AddExceptionLog(ex, ex.Message) and rethrows.
Supported Entity Types & Schema Identifiers:

DataMesh team validates payloads against schema identifiers. All 4 entity types must have at least 1 payload sent for schema validation.
#	EntityType (MessageAttribute)	DataLakeMessage<T>	Schema Identifier (DataMesh)	Triggered By
1	PromoEntity	DataLakeMessage<PromoResource>	lnepromocodeprovisionstatus	Apply / Reissue
2	PromoParticipantEntity	DataLakeMessage<Participant>	lnepromocodeprovisionstatus	Apply / Reissue
3	PromoUsageEntity	DataLakeMessage<PromoUsageResource>	lnepromocodeusage	Apply Lambda
4	ProvisioningEntity	DataLakeMessage<PromoProvisioningResource>	lnepromocodeprovisions	Provisioning flow
Sample Function Input:

SQS Event with EntityType in messageAttributes:

{
  "Records": [
    {
      "messageId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "receiptHandle": "MessageReceiptHandle",
      "body": "<compressed-base64-encoded-payload>",
      "attributes": {
        "ApproximateReceiveCount": "1",
        "SentTimestamp": "1523232000000",
        "SenderId": "123456789012",
        "ApproximateFirstReceiveTimestamp": "1523232000001"
      },
      "messageAttributes": {
        "EntityType": {
          "stringValue": "PromoUsageEntity",
          "dataType": "String"
        }
      },
      "eventSource": "aws:sqs",
      "eventSourceARN": "arn:{partition}:sqs:{region}:123456789012:DataMeshQueue",
      "awsRegion": "{region}"
    }
  ]
}
Sample Payloads — All 4 Entity Types:

1. PromoEntity (lnepromocodeprovisionstatus)

{
  "entityType": "PromoEntity",
  "correlationId": "abc-111-xyz",
  "headers": {
    "cnxTenantId": "CHASE",
    "cnxProgramId": "CPG-001",
    "cnxParticipantId": "USR-001",
    "cnxEnvironmentToken": "qa"
  },
  "data": {
    "promoCodeId": "PROMO-001",
    "promoCode": "CHASE500",
    "status": "ACTIVE",
    "clientTenantId": "CHASE",
    "validFrom": "2026-01-01",
    "validTo": "2026-12-31"
  }
}
2. PromoParticipantEntity (lnepromocodeprovisionstatus)

{
  "entityType": "PromoParticipantEntity",
  "correlationId": "abc-222-xyz",
  "headers": {
    "cnxTenantId": "CHASE",
    "cnxProgramId": "CPG-001",
    "cnxParticipantId": "USR-002",
    "cnxEnvironmentToken": "qa"
  },
  "data": {
    "participantId": "USR-002",
    "programId": "CPG-001",
    "promoCodeId": "PROMO-001",
    "tag": "RETENTION",
    "assignedAt": "2026-03-01T10:00:00Z"
  }
}
3. PromoUsageEntity (lnepromocodeusage)

{
  "entityType": "PromoUsageEntity",
  "correlationId": "abc-333-xyz",
  "headers": {
    "cnxTenantId": "CHASE",
    "cnxProgramId": "CPG-001",
    "cnxParticipantId": "USR-003",
    "cnxEnvironmentToken": "qa"
  },
  "data": {
    "promoCodeId": "PROMO-001",
    "promoCode": "CHASE500",
    "usedBy": "USR-003",
    "orderId": "ORDER-9001",
    "usageCount": 1,
    "discountApplied": 50.00,
    "currency": "CASH",
    "usedAt": "2026-03-15T14:30:00Z"
  }
}
4. ProvisioningEntity (lnepromocodeprovisions)

{
  "entityType": "ProvisioningEntity",
  "correlationId": "abc-444-xyz",
  "headers": {
    "cnxTenantId": "CHASE",
    "cnxProgramId": "CPG-001",
    "cnxParticipantId": "USR-004",
    "cnxEnvironmentToken": "qa"
  },
  "data": {
    "promoCodeId": "PROMO-002",
    "promoCode": "SUMMER150",
    "provisioningStatus": "PROVISIONED",
    "clientTenantId": "CHASE",
    "promoType": "ALL_PARTICIPANT",
    "discountType": "FIXED",
    "discountValue": 150.00,
    "currency": "CASH",
    "provisionedAt": "2026-02-01T09:00:00Z"
  }
}
Why DataMesh Lambda?

Generates business insights — booking counts, cancellations, promo usage history
Uses Kinesis for real-time data push to DataMesh platform
Decoupled from main promo flow — all 3 Lambdas publish events independently
Supports 4 entity types covering the full promo lifecycle
Uses Redis + Firehose sinks for logging