1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error.
6  */
7 library SafeMath {
8     // Multiplies two numbers, throws on overflow./
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) return 0;
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     // Integer division of two numbers, truncating the quotient.
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19     // Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     // Adds two numbers, throws on overflow.
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 /**
34  * @title CMR_Mining distribution-contract (C 25 / M 25 / R 50)
35  */
36 contract CMR_Mining {
37     using SafeMath for uint256;
38     
39     // -------------------------------------------------------------------------
40     // Variables
41     // -------------------------------------------------------------------------
42     
43     struct Member {
44         uint256 share;                               // Percent of mining profits
45         uint256 unpaid;                              // Available Wei for withdrawal, + 1 in storage for gas optimization
46     }                                              
47     mapping (address => Member) private members;     // All contract members as 'Member'-struct
48     
49     uint16    public memberCount;                   // Count of all members
50     address[] public memberIndex;                   // Lookuptable of all member addresses to iterate on deposit over and assign unpaid Ether to members
51     
52     
53     // -------------------------------------------------------------------------
54     // Private functions, can only be called by this contract
55     // -------------------------------------------------------------------------
56     
57     function _addMember (address _member, uint256 _share) private {
58         emit AddMember(_member, _share);
59         members[_member].share = _share;
60         members[_member].unpaid = 1;
61         memberIndex.push(_member);
62         memberCount++;
63     }
64     
65     
66     // -------------------------------------------------------------------------
67     // Constructor
68     // -------------------------------------------------------------------------
69     
70     constructor () public {
71         // Initialize members with their share (total 100) and trigger 'AddMember'-event
72         _addMember(0xd2Ce719a0d00f4f8751297aD61B0E936970282E1, 50);
73         _addMember(0xE517CB63e4dD36533C26b1ffF5deB893E63c3afA, 25);
74         _addMember(0x430e1dd1ab2E68F201B53056EF25B9e116979D9b, 25);
75     }
76     
77     
78     // -------------------------------------------------------------------------
79     // Events
80     // -------------------------------------------------------------------------
81     
82     event AddMember(address indexed member, uint256 share);
83     event Withdraw(address indexed member, uint256 value);
84     event Deposit(address indexed from, uint256 value);
85     
86     
87     // -------------------------------------------------------------------------
88     // Public external interface
89     // -------------------------------------------------------------------------
90     
91     function () external payable {
92         // Distribute deposited Ether to all members related to their profit-share
93         for (uint i=0; i<memberIndex.length; i++) {
94             members[memberIndex[i]].unpaid = 
95                 // Adding current deposit to members unpaid Wei amount
96                 members[memberIndex[i]].unpaid.add(
97                     // MemberShare * DepositedWei / 100 = WeiAmount of member-share to be added to members unpaid holdings
98                     members[memberIndex[i]].share.mul(msg.value).div(100)
99                 );
100         }
101         
102         // Trigger 'Deposit'-event
103         emit Deposit(msg.sender, msg.value);
104     }
105     
106     function withdraw () external { 
107         // Pre-validate withdrawal
108         require(members[msg.sender].unpaid > 1, "No unpaid balance or not a member account");
109         
110         // Remember members unpaid amount but remove it from his contract holdings before initiating the withdrawal for security reasons
111         uint256 unpaid = members[msg.sender].unpaid.sub(1);
112         members[msg.sender].unpaid = 1;
113         
114         // Trigger 'Withdraw'-event
115         emit Withdraw(msg.sender, unpaid);
116         
117         // Transfer the unpaid Wei amount to member address
118         msg.sender.transfer(unpaid);
119     }
120     
121     function shareOf (address _member) public view returns (uint256) {
122         // Get share percentage of member
123         return members[_member].share;
124     }
125     
126     function unpaidOf (address _member) public view returns (uint256) {
127         // Get unpaid Wei amount of member
128         return members[_member].unpaid.sub(1);
129     }
130     
131     
132 }