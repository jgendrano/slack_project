<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">

 $(function() { $('body').hide().show(); });
</script>


<script type="text/javascript">

//JavaScript goes here


WebFontConfig = {
  google: { families: ['FontOne', 'FontTwo'] },
    fontinactive: function (fontFamily, fontDescription) {
   //Something went wrong! Let's load our local fonts.
    WebFontConfig = {
      custom: { families: ['FontOne', 'FontTwo'],
      urls: ['font-one.css', 'font-two.css']
    }
  };
  loadFonts();
  }
};

function loadFonts() {
  var wf = document.createElement('script');
  wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
    '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
  wf.type = 'text/javascript';
  wf.async = 'true';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(wf, s);
}

(function () {
  //Once document is ready, load the fonts.
  loadFonts();
  })();

</script>
