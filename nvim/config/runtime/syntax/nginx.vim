" Vim syntax file
" Language: nginx

if exists("b:current_syntax")
  finish
end

setlocal iskeyword+=.
setlocal iskeyword+=/
setlocal iskeyword+=:

sy case match
sy spell notoplevel

sy match ngxVariable '\$\w\+'
sy match ngxVariableBlock '\$\w\+'
sy match ngxVariableString '\$\w\+'
sy region ngxBlock start='{' end='}' transparent fold
sy region ngxBlockParam start='\S' end='}' transparent
sy region ngxString start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=ngxVariableString oneline
sy region ngxString start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=ngxVariableString oneline
sy match ngxComment '\s*#.*$'

sy keyword ngxBoolean on
sy keyword ngxBoolean off

sy keyword ngxConstant last
sy keyword ngxConstant break
sy keyword ngxConstant permanent

sy keyword ngxDirectiveBlock          http         nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          mail         nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          events       nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          server       nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          types        nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          location     nextgroup=ngxBlockParam skipwhite
sy keyword ngxDirectiveBlock          upstream     nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          charset_map  nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          limit_except nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          geo          nextgroup=ngxBlock skipwhite
sy keyword ngxDirectiveBlock          map          nextgroup=ngxBlockParam skipwhite
sy keyword ngxDirectiveBlockDangerous if           nextgroup=ngxBlockParam skipwhite

" Most definitely dangerous
sy keyword ngxDirectiveDangerous rewrite
sy keyword ngxDirectiveSet set
hi link ngxDirectiveSet Define
" Potentially dangerous
sy keyword ngxDirectiveVolatile break
sy keyword ngxDirectiveVolatile return

sy keyword ngxDirectiveInclude include
hi link ngxDirectiveInclude Include

sy keyword ngxDirectiveControl root
sy keyword ngxDirectiveControl alias
sy keyword ngxDirectiveControl internal
sy keyword ngxDirectiveControl try_files
sy keyword ngxDirectiveControl index


sy keyword ngxDirectiveControl error_page

sy keyword ngxDirectiveDeprecated connections
sy keyword ngxDirectiveDeprecated imap
sy keyword ngxDirectiveDeprecated open_file_cache_retest
sy keyword ngxDirectiveDeprecated optimize_server_names
sy keyword ngxDirectiveDeprecated satisfy_any

