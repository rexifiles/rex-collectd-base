# rex-collectd-base

<h3>setup()</h3>
Will add the collectd package to the designated server(s)

<h3>influxdb()</h3>
Will add an influxdb network plugin config to the designated server(s)
Required: influxdb =>
Optional: port =>


```
task "setup", make {

  Rex::Collectd::Base::setup();
  Rex::Collectd::Base::influxdb(influxdb=>"influx.web.example.com",port=>"25826");

};
```
