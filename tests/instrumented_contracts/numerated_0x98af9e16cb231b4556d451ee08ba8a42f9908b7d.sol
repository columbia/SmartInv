1 pragma solidity ^0.4.25;
2 
3 
4 contract VIC {
5     event CardsAdded(
6         address indexed user,
7         uint160 indexed root,
8         uint32 count
9     );
10     
11     event CardCompromised(
12         address indexed user,
13         uint160 indexed root,
14         uint32 indexed index
15     );
16     
17     function publish(uint160 root, uint32 count) public {
18         _publish(msg.sender, root, count);
19     }
20     
21     function publishBySignature(address user, uint160 root, uint32 count, bytes32 r, bytes32 s, uint8 v) public {
22         bytes32 messageHash = keccak256(abi.encodePacked(root, count));
23         require(user == ecrecover(messageHash, 27 + v, r, s), "Invalid signature");
24         _publish(user, root, count);
25     }
26     
27     function report(uint160 root, uint32 index) public {
28         _report(msg.sender, root, index);
29     }
30     
31     function reportBySignature(address user, uint160 root, uint32 index, bytes32 r, bytes32 s, uint8 v) public {
32         bytes32 messageHash = keccak256(abi.encodePacked(root, index));
33         require(user == ecrecover(messageHash, 27 + v, r, s), "Invalid signature");
34         _report(user, root, index);
35     }
36     
37     function _publish(address user, uint160 root, uint32 count) public {
38         emit CardsAdded(user, root, count);
39     }
40     
41     function _report(address user, uint160 root, uint32 index) public {
42         emit CardCompromised(user, root, index);
43     }
44 }