sy keyword ngxDirective accept_mutex
sy keyword ngxDirective accept_mutex_delay
sy keyword ngxDirective access_log
sy keyword ngxDirective add_after_body
sy keyword ngxDirective add_before_body
sy keyword ngxDirective add_header
sy keyword ngxDirective addition_types
sy keyword ngxDirective aio
sy keyword ngxDirective allow
sy keyword ngxDirective ancient_browser
sy keyword ngxDirective ancient_browser_value
sy keyword ngxDirective auth_basic
sy keyword ngxDirective auth_basic_user_file
sy keyword ngxDirective auth_http
sy keyword ngxDirective auth_http_header
sy keyword ngxDirective auth_http_timeout
sy keyword ngxDirective autoindex
sy keyword ngxDirective autoindex_exact_size
sy keyword ngxDirective autoindex_localtime
sy keyword ngxDirective charset
sy keyword ngxDirective charset_types
sy keyword ngxDirective client_body_buffer_size
sy keyword ngxDirective client_body_in_file_only
sy keyword ngxDirective client_body_in_single_buffer
sy keyword ngxDirective client_body_temp_path
sy keyword ngxDirective client_body_timeout
sy keyword ngxDirective client_header_buffer_size
sy keyword ngxDirective client_header_timeout
sy keyword ngxDirective client_max_body_size
sy keyword ngxDirective connection_pool_size
sy keyword ngxDirective create_full_put_path
sy keyword ngxDirective daemon
sy keyword ngxDirective dav_access
sy keyword ngxDirective dav_methods
sy keyword ngxDirective debug_connection
sy keyword ngxDirective debug_points
sy keyword ngxDirective default_type
sy keyword ngxDirective degradation
sy keyword ngxDirective degrade
sy keyword ngxDirective deny
sy keyword ngxDirective devpoll_changes
sy keyword ngxDirective devpoll_events
sy keyword ngxDirective directio
sy keyword ngxDirective directio_alignment
sy keyword ngxDirective empty_gif
sy keyword ngxDirective env
sy keyword ngxDirective epoll_events
sy keyword ngxDirective error_log
sy keyword ngxDirective eventport_events
sy keyword ngxDirective expires
sy keyword ngxDirective fastcgi_bind
sy keyword ngxDirective fastcgi_buffer_size
sy keyword ngxDirective fastcgi_buffers
sy keyword ngxDirective fastcgi_busy_buffers_size
sy keyword ngxDirective fastcgi_cache
sy keyword ngxDirective fastcgi_cache_key
sy keyword ngxDirective fastcgi_cache_methods
sy keyword ngxDirective fastcgi_cache_min_uses
sy keyword ngxDirective fastcgi_cache_path
sy keyword ngxDirective fastcgi_cache_use_stale
sy keyword ngxDirective fastcgi_cache_valid
sy keyword ngxDirective fastcgi_catch_stderr
sy keyword ngxDirective fastcgi_connect_timeout
sy keyword ngxDirective fastcgi_hide_header
sy keyword ngxDirective fastcgi_ignore_client_abort
sy keyword ngxDirective fastcgi_ignore_headers
sy keyword ngxDirective fastcgi_index
sy keyword ngxDirective fastcgi_intercept_errors
sy keyword ngxDirective fastcgi_max_temp_file_size
sy keyword ngxDirective fastcgi_next_upstream
sy keyword ngxDirective fastcgi_param
sy keyword ngxDirective fastcgi_pass_header
sy keyword ngxDirective fastcgi_pass_request_body
sy keyword ngxDirective fastcgi_pass_request_headers
sy keyword ngxDirective fastcgi_read_timeout
sy keyword ngxDirective fastcgi_send_lowat
sy keyword ngxDirective fastcgi_send_timeout
sy keyword ngxDirective fastcgi_split_path_info
sy keyword ngxDirective fastcgi_store
sy keyword ngxDirective fastcgi_store_access
sy keyword ngxDirective fastcgi_temp_file_write_size
sy keyword ngxDirective fastcgi_temp_path
sy keyword ngxDirective fastcgi_upstream_fail_timeout
sy keyword ngxDirective fastcgi_upstream_max_fails
sy keyword ngxDirective flv
sy keyword ngxDirective geoip_city
sy keyword ngxDirective geoip_country
sy keyword ngxDirective google_perftools_profiles
sy keyword ngxDirective gzip
sy keyword ngxDirective gzip_buffers
sy keyword ngxDirective gzip_comp_level
sy keyword ngxDirective gzip_disable
sy keyword ngxDirective gzip_hash
sy keyword ngxDirective gzip_http_version
sy keyword ngxDirective gzip_min_length
sy keyword ngxDirective gzip_no_buffer
sy keyword ngxDirective gzip_proxied
sy keyword ngxDirective gzip_static
sy keyword ngxDirective gzip_types
sy keyword ngxDirective gzip_vary
sy keyword ngxDirective gzip_window
sy keyword ngxDirective if_modified_since
sy keyword ngxDirective ignore_invalid_headers
sy keyword ngxDirective image_filter
sy keyword ngxDirective image_filter_buffer
sy keyword ngxDirective image_filter_jpeg_quality
sy keyword ngxDirective image_filter_transparency
sy keyword ngxDirective imap_auth
sy keyword ngxDirective imap_capabilities
sy keyword ngxDirective imap_client_buffer
sy keyword ngxDirective index
sy keyword ngxDirective ip_hash
sy keyword ngxDirective keepalive_requests
sy keyword ngxDirective keepalive_timeout
sy keyword ngxDirective kqueue_changes
sy keyword ngxDirective kqueue_events
sy keyword ngxDirective large_client_header_buffers
sy keyword ngxDirective limit_conn
sy keyword ngxDirective limit_conn_log_level
sy keyword ngxDirective limit_rate
sy keyword ngxDirective limit_rate_after
sy keyword ngxDirective limit_req
sy keyword ngxDirective limit_req_log_level
sy keyword ngxDirective limit_req_zone
sy keyword ngxDirective limit_zone
sy keyword ngxDirective lingering_close
sy keyword ngxDirective lingering_time
sy keyword ngxDirective lingering_timeout
sy keyword ngxDirective lock_file
sy keyword ngxDirective log_format
sy keyword ngxDirective log_not_found
sy keyword ngxDirective log_subrequest
sy keyword ngxDirective map_hash_bucket_size
sy keyword ngxDirective map_hash_max_size
sy keyword ngxDirective master_process
sy keyword ngxDirective memcached_bind
sy keyword ngxDirective memcached_buffer_size
sy keyword ngxDirective memcached_connect_timeout
sy keyword ngxDirective memcached_next_upstream
sy keyword ngxDirective memcached_read_timeout
sy keyword ngxDirective memcached_send_timeout
sy keyword ngxDirective memcached_upstream_fail_timeout
sy keyword ngxDirective memcached_upstream_max_fails
sy keyword ngxDirective merge_slashes
sy keyword ngxDirective min_delete_depth
sy keyword ngxDirective modern_browser
sy keyword ngxDirective modern_browser_value
sy keyword ngxDirective msie_padding
sy keyword ngxDirective msie_refresh
sy keyword ngxDirective multi_accept
sy keyword ngxDirective open_file_cache
sy keyword ngxDirective open_file_cache_errors
sy keyword ngxDirective open_file_cache_events
sy keyword ngxDirective open_file_cache_min_uses
sy keyword ngxDirective open_file_cache_valid
sy keyword ngxDirective open_log_file_cache
sy keyword ngxDirective output_buffers
sy keyword ngxDirective override_charset
sy keyword ngxDirective perl
sy keyword ngxDirective perl_modules
sy keyword ngxDirective perl_require
sy keyword ngxDirective perl_set
sy keyword ngxDirective pid
sy keyword ngxDirective pop3_auth
sy keyword ngxDirective pop3_capabilities
sy keyword ngxDirective port_in_redirect
sy keyword ngxDirective postpone_gzipping
sy keyword ngxDirective postpone_output
sy keyword ngxDirective protocol
sy keyword ngxDirective proxy
sy keyword ngxDirective proxy_bind
sy keyword ngxDirective proxy_buffer
sy keyword ngxDirective proxy_buffer_size
sy keyword ngxDirective proxy_buffering
sy keyword ngxDirective proxy_buffers
sy keyword ngxDirective proxy_busy_buffers_size
sy keyword ngxDirective proxy_cache
sy keyword ngxDirective proxy_cache_key
sy keyword ngxDirective proxy_cache_methods
sy keyword ngxDirective proxy_cache_min_uses
sy keyword ngxDirective proxy_cache_path
sy keyword ngxDirective proxy_cache_use_stale
sy keyword ngxDirective proxy_cache_valid
sy keyword ngxDirective proxy_connect_timeout
sy keyword ngxDirective proxy_headers_hash_bucket_size
sy keyword ngxDirective proxy_headers_hash_max_size
sy keyword ngxDirective proxy_hide_header
sy keyword ngxDirective proxy_ignore_client_abort
sy keyword ngxDirective proxy_ignore_headers
sy keyword ngxDirective proxy_intercept_errors
sy keyword ngxDirective proxy_max_temp_file_size
sy keyword ngxDirective proxy_method
sy keyword ngxDirective proxy_next_upstream
sy keyword ngxDirective proxy_pass_error_message
sy keyword ngxDirective proxy_pass_header
sy keyword ngxDirective proxy_pass_request_body
sy keyword ngxDirective proxy_pass_request_headers
sy keyword ngxDirective proxy_read_timeout
sy keyword ngxDirective proxy_redirect
sy keyword ngxDirective proxy_send_lowat
sy keyword ngxDirective proxy_send_timeout
sy keyword ngxDirective proxy_set_body
sy keyword ngxDirective proxy_set_header
sy keyword ngxDirective proxy_ssl_session_reuse
sy keyword ngxDirective proxy_store
sy keyword ngxDirective proxy_store_access
sy keyword ngxDirective proxy_temp_file_write_size
sy keyword ngxDirective proxy_temp_path
sy keyword ngxDirective proxy_timeout
sy keyword ngxDirective proxy_upstream_fail_timeout
sy keyword ngxDirective proxy_upstream_max_fails
sy keyword ngxDirective random_index
sy keyword ngxDirective read_ahead
sy keyword ngxDirective real_ip_header
sy keyword ngxDirective real_ip_recursive
sy keyword ngxDirective recursive_error_pages
sy keyword ngxDirective request_pool_size
sy keyword ngxDirective reset_timedout_connection
sy keyword ngxDirective resolver
sy keyword ngxDirective resolver_timeout
sy keyword ngxDirective rewrite_log
sy keyword ngxDirective rtsig_overflow_events
sy keyword ngxDirective rtsig_overflow_test
sy keyword ngxDirective rtsig_overflow_threshold
sy keyword ngxDirective rtsig_signo
sy keyword ngxDirective satisfy
sy keyword ngxDirective secure_link_secret
sy keyword ngxDirective send_lowat
sy keyword ngxDirective send_timeout
sy keyword ngxDirective sendfile
sy keyword ngxDirective sendfile_max_chunk
sy keyword ngxDirective server_name_in_redirect
sy keyword ngxDirective server_names_hash_bucket_size
sy keyword ngxDirective server_names_hash_max_size
sy keyword ngxDirective server_tokens
sy keyword ngxDirective set_real_ip_from
sy keyword ngxDirective smtp_auth
sy keyword ngxDirective smtp_capabilities
sy keyword ngxDirective smtp_client_buffer
sy keyword ngxDirective smtp_greeting_delay
sy keyword ngxDirective so_keepalive
sy keyword ngxDirective source_charset
sy keyword ngxDirective ssi
sy keyword ngxDirective ssi_ignore_recycled_buffers
sy keyword ngxDirective ssi_min_file_chunk
sy keyword ngxDirective ssi_silent_errors
sy keyword ngxDirective ssi_types
sy keyword ngxDirective ssi_value_length
sy keyword ngxDirective ssl
sy keyword ngxDirective ssl_certificate
sy keyword ngxDirective ssl_certificate_key
sy keyword ngxDirective ssl_ciphers
sy keyword ngxDirective ssl_client_certificate
sy keyword ngxDirective ssl_crl
sy keyword ngxDirective ssl_dhparam
sy keyword ngxDirective ssl_engine
sy keyword ngxDirective ssl_prefer_server_ciphers
sy keyword ngxDirective ssl_protocols
sy keyword ngxDirective ssl_session_cache
sy keyword ngxDirective ssl_session_timeout
sy keyword ngxDirective ssl_verify_client
sy keyword ngxDirective ssl_verify_depth
sy keyword ngxDirective starttls
sy keyword ngxDirective stub_status
sy keyword ngxDirective sub_filter
sy keyword ngxDirective sub_filter_once
sy keyword ngxDirective sub_filter_types
sy keyword ngxDirective tcp_nodelay
sy keyword ngxDirective tcp_nopush
sy keyword ngxDirective thread_stack_size
sy keyword ngxDirective timeout
sy keyword ngxDirective timer_resolution
sy keyword ngxDirective types_hash_bucket_size
sy keyword ngxDirective types_hash_max_size
sy keyword ngxDirective underscores_in_headers
sy keyword ngxDirective uninitialized_variable_warn
sy keyword ngxDirective use
sy keyword ngxDirective user
sy keyword ngxDirective userid
sy keyword ngxDirective userid_domain
sy keyword ngxDirective userid_expires
sy keyword ngxDirective userid_mark
sy keyword ngxDirective userid_name
sy keyword ngxDirective userid_p3p
sy keyword ngxDirective userid_path
sy keyword ngxDirective userid_service
sy keyword ngxDirective valid_referers
sy keyword ngxDirective variables_hash_bucket_size
sy keyword ngxDirective variables_hash_max_size
sy keyword ngxDirective worker_connections
sy keyword ngxDirective worker_cpu_affinity
sy keyword ngxDirective worker_priority
sy keyword ngxDirective worker_processes
sy keyword ngxDirective worker_rlimit_core
sy keyword ngxDirective worker_rlimit_nofile
sy keyword ngxDirective worker_rlimit_sigpending
sy keyword ngxDirective worker_threads
sy keyword ngxDirective working_directory
sy keyword ngxDirective xclient
sy keyword ngxDirective xml_entities
sy keyword ngxDirective xslt_stylesheet
sy keyword ngxDirective xslt_types

