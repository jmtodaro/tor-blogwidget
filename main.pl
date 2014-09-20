#!/usr/bin/perl
  use open ':std', ':encoding(UTF-8)';
  
  my $url = 'https://blog.torproject.org';
  # Number of posts to show
  my $showPosts = "2";
  # Maximum title characters to allow before truncating
  my $maxLength = "35";

  use LWP::Simple;
  my $content = get $url;
#  die "Couldn't get $url" unless defined $content;

  # Check if we have the right data
  my $check = $content;
  $check =~ m{Tor\s*-\s*Home(.*?)</a>}i;
  my $checkPage = $1;

  my $titleStr = $content;
  my $linkStr = $content;
  my $dateStr = $content;
  my $authorStr = $content;
  $showPosts = $showPosts - 1;

  print "<div class='blogFeed'>
         <div class='blogFirstRow'>
         <h2>Recent Blog Posts</h2>
         </div>";
             
  if ($checkPage) {  # Page check passed
      for my $i (0..$showPosts) { 
	
	# Parse title
	$titleStr =~ m{>(.*?)</a>\s*</h2>}g;
	my $titleVal = $1;
	$titleLength = length($titleVal);
	
	# Check title length and trim if necessary
	if ($titleLength > $maxLength) {
	    $trimLength = $maxLength - 3;
	    $titleTxt = substr($titleVal, 0, $trimLength);
	    $title = "$titleTxt...";
	} else {
	    $title = $titleVal;
	}

	# Parse link
	$linkStr =~ m{<h2 class="title">\s*<a href="(.*?)">}g;
	my $linkSuf = $1;
	my $link = "$url$linkSuf";
	
	# Parse date
	$dateStr =~ m{>(.*?)</abbr>}g;
	my $date = $1;

	# Parse author
	$authorStr =~ m{</abbr>\s*by\s*(.*?)\s*</span>}g;
	my $author = $1;
	
	# Begin html output
	print "<a href=\'$link\' title=\'$titleVal\'>";
	
	# Required for alternating row colors
	if (0 == $i % 2) {
	    print "<div class='blogRow blogRow0'>";
	} else {
	    print "<div class='blogRow blogRow1'>";
	}
	
	print "<p class='blogTitle'>$title</p>
	      <p class='blogDate'>$date</p>
	      <p class='blogAuthor'><a href=\"$url/blogs/$author\">Posted by: <em>$author</em></a></p>
	      </div>
	      </a>";    
      }
      
  } else {	# Page check failed - display message
      print "<div class='blogRow blogRow1'>";
      print "<br /><p class='blogDate' style=\"text-align:center;color:\#999;\"><em>Recent posts are currently unavailable</em></p></div>";    
  }
  
  print "<a href='https://blog.torproject.org' title='Tor Blog Home'>
	<div class='blogRow blogLastRow'>
	<p>View all blog posts &raquo;</p>
	</div>
	</a>
	</div>";
  
