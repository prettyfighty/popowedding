# frozen_string_literal: true

class MessagesExportService
  require 'csv'
  include ActionView::Helpers::NumberHelper

  BOM_HEADER = "\xEF\xBB\xBF"

  def initialize(records, prompt, header)
    @records = records
    @prompt = prompt
    @header = header
  end

  def generate_csv_string(controller)
    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << @prompt
      csv << @header
      @records.each do |r|
        csv << public_send("#{controller}_columns", r)
      end
    end
  end

  def output_csv(controller, file_name, is_temp = true)
    file_name = is_temp ? ["#{file_name}-", '.csv'] : "#{file_name}-#{Time.now.strftime("%Y%m%d %H%M%S")}.csv"
    file = is_temp ? Tempfile.new(file_name, "#{Rails.root}/tmp") : File.new(file_name, 'w')
    CSV.open(file, 'wb') do |csv|
      csv.to_io.write BOM_HEADER
      CSV.parse(generate_csv_string(controller)).each { |row| csv << row }
    end
    file.path
  end

  def comments_columns(r)
    [
      r.mask(r.phone_number),
      r.name,
      r.message,
      r.picture.attached? ? r.picture.url : '無',
      r.created_at.strftime("%Y-%m-%d %H:%M:%S"),
      I18n.t("view.common.#{r.win}")
    ]
  end
end
