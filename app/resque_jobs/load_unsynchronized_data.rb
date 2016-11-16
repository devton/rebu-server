class LoadUnsynchronizedData
  @queue = 'load_unsynchronized_data'
  def self.perform
    entries = FormEntry.where('synchronized = false or synchronized is null')
    entries.each do |form_entry|
      if not form_entry.widget.mailchimp_segment_id
        form_entry.widget.async_create_mailchimp_segment
      end
      form_entry.async_send_to_mailchimp
    end
  end
end