sy keyword ngxDirective server_name
sy keyword ngxDirective listen
sy keyword ngxDirective proxy_pass
sy keyword ngxDirective memcached_pass
sy keyword ngxDirective fastcgi_pass
sy keyword ngxDirective post_action
sy keyword ngxDirective etag

" 3rd party module list:
" http://wiki.nginx.org/Nginx3rdPartyModules

" Accept Language Module <http://wiki.nginx.org/NginxAcceptLanguageModule>
" Parses the Accept-Language header and gives the most suitable locale from a list of supported locales.
sy keyword ngxDirectiveThirdParty set_from_accept_language

" Access Key Module <http://wiki.nginx.org/NginxHttpAccessKeyModule>
" Denies access unless the request URL contains an access key. 
sy keyword ngxDirectiveThirdParty accesskey
sy keyword ngxDirectiveThirdParty accesskey_arg
sy keyword ngxDirectiveThirdParty accesskey_hashmethod
sy keyword ngxDirectiveThirdParty accesskey_signature

" Auth PAM Module <http://web.iti.upv.es/~sto/nginx/>
" HTTP Basic Authentication using PAM.
sy keyword ngxDirectiveThirdParty auth_pam
sy keyword ngxDirectiveThirdParty auth_pam_service_name

" Cache Purge Module <http://labs.frickle.com/nginx_ngx_cache_purge/>
" Module adding ability to purge content from FastCGI and proxy caches.
sy keyword ngxDirectiveThirdParty fastcgi_cache_purge
sy keyword ngxDirectiveThirdParty proxy_cache_purge

