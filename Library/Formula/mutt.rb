require 'formula'

class Mutt < Formula
  homepage 'http://www.mutt.org/'
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  sha1 'a8475f2618ce5d5d33bff85c0affdf21ab1d76b9'

  depends_on 'tokyo-cabinet'
  depends_on 'slang' if build.include? 'with-slang'

  option "with-debug", "Build with debug option enabled"
  option "with-sidebar-patch", "Apply sidebar (folder list) patch"
  option "with-trash-patch", "Apply trash folder patch"
  option "with-purge-patch", "Apply purge message patch (requires trash)"
  option "with-trash-patch-bk", "Apply combined trash/purge folder patch"
  option "with-slang", "Build against slang instead of ncurses"
  option "with-ignore-thread-patch", "Apply ignore-thread patch"
  option "with-pgp-verbose-mime-patch", "Apply PGP verbose mime patch"

  def patches
    urls = [
      ['with-sidebar-patch', 'http://lunar-linux.org/~tchan/mutt/patch-1.5.21.sidebar.20120829.txt'],
      ['with-trash-patch', 'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.2/features/trash-folder'],
      ['with-purge-patch', 'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.2/features/purge-message'],
      ['with-trash-patch-bk', 'https://raw.github.com/kuperman/Mutt-Trash-Purge-patch/master/patch-1.5.20.bk.trash_folder-purge_message.1'],
      ['with-ignore-thread-patch', 'http://ben.at.tanjero.com/patches/ignore-thread-1.5.21.patch'],
      ['with-pgp-verbose-mime-patch',
          'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.2/features-old/patch-1.5.4.vk.pgp_verbose_mime'],
    ]

    if build.include? "with-purge-patch" and not build.include? "with-trash-patch"
      puts "\n"
      opoo "The purge-patch requires the trash-patch. Adding it."
      # apply trash before purge
      build.unshift "with-trash-patch"
    end

    if build.include? "with-ignore-thread-patch" and build.include? "with-sidebar-patch"
      puts "\n"
      onoe "The ignore-thread-patch and sidebar-patch options are mutually exlusive. Please pick one"
      exit 1
    end

    p = []
    urls.each do |u|
      p << u[1] if build.include? u[0]
    end

    return p
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl",
            "--with-sasl",
            "--with-gnutls",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-tokyocabinet",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"]
    args << "--with-slang" if build.include? 'with-slang'

    if build.include? 'with-debug'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end
end
