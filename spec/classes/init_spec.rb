require 'spec_helper'
describe 'gb_backend' do
  on_supported_os.each do |os, facts|
    context 'with specified keycloak and default parameters on #{os}' do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it {
        is_expected.to create_class('gb_backend')

        is_expected.to contain_file('/home/gb/start.sh')
            .with_content(/\s*-Dserver.port=8083\s*/)
            .with_content(/\s*-Dspring.config.additional-location=\/home\/gb\/application\.yml\s*/)
            .with_content(/\s*\/home\/gb\/gb-backend\-0\.1\-SNAPSHOT\.war\s*/)

        is_expected.to contain_file('/home/gb/application.yml')
            .with_content(/\s*server-url:\s*http:\/\/transmart\.example\.com\s*/)
            .with_content(/\s*auth-server-url:\s*http:\/\/keycloak\.example\.com\/auth\s*/)
            .with_content(/\s*realm:\s*test\s*/)
            .with_content(/\s*resource:\s*gb_backend\s*/)
            .with_content(/\s*offlineToken:\s*token\s*/)
            .with_content(/\s*username:\s*gb\s*/)
            .with_content(/\s*password:\s*gb\s*/)
            .with_content(/\s*url:\s*jdbc:postgresql:\/\/localhost:5432\/gb_backend\s*/)

        is_expected.to contain_file('/etc/systemd/system/gb-backend.service')
            .with_content(/\s*ExecStart=\/home\/gb\/start\.sh\s*/)
            .with_content(/\s*User=gb\s*/)
      }
    end

    context 'with specified notification parameters' do
      let(:facts) { facts }
      let(:node) { 'notifications.example.com' }
      it {
        is_expected.to create_class('gb_backend')
        is_expected.to contain_file('/home/gb/application.yml')
            .with_content(/\s*maxNumberOfSets:\s*35\s*/)
            .with_content(/\s*dailyJobTriggerTime:\s*18\-25\s*/)
            .with_content(/\s*from:\s*email@example.com\s*/)
            .with_content(/\s*clientApplicationName:\s*Glowing Bear\s*/)
            .with_content(/\s*clientApplicationUrl:\s*https:\/\/glowingbear.example.com\s*/)
      }
    end

  end


  context 'with no keycloak url specified' do
    let(:node) { 'nokeycloakurl.example.com' }
    it {
        is_expected.to raise_error(/keycloak_server_url/)
    }
  end

  context 'with no keycloak realm specified' do
    let(:node) { 'nokeycloakrealm.example.com' }
    it {
        is_expected.to raise_error(/keycloak_realm/)
    }
  end

  context 'with no keycloak client specified' do
    let(:node) { 'nokeycloakclient.example.com' }
    it {
        is_expected.to raise_error(/keycloak_client_id/)
    }
  end

  context 'with no transmart specified' do
    let(:node) { 'notransmart.example.com' }
    it {
        is_expected.to raise_error(/transmart_server_url/)
    }
  end

  context 'with no offline token specified' do
    let(:node) { 'noofflinetoken.example.com' }
    it {
        is_expected.to raise_error(/keycloak_offline_token/)
    }
  end
end
