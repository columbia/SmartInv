1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 // Title: ⌐◨-◨ Caterpillar V3
5 // Contract by: @backseats_eth
6 
7 // This is an experimental implementation of an allow list game for NounCats (NounCats.com / @NounCats on Twitter).
8 // Periodically, this contract will open up and anyone can add themselves to the allow list before we mint.
9 
10 // NEW IN V3: Add yourself, add your friend, and give to a good cause! 
11 // (Fixes a non-critical bug in V2 where `giveTwoGetOne` didn't add addresses to the mapping)
12 
13 // V1: https://www.contractreader.io/contract/0x74a2867c2740bd3f12b4a5a78a9b6938782c445a
14 // V2: https://www.contractreader.io/contract/0x781165ac4678b12d0438ca09a97c5954aa730012
15 
16 // DISCLAIMER: Yes, there are better and gasless ways to run an allow list (like a Google Form, lol). 
17 // This is not our only way of taking addresses before mint. It's just a fun one. 
18 contract NounCaterpillarV3 {
19     
20     // How many open slots are currently available in this contract
21     uint8 public openSlots;
22     
23     // Using a bytes32 array rather than an array of addresses to save space and save the user on gas costs. 
24     // These will eventually be used in a Merkle tree which the bytes32[] also lends itself to.
25     bytes32[] public addresses;
26 
27     // A mapping to make sure you haven't been here before
28     mapping(bytes32 => bool) private addressMapping;
29 
30     // Owner and donation wallet addresses
31     address private owner = 0x3a6372B2013f9876a84761187d933DEe0653E377;
32     address private donationWallet = 0x1D4f4dd22cB0AF859E33DEaF1FF55d9f6251C56B;
33 
34     // A simplified implementation of Ownable 
35     modifier onlyOwner { 
36         require(msg.sender == owner, "Not owner");
37         _;
38     }
39 
40     /// @notice A function that only costs gas to add yourself to the allow list if there are open spots.
41     /// If Metamask or another wallet shows a ridiculous gas price, open slots == 0 or you're already on the list! Don't submit that transaction
42     function addMeToAllowList() external {
43         require(openSlots > 0, "Wait for spots to open up");
44         bytes32 encoded = keccak256(abi.encodePacked(msg.sender));
45         require(!addressMapping[encoded], "Already on list");
46         addressMapping[encoded] = true;
47         openSlots -= 1;
48         addresses.push(encoded);
49         delete encoded;
50     }
51 
52     /// @notice Add your address *and* a friend's address to the Noun Cats allow list at any time, even if openSlots == 0. 
53     /// All proceeds will be donated to a good cause, to be determined by the Noun Cats Discord.
54     /// @param _giveTo Address of the wallet of someone you want to add to the allow list
55     function giveTwoGetOne(address _giveTo) payable external { 
56         bytes32 you = keccak256(abi.encodePacked(msg.sender));
57         bytes32 yourFriend = keccak256(abi.encodePacked(_giveTo));
58         require(!addressMapping[you], "You're already on list");
59         require(!addressMapping[yourFriend], "They're already on list");
60         require(msg.value == 0.01 ether, 'Wrong price');
61         
62         addressMapping[you] = true;
63         addressMapping[yourFriend] = true;
64 
65         addresses.push(you);
66         addresses.push(yourFriend);
67         
68         delete you;
69         delete yourFriend;
70     }
71 
72     /// @notice A function that allows the owner to open up new spots in the NounCaterpillar
73     function extendCaterpillar(uint8 _newSlots) external onlyOwner { 
74         openSlots += _newSlots;
75     }
76     
77     /// @notice Withdraw funds from the contract
78     function withdraw() external payable onlyOwner { 
79         payable(donationWallet).transfer(address(this).balance);
80     }
81 
82 }