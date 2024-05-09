1 pragma solidity ^0.4.2;
2 
3 contract Numa {
4     mapping(address => bytes32) public users;
5     Message[] public messages;
6 
7     struct Message {
8         address sender;
9         bytes32 ipfsHash;
10     }
11 
12     event UserUpdated(
13         address indexed sender,
14         bytes32 indexed ipfsHash
15     );
16 
17     event MessageCreated(
18         uint indexed id,
19         address indexed sender,
20         bytes32 indexed ipfsHash
21     );
22     
23     event MessageUpdated(
24         uint indexed id,
25         address indexed sender,
26         bytes32 indexed ipfsHash
27     );
28 
29     function Numa() public { }
30 
31     function messagesLength() public view returns (uint) {
32         return messages.length;
33     }
34 
35     function createMessage(bytes32 ipfsHash) public {
36         messages.length++;
37         uint index = messages.length - 1;
38 
39         messages[index].ipfsHash = ipfsHash;
40         messages[index].sender = msg.sender;
41 
42         MessageCreated(index, msg.sender, ipfsHash);
43     }
44 
45     function updateMessage(uint id, bytes32 ipfsHash) public {
46         require(messages.length > id);
47         require(messages[id].sender == msg.sender);
48         
49         messages[id].ipfsHash = ipfsHash;
50 
51         MessageUpdated(id, msg.sender, ipfsHash);
52     }
53 
54     function updateUser(bytes32 ipfsHash) public {
55         users[msg.sender] = ipfsHash;
56         UserUpdated(msg.sender, ipfsHash);
57     }
58 
59 }