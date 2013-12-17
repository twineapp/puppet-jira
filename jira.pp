# Config Variables for Jira
$dbpassword = 'pwd'

# Default path
Exec 
{
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# Create Jira directory and config PostgreSQL
exec 
{ 
    'mkdir-jira':
        command => 'mkdir /opt/atlassian-jira',
        before => Class["jira"],
}
exec 
{ 
    'pg-jira-db':
        command => 'sudo -u postgres psql -c "create database jira;"',
        before => Class["jira"],
}
$pg0 = 'sudo -u postgres psql -c "create user jira with password '
$pg1 = "'${dbpassword}'"
$pg2 = ';"'
exec 
{ 
    'pg-jira-user':
        command => "${pg0}${pg1}${pg2}",
        before => Class["jira"],
}
exec 
{ 
    'pg-jira-privileges':
        command => 'sudo -u postgres psql -c "grant all privileges on database jira to jira;"',
        before => Class["jira"],
}


# Set the default temp directory to use
class { 'deploy':
  tempdir => '/opt/deploy'
}

# Config for puppet-jira
class { 'jira':
  version     => '6.0.1',
  installdir  => '/opt/atlassian-jira',
  homedir     => '/opt/atlassian-jira/jira-home',
  user        => 'jira',
  group       => 'jira',
  dbuser      => 'jira',
  dbpassword  => "${dbpassword}",
  dbserver    => 'localhost',
  javahome    => '/usr/lib/jvm/java-1.6.0-openjdk/',
  downloadURL  => 'http://downloads.atlassian.com/software/jira/downloads/',
}
