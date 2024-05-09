1 pragma solidity ^0.4.24;
2 
3 // Author: Bruno Block
4 // Version: 0.5
5 
6 interface contractInterface {
7     function balanceOf(address _owner) external constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) external;
9 }
10 
11 contract DualSig {
12     address public directorA;
13     address public directorB;
14     address public proposalAuthor;
15     address public proposalContract;
16     address public proposalDestination;
17     uint256 public proposalAmount;
18     uint256 public proposalBlock;
19     uint256 public proposalNonce;
20     uint256 public overrideBlock;
21     uint256 public transferSafety;
22 
23     event Proposal(uint256 _nonce, address _author, address _contract, uint256 _amount, address _destination, uint256 _timestamp);
24 
25     event Accept(uint256 _nonce);
26 
27     event NewDirectorA(address _director);
28 
29     event NewDirectorB(address _director);
30 
31     modifier onlyDirectors {
32         require(msg.sender == directorA || msg.sender == directorB);
33         _;
34     }
35 
36     constructor() public {
37         overrideBlock = (60*60*24*30)/15;// One month override interval assuming 15 second blocks (172,800 blocks)
38         proposalNonce = 0;
39         transferSafety = 1 ether;
40         directorA = msg.sender;
41         directorB = msg.sender;
42         reset();
43     }
44 
45     function () public payable {}
46 
47     function proposal(address proposalContractSet, uint256 proposalAmountSet, address proposalDestinationSet) public onlyDirectors {
48         proposalNonce++;
49         proposalAuthor = msg.sender;
50         proposalContract = proposalContractSet;
51         proposalAmount = proposalAmountSet;
52         proposalDestination = proposalDestinationSet;
53         proposalBlock = block.number + overrideBlock;
54         emit Proposal(proposalNonce, proposalAuthor, proposalContract, proposalAmount, proposalDestination, proposalBlock);
55     }
56 
57     function reset() public onlyDirectors {
58         proposalNonce++;
59         if (proposalNonce > 1000000) {
60             proposalNonce = 0;
61         }
62         proposalAuthor = 0x0;
63         proposalContract = 0x0;
64         proposalAmount = 0;
65         proposalDestination = 0x0;
66         proposalBlock = 0;
67     }
68 
69     function accept(uint256 acceptNonce) public onlyDirectors {
70         require(proposalNonce == acceptNonce);
71         require(proposalAmount > 0);
72         require(proposalDestination != 0x0);
73         require(proposalAuthor != msg.sender || block.number >= proposalBlock);
74 
75         address localContract = proposalContract;
76         address localDestination = proposalDestination;
77         uint256 localAmount = proposalAmount;
78         reset();
79 
80         if (localContract==0x0) {
81             require(localAmount <= address(this).balance);
82             localDestination.transfer(localAmount);
83         }
84         else {
85             contractInterface tokenContract = contractInterface(localContract);
86             tokenContract.transfer(localDestination, localAmount);
87         }
88         emit Accept(acceptNonce);
89     }
90 
91     function transferDirectorA(address newDirectorA) public payable {
92         require(msg.sender==directorA);
93         require(msg.value==transferSafety);// Prevents accidental transfer
94         directorA.transfer(transferSafety);// Reimburse safety deposit
95         reset();
96         directorA = newDirectorA;
97         emit NewDirectorA(directorA);
98     }
99 
100     function transferDirectorB(address newDirectorB) public payable {
101         require(msg.sender==directorB);
102         require(msg.value==transferSafety);// Prevents accidental transfer
103         directorB.transfer(transferSafety);// Reimburse safety deposit
104         reset();
105         directorB = newDirectorB;
106         emit NewDirectorB(directorB);
107     }
108 }