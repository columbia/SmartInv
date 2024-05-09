1 pragma solidity >=0.4.22 < 0.7.0;
2 
3 contract ProofOfExistence {
4 
5     address public owner;
6 
7     mapping (bytes32 => uint256) public documents;
8 
9     modifier requireOwner() {
10         require(msg.sender == owner, "Owner is required.");
11         _;
12     }
13 
14     modifier requireNoHashExists(bytes32 hashedDocument) {
15         require(documents[hashedDocument] == 0, "Hash value already exists.");
16         _;
17     }
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     function addDocument(bytes32 hashedDocument)
24         external requireOwner requireNoHashExists(hashedDocument) returns (bytes32) {
25 
26         documents[hashedDocument] = block.number;
27 
28         return hashedDocument;
29     }
30 
31     function doesHashExist(bytes32 documentHash) public view returns (bool) {
32         return documents[documentHash] != 0;
33     }
34 
35     function getBlockNumber(bytes32 documentHash) public view returns (uint256) {
36         return documents[documentHash];
37     }
38 
39     function () external {
40         revert("Invalid data sent to contract.");
41     }
42 
43     function selfDestroy() public requireOwner {
44         selfdestruct(msg.sender);
45     }
46 }