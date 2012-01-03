require 'ios/vim'

describe IOS::Vim::CommandInstaller do

  let(:handler) {Object.new}
  subject {IOS::Vim::CommandInstaller.new handler}

  describe '::install' do
    it 'should install detected edit commands' do
      subject.stub(:edit_commands).and_return([:FoObAr, :Baz])
      subject.should_receive(:install_edit_command).with(:FoObAr)
      subject.should_receive(:install_edit_command).with(:Baz)
      subject.install
    end

    it 'should install detected non-edit commands' do
      subject.stub(:non_edit_commands).and_return([:SlImE, :BaZBaR])
      subject.should_receive(:install_non_edit_command).with(:SlImE)
      subject.should_receive(:install_non_edit_command).with(:BaZBaR)
      subject.install
    end
  end

  describe '::edit_commands' do
    it 'should return :QwErTyUiOp if edit_command_QwErTyUiOp is defined' do
      handler.stub :edit_command_QwErTyUiOp
      subject.send(:edit_commands).should include(:QwErTyUiOp)
    end
  end

  describe '::non_edit_commands' do
    it 'should return :FoBaR if command_FoBaR is defined' do
      handler.stub :command_FoBaR
      subject.send(:non_edit_commands).should include(:FoBaR)
    end
  end

  describe '::install_edit_command' do
    it 'should map the command for each edit "type"' do
      subject.instance_variable_set :@script, []
      subject.send :install_edit_command, :Foobar
      subject.send(:script).should include("autocmd FileType objc,objcpp command! -buffer Foobar :ruby IOS::Vim::edit_command_Foobar('edit')<CR>")
      subject.send(:script).should include("autocmd FileType objc,objcpp command! -buffer FEoobar :ruby IOS::Vim::edit_command_Foobar('edit')<CR>")
      subject.send(:script).should include("autocmd FileType objc,objcpp command! -buffer FVoobar :ruby IOS::Vim::edit_command_Foobar('vsplit')<CR>")
      subject.send(:script).should include("autocmd FileType objc,objcpp command! -buffer FSoobar :ruby IOS::Vim::edit_command_Foobar('split')<CR>")
      subject.send(:script).should include("autocmd FileType objc,objcpp command! -buffer FToobar :ruby IOS::Vim::edit_command_Foobar('tabedit')<CR>")
    end
  end

  describe '::install_non_edit_command' do
    it 'should map the command' do
      subject.instance_variable_set :@script, []
      subject.send :install_non_edit_command, :FooBAR
      subject.send(:script).should == ["autocmd FileType objc,objcpp command! -buffer FooBAR :ruby IOS::Vim::command_FooBAR(<q-args>)<CR>"]
    end
  end

end
