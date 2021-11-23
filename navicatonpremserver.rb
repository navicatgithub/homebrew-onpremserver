class Navicatonpremserver < Formula
  desc "Navicat On-Prem Server is an on-premise solution that provides you with the option to host a cloud environment for storing Navicat objects internally at your location. You can enjoy complete control over your system and maintain 100% privacy."
  homepage "https://www.navicat.com/en/products#navicat-on-prem"
  url "https://download3.navicat.com/onpremsvr-download/homebrew/navicat-onprem-server1.0.2.tar.gz"
  sha256 "ace63f1f1e0e490b9395ad85ab9e837e212d09b2d9d0abb26836f3d8fb3b5eb7"

  bottle :unneeded

  def install
    # Preload
    system "./install.sh"
    libexec.install Dir["*"]

    # Symlink var to persist across version update
    rm_rf "#{libexec}/var"
    mkdir_p "#{var}/navicatonpremserver/var"
    ln_s "#{var}/navicatonpremserver/var", "#{libexec}/var"

    # Create wrapper binary
    bin.write_exec_script "#{libexec}/wrapper"
    mv "#{bin}/wrapper", "#{bin}/navicatonpremserver"
  end

  plist_options :startup => "true"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{libexec}/wrapper</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{libexec}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/navicatonpremserver version"
  end
end
