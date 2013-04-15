doxygen:
	PROJECT_NAME=ActiveSupportKit $(HOME)/.rvm/bin/rvm-auto-ruby -r XcodePages -e XcodePages.doxygen_docset_install

clean:
	rm -rf ActiveSupportKitPages/html
