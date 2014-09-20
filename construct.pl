#!/usr/bin/perl
  use strict;
  use warnings;
  use open ':std', ':encoding(UTF-8)';
  use LWP::Simple;
  use XML::RSS;

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
      my $rss = XML::RSS->new();
      $rss->parse( $data );
        
      #my $channel = $rss->{channel};
      #my $title   = $channel->{title};
      #my $link    = $channel->{link};
      #my $desc    = $channel->{description};
      my @items;
      my $item;
    
      print "<div class='blogFeed'>
             <div class='blogFirstRow'>
             <h2>Recent Blog Posts</h2>
             </div>";
         
      # Store rss post data in array
      foreach $item ( @{ $rss->{items} } )
      {
        push(@items, $item);
      }

      # Generate posts
      $showPosts = $showPosts - 1;           
      for my $i (0..$showPosts)
      {  
        my $item = $items[$i];
      	my $link  = $item->{link};
      	my $title = $item->{title};
      	my $date = $item->{pubDate};
      	my $author = $item->{dc}->{creator};
      	#my $desc = $item->{description};
      	
      	# Check title length and trim if necessary
      	my $titleLength = length($title);
      	my $titleTrim = $title;
        if ($titleLength > $titleMaxLength)
      	{
    	    my $trimLength = $titleMaxLength - 3;
    	    my $titleTxt = substr($title, 0, $trimLength);
    	    $titleTrim = "$titleTxt...";
      	}
    
      	# Trim date
      	my $dateTrim = substr($date, 0, -15);
      	
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
      	    print "<div class='blogRow blogRow0'>";
      	} else {
      	    print "<div class='blogRow blogRow1'>";
      	}
      	
      	print "<p class='blogTitle'>$titleTrim</p>
      	      <p class='blogDate'>$dateTrim</p>
      	      <p class='blogAuthor'>Posted by: <em>$author</em></p>
      	      </div>
      	      </a>";    
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
