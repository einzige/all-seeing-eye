require 'spec_helper'


describe Requests::FilePresenter do
  let(:file) { {'patch' => "zero\n-one\n+two\n-three\nfour"} }
  subject { described_class.new(file) }

  it 'assigns diff' do
    subject.diff.should == file['patch']
  end

  describe "#future_map" do
    it 'returns future file state' do
      subject.future_map.should == [[0, 'zero'], [1, '+two'], [2, nil], [2, 'four']]
    end

    context "multiple cluster diff" do
      let(:file) { {'patch' => "-1\n-2\n+3\n+4"} }

      its(:future_map) { should == [[0,'+3'], [1,'+4']] }
    end

    context "multiple revert cluster diff" do
      let(:file) { {'patch' => "+3\n+4\n-1\n-2"} }

      its(:future_map) { should == [[0,'+3'], [1,'+4'], [2, nil], [2, nil]] }
    end

    context "empty lines" do
      let(:file) { {'patch' => "-3\n-4\n1\n2"} }

      its(:future_map) { should == [[0,nil], [0,nil], [0,'1'], [1,'2']] }
    end
  end

  describe "#lines" do
    it 'returns lines' do
      subject.lines.should == ['zero', '-one', '+two', '-three', 'four']
    end
  end

  describe "#past_map" do
    it 'returns past file state' do
      subject.past_map.should == [[0, 'zero'], [1, '-one'], [2, '-three'], [3, 'four']]
    end

    context "multiple cluster diff" do
      let(:file) { {'patch' => "-1\n-2\n+3\n+4"} }

      its(:past_map) { should == [[0,'-1'], [1,'-2']] }
    end

    context "multiple revert cluster diff" do
      let(:file) { {'patch' => "+3\n+4\n-1\n-2"} }

      its(:past_map) { should == [[0, nil], [0, nil], [0,'-1'], [1,'-2']] }
    end

    context "empty lines" do
      let(:file) { {'patch' => "+3\n+4\n1\n2"} }

      its(:past_map) { should == [[0,nil], [0,nil], [0,'1'], [1,'2']] }
    end

    context 'tripple plus' do
      let(:file) { {'patch' => "0\n+1\n+2\n+\n3\n-4"} }

      its(:past_map) { should == [[0,'0'], [1,nil], [1,nil], [1,nil], [1,'3'], [2,'-4']] }
    end
  end

  describe "#split" do
    context 'changes' do
      let(:file) { {'patch' => "zero\n-one\n+two\n-three\nfour"} }

      its(:past) { should == ['zero', '-one', '-three', 'four'] }
      its(:future) { should == ['zero', '+two', nil, 'four'] }
    end

    context "multiple cluster diff" do
      let(:file) { {'patch' => "-1\n-2\n+3\n+4"} }

      its(:past) { should == ['-1', '-2'] }
      its(:future) { should == ['+3', '+4'] }
    end

    context "multiple revert cluster diff" do
      let(:file) { {'patch' => "+3\n+4\n-1\n-2"} }

      its(:past) { should == [nil, nil, '-1', '-2'] }
      its(:future) { should == ['+3', '+4', nil, nil] }
    end

    context "empty lines" do
      let(:file) { {'patch' => "+3\n+4\n1\n2"} }

      its(:past) { should == [nil, nil, '1', '2'] }
      its(:future) { should == ['+3', '+4', '1', '2'] }
    end

    context 'tripple plus' do
      let(:file) { {'patch' => "0\n+1\n+2\n+\n3\n-4"} }

      its(:past) { should == ['0', nil, nil, nil, '3', '-4'] }
      its(:future) { should == ['0', '+1', '+2', '+', '3', nil] }
    end
  end
end