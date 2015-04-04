au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,*/nginx/*.conf,*/nginx/*.inc,*/fastcgi_parms,*/mime.types,*/nginx.conf set filetype=vim
au BufRead,BufNewFile *.site setfiletype vim
