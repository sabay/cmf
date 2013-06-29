<?php
$isWin = strtoupper(substr(PHP_OS, 0, 3)) === 'WIN';
$in = fopen('tmp.tpl', 'r');
while (!feof($in)) {
        $buffer = fgets($in, 4096);
        if (preg_match("/^-----------------------\|(.+)\|/", $buffer, $matches))
                $out= fopen($matches[1], 'w');
        elseif (preg_match("/^-----------------------/", $buffer))
                fclose($out);
        else {
                if (is_resource($out)) {
                        if ($isWin)
                                $buffer = iconv('CP1251', 'utf-8', $buffer);
                        fputs($out, $buffer);
                }
        }
}
fclose($in);
?>
