public void GetTenantConfiguration_IsCalled_WithDataApiAuthSettingsKey()

var keyAuth

new NeyAuth

ApplicationId= "app-id",

ClientId= "client-id",

ClientSecret = "client-secret",

IdentityHostLink = "https://identity.example.com",

ResourceId="resource-id",

AwsRegion = "us-east-1"

var mockConfigurationProvider = new Rock IConfigurationProvider>();

nockConfigurationProvider

Setup(x > x.GetTenantConfiguration<HeyAuth>(

KeyStore.ConfigurationSections.ApplicationSetting,

KeyStore.Constant. TenantId, KeyStore.Configuration.Keys.DataAPI AuthSettings)) Returns (keyAuth);

dataApiCredentials = sockConfigurationProvider.Object.GetTenantConfiguration<KeyAuth>( KeyStore.Constant. TenantId,

KeyStore.ConfigurationSections. ApplicationSetting, KeyStore.Configuration.Keys.DataAPI AuthSettings);

Assert. Same (keyAuth, dataApiCredentials); nockConfigurationProvider. Verify(

>x.GetTenantConfiguration<KeyAuth>(

KeyStore. Constant. Tenant Id, KeyStore.ConfigurationSections.ApplicationSetting,

KeyStore.Configuration.Keys.DataAPI AuthSettings),

Times. Once);