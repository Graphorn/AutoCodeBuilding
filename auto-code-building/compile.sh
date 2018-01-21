git clone $1 $2 >/dev/null 2>/dev/null
cd $2
bundle install
rake