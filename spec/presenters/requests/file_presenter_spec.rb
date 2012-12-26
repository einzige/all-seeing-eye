require 'spec_helper'


describe Requests::FilePresenter do
  let(:diff) { "zero\n-one\n+two\n-three\nfour" }
  subject { described_class.new(diff) }

  it 'assigns diff' do
    subject.diff.should == diff
  end

  describe "#diff_future_lines" do
    it 'returns future lines' do
      subject.diff_future_lines.should == ["zero", "+two", "four"]
    end
  end

  describe "#diff_past_lines" do
    it 'returns past lines' do
      subject.diff_past_lines.should == ["zero", "-one", "-three", "four"]
    end
  end

  describe "#future" do
    it 'returns future file state' do
      subject.future.should == [[0, 'zero'], [1, 'two'], [1, nil], [2, 'four']]
    end

    context "multiple cluster diff" do
      let(:diff) { "-1\n-2\n+3\n+4" }

      its(:future) { should == [[0,'3'], [1,'4']] }
    end

    context "multiple revert cluster diff" do
      let(:diff) { "+3\n+4\n-1\n-2" }

      its(:future) { should == [[0,'3'], [1,'4']] }
    end
  end

  describe "#future_line_numbers" do
    it 'returns line numbers' do
      subject.future_line_numbers.should == [1]
    end
  end

  describe "#lines" do
    it 'returns lines' do
      subject.lines.should == ['zero', '-one', '+two', '-three', 'four']
    end
  end

  describe "#past" do
    it 'returns past file state' do
      subject.past.should == [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    end

    context "multiple cluster diff" do
      let(:diff) { "-1\n-2\n+3\n+4" }

      its(:past) { should == [[0,'1'], [1,'2']] }
    end

    context "multiple revert cluster diff" do
      let(:diff) { "+3\n+4\n-1\n-2" }

      its(:past) { should == [[0,'1'], [1,'2']] }
    end
  end

  describe "#past_line_numbers" do
    it 'returns line numbers' do
      subject.past_line_numbers.should == [1, 2]
    end
  end
end