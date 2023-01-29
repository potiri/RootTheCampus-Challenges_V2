<form method="post">
	Search: <input type="text" name="search" placeholder="ctf essay">
	<input type="submit">
</form>

<?php
	// Todo: remove in final version
	$password = "" ; // why am i always forgetting this
	
	if (isset($_POST['search']) && !empty($_POST['search'])) {
		echo "Result:<br>";
		if (str_contains($_POST['search'], "essay")) {
			echo "<img src='essay.jpg'>";
		} else {
			$words = Array("Leak", "Breach", "Confidential", "Secret", "Documents");
			$years = Array("2019", "2020", "2021", "2022", "2023", "2024", "2025");
	
			for ($x = 0; $x <= 2; $x++) {
				$word = $words[array_rand($words)];
				$year = $years[array_rand($years)];
				echo "<a href=\"#\">".$word." ".$_POST['search']." ".$year."</a><br>";
			}
		}
	}
?>