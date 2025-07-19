function dev_reload_plug --description
  git add . && git commit -m 'working' && git push origin master && fisher update srk9/srk9.fisher-plugin
end
