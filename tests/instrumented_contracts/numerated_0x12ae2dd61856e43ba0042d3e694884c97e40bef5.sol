1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error.
8  */
9 library SafeMath {
10     // Multiplies two numbers, throws on overflow./
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) return 0;
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17     // Integer division of two numbers, truncating the quotient.
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21     // Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     // Adds two numbers, throws on overflow.
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title _1010_Mining_ distribution-contract (50/25/25)
37  */
38 contract _1010_Mining_ {
39     using SafeMath for uint256;
40     
41     // -------------------------------------------------------------------------
42     // Variables
43     // -------------------------------------------------------------------------
44     
45     struct Member {
46         uint256 share;                               // Percent of mining profits
47         uint256 unpaid;                              // Available Wei for withdrawal, + 1 in storage for gas optimization
48     }                                              
49     mapping (address => Member) public members;      // All contract members as 'Member'-struct
50     
51     uint16    public memberCount;                    // Count of all members
52     address[] public memberIndex;                    // Lookuptable of all member addresses to iterate on deposit over and assign unpaid Ether to members
53     
54     
55     // -------------------------------------------------------------------------
56     // Private functions, can only be called by this contract
57     // -------------------------------------------------------------------------
58     
59     function _addMember (address _member, uint256 _share) private {
60         emit AddMember(_member, _share);
61         members[_member].share = _share;
62         members[_member].unpaid = 1;
63         memberIndex.push(_member);
64         memberCount++;
65     }
66     
67     
68     // -------------------------------------------------------------------------
69     // Constructor
70     // -------------------------------------------------------------------------
71     
72     constructor () public {
73         // Initialize members with their share (total 100) and trigger 'AddMember'-event
74         _addMember(0xd2Ce719a0d00f4f8751297aD61B0E936970282E1, 50);
75         _addMember(0xE517CB63e4dD36533C26b1ffF5deB893E63c3afA, 25);
76         _addMember(0x430e1dd1ab2E68F201B53056EF25B9e116979D9b, 25);
77     }
78     
79     
80     // -------------------------------------------------------------------------
81     // Events
82     // -------------------------------------------------------------------------
83     
84     event AddMember(address indexed member, uint256 share);
85     event Withdraw(address indexed member, uint256 value);
86     event Deposit(address indexed from, uint256 value);
87     
88     
89     // -------------------------------------------------------------------------
90     // Public external interface
91     // -------------------------------------------------------------------------
92     
93     function () external payable {
94         // Distribute deposited Ether to all members related to their profit-share
95         for (uint i=0; i<memberIndex.length; i++) {
96             members[memberIndex[i]].unpaid = 
97                 // Adding current deposit to members unpaid Wei amount
98                 members[memberIndex[i]].unpaid.add(
99                     // MemberShare * DepositedWei / 100 = WeiAmount of member-share to be added to members unpaid holdings
100                     members[memberIndex[i]].share.mul(msg.value).div(100)
101                 );
102         }
103         
104         // Trigger 'Deposit'-event
105         emit Deposit(msg.sender, msg.value);
106     }
107     
108     function withdraw () external { 
109         // Pre-validate withdrawal
110         require(members[msg.sender].unpaid > 1, "No unpaid balance or not a member account");
111         
112         // Remember members unpaid amount but remove it from his contract holdings before initiating the withdrawal for security reasons
113         uint256 unpaid = members[msg.sender].unpaid.sub(1);
114         members[msg.sender].unpaid = 1;
115         
116         // Trigger 'Withdraw'-event
117         emit Withdraw(msg.sender, unpaid);
118         
119         // Transfer the unpaid Wei amount to member address
120         msg.sender.transfer(unpaid);
121     }
122     
123     function unpaid () public view returns (uint256) {
124         // Get unpaid Wei amount of member
125         return members[msg.sender].unpaid.sub(1);
126     }
127     
128     function member () public view returns (bool) {
129         // Get member-state (true or false)
130         return members[msg.sender].unpaid >= 1;
131     }
132     
133     
134 }