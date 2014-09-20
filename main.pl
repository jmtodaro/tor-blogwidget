#!/usr/bin/perl
  use open ':std', ':encoding(UTF-8)';
  my $url = 'https://blog.torproject.org';

  use LWP::Simple;
  my $content = get $url;
  die "Couldn't get $url" unless defined $content;
  
  my $titleStr = $content;
  my $linkStr = $content;
  my $dateStr = $content;
  my $authorStr = $content;
#  while ($titleStr =~ m{>(.*?)</a>\s*</h2>}g) {
  $titleStr =~ m{>(.*?)</a>\s*</h2>}i;
  my $title = $1;

  $linkStr =~ m{<h2 class="title">\s*<a href="(.*?)">}g;
  my $linkSuf = $1;
  my $link = "$url$linkSuf";
  
  $dateStr =~ m{>(.*?)</abbr>}g;
  my $date = $1;

  $authorStr =~ m{</abbr>\s*by\s*(.*?)\s*</span>}g;
  my $author = $1;

print "<a href=\"$link\">$title</a><br />";
print "Posted $date by <a href=\"$url/blogs/$author\">$author</a><br />";
#}
