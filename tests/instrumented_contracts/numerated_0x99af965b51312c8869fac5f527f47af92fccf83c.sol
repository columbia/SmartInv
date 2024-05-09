1 pragma solidity 0.4.25;
2 
3 contract SLoader {
4   uint8 public releaseCount;
5   Version[] releases;
6   address owner;
7 
8   modifier ifOwner {
9     require(owner == msg.sender);
10     _;
11   }
12 
13   constructor() public {
14     owner = msg.sender;
15   }
16 
17   function addRelease(bytes32 checksum, string url) ifOwner public {
18     releases.push(Version(checksum, url));
19     releaseCount++;
20   }
21 
22   function latestReleaseChecksum() constant public returns (bytes32) {
23     return releases[releaseCount - 1].checksum;
24   }
25 
26   function latestReleaseUrl() constant public returns (string) {
27     return releases[releaseCount - 1].url;
28   }
29 
30   function releaseChecksum(uint8 index) constant public returns (bytes32) {
31     return releases[index].checksum;
32   }
33 
34   function releaseUrl(uint8 index) constant public returns (string) {
35     return releases[index].url;
36   }
37 
38   struct Version {
39     bytes32 checksum;
40     string url;
41   }
42 }