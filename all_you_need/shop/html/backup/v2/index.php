<!DOCTYPE html>
<html lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="w00d's Hyyper Dyyper Shop">
    <meta name="author" content="w00d">

    <title>w00d's Hyyper Dyyper Shop</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="../cover.css" rel="stylesheet">
  </head>

  <body class="text-center">

    <div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
      <header class="masthead mb-auto">
        <div class="inner">
          <h3 class="masthead-brand">w00d's Hyyper Dyyper Shop</h3>
          <nav class="nav nav-masthead justify-content-center">
            <a class="nav-link active" href="#">Home</a>
          </nav>
        </div>
      </header>

      <main role="main" class="inner cover">
        <h1 class="cover-heading">Under development</h1>
        <p class="lead">
			This is the new version of our shop. We are working hard on implementing some awesome new features as well as improving our security system.
		</p>
		<p class="lead">
		<a href="?feature=upcoming" class="btn btn-lg btn-secondary">Upcoming</a>
        <a href="?feature=shop_ai" class="btn btn-lg btn-secondary">Test Shop AI</a>
		<!-- <a href="?devFeature=upcoming" class="btn btn-lg btn-secondary">Upcoming (DEV)</a> -->
		<!-- <a href="?devFeature=shop_ai" class="btn btn-lg btn-secondary">Test Shop AI (DEV)</a> -->
        </p>
			<!-- maybe enable errors? -->
		  <?php
				error_reporting(0);
				if (isset($_GET['feature']) && !empty($_GET['feature'])) {
					if ($_GET['feature'] == "upcoming") {
						include("upcoming.php");
					} elseif ($_GET['feature'] == "shop_ai") {
						include("shop_ai.php");
					}
				}
				if (isset($_GET['devFeature']) && !empty($_GET['devFeature'])) {
					include($_GET['devFeature'].".php");
				}
			?>
        </p>
        
      </main>

      <footer class="mastfoot mt-auto">
        <div class="inner">
          <p>Made by <a href="#">YFCD | YourFriendlyCampusDev</a></p>
        </div>
      </footer>
    </div>