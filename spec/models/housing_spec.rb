# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Housing, type: :model do
  describe '#siao?' do
    context 'for non urgences' do
      let(:housing) do
        create(
          :housing,
          duration: '> 1 an',
          status: 'Étudiant·e',
          resources: 299
        )
      end

      it { expect(housing.siao?).to eq(false) }
    end

    context 'for people with enough resources' do
      let(:housing) do
        create(
          :housing,
          duration: nil,
          status: 'Sans activité',
          resources: 300
        )
      end

      it { expect(housing.siao?).to eq(false) }
    end

    context 'for urgences and without enough resources' do
      let(:housing) do
        create(
          :housing,
          duration: 'Ce soir',
          status: 'Salarié·e',
          resources: 299
        )
      end

      it { expect(housing.siao?).to eq(true) }
    end
  end

  describe '#crous?' do
    context 'for more than a year' do
      let(:housing) do
        create(
          :housing,
          duration: '> 1 an',
          status: 'Étudiant·e',
          resources: 1234
        )
      end

      it { expect(housing.crous?).to eq(false) }
    end

    context 'for a non student' do
      let(:housing) do
        create(
          :housing,
          duration: '<= 1 an',
          status: 'Sans activité',
          resources: 1234
        )
      end

      it { expect(housing.crous?).to eq(false) }
    end

    context 'for students and no more than a year' do
      let(:housing) do
        create(
          :housing,
          duration: '<= 1 an',
          status: 'Étudiant·e',
          resources: 1234
        )
      end

      it { expect(housing.crous?).to eq(true) }
    end
  end

  describe '#pain_d_avoine?' do
    context 'for urgences' do
      let(:housing) do
        create(
          :housing,
          duration: 'Ce soir',
          status: 'Sans activité',
          resources: 300
        )
      end

      it { expect(housing.pain_d_avoine?).to eq(false) }
    end

    context 'for students' do
      let(:housing) do
        create(
          :housing,
          duration: '<= 1 an',
          status: 'Étudiant·e',
          resources: 300
        )
      end

      it { expect(housing.pain_d_avoine?).to eq(false) }
    end

    context 'for people without enough resources' do
      let(:housing) do
        create(
          :housing,
          duration: '<= 1 an',
          status: 'Sans activité',
          resources: 299
        )
      end

      it { expect(housing.pain_d_avoine?).to eq(false) }
    end

    context 'for non urgences, non students and with enough resources' do
      let(:housing) do
        create(
          :housing,
          duration: '<= 1 an',
          status: 'Sans activité',
          resources: 300
        )
      end

      it { expect(housing.pain_d_avoine?).to eq(true) }
    end
  end
end
