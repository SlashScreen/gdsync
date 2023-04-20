# frozen_string_literal: true

require 'git'
require 'fileutils'
require 'yaml'

def load_requirements_file(path)	
	# load requirements from file
	reqs = YAML.load_file(path)
	
	reqs.each do |k, v|
		repo = v["repo"]
		src_folder = v["src_folder"]
		dest_folder = v["dest_folder"]
		# clone repo
		if Dir.exists? "#{k}"
			FileUtils.remove_dir "#{k}"
		end
		Git.clone(repo)
		# `git clone --no-checkout #{repo} && cd #{k} && git sparse-checkout init --cone && git sparse-checkout set #{src_folder}`
		# recurse if more addons
		load_requirements_file "#{k}/addons.yaml" if File.exists? "#{k}/addons.yaml"
		# move folder
		FileUtils.mkdir_p "#{dest_folder}" unless Dir.exists? "#{dest_folder}" # make dir if it doesnt already exist
		FileUtils.mv "#{k}/#{src_folder}", "#{dest_folder}/", :force => true
		# remove repo
		FileUtils.remove_dir "#{k}"
	end
end

load_requirements_file "addons.yaml"
