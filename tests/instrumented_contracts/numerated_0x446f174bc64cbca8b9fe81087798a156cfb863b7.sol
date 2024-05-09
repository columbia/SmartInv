1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 }
27 
28 /**
29  * @title Voting2018 Contract
30  */
31 contract Voting2018 is Ownable {
32     string public version = "1.0";
33 
34     struct File {
35         string content;
36         string contentTime;
37 
38         string md5;
39         string sha256;
40         string sha1;
41         string hashTime;
42     }
43 
44     File[13] public files;
45 
46     function setHashes(uint8 fileId, string _md5, string _sha256, string _sha1, string _time) public onlyOwner() {
47         if (fileId < files.length) {
48             bytes memory hashTimeEmptyTest = bytes(files[fileId].hashTime); // Uses memory
49             if (hashTimeEmptyTest.length == 0) {
50                 files[fileId].md5 = _md5;
51                 files[fileId].sha256 = _sha256;
52                 files[fileId].sha1 = _sha1;
53                 files[fileId].hashTime = _time;
54             } 
55         }
56     }
57 
58     function setContent(uint8 fileId, string _content, string _time) public onlyOwner() {
59         if (fileId < files.length) {
60             bytes memory contentTimeEmptyTest = bytes(files[fileId].contentTime); // Uses memory
61             if (contentTimeEmptyTest.length == 0) {
62                 files[fileId].content = _content;
63                 files[fileId].contentTime = _time;
64             } 
65         }
66     }
67 
68     function getFile(uint8 fileId) public view returns (string content, string contentTime, string _md5, string _sha256, string _sha1, string hashTime) {
69         if (fileId < files.length) {
70             return (files[fileId].content, files[fileId].contentTime, files[fileId].md5, files[fileId].sha256, files[fileId].sha1, files[fileId].hashTime);
71         }
72 
73         return ("", "", "", "", "", "");
74     }
75 }