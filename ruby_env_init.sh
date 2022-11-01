#rbenvの環境構築用スクリプト
#rbenvのインストール
brew install rbenv
brew install ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
source ~/.zshrc
rbenv install 2.7.6  
rbenv rehash            
rbenv global 2.7.6
 