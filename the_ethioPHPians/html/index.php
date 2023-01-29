<!DOCTYPE html>
<html lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> -->
  </head>

  <body>
		<a href="?visible=test">Test</a>
		<!-- <a href="?hidden=test.php">Hidden</a> -->
        </p>
			<?php
				if (isset($_GET['visible'])) {
					echo "Value: ".$_GET['visible'];
					exit();
				}
				
				if (isset($_GET['hidden']) && !empty($_GET['hidden'])) {
					if (!include($_GET['hidden'])) {
						echo nl2br("\n");
						echo "Successfully crashed. Retrieving flag 1: ";
						$flag = fopen("../flag1", "r");
						echo fread($flag,filesize("../flag1"));
						fclose($flag);
					}
				}
			?>
        </p>
      </main>
    </div>