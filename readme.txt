public void GetTenantConfiguration_IsCalled_WithExpectedKeys_ForDataApiAuthenticationSettings()

}; Identityllostürl = "https://identity.example",

expected nen DataApiAuthenticationSettings

TenantId= "tenant-1",

Hosturl = "https://data-api.example",

ApplicationId="app-1",

ClientId= "client-1", ClientSecret "secret-1",

ResourceId="res-1", AxsRegion "us-east-1"

var providerlock new Rock IConfigurationProvider>();

providerflock

Setup(pp.GetTenantConfiguration DataApiAuthenticationSettings>( KeyStore.Constants. TenantId KeyStore.ConfigurationSections.DataApiSettings, KeyStore.DataApi.AuthenticationSettings))

Returns (expected);

actual providerlock.Object.GetTenantConfiguration DataApiAuthenticationSettings>( KeyStore.Constants. Tenant Id, KayStore.ConfigurationSections.DataApiSettings, KeyStore.DataApi.AuthenticationSettings);

actual.Should().BesameAs(expected);

providerlock. Verify(p => p.GetTenantConfiguration DataApiAuthenticationSettings>( KeyStore.Constants. TenantId, KeyStore.ConfigurationSections.DataApiSettings, KeyStore.DataApi.AuthenticationSettings), Times. Once); providerlock. VerifyNootherCalls();