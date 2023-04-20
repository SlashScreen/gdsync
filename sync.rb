# frozen_string_literal: true

require 'git'
require 'fileutils'
require 'yaml'


# load requirements from file
reqs = YAML.load_file("requirements.yaml")

reqs.each do |k, v|
	repo = v["repo"]
	src_folder = v["src_folder"]
	dest_folder = v["dest_folder"]
	# clone repo
	if Dir.exists? "#{k}"
		FileUtils.remove_dir "#{k}"
	end
	git = Git.clone repo
	# move folder
	unless Dir.exists? "#{dest_folder}"
		FileUtils.mkdir_p "#{dest_folder}"
	end
	FileUtils.mv "#{k}/#{src_folder}", "#{dest_folder}/", :force => true
	# remove repo
	FileUtils.remove_dir "#{k}"
end
