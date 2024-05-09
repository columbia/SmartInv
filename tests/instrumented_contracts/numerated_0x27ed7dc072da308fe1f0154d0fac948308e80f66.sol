1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Ownable.sol
4 
5 /*
6  * Ownable
7  *
8  * Base contract with an owner.
9  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
10  */
11 contract Ownable {
12 
13   address public owner;
14 
15   function Ownable() public { owner = msg.sender; }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23 
24     if (newOwner != address(0)) {
25       owner = newOwner;
26     }
27 
28   }
29 }
30 
31 // File: contracts/Deployer.sol
32 
33 contract Deployer {
34 
35   address public deployer;
36 
37   function Deployer() public { deployer = msg.sender; }
38 
39   modifier onlyDeployer() {
40     require(msg.sender == deployer);
41     _;
42   }
43 }
44 
45 // File: contracts/ModultradeStorage.sol
46 
47 contract ModultradeStorage is Ownable, Deployer {
48 
49   bool private _doMigrate = true;
50 
51   mapping (address => address[]) public sellerProposals;
52 
53   mapping (uint => address) public proposalListAddress;
54 
55   address[] public proposals;
56 
57   event InsertProposalEvent (address _proposal, uint _id, address _seller);
58 
59   event PaidProposalEvent (address _proposal, uint _id);
60 
61   function ModultradeStorage() public {}
62 
63   function insertProposal(address seller, uint id, address proposal) public onlyOwner {
64     sellerProposals[seller].push(proposal);
65     proposalListAddress[id] = proposal;
66     proposals.push(proposal);
67 
68     InsertProposalEvent(proposal, id, seller);
69   }
70 
71   function getProposalsBySeller(address seller) public constant returns (address[]){
72     return sellerProposals[seller];
73   }
74 
75   function getProposals() public constant returns (address[]){
76     return proposals;
77   }
78 
79   function getProposalById(uint id) public constant returns (address){
80     return proposalListAddress[id];
81   }
82 
83   function getCount() public constant returns (uint) {
84     return proposals.length;
85   }
86 
87   function getCountBySeller(address seller) public constant returns (uint) {
88     return sellerProposals[seller].length;
89   }
90 
91   function firePaidProposalEvent(address proposal, uint id) public {
92     require(proposalListAddress[id] == proposal);
93 
94     PaidProposalEvent(proposal, id);
95   }
96 
97   function changeOwner(address newOwner) public onlyDeployer {
98     if (newOwner != address(0)) {
99       owner = newOwner;
100     }
101   }
102 
103 }