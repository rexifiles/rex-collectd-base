package Rex::Collectd::Base; 
use Rex -base;
use Rex::Ext::ParamLookup;

# Usage: rex setup 
# Usage: rex plugin-influxdb --influxdb=influx [ --port=12345 ]
# Usage: rex plugin-del --remove=influxdb

desc 'Set up collectd';
task 'setup', sub { 

	pkg "collectd",
		ensure => "installed",
		on_change => sub {
			say "package installed";
		};
	service collectd => ensure => "started";
};

desc 'InfluxDB endpoint';
task 'influxdb', sub {

	unless ( is_installed("collectd") ) {
    		Rex::Logger::info "pkg collectd not detected on this node. Aborting", 'error';
		return;
   	}

	my $influxdb = param_lookup "influxdb";
	my $port     = param_lookup "port" || "25826";

	file "/etc/collectd/collectd.conf.d/network-influxdb.conf",
		content => template("files/etc/collectd.conf.d/network-influx.tmpl", conf => { influxdb => "$influxdb", port => "$port" }),
		on_change => sub { 
			say "config updated. ";
			service collectd => "restart";
			}
};
