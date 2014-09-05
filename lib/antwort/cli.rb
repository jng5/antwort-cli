require 'thor'

module Antwort
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../../template', File.dirname(__FILE__))
    end

    desc 'init PROJECT_NAME', 'Initializes a new Antwort project'
    method_option :key, type: :string, desc: 'API key of the offsides gem server'
    def init(project_name)
      @project_name = project_name
      @api_key = options[:key]
      copy_project
      initialize_git_repo
      run_bundler
      say "Antwort project initialized in directory ./#{project_directory}/", :green
    end

    desc 'new EMAIL_ID', 'Creates a new Antwort email'
    def new(email_id)
      @email_id = email_id
      copy_email
      say "Antwort email created in directory ./emails/#{email_directory}/", :green
    end

    protected

    attr_reader :project_name, :email_id

    def copy_email
      directory 'email/css',
                File.join('assets', 'css', email_directory)
      directory 'email/images',
                File.join('assets', 'images', email_directory)
      copy_file 'email/email.html.erb',
                File.join('emails', email_directory, 'index.html.erb')
    end

    def copy_project
      directory 'project', project_directory
    end

    def initialize_git_repo
      inside(project_directory) do
        run('git init .')
      end
    end

    def run_bundler
      inside(project_directory) do
        run('bundle')
      end
    end

    def email_directory
      email_id.downcase.gsub(/[^a-z|\-|\_]/, '')
    end

    def project_directory
      project_name.downcase.gsub(/[^a-z|\-|\_]/, '')
    end
  end
end