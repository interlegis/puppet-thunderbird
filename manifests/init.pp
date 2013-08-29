#init.pp

class thunderbird (	$maildomain = undef,		#Required
			$accountdomain = undef,		#Required
			$imapserver = undef,		#Required
			$organization = undef,		#Required
			$smtpserver = undef,		#Required
			$ldapuri = undef,		#Optional
			$caldavserver = undef,		#Optional
			$caltimezone = undef,		#Required if caldavserver is set
		) {
	
	package { "thunderbird": ensure => latest }

	file { "/etc/thunderbird/syspref.js":
                owner => root, group => root, mode => 444,
                content => template('thunderbird/syspref.js.erb'),
		require => Package["thunderbird"],
        }
	file { "/usr/lib/thunderbird/thunderbird.cfg":
                owner => root, group => root, mode => 444,
                content => template('thunderbird/thunderbird.cfg.erb'),
		require => File["/etc/thunderbird/syspref.js"],
	}


}
