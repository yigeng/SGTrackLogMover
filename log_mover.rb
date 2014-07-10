require 'date'
require 'time'
require 'fileutils'

time_span = 5  # process files modified 5 minutes ago
flume_dir = "/root/flume/"
pomelo_log_dir = flume_dir + "sgtrack_logs"
backup_dir = flume_dir + "backup"
spool_dir = flume_dir + "spool"


Dir.foreach(pomelo_log_dir) do |file|
        if File.extname(file) != ".log"
                next
        end
        original_file_path = pomelo_log_dir + '/'+ file
        backup_file_path = backup_dir + '/'+ file
        spool_file_path = spool_dir + '/'+ file

        ctime = Time.parse File.ctime(original_file_path).to_s
        now = Time.parse DateTime.now.to_s

        time_ellapsed = ((now - ctime)/60).round

        if time_ellapsed >= time_span
                # copy the file to backup folder
                FileUtils.cp original_file_path, backup_file_path
                # then mv the file to flume spool folder
                FileUtils.mv  original_file_path, spool_file_path
        end
end
