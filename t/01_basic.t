use strict;
use Test::More 0.98;

use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;

subtest 'HTML' => sub {
    my $app = builder {
        enable 'Bootstrap';
        sub {
            return [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ "<h1>Hello</h1>\n<p>World!</p>" ] ];
        }
    };

    test_psgi $app => sub {
        my $server = shift;

        my $res = $server->(GET "http://localhost/");
        is $res->code, 200;
        is $res->content, <<HTML;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

  </head>
  <body>
    <div class="container">
<h1>Hello</h1>
<p>World!</p>
    </div>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  </body>
</html>
HTML
    };
};

subtest 'HTML with head' => sub {
    my $app = builder {
        enable 'Bootstrap';
        sub {
            return [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ "<head><title>Hello!</title></head><h1>Hello</h1>\n<p>World!</p>" ] ];
        }
    };

    test_psgi $app => sub {
        my $server = shift;

        my $res = $server->(GET "http://localhost/");
        is $res->code, 200;
        is $res->content, <<HTML;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
<title>Hello!</title>
  </head>
  <body>
    <div class="container">
<h1>Hello</h1>
<p>World!</p>
    </div>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
  </body>
</html>
HTML
    };
};

subtest 'when not HTML' => sub {
    my $body = "Hello, World!";
    my $app = builder {
        enable 'Bootstrap';
        sub {
            return [ 200, [ 'Content-Type' => 'text/plain' ], [ $body ] ];
        }
    };

    test_psgi $app => sub {
        my $server = shift;

        my $res = $server->(GET "http://localhost/");
        is $res->code, 200;
        is $res->content, $body;
    };
};

done_testing;

