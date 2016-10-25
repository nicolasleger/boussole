# encoding: utf-8
# frozen_string_literal: true

RSpec.describe ServiceOffering, type: :model do
  subject(:service_offering) { create(:service_offering, public_service: public_service) }
  let(:public_service)       { create(:public_service) }
  let(:social_right)         { create(:social_right) }

  it { is_expected.to belong_to(:public_service) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:public_service_id) }
  it { is_expected.to validate_presence_of(:public_service) }

  describe '#response_time_upper_bound' do
    context '#public_service with #response_time_upper_bound' do
      before { public_service.update(response_time_upper_bound: 7) }

      it { is_expected.not_to validate_presence_of(:response_time_upper_bound) }
    end

    context '#public_service without #response_time_upper_bound' do
      before { public_service.update(response_time_upper_bound: nil) }

      it { is_expected.to validate_presence_of(:response_time_upper_bound) }
    end
  end

  it 'has_many #social_rights' do
    expect {
      service_offering.social_rights << social_right
    }.to change { service_offering.social_rights.count }.by(1)
  end

  it 'delegates #title to #public_service' do
    expect(service_offering.public_service_title).to eq(public_service.title)
  end
end
