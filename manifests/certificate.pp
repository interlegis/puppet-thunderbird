#certificate.pp

define thunderbird::certificate (	$content = undef,
					$source = undef,
				){

	if !($content or $source) {
                fail 'Please provide either $source or $content'
        }
        if ($content and $source) {
                fail 'Please provide either $source OR $content'
        }

	if ! defined(Package['libnss3-tools']) { package { "libnss3-tools": ensure => installed } }

	if ! defined(File['/usr/local/bin/mozilla_cert.sh']) {
		file { "/usr/local/bin/mozilla_cert.sh":
			owner => 'root', group => 'root', mode => '554',
			source => "puppet:///modules/thunderbird/mozilla_cert.sh",
		}	
	}

	file { "/tmp/${name}.crt":
                owner => root, group => root, mode => 440,
                require => Package["libnss3-tools"],
		notify => Exec["add certificate $name"],
        }

        if $content {
                File["/tmp/${name}.crt"] {
                        content => $content,
                }
        } else {
                File["/tmp/${name}.crt"] {
                        source => $source,
                }
        }
	
	exec { "add certificate $name":
		refreshonly => true,
		command => "/usr/local/bin/mozilla_cert.sh ${name} /tmp/${name}.crt",
		require => [ 	Package[ "libnss3-tools" ],
				File["/tmp/${name}.crt"],
		],
	}
}
