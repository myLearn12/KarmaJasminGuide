public void GetDataApiClient Fet tDataApiConfig_once()

const string cnxTenantId = "tenant-123";

var dataApiConfig = new DataApiConfig {

AppName = "PromoEngine",

HostLink = "https://data-api.local", TenantId = "fallback-tenant", TimeOutInMs = 60_600,

UseHttps = true

var mockConfigurationProvider = new Mock<IConfigurationProvider>();

mockConfigurationProvider

Setup(x => x.GetTenantConfiguration<DataApiConfig>( It. IsAny<string>(),

DataApiConstants.Configurations.Sections.ApplicationSettings, DataApiConstants.Configurations. figurations.Keys.DataAPI_Settings))

Returns(dataApiConfig);

var factory = new DataApiClientFactory(mockConfigurationProvider.Object);

var client = factory.GetDataApiClient(cnxTenantId);

Assert.NotNull(client);

mockConfigurationProvider.Verify(

x => x.GetTenantConfiguration<DataApiConfig>(

cnxTenantId,

DataApiConstants.Configurations.Sections.ApplicationSettings, DataApiConstants.Configurations.Keys.DataAPI_Settings),

Times. Once); mockConfigurationProvider. VerifyNoOtherCalls();