" Chunkin Module <http://wiki.nginx.org/NginxHttpChunkinModule>
" HTTP 1.1 chunked-encoding request body support for Nginx.
sy keyword ngxDirectiveThirdParty chunkin
sy keyword ngxDirectiveThirdParty chunkin_keepalive
sy keyword ngxDirectiveThirdParty chunkin_max_chunks_per_buf
sy keyword ngxDirectiveThirdParty chunkin_resume

" Circle GIF Module <http://wiki.nginx.org/NginxHttpCircleGifModule>
" Generates simple circle images with the colors and size specified in the URL.
sy keyword ngxDirectiveThirdParty circle_gif
sy keyword ngxDirectiveThirdParty circle_gif_max_radius
sy keyword ngxDirectiveThirdParty circle_gif_min_radius
sy keyword ngxDirectiveThirdParty circle_gif_step_radius

" Drizzle Module <http://github.com/chaoslawful/drizzle-nginx-module>
" Make nginx talk directly to mysql, drizzle, and sqlite3 by libdrizzle.
sy keyword ngxDirectiveThirdParty drizzle_connect_timeout
sy keyword ngxDirectiveThirdParty drizzle_dbname
sy keyword ngxDirectiveThirdParty drizzle_keepalive
sy keyword ngxDirectiveThirdParty drizzle_module_header
sy keyword ngxDirectiveThirdParty drizzle_pass
sy keyword ngxDirectiveThirdParty drizzle_query
sy keyword ngxDirectiveThirdParty drizzle_recv_cols_timeout
sy keyword ngxDirectiveThirdParty drizzle_recv_rows_timeout
sy keyword ngxDirectiveThirdParty drizzle_send_query_timeout
sy keyword ngxDirectiveThirdParty drizzle_server

