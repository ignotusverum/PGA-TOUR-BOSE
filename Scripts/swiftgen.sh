swiftgen="$PODS_ROOT"/SwiftGen/bin/swiftgen
resources="$SRCROOT"/Modules/$TARGETNAME/Resources
template="$SRCROOT"/Scripts/swiftGenTemplate

"$swiftgen" strings -p "$template"/runtime-swift4.stencil "$resources"/en.lproj/Localizable.strings --output "$resources"/Strings.swift
"$swiftgen" xcassets -t swift4 "$resources"/Assets.xcassets --output "$resources"/Assets.swift
"$swiftgen" storyboards --param ignoreTargetModule=true -t swift4 "$resources" --output "$resources"/Storyboards.swift
