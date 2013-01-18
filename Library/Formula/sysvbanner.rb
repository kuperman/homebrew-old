require 'formula'

class Sysvbanner < Formula
  homepage 'http://packages.debian.org/source/stable/sysvbanner'
  url 'http://ftp.debian.org/debian/pool/main/s/sysvbanner/sysvbanner_1.0.15.tar.gz'
  version '1.0.15'
  sha1 '310960c38ff9778bc1597322f45f8b052b7c5ede'


  def install
    system 'make'
    bin.install  'banner'
    man1.install 'banner.1'
  end

  def test
    system "#{bin}/banner", "testing"
  end
end