" Echo Module <http://wiki.nginx.org/NginxHttpEchoModule>
" Brings 'echo', 'sleep', 'time', 'exec' and more shell-style goodies to Nginx config file.
sy keyword ngxDirectiveThirdParty echo
sy keyword ngxDirectiveThirdParty echo_after_body
sy keyword ngxDirectiveThirdParty echo_before_body
sy keyword ngxDirectiveThirdParty echo_blocking_sleep
sy keyword ngxDirectiveThirdParty echo_duplicate
sy keyword ngxDirectiveThirdParty echo_end
sy keyword ngxDirectiveThirdParty echo_exec
sy keyword ngxDirectiveThirdParty echo_flush
sy keyword ngxDirectiveThirdParty echo_foreach_split
sy keyword ngxDirectiveThirdParty echo_location
sy keyword ngxDirectiveThirdParty echo_location_async
sy keyword ngxDirectiveThirdParty echo_read_request_body
sy keyword ngxDirectiveThirdParty echo_request_body
sy keyword ngxDirectiveThirdParty echo_reset_timer
sy keyword ngxDirectiveThirdParty echo_sleep
sy keyword ngxDirectiveThirdParty echo_subrequest
sy keyword ngxDirectiveThirdParty echo_subrequest_async

" Events Module <http://docs.dutov.org/nginx_modules_events_en.html>
" Privides options for start/stop events.
sy keyword ngxDirectiveThirdParty on_start
sy keyword ngxDirectiveThirdParty on_stop

