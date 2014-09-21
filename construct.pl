#!/usr/bin/perl
  use strict;
  use warnings;
  use open ':std', ':encoding(UTF-8)';
  use LWP::Simple;

  # RSS feed url
  my $url = 'https://blog.torproject.org/blog/feed';
  # Number of posts to show
  my $showPosts = "2";
  # Maximum characters in post title to allow before truncating
  my $titleMaxLength = "35";
  # Maximum characters in author name to allow before truncating
  my $authorMaxLength = "15";
  
  # Retreive url
  my $data = get( $url );
  
  if ($data) # Url returned data
  {
    my $check = $data;
    $check =~ m{<rss(.*?)>}i;
    my $checkVal = $1;

    if ($checkVal) # Is an rss feed
    {
      my $titleStr = $data;
      my $linkStr = $data;
      my $dateStr = $data;
      my $authorStr = $data;
    
      print "<div class='blogFeed'>
             <div class='blogFirstRow'>
             <h2>Recent Blog Posts</h2>
             </div>";

      # Generate posts
      for my $i (0..$showPosts)
      {  
      	
	# Parse title
	$titleStr =~ m{<title>(.*?)</title>}g;
	my $titleVal = $1;
	my $titleLength = length($titleVal);
	my $title = $titleVal;

	# Check title length and trim if necessary
      	my $titleTrim = $title;
        if ($titleLength > $titleMaxLength)
      	{
    	    my $trimLength = $titleMaxLength - 3;
    	    my $titleTxt = substr($title, 0, $trimLength);
    	    $titleTrim = "$titleTxt...";
      	}
    
	# Parse link
	$linkStr =~ m{<link>(.*?)</link>}g;
	my $link = $1;

	if ($i != 0)
        {
	  # Parse date
	  $dateStr =~ m{<pubDate>(.*?)</pubDate>}g;
	  my $date = $1;

	  # Trim date
	  my $dateTrim = substr($date, 0, -15);

	  # Parse author
	  $authorStr =~ m{<dc:creator>(.*?)\s*</dc:creator>}g;
	  my $author = $1;

	  # Check author length and trim if necessary
	  my $authorLength = length($author);
	  my $authorTrim = $author;
	  if ($authorLength > $authorMaxLength)
	  {
	      my $authorTrimLength = $authorMaxLength - 3;
	      my $authorTxt = substr($author, 0, $authorTrimLength);
	      $authorTrim = "$authorTxt...";
	  }

	  # Begin html output
	  print "<a href=\'$link\' title=\'$title\'>";
	  
	  # Required for alternating row colors - switch blogRow# to change order
	  if (0 == $i % 2) {
	      print "<div class='blogRow blogRow1'>";
	  } else {
	      print "<div class='blogRow blogRow0'>";
	  }
	  
	  print "<p class='blogTitle'>$titleTrim</p>
		<p class='blogDate'>$dateTrim</p>
		<p class='blogAuthor'>Posted by: <em>$authorTrim</em></p>
		</div>
		</a>";    
	}
      }
      
    } else {	# Not an rss feed
      print "<div class='blogRow blogRow1'>";
      print "<br /><p class='blogDate' style=\"text-align:center;color:\#999;line-height:16px;\"><em>Recent posts are temporarily unavailable</em></p></div>";    
    }
  
  } else {	# Url did not return any data
    print "<div class='blogRow blogRow1'>";
    print "<br /><p class='blogDate' style=\"text-align:center;color:\#999;line-height:16px;\"><em>Recent posts are temporarily unavailable</em></p></div>";    
  }
  
  print "<a href='https://blog.torproject.org' title='Tor Blog Home'>
  <div class='blogRow blogLastRow'>
	<p>View all blog posts &raquo;</p>
	</div>
	</a>
	</div>";
