1 pragma solidity ^0.4.15;
2 
3 // Math helper functions
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 /// @title DNNToken contract - Main DNN contract
32 /// @author Dondrey Taylor - <dondrey@dnn.media>
33 contract DNNToken {
34     enum DNNSupplyAllocations {
35         EarlyBackerSupplyAllocation,
36         PRETDESupplyAllocation,
37         TDESupplyAllocation,
38         BountySupplyAllocation,
39         WriterAccountSupplyAllocation,
40         AdvisorySupplyAllocation,
41         PlatformSupplyAllocation
42     }
43     function balanceOf(address who) constant public returns (uint256);
44     function issueTokens(address, uint256, DNNSupplyAllocations) public pure returns (bool) {}
45 }
46 
47 /// @author Dondrey Taylor - <dondrey@dnn.media>
48 contract DNNAdvisoryLockBox {
49 
50   using SafeMath for uint256;
51 
52   // DNN Token Contract
53   DNNToken public dnnToken;
54 
55   // Addresses of the co-founders of DNN
56   address public cofounderA;
57   address public cofounderB;
58 
59   // Amount of tokens that each advisor is entitled to
60   mapping(address => uint256) advisorsWithEntitledSupply;
61 
62   // Amount of tokens that each advisor is entitled to
63 	mapping(address => uint256) advisorsTokensIssued;
64 
65   // The last time that tokens were issued to each advisor
66 	mapping(address => uint256) advisorsTokensIssuedOn;
67 
68   // Events
69 	event AdvisorTokensSent(address to, uint256 issued, uint256 remaining);
70 	event AdvisorAdded(address advisor);
71 	event AdvisorAddressChanged(address oldaddress, address newaddress);
72   event NotWhitelisted(address to);
73   event NoTokensRemaining(address advisor);
74   event NextRedemption(uint256 nextTime);
75 
76   // Checks to see if sender is a cofounder
77   modifier onlyCofounders() {
78       require (msg.sender == cofounderA || msg.sender == cofounderB);
79       _;
80   }
81 
82   // Replace advisor address
83   function replaceAdvisorAddress(address oldaddress, address newaddress) public onlyCofounders {
84       // Check to see if the advisor's old address exists
85       if (advisorsWithEntitledSupply[oldaddress] > 0) {
86           advisorsWithEntitledSupply[newaddress] = advisorsWithEntitledSupply[oldaddress];
87           advisorsWithEntitledSupply[oldaddress] = 0;
88           emit AdvisorAddressChanged(oldaddress, newaddress);
89       }
90       else {
91           emit NotWhitelisted(oldaddress);
92       }
93   }
94 
95   // Provides the remaining amount tokens to be issued to the advisor
96   function nextRedemptionTime(address advisorAddress) public view returns (uint256) {
97       return advisorsTokensIssuedOn[advisorAddress] == 0 ? now : (advisorsTokensIssuedOn[advisorAddress] + 30 days);
98   }
99 
100   // Provides the remaining amount tokens to be issued to the advisor
101   function checkRemainingTokens(address advisorAddress) public view returns (uint256) {
102       return advisorsWithEntitledSupply[advisorAddress] - advisorsTokensIssued[advisorAddress];
103   }
104 
105   // Checks if the specified address is whitelisted
106   function isWhitelisted(address advisorAddress) public view returns (bool) {
107      return advisorsWithEntitledSupply[advisorAddress] != 0;
108   }
109 
110   // Add advisor address
111   function addAdvisor(address advisorAddress, uint256 entitledTokenAmount) public onlyCofounders {
112       advisorsWithEntitledSupply[advisorAddress] = entitledTokenAmount;
113       emit AdvisorAdded(advisorAddress);
114   }
115 
116   // Amount of tokens that the advisor is entitled to
117   function advisorEntitlement(address advisorAddress) public view returns (uint256) {
118       return advisorsWithEntitledSupply[advisorAddress];
119   }
120 
121   constructor() public
122   {
123       // Set token address
124       dnnToken = DNNToken(0x9D9832d1beb29CC949d75D61415FD00279f84Dc2);
125 
126       // Set cofounder addresses
127       cofounderA = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
128       cofounderB = 0x9FFE2aD5D76954C7C25be0cEE30795279c4Cab9f;
129   }
130 
131 	// Handles incoming transactions
132 	function () public payable {
133 
134       // Check to see if the advisor is within
135       // our whitelist
136       if (advisorsWithEntitledSupply[msg.sender] > 0) {
137 
138           // Check to see if the advisor has any tokens left
139           if (advisorsTokensIssued[msg.sender] < advisorsWithEntitledSupply[msg.sender]) {
140 
141               // Check to see if we can issue tokens to them. Advisors can redeem every 30 days for 10 months
142               if (advisorsTokensIssuedOn[msg.sender] == 0 || ((now - advisorsTokensIssuedOn[msg.sender]) >= 30 days)) {
143 
144                   // Issue tokens to advisors
145                   uint256 tokensToIssue = advisorsWithEntitledSupply[msg.sender].div(10);
146 
147                   // Update amount of tokens issued to this advisor
148                   advisorsTokensIssued[msg.sender] = advisorsTokensIssued[msg.sender].add(tokensToIssue);
149 
150                   // Update the time that we last issued tokens to this advisor
151                   advisorsTokensIssuedOn[msg.sender] = now;
152 
153                   // Allocation type will be advisory
154                   DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.AdvisorySupplyAllocation;
155 
156                   // Attempt to issue tokens
157                   if (!dnnToken.issueTokens(msg.sender, tokensToIssue, allocationType)) {
158                       revert();
159                   }
160                   else {
161                      emit AdvisorTokensSent(msg.sender, tokensToIssue, checkRemainingTokens(msg.sender));
162                   }
163               }
164               else {
165                    emit NextRedemption(advisorsTokensIssuedOn[msg.sender] + 30 days);
166               }
167           }
168           else {
169             emit NoTokensRemaining(msg.sender);
170           }
171       }
172       else {
173         emit NotWhitelisted(msg.sender);
174       }
175 	}
176 
177 }