" EY Balancer Module <http://github.com/ry/nginx-ey-balancer>
" Adds a request queue to Nginx that allows the limiting of concurrent requests passed to the upstream.
sy keyword ngxDirectiveThirdParty max_connections
sy keyword ngxDirectiveThirdParty max_connections_max_queue_length
sy keyword ngxDirectiveThirdParty max_connections_queue_timeout

" Fancy Indexes Module <https://connectical.com/projects/ngx-fancyindex/wiki>
" Like the built-in autoindex module, but fancier.
sy keyword ngxDirectiveThirdParty fancyindex
sy keyword ngxDirectiveThirdParty fancyindex_exact_size
sy keyword ngxDirectiveThirdParty fancyindex_footer
sy keyword ngxDirectiveThirdParty fancyindex_header
sy keyword ngxDirectiveThirdParty fancyindex_localtime
sy keyword ngxDirectiveThirdParty fancyindex_readme
sy keyword ngxDirectiveThirdParty fancyindex_readme_mode

" GeoIP Module (DEPRECATED) <http://wiki.nginx.org/NginxHttp3rdPartyGeoIPModule>
" Country code lookups via the MaxMind GeoIP API.
sy keyword ngxDirectiveThirdParty geoip_country_file

" Headers More Module <http://wiki.nginx.org/NginxHttpHeadersMoreModule>
" Set and clear input and output headers...more than "add"!
sy keyword ngxDirectiveThirdParty more_clear_headers
sy keyword ngxDirectiveThirdParty more_clear_input_headers
sy keyword ngxDirectiveThirdParty more_set_headers
sy keyword ngxDirectiveThirdParty more_set_input_headers

" HTTP Push Module <http://pushmodule.slact.net/>
" Turn Nginx into an adept long-polling HTTP Push (Comet) server.
sy keyword ngxDirectiveThirdParty push_buffer_size
sy keyword ngxDirectiveThirdParty push_listener
sy keyword ngxDirectiveThirdParty push_message_timeout
sy keyword ngxDirectiveThirdParty push_queue_messages
sy keyword ngxDirectiveThirdParty push_sender

" HTTP Redis Module <http://people.FreeBSD.ORG/~osa/ngx_http_redis-0.3.1.tar.gz>>
" Redis <http://code.google.com/p/redis/> support.>
sy keyword ngxDirectiveThirdParty redis_bind
sy keyword ngxDirectiveThirdParty redis_buffer_size
sy keyword ngxDirectiveThirdParty redis_connect_timeout
sy keyword ngxDirectiveThirdParty redis_next_upstream
sy keyword ngxDirectiveThirdParty redis_pass
sy keyword ngxDirectiveThirdParty redis_read_timeout
sy keyword ngxDirectiveThirdParty redis_send_timeout

" HTTP JavaScript Module <http://wiki.github.com/kung-fu-tzu/ngx_http_js_module>
" Embedding SpiderMonkey. Nearly full port on Perl module.
sy keyword ngxDirectiveThirdParty js
sy keyword ngxDirectiveThirdParty js_filter
sy keyword ngxDirectiveThirdParty js_filter_types
sy keyword ngxDirectiveThirdParty js_load
sy keyword ngxDirectiveThirdParty js_maxmem
sy keyword ngxDirectiveThirdParty js_require
sy keyword ngxDirectiveThirdParty js_set
sy keyword ngxDirectiveThirdParty js_utf8

" Log Request Speed <http://wiki.nginx.org/NginxHttpLogRequestSpeed>
" Log the time it took to process each request.
sy keyword ngxDirectiveThirdParty log_request_speed_filter
sy keyword ngxDirectiveThirdParty log_request_speed_filter_timeout

" Memc Module <http://wiki.nginx.org/NginxHttpMemcModule>
" An extended version of the standard memcached module that supports set, add, delete, and many more memcached commands.
sy keyword ngxDirectiveThirdParty memc_buffer_size
sy keyword ngxDirectiveThirdParty memc_cmds_allowed
sy keyword ngxDirectiveThirdParty memc_connect_timeout
sy keyword ngxDirectiveThirdParty memc_flags_to_last_modified
sy keyword ngxDirectiveThirdParty memc_next_upstream
sy keyword ngxDirectiveThirdParty memc_pass
sy keyword ngxDirectiveThirdParty memc_read_timeout
sy keyword ngxDirectiveThirdParty memc_send_timeout
sy keyword ngxDirectiveThirdParty memc_upstream_fail_timeout
sy keyword ngxDirectiveThirdParty memc_upstream_max_fails

