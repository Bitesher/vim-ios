module IOS
  module Vim
    class CommandInstaller

      def initialize handler
        @handler = handler
      end

      def install
        script.each {|command| VIM.command command}
      end

      def script
        return @script if @script
        @script = []
        install_non_edit_commands
        install_edit_commands
        @script
      end
      private :script

      def install_non_edit_commands
        non_edit_commands.each {|command| install_non_edit_command command}
      end
      private :install_non_edit_commands

      def non_edit_commands
        @handler.methods.grep(/^command_/).map {|name| name.to_s.gsub(/^command_/, "").intern}
      end
      private :non_edit_commands

      def install_non_edit_command(command)
        @script << "autocmd FileType objc,objcpp command! -buffer #{command} :ruby IOS::Vim::command_#{command}(<q-args>)<CR>"
      end
      private :install_non_edit_command

      EDIT_VARIANTS = {
        '' => 'edit',
        'E' => 'edit',
        'V' => 'vsplit',
        'S' => 'split',
        'T' => 'tabedit'
      }

      def install_edit_commands
        edit_commands.each {|command| install_edit_command command}
      end
      private :install_edit_commands

      def install_edit_command(command)
        EDIT_VARIANTS.each do |infix, edit_method|
          variant = edit_command_variant command, infix
          @script << "autocmd FileType objc,objcpp command! -buffer #{variant} :ruby IOS::Vim::edit_command_#{command}('#{edit_method}')<CR>"
        end
      end
      private :install_edit_command

      def edit_commands
        @handler.methods.grep(/^edit_command_/).map {|name| name.to_s.gsub(/^edit_command_/, "").intern}
      end
      private :edit_commands

      def edit_command_variant(command, infix)
        "#{command.to_s[0..0]}#{infix}#{command.to_s[1..-1]}"
      end
      private :edit_command_variant

    end
  end
end
