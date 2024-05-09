1 pragma solidity 0.4.24;
2 
3 /// @title Ownable
4 /// @dev Provide a modifier that permits only a single user to call the function
5 contract Ownable {
6     address public owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /// @dev Set the original `owner` of the contract to the sender account.
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     /// @dev Require that the modified function is only called by `owner`
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     /// @dev Allow `owner` to transfer control of the contract to `newOwner`.
22     /// @param newOwner The address to transfer ownership to.
23     function transferOwnership(address newOwner) public onlyOwner {
24         require(newOwner != address(0));
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27     }
28 
29 }
30 
31 /// @title SafeMath
32 /// @dev Math operations with safety checks that throw on error
33 library SafeMath {
34 
35     /// @dev Multiply two numbers, throw on overflow.
36     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37         if (a == 0) {
38             return 0;
39         }
40         c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     /// @dev Substract two numbers, throw on overflow (i.e. if subtrahend is greater than minuend).
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     /// @dev Add two numbers, throw on overflow.
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 /// @title Whitelist
60 /// @dev Handle whitelisting, maximum purchase limits, and bonus calculation for PLGCrowdsale
61 contract Whitelist is Ownable {
62     using SafeMath for uint256;
63 
64     /// A participant in the crowdsale
65     struct Participant {
66         /// Percent of bonus tokens awarded to this participant
67         uint256 bonusPercent;
68         /// Maximum amount the participant can contribute in wei
69         uint256 maxPurchaseAmount;
70         /// Wei contributed to the crowdsale so far
71         uint256 weiContributed;
72     }
73 
74     /// Crowdsale address, used to authorize purchase records
75     address public crowdsaleAddress;
76 
77     /// Bonus/Vesting for specific accounts
78     /// If Participant.maxPurchaseAmount is zero, the address is not whitelisted
79     mapping(address => Participant) private participants;
80 
81     /// @notice Set the crowdsale address. Only one crowdsale at a time may use this whitelist
82     /// @param crowdsale The address of the crowdsale
83     function setCrowdsale(address crowdsale) public onlyOwner {
84         require(crowdsale != address(0));
85         crowdsaleAddress = crowdsale;
86     }
87 
88     /// @notice Get the bonus token percentage for `user`
89     /// @param user The address of a crowdsale participant
90     /// @return The percentage of bonus tokens `user` qualifies for
91     function getBonusPercent(address user) public view returns(uint256) {
92         return participants[user].bonusPercent;
93     }
94 
95     /// @notice Check if an address is whitelisted
96     /// @param user Potential participant
97     /// @return Whether `user` may participate in the crowdsale
98     function isValidPurchase(address user, uint256 weiAmount) public view returns(bool) {
99         require(user != address(0));
100         Participant storage participant = participants[user];
101         if(participant.maxPurchaseAmount == 0) {
102             return false;
103         }
104         return participant.weiContributed.add(weiAmount) <= participant.maxPurchaseAmount;
105     }
106 
107     /// @notice Whitelist a crowdsale participant
108     /// @notice Do not override weiContributed if the user has previously been whitelisted
109     /// @param user The participant to add
110     /// @param bonusPercent The user's bonus percentage
111     /// @param maxPurchaseAmount The maximum the participant is allowed to contribute in wei
112     ///     If zero, the user is de-whitelisted
113     function addParticipant(address user, uint256 bonusPercent, uint256 maxPurchaseAmount) external onlyOwner {
114         require(user != address(0));
115         participants[user].bonusPercent = bonusPercent;
116         participants[user].maxPurchaseAmount = maxPurchaseAmount;
117     }
118 
119     /// @notice Whitelist multiple crowdsale participants at once with the same bonus/purchase amount
120     /// @param users The participants to add
121     /// @param bonusPercent The bonus percentage shared among users
122     /// @param maxPurchaseAmount The maximum each participant is allowed to contribute in wei
123     function addParticipants(address[] users, uint256 bonusPercent, uint256 maxPurchaseAmount) external onlyOwner {
124         
125         for(uint i=0; i<users.length; i+=1) {
126             require(users[i] != address(0));
127             participants[users[i]].bonusPercent = bonusPercent;
128             participants[users[i]].maxPurchaseAmount = maxPurchaseAmount;
129         }
130     }
131 
132     /// @notice De-whitelist a crowdsale participant
133     /// @param user The participant to revoke
134     function revokeParticipant(address user) external onlyOwner {
135         require(user != address(0));
136         participants[user].maxPurchaseAmount = 0;
137     }
138 
139     /// @notice De-whitelist multiple crowdsale participants at once
140     /// @param users The participants to revoke
141     function revokeParticipants(address[] users) external onlyOwner {
142         
143         for(uint i=0; i<users.length; i+=1) {
144             require(users[i] != address(0));
145             participants[users[i]].maxPurchaseAmount = 0;
146         }
147     }
148 
149     function recordPurchase(address beneficiary, uint256 weiAmount) public {
150 
151         require(msg.sender == crowdsaleAddress);
152 
153         Participant storage participant = participants[beneficiary];
154         participant.weiContributed = participant.weiContributed.add(weiAmount);
155     }
156     
157 }