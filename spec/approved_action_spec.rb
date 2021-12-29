describe Fastlane::Actions::ApprovedAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The approved plugin is working!")

      Fastlane::Actions::ApprovedAction.run(nil)
    end
  end
end
