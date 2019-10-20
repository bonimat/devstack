<?php

// Connects to the XE service (i.e. database) on the "localhost" machine
$conn = oci_connect('moodle.oracle-db[MOODLE]', 'KTiR9xm2', 'app_moodle_con');
if (!$conn) {
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}

$sql = "select instance_name, host_name ".
"from v\$instance ";
$stid = oci_parse($conn, $sql);
oci_execute($stid);

echo "<table border='1'>\n";
while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
    }
    echo "</tr>\n";
}
echo "</table>\n";

?>