" Mogilefs Module <http://www.grid.net.ru/nginx/mogilefs.en.html>
" Implements a MogileFS client, provides a replace to the Perlbal reverse proxy of the original MogileFS.
sy keyword ngxDirectiveThirdParty mogilefs_connect_timeout
sy keyword ngxDirectiveThirdParty mogilefs_domain
sy keyword ngxDirectiveThirdParty mogilefs_methods
sy keyword ngxDirectiveThirdParty mogilefs_noverify
sy keyword ngxDirectiveThirdParty mogilefs_pass
sy keyword ngxDirectiveThirdParty mogilefs_read_timeout
sy keyword ngxDirectiveThirdParty mogilefs_send_timeout
sy keyword ngxDirectiveThirdParty mogilefs_tracker

" MP4 Streaming Lite Module <http://wiki.nginx.org/NginxMP4StreamingLite>
" Will seek to a certain time within H.264/MP4 files when provided with a 'start' parameter in the URL. 
sy keyword ngxDirectiveThirdParty mp4

" Nginx Notice Module <http://xph.us/software/nginx-notice/>
" Serve static file to POST requests.
sy keyword ngxDirectiveThirdParty notice
sy keyword ngxDirectiveThirdParty notice_type

" Phusion Passenger <http://www.modrails.com/documentation.html>
" Easy and robust deployment of Ruby on Rails application on Apache and Nginx webservers.
sy keyword ngxDirectiveThirdParty passenger_base_uri
sy keyword ngxDirectiveThirdParty passenger_default_user
sy keyword ngxDirectiveThirdParty passenger_enabled
sy keyword ngxDirectiveThirdParty passenger_log_level
sy keyword ngxDirectiveThirdParty passenger_max_instances_per_app
sy keyword ngxDirectiveThirdParty passenger_max_pool_size
sy keyword ngxDirectiveThirdParty passenger_pool_idle_time
sy keyword ngxDirectiveThirdParty passenger_root
sy keyword ngxDirectiveThirdParty passenger_ruby
sy keyword ngxDirectiveThirdParty passenger_use_global_queue
sy keyword ngxDirectiveThirdParty passenger_user_switching
sy keyword ngxDirectiveThirdParty rack_env
sy keyword ngxDirectiveThirdParty rails_app_spawner_idle_time
sy keyword ngxDirectiveThirdParty rails_env
sy keyword ngxDirectiveThirdParty rails_framework_spawner_idle_time
sy keyword ngxDirectiveThirdParty rails_spawn_method

" RDS JSON Module <http://github.com/agentzh/rds-json-nginx-module>
" Help ngx_drizzle and other DBD modules emit JSON data.
sy keyword ngxDirectiveThirdParty rds_json
sy keyword ngxDirectiveThirdParty rds_json_content_type
sy keyword ngxDirectiveThirdParty rds_json_format
sy keyword ngxDirectiveThirdParty rds_json_ret

" RRD Graph Module <http://wiki.nginx.org/NginxNgx_rrd_graph>
" This module provides an HTTP interface to RRDtool's graphing facilities.
sy keyword ngxDirectiveThirdParty rrd_graph
sy keyword ngxDirectiveThirdParty rrd_graph_root

" Secure Download <http://wiki.nginx.org/NginxHttpSecureDownload>
" Create expiring links.
sy keyword ngxDirectiveThirdParty secure_download
sy keyword ngxDirectiveThirdParty secure_download_fail_location
sy keyword ngxDirectiveThirdParty secure_download_path_mode
sy keyword ngxDirectiveThirdParty secure_download_secret

" SlowFS Cache Module <http://labs.frickle.com/nginx_ngx_slowfs_cache/>
" Module adding ability to cache static files.
sy keyword ngxDirectiveThirdParty slowfs_big_file_size
sy keyword ngxDirectiveThirdParty slowfs_cache
sy keyword ngxDirectiveThirdParty slowfs_cache_key
sy keyword ngxDirectiveThirdParty slowfs_cache_min_uses
sy keyword ngxDirectiveThirdParty slowfs_cache_path
sy keyword ngxDirectiveThirdParty slowfs_cache_purge
sy keyword ngxDirectiveThirdParty slowfs_cache_valid
sy keyword ngxDirectiveThirdParty slowfs_temp_path

