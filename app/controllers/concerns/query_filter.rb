# frozen_string_literal: true

module QueryFilter
  extend ActiveSupport::Concern

  def query_by_filter_scope(query, filter_hash, column = nil, time_interval = {})
    if filter_hash[:datetime_filter].nil? && time_interval.present?
      time_interval.each do |key, value|
        query = query.public_send("filter_by_#{column}_#{key}", value)
      end
    end
    filter_hash.each do |key, value|
      if key == 'datetime_filter'
        filter_field = value[:type].present? ? value[:type] : :created_at
        value.each do |filter_key, filter_value|
          query = query.public_send("filter_by_#{filter_field}_#{filter_key}", filter_value) if filter_value.present? && filter_key != 'type'
        end
      elsif key == 'win_line' && value.present?
        value = ([:minimum, :maximum].zip(value.split('..'))).to_h
        value.each do |filter_key, filter_value|
          query = query.public_send("filter_by_#{filter_key}_#{key}", filter_value) if filter_value != '0'
        end
      else
        query = query.public_send("filter_by_#{key}", value) if value.present?
      end
    end
    query
  end

  def date_range_exist?(*date_filters)
    date_filters.all? { |key| params[key].present? }
  end

  def set_default_time_interval(days = 3)
    @default_time_interval = {
      start_at: Date.current.ago(days.days).strftime('%Y-%m-%dT%H:%M'),
      end_at: Date.current.end_of_day.strftime('%Y-%m-%dT%H:%M')
    }
  end
end
