module Locomotive
  module Api
    class ContentEntriesController < BaseController

      load_and_authorize_resource({
        class:                Locomotive::ContentEntry,
        through:              :content_type,
        through_association:  :entries
        # find_by:              :permalink
      })

      def index
        @content_entries = @content_entries.order_by([content_type.order_by_definition])
        puts "-----------"
        puts @content_entries.map(&:to_json)[2].inspect
        respond_with @content_entries
      end

      def show
        # @content_entry = @content_type.entries.any_of({ _id: params[:id] }, { _slug: params[:id] }).first
        respond_with @content_entry, status: @content_entry ? :ok : :not_found
      end

      def create
        @content_entry.from_presenter(params[:content_entry])
        @content_entry.save
        puts @content_entry.as_json #inspect
        respond_with @content_entry, location: main_app.locomotive_api_content_entries_url(@content_type.slug)
      end

      def update
        @content_entry.from_presenter(params[:content_entry])
        @content_entry.save
        respond_with @content_entry, location: main_app.locomotive_api_content_entries_url(@content_type.slug)
      end

      def destroy
        @content_entry.destroy
        respond_with @content_entry, location: main_app.locomotive_api_content_entries_url(@content_type.slug)
      end

      protected

      def content_type
        @content_type ||= current_site.content_types.where(slug: params[:slug]).first
      end

    end
  end
end
