<?php
    $connection = pg_connect ("host=localhost dbname=site user=postgres password=root");
    if($connection) {
       echo 'connected';
    } else {
        echo 'there has been an error connecting';
    }
    $result = pg_query($connction, "SELECT version()");
if (!$result) {
  echo "An error occurred.\n";
  exit;
}

while ($row = pg_fetch_row($result)) {
  echo "Author: $row[0]  E-mail: $row[1]";
  echo "<br />\n";
}