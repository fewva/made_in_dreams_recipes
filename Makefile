all: apk

apk:
	flutter build apk --split-per-abi --no-tree-shake-icons
	open build/app/outputs/flutter-apk/
