1 pragma solidity 0.4.24;
2 
3 contract SimpleVoting {
4 
5     string public constant description = "abc";
6 
7     string public name = "asd";
8 
9     mapping (string => string) certificates;
10 
11     address owner;
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     function getCertificate(string memory id) public view returns (string memory) {
18         return certificates[id];
19     }
20 
21     function setCertificate(string memory id, string memory cert) public {
22         require(msg.sender == owner);
23         certificates[id] = cert;
24     }
25 }