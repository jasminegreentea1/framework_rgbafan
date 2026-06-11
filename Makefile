target/release/framework_rgbafan_daemon:
	cargo build --release

clean:
	cargo clean

install: target/release/framework_rgbafan_daemon deploy/fmwrk-rgbfan deploy/fmwrk-rgbfan.service
	sudo cp target/release/framework_rgbafan_daemon /usr/bin/framework_rgbafan_daemon
	sudo chown root /usr/bin/framework_rgbafan_daemon
	sudo chmod 755 /usr/bin/framework_rgbafan_daemon

	sudo cp deploy/fmwrk-rgbfan /usr/bin/fmwrk-rgbfan
	sudo chown root /usr/bin/fmwrk-rgbfan
	sudo chmod 755 /usr/bin/fmwrk-rgbfan

	sudo cp deploy/fmwrk-rgbfan.service /etc/systemd/system/fmwrk-rgbfan.service
	sudo chown root /etc/systemd/system/fmwrk-rgbfan.service
	sudo chmod 644 /etc/systemd/system/fmwrk-rgbfan.service

	sudo systemctl daemon-reload

	printf '%s\n' 'LED_OPTS="smoothspin -c 0E81AD D4002A FFFFFF D4002A"' | sudo tee /etc/default/fmwrk-rgbfan > /dev/null

	sudo chown root /etc/default/fmwrk-rgbfan
	sudo chmod 644 /etc/default/fmwrk-rgbfan

	sudo systemctl enable --now fmwrk-rgbfan.service
	echo "Framework RGB Fan Daemon installed!"


uninstall:
	sudo systemctl disable --now fmwrk-rgbfan.service
	sudo systemctl daemon-reload

	sudo rm -f /usr/bin/framework_rgbafan_daemon
	sudo rm -f /usr/bin/fmwrk-rgbfan
	sudo rm -f /etc/default/fmwrk-rgbfan
	sudo rm -f /etc/systemd/system/fmwrk-rgbfan.service

	echo "Framework RGB Fan Daemon uninstalled."

