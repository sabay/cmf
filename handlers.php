<?
define('DEBUG', 1);

function tizer_exception_handler(Exception $exception)
{
    $code = $exception->getCode();
    $file = $exception->getFile();
    $line = $exception->getLine();
    $message = $exception->getMessage();
    $trace = str_replace("\n", '<br />', $exception->getTraceAsString());
    $htmlMessage = <<<MESSAGE
        <table width="100%">
            <tr>
                <th>Message:</th>
                <td width="100%">$message</td>
            </tr>
            <tr>
                <th>Code:</th>
                <td>$code</td>
            </tr>
            <tr>
                <th>File:</th>
                <td>$file</td>
            </tr>
            <tr>
                <th>Line:</th>
                <td>$line</td>
            </tr>
            <tr>
                <th>Trace:</th>
                <td>$trace</td>
            </tr>
        </table>
MESSAGE;

//var_dump($exception->getTrace());

    if (isset($_SERVER['REQUEST_URI'])) {
        error_log("Url: {$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
    }
    error_log("Message: $message");
    error_log("Code: $code");
    error_log("File: $file");
    error_log("Line: $line");
    error_log('Trace: '.$exception->getTraceAsString());
    error_log("Request: ".print_r($_REQUEST, true));

    if (defined('DEBUG')) {
        print $htmlMessage;
    } else {
        print_error_message($htmlMessage);
    }
    increment_error_count();
}

function tizer_error_handler($errno, $errstr, $errfile, $errline)
{
    switch ($errno) {
        case E_ERROR:
            $type = 'Error';
            break;
        case E_WARNING:
            $type = 'Warning';
            break;
        case E_NOTICE:
            $type = 'Notice';
            break;
        default:
            $type = 'Unknown';
    }
    $message = <<<MESSAGE
        <table width="100%">
            </tr>
            <tr>
                <th>Message:</th>
                <td width="100%">$errstr</td>
            </tr>
            <tr>
                <th>Error type:</th>
                <td>$type</td>
            </tr>
            <tr>
                <th>File:</th>
                <td>$errfile</td>
            </tr>
            <tr>
                <th>Line:</th>
                <td>$errline</td>
            </tr>
        </table>
MESSAGE;
    if (isset($_SERVER['REQUEST_URI'])) {
        error_log("Url: {$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
    }
    error_log("Message: $errstr");
    error_log("File: $errfile");
    error_log("Line: $errline");
    error_log("Trace: ".array_reverse(debug_backtrace()));
    error_log("Request: ".print_r($_REQUEST, true));

    if (defined('DEBUG')) {
        print $message;
    } else {
        print_error_message($message);
    }
    increment_error_count();
    exit(0);
}

function print_error_message($message)
{
    print str_replace('ERROR_MESSAGE', strip_tags($message),
                      file_get_contents('error.html'));
}

function increment_error_count()
{
    global $cmf;
    $page = array_values(array_filter(explode('/', $_SERVER['REQUEST_URI'])));
    if (count($page) > 1) {
        $cmf->db->query(
            'INSERT INTO profiling_data_cache (date, alias, server_error)
             VALUES (CURDATE(), ?, 1)
             ON DUPLICATE KEY UPDATE server_error = server_error + 1',
            $page[1]
        );
    }
}

set_exception_handler('tizer_exception_handler');
set_error_handler('tizer_error_handler');
