# MarkdownChildrenKit

<p align="center">
    <img src="Assets/logo/logo.svg" width="320pt" alt="Markdown Logo with list">
    <br>
    <a href="https://swiftpackageindex.com/ptrkstr/MarkdownChildrenKit"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fptrkstr%2FMarkdownChildrenKit%2Fbadge%3Ftype%3Dplatforms"/></a>
    <a href="https://swiftpackageindex.com/ptrkstr/MarkdownChildrenKit"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fptrkstr%2FMarkdownChildrenKit%2Fbadge%3Ftype%3Dswift-versions"/></a>
    <br>
    <a href="https://github.com/apple/swift-package-manager" alt="MarkdownChildrenKit on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
    <a href="https://github.com/ptrkstr/MarkdownChildrenKit/actions/workflows/swift.yml"><img src="https://github.com/ptrkstr/MarkdownChildrenKit/actions/workflows/swift.yml/badge.svg"/></a>
    <a href="https://codecov.io/gh/ptrkstr/MarkdownChildrenKit"><img src="https://codecov.io/gh/ptrkstr/MarkdownChildrenKit/branch/develop/graph/badge.svg?token=O6FVY8NPLC"/></a>
    <br>
    Generates a markdown list of children files and folders and saves it to a markdown file.<br>
    Useful when wanting an index in a readme.md.<br>
    <a href="https://github.com/ptrkstr/MarkdownChildren">Available as a command line tool here.</a>
</p>

## Example
GIVEN a readme.md file exists

```markdown
My favourite things are:
<!-- markdown-children:start -->
<!-- markdown-children:end -->
```

<details>
	<summary>AND it's in this directory</summary>
	
<img src="Assets/readme/given.png" height="300pt" alt="Directory of files and folders">
</details>

<details>
	<summary>WHEN MarkdownChildrenKit is invoked</summary>
	
```swift
try MarkdownChildren().process(.init(
    url: URL(string: "../readme.md",
    nameType: .useH1,
    tagStart: "<!-- markdown-children:start -->",
    tagEnd: "<!-- markdown-children:end -->",
    saver: saver
))
``` 
</details>

THEN the readme.md turns into:

```markdown
My favourite things are:
<!-- markdown-children:start -->
- [Animals](animals.md)
- animals
  - pets
    - [Cats](animals/pets/cats.md)
    - [Dogs](animals/pets/dogs.md)
  - zoo
    - [Tiger](animals/zoo/tiger.md)
- [Clothes](clothes.md)
- clothes
  - summer
    - [Dress](clothes/summer/dress.md)
    - [Hat](clothes/summer/hat.md)
  - winter
    - [Jumper](clothes/winter/jumper.md)
    - [Pants](clothes/winter/pants.md)
<!-- markdown-children:end -->
```


## Installation

### SPM
Add the following to your project:  
```
https://github.com/ptrkstr/MarkdownChildrenKit
```

## TODO

- [ ] Option - Choose list node (`-`, `*` or `+`)
- [ ] Option - Skip folder if it doesn't contain any markdown files
