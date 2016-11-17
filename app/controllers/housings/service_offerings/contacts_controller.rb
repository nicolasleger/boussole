# encoding: utf-8
# frozen_string_literal: true

module Housings
  module ServiceOfferings
    class ContactsController < ApplicationController
      include ControllerHelpers

      require_feature :housing

      # POST /housings/1/service_offerings/1/contacts
      def create
        load_housing
        load_service_offering
        load_public_service
        build_contact

        # TODO: Service + listener
        if @contact.save
          Mailer.contact_email(@contact, @service_offering, @housing).deliver_now
          redirect_to(
            housing_service_offering_url(@housing, @service_offering),
            notice: t('actioncontroller.notice.contact', response_time: @service_offering.response_time_upper_bound)
          )
        else
          render(template: 'housings/service_offerings/show')
        end
      end
    end
  end
end
