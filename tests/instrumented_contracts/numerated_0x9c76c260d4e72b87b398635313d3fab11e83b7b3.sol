1 pragma solidity ^0.4.13;
2 
3 interface CompetitionInterface {
4 
5     // EVENTS
6 
7     event Register(uint withId, address fund, address manager);
8     event ClaimReward(address registrant, address fund, uint shares);
9 
10     // PRE, POST, INVARIANT CONDITIONS
11 
12     function termsAndConditionsAreSigned(address byManager, uint8 v, bytes32 r, bytes32 s) view returns (bool);
13     function isWhitelisted(address x) view returns (bool);
14     function isCompetitionActive() view returns (bool);
15 
16     // CONSTANT METHODS
17 
18     function getMelonAsset() view returns (address);
19     function getRegistrantId(address x) view returns (uint);
20     function getRegistrantFund(address x) view returns (address);
21     function getCompetitionStatusOfRegistrants() view returns (address[], address[], bool[]);
22     function getTimeTillEnd() view returns (uint);
23     function getEtherValue(uint amount) view returns (uint);
24     function calculatePayout(uint payin) view returns (uint);
25 
26     // PUBLIC METHODS
27 
28     function registerForCompetition(address fund, uint8 v, bytes32 r, bytes32 s) payable;
29     function batchAddToWhitelist(uint maxBuyinQuantity, address[] whitelistants);
30     function withdrawMln(address to, uint amount);
31     function claimReward();
32 
33 }
34 
35 interface ComplianceInterface {
36 
37     // PUBLIC VIEW METHODS
38 
39     /// @notice Checks whether investment is permitted for a participant
40     /// @param ofParticipant Address requesting to invest in a Melon fund
41     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
42     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
43     /// @return Whether identity is eligible to invest in a Melon fund.
44     function isInvestmentPermitted(
45         address ofParticipant,
46         uint256 giveQuantity,
47         uint256 shareQuantity
48     ) view returns (bool);
49 
50     /// @notice Checks whether redemption is permitted for a participant
51     /// @param ofParticipant Address requesting to redeem from a Melon fund
52     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
53     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
54     /// @return Whether identity is eligible to redeem from a Melon fund.
55     function isRedemptionPermitted(
56         address ofParticipant,
57         uint256 shareQuantity,
58         uint256 receiveQuantity
59     ) view returns (bool);
60 }
61 
62 contract DBC {
63 
64     // MODIFIERS
65 
66     modifier pre_cond(bool condition) {
67         require(condition);
68         _;
69     }
70 
71     modifier post_cond(bool condition) {
72         _;
73         assert(condition);
74     }
75 
76     modifier invariant(bool condition) {
77         require(condition);
78         _;
79         assert(condition);
80     }
81 }
82 
83 contract Owned is DBC {
84 
85     // FIELDS
86 
87     address public owner;
88 
89     // NON-CONSTANT METHODS
90 
91     function Owned() { owner = msg.sender; }
92 
93     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
94 
95     // PRE, POST, INVARIANT CONDITIONS
96 
97     function isOwner() internal returns (bool) { return msg.sender == owner; }
98 
99 }
100 
101 contract CompetitionCompliance is ComplianceInterface, DBC, Owned {
102 
103     address public competitionAddress;
104 
105     // CONSTRUCTOR
106 
107     /// @dev Constructor
108     /// @param ofCompetition Address of the competition contract
109     function CompetitionCompliance(address ofCompetition) public {
110         competitionAddress = ofCompetition;
111     }
112 
113     // PUBLIC VIEW METHODS
114 
115     /// @notice Checks whether investment is permitted for a participant
116     /// @param ofParticipant Address requesting to invest in a Melon fund
117     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
118     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
119     /// @return Whether identity is eligible to invest in a Melon fund.
120     function isInvestmentPermitted(
121         address ofParticipant,
122         uint256 giveQuantity,
123         uint256 shareQuantity
124     )
125         view
126         returns (bool)
127     {
128         return competitionAddress == ofParticipant;
129     }
130 
131     /// @notice Checks whether redemption is permitted for a participant
132     /// @param ofParticipant Address requesting to redeem from a Melon fund
133     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
134     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
135     /// @return isEligible Whether identity is eligible to redeem from a Melon fund.
136     function isRedemptionPermitted(
137         address ofParticipant,
138         uint256 shareQuantity,
139         uint256 receiveQuantity
140     )
141         view
142         returns (bool)
143     {
144         return competitionAddress == ofParticipant;
145     }
146 
147     /// @notice Checks whether an address is whitelisted in the competition contract and competition is active
148     /// @param x Address
149     /// @return Whether the address is whitelisted
150     function isCompetitionAllowed(
151         address x
152     )
153         view
154         returns (bool)
155     {
156         return CompetitionInterface(competitionAddress).isWhitelisted(x) && CompetitionInterface(competitionAddress).isCompetitionActive();
157     }
158 
159 
160     // PUBLIC METHODS
161 
162     /// @notice Changes the competition address
163     /// @param ofCompetition Address of the competition contract
164     function changeCompetitionAddress(
165         address ofCompetition
166     )
167         pre_cond(isOwner())
168     {
169         competitionAddress = ofCompetition;
170     }
171 
172 }