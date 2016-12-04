This bit of implements text based on a STB Nothings's TrueType implementation.

The main purpose is to create a minimal implementation for comparrison
with QtQuick's built in Text item..

Things it does wrong or ignores at the moment:
 - No cleanup of the texture atlas
 - Only a fixed set of characters

