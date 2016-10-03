au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,*/nginx/*.conf,*/nginx/*.inc,*/fastcgi_parms,*/mime.types,*/nginx.conf set filetype=nginx
au BufRead,BufNewFile *.site setfiletype nginx
