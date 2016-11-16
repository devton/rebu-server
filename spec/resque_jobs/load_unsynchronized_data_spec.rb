require './app/resque_jobs/load_unsynchronized_data.rb'

RSpec.describe LoadUnsynchronizedData, type: :resque_job do
  describe '#perform' do
    it 'should call the async_send_to_mailchimp method to each entry it receives' do
      spy1 = spy(:FormEntry)
      spy2 = spy(:FormEntry)
      allow(FormEntry).to receive(:where).and_return([spy1, spy2])

      LoadUnsynchronizedData.perform

      expect(spy1).to have_received(:async_send_to_mailchimp).once
      expect(spy2).to have_received(:async_send_to_mailchimp).once
    end

    it 'should call widget\'s async_create_mailchimp_segment if it doesn\'t have the mailchimp_segment_id filled up' do
      spyWidget = spy(:widget, :mailchimp_segment_id => nil)
      formEntry = spy(:FormEntry, :widget => spyWidget)
      allow(FormEntry).to receive(:where).and_return([formEntry])

      LoadUnsynchronizedData.perform

      expect(spyWidget).to have_received(:async_create_mailchimp_segment).once
    end

    it 'should not call widget\'s async_create_mailchimp_segment if it isn\'t necessary' do
      spyWidget = spy(:widget, :mailchimp_segment_id => 'foobar')
      formEntry = spy(:FormEntry, :widget => spyWidget)
      allow(FormEntry).to receive(:where).and_return([formEntry])

      LoadUnsynchronizedData.perform

      expect(spyWidget).not_to have_received(:async_create_mailchimp_segment)
    end
  end
end