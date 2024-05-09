1 pragma solidity ^0.4.13;
2 
3 interface FundInterface {
4 
5     // EVENTS
6 
7     event PortfolioContent(address[] assets, uint[] holdings, uint[] prices);
8     event RequestUpdated(uint id);
9     event Redeemed(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
10     event FeesConverted(uint atTimestamp, uint shareQuantityConverted, uint unclaimed);
11     event CalculationUpdate(uint atTimestamp, uint managementFee, uint performanceFee, uint nav, uint sharePrice, uint totalSupply);
12     event ErrorMessage(string errorMessage);
13 
14     // EXTERNAL METHODS
15     // Compliance by Investor
16     function requestInvestment(uint giveQuantity, uint shareQuantity, address investmentAsset) external;
17     function executeRequest(uint requestId) external;
18     function cancelRequest(uint requestId) external;
19     function redeemAllOwnedAssets(uint shareQuantity) external returns (bool);
20     // Administration by Manager
21     function enableInvestment(address[] ofAssets) external;
22     function disableInvestment(address[] ofAssets) external;
23     function shutDown() external;
24 
25     // PUBLIC METHODS
26     function emergencyRedeem(uint shareQuantity, address[] requestedAssets) public returns (bool success);
27     function calcSharePriceAndAllocateFees() public returns (uint);
28 
29 
30     // PUBLIC VIEW METHODS
31     // Get general information
32     function getModules() view returns (address, address, address);
33     function getLastRequestId() view returns (uint);
34     function getManager() view returns (address);
35 
36     // Get accounting information
37     function performCalculations() view returns (uint, uint, uint, uint, uint, uint, uint);
38     function calcSharePrice() view returns (uint);
39 }
40 
41 interface ComplianceInterface {
42 
43     // PUBLIC VIEW METHODS
44 
45     /// @notice Checks whether investment is permitted for a participant
46     /// @param ofParticipant Address requesting to invest in a Melon fund
47     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
48     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
49     /// @return Whether identity is eligible to invest in a Melon fund.
50     function isInvestmentPermitted(
51         address ofParticipant,
52         uint256 giveQuantity,
53         uint256 shareQuantity
54     ) view returns (bool);
55 
56     /// @notice Checks whether redemption is permitted for a participant
57     /// @param ofParticipant Address requesting to redeem from a Melon fund
58     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
59     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
60     /// @return Whether identity is eligible to redeem from a Melon fund.
61     function isRedemptionPermitted(
62         address ofParticipant,
63         uint256 shareQuantity,
64         uint256 receiveQuantity
65     ) view returns (bool);
66 }
67 
68 contract DBC {
69 
70     // MODIFIERS
71 
72     modifier pre_cond(bool condition) {
73         require(condition);
74         _;
75     }
76 
77     modifier post_cond(bool condition) {
78         _;
79         assert(condition);
80     }
81 
82     modifier invariant(bool condition) {
83         require(condition);
84         _;
85         assert(condition);
86     }
87 }
88 
89 contract Owned is DBC {
90 
91     // FIELDS
92 
93     address public owner;
94 
95     // NON-CONSTANT METHODS
96 
97     function Owned() { owner = msg.sender; }
98 
99     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
100 
101     // PRE, POST, INVARIANT CONDITIONS
102 
103     function isOwner() internal returns (bool) { return msg.sender == owner; }
104 
105 }
106 
107 contract BugBountyCompliance is ComplianceInterface, DBC, Owned {
108 
109     mapping (address => bool) isWhitelisted;
110 
111     // PUBLIC VIEW METHODS
112 
113     /// @notice Checks whether investment is permitted for a participant
114     /// @param ofParticipant Address requesting to invest in a Melon fund
115     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
116     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
117     /// @return Whether identity is eligible to invest in a Melon fund.
118     function isInvestmentPermitted(
119         address ofParticipant,
120         uint256 giveQuantity,
121         uint256 shareQuantity
122     )
123         view
124         returns (bool)
125     {
126         return FundInterface(msg.sender).getManager() == ofParticipant;
127     }
128 
129     /// @notice Checks whether redemption is permitted for a participant
130     /// @param ofParticipant Address requesting to redeem from a Melon fund
131     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
132     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
133     /// @return isEligible Whether identity is eligible to redeem from a Melon fund.
134     function isRedemptionPermitted(
135         address ofParticipant,
136         uint256 shareQuantity,
137         uint256 receiveQuantity
138     )
139         view
140         returns (bool)
141     {
142         return true;    // No need for KYC/AML in case of redeeming shares
143     }
144 
145     /// @notice Checks whether an address is whitelisted in the competition contract and competition is active
146     /// @param user Address
147     /// @return Whether the address is whitelisted
148     function isCompetitionAllowed(address user)
149         view
150         returns (bool)
151     {
152         return isWhitelisted[user];
153     }
154 
155 
156     // PUBLIC METHODS
157 
158     function addToWhitelist(address user)
159         pre_cond(isOwner())
160     {
161         isWhitelisted[user] = true;
162     }
163 
164     function removeFromWhitelist(address user)
165         pre_cond(isOwner())
166     {
167         isWhitelisted[user] = false;
168     }
169 }