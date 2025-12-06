<?php

$cfg['Servers'][1]['host'] = '172.45.0.2';

$allowed_hosts = [
    ['host' => '172.45.0.2', 'label' => 'MySql 8.0'],
    ['host' => '172.45.0.12', 'label' => 'MySql 8.3'],
    ['host' => '172.45.0.17', 'label' => 'MySql 5.7'],
    // ['host' => '172.21.0.29', 'label' => 'MySql 9.3'],
    // ['host' => '172.21.0.24', 'label' => 'MySql 8.4'],
    // ['host' => '172.21.0.2',  'label' => 'MySql 8.3'],
    // ['host' => '172.21.0.80', 'label' => 'MySql 8.0'],
    // ['host' => '172.21.0.57', 'label' => 'MySql 5.7'],
    // ['host' => '172.21.0.56', 'label' => 'MySql 5.6'],
    // ['host' => '172.21.0.113', 'label' => 'mariaDB 11.3'],
    // ['host' => '172.21.0.111', 'label' => 'mariaDB 10.11'],
    // ['host' => '172.21.0.106',  'label' => 'mariaDB 10.6'],
    // ['host' => '172.21.0.105', 'label' => 'mariaDB 10.5'],
    // ['host' => '172.21.0.103', 'label' => 'mariaDB 10.3'],
];

foreach ($allowed_hosts as $i => $srv) {
    $idx = $i + 1;
    $cfg['Servers'][$idx]['host'] = $srv['host'];
    $cfg['Servers'][$idx]['verbose'] = $srv['label']; // <- Aquí el alias visible
    $cfg['Servers'][$idx]['user'] = 'root';
    $cfg['Servers'][$idx]['auth_type'] = 'cookie';
    $cfg['Servers'][$idx]['connect_type'] = 'tcp';
    $cfg['Servers'][$idx]['AllowNoPassword'] = false;
}

$cfg['AllowArbitraryServer'] = false; // Desactiva el input libre

// Establecer tema por defecto
// $cfg['ThemeDefault'] = 'darkwolf';

// Prellenar usuario por defecto en el login
$cfg['LoginUsername'] = 'root';

$cfg['NavigationTreeEnableGrouping'] = false;
