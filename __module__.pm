package Rex::Collectd::Influx; 
use Rex -base;
use Rex::Ext::ParamLookup;

# Usage: rex setup 
# Usage: rex plugin-influxdb --influxdb=influx [ --port=12345 ]
# Usage: rex plugin-del --remove=influxdb

desc 'Set up collectd';
task 'setup', sub { 

	my $params   = shift;
	my $influxdb = param_lookup "influxdb";

	unless (param_lookup "influxdb") {
		Rex::Logger::info "You must set the --$_ paramater", 'error';
		return;
	}
	
	pkg "collectd",
		ensure => "installed",
		on_change => sub {
			say "package installed";
		};
	service collectd => ensure => "started";
};

desc 'Add InfluxDB endpoint';
task 'plugin-influxdb', sub {

	unless ( is_installed("collectd") ) {
    		Rex::Logger::info "pkg collectd not detected on this node. Aborting", 'error';
		return;
   	}

	my $influxdb = param_lookup "influxdb";
	my $port     = param_lookup "port" || "25826";

	file "/etc/collectd/collectd.conf.d/network-influxdb.conf",
		content => template("files/etc/collectd.conf.d/network-influcdb.tmpl", conf => { influxdb => "$influxdb", port => "$port" }),
		on_change => sub { 
			say "config updated. ";
			service collectd => "restart";
			}
	};
};
