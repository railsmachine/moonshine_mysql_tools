module MysqlTools

  def mysql_tools(hash = {})
    options = {
      :maatkit => "http://maatkit.googlecode.com/files/maatkit_5014-1_all.deb",
      :xtrabackup => "http://www.percona.com/mysql/xtrabackup/1.0/deb/xtrabackup_1.0_amd64.deb",
    }.merge(hash)

    package 'mytop', :ensure => :installed
    package 'wget', :ensure => :installed
    file '/usr/local/src',
      :ensure => :directory # same here

    exec 'wget mysqltuner.pl && chmod a+x /usr/sbin/mysqltuner.pl',
      :cwd => "/usr/sbin/",
      :creates => "/usr/sbin/mysqltuner.pl",
      :require => package('wget')

    if options[:maatkit]

      maatkit_deb = options[:maatkit].split('/').last

      exec 'wget maatkit',
        :command => "wget #{options[:maatkit]}",
        :cwd => "/usr/local/src",
        :creates => "/usr/local/src/#{maatkit_deb}",
        :require => package('wget')

      package "maatkit",
         :ensure => "installed",
         :provider => "dpkg",
         :source => "/usr/local/src/#{maatkit_deb}",
         :require => exec('wget maatkit')
    end

    if options[:xtrabackup]

      xtrabackup_deb = options[:xtrabackup].split('/').last

      exec 'wget xtrabackup',
        :command => "wget #{options[:xtrabackup]}",
        :cwd => "/usr/local/src",
        :creates => "/usr/local/src/#{xtrabackup_deb}",
        :require => package('wget')
      package "xtrabackup",
         :ensure => "installed",
         :provider => "dpkg",
         :source => "/usr/local/src/#{xtrabackup_deb}",
         :require => exec('wget xtrabackup')
    end
  end
  
end