" Strip Module <http://wiki.nginx.org/NginxHttpStripModule>
" Whitespace remover.
sy keyword ngxDirectiveThirdParty strip

" Substitutions Module <http://wiki.nginx.org/NginxHttpSubsModule>
" A filter module which can do both regular expression and fixed string substitutions on response bodies.
sy keyword ngxDirectiveThirdParty subs_filter
sy keyword ngxDirectiveThirdParty subs_filter_types

" Supervisord Module <http://labs.frickle.com/nginx_ngx_supervisord/>
" Module providing nginx with API to communicate with supervisord and manage (start/stop) backends on-demand.
sy keyword ngxDirectiveThirdParty supervisord
sy keyword ngxDirectiveThirdParty supervisord_inherit_backend_status
sy keyword ngxDirectiveThirdParty supervisord_name
sy keyword ngxDirectiveThirdParty supervisord_start
sy keyword ngxDirectiveThirdParty supervisord_stop

" Upload Module <http://www.grid.net.ru/nginx/upload.en.html>
" Parses multipart/form-data allowing arbitrary handling of uploaded files.
sy keyword ngxDirectiveThirdParty upload_aggregate_form_field
sy keyword ngxDirectiveThirdParty upload_buffer_size
sy keyword ngxDirectiveThirdParty upload_cleanup
sy keyword ngxDirectiveThirdParty upload_limit_rate
sy keyword ngxDirectiveThirdParty upload_max_file_size
sy keyword ngxDirectiveThirdParty upload_max_output_body_len
sy keyword ngxDirectiveThirdParty upload_max_part_header_len
sy keyword ngxDirectiveThirdParty upload_pass
sy keyword ngxDirectiveThirdParty upload_pass_args
sy keyword ngxDirectiveThirdParty upload_pass_form_field
sy keyword ngxDirectiveThirdParty upload_set_form_field
sy keyword ngxDirectiveThirdParty upload_store
sy keyword ngxDirectiveThirdParty upload_store_access

" Upload Progress Module <http://wiki.nginx.org/NginxHttpUploadProgressModule>
" Tracks and reports upload progress.
sy keyword ngxDirectiveThirdParty report_uploads
sy keyword ngxDirectiveThirdParty track_uploads
sy keyword ngxDirectiveThirdParty upload_progress
sy keyword ngxDirectiveThirdParty upload_progress_content_type
sy keyword ngxDirectiveThirdParty upload_progress_header
sy keyword ngxDirectiveThirdParty upload_progress_json_output
sy keyword ngxDirectiveThirdParty upload_progress_template

" Upstream Fair Balancer <http://wiki.nginx.org/NginxHttpUpstreamFairModule>
" Sends an incoming request to the least-busy backend server, rather than distributing requests round-robin.
sy keyword ngxDirectiveThirdParty fair
sy keyword ngxDirectiveThirdParty upstream_fair_shm_size

" Upstream Consistent Hash <http://wiki.nginx.org/NginxHttpUpstreamConsistentHash>
" Select backend based on Consistent hash ring.
sy keyword ngxDirectiveThirdParty consistent_hash

" Upstream Hash Module <http://wiki.nginx.org/NginxHttpUpstreamRequestHashModule>
" Provides simple upstream load distribution by hashing a configurable variable.
sy keyword ngxDirectiveThirdParty hash
sy keyword ngxDirectiveThirdParty hash_again

" XSS Module <http://github.com/agentzh/xss-nginx-module>
" Native support for cross-site scripting (XSS) in an nginx.
sy keyword ngxDirectiveThirdParty xss_callback_arg
sy keyword ngxDirectiveThirdParty xss_get
sy keyword ngxDirectiveThirdParty xss_input_types
sy keyword ngxDirectiveThirdParty xss_output_type

" highlight

hi link ngxComment Comment
hi link ngxVariable Identifier
hi link ngxVariableBlock Identifier
hi link ngxVariableString PreProc
hi link ngxBlock Normal
hi link ngxString String
hi link ngxBoolean Boolean
hi link ngxConstant Constant

hi link ngxDirectiveBlock Statement
hi link ngxDirectiveControl Type
hi link ngxDirective Keyword
hi link ngxDirectiveThirdParty Keyword

hi link ngxDirectiveDeprecated Error
hi link ngxDirectiveVolatile Special
hi link ngxDirectiveDangerous Special
hi link ngxDirectiveBlockDangerous Constant

let b:current_syntax = "nginx"
