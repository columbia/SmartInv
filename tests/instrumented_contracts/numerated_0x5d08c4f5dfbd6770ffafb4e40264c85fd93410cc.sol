1 pragma solidity ^0.4.11;
2 
3 /// @title DNNToken contract - Main DNN contract
4 /// @author Dondrey Taylor - <dondrey@dnn.media>
5 contract DNNToken {
6     enum DNNSupplyAllocations {
7         EarlyBackerSupplyAllocation,
8         PRETDESupplyAllocation,
9         TDESupplyAllocation,
10         BountySupplyAllocation,
11         WriterAccountSupplyAllocation,
12         AdvisorySupplyAllocation,
13         PlatformSupplyAllocation
14     }
15     function issueTokens(address, uint256, DNNSupplyAllocations) public returns (bool) {}
16 }
17 
18 /// @title DNNRedemption contract - Issues DNN tokens
19 /// @author Dondrey Taylor - <dondrey@dnn.media>
20 contract DNNRedemption {
21 
22     /////////////////////////
23     // DNN Token Contract  //
24     /////////////////////////
25     DNNToken public dnnToken;
26 
27     //////////////////////////////////////////
28     // Addresses of the co-founders of DNN. //
29     //////////////////////////////////////////
30     address public cofounderA;
31     address public cofounderB;
32 
33     /////////////////////////////////////////////////
34     // Number of tokens distributed (in atto-DNN) //
35     /////////////////////////////////////////////////
36     uint256 public tokensDistributed = 0;
37 
38     //////////////////////////////////////////////////////////////////
39     // Maximum number of tokens for this distribution (in atto-DNN) //
40     //////////////////////////////////////////////////////////////////
41     uint256 public maxTokensToDistribute = 30000000 * 1 ether;
42 
43     ///////////////////////////////////////////////
44     // Used to generate number of tokens to send //
45     ///////////////////////////////////////////////
46     uint256 public seed = 8633926795440059073718754917553891166080514579013872221976080033791214;
47 
48     /////////////////////////////////////////////////
49     // We'll keep track of who we have sent DNN to //
50     /////////////////////////////////////////////////
51     mapping(address => uint256) holders;
52 
53     /////////////////////////////////////////////////////////////////////////////
54     // Event triggered when tokens are transferred from one address to another //
55     /////////////////////////////////////////////////////////////////////////////
56     event Redemption(address indexed to, uint256 value);
57 
58 
59     ////////////////////////////////////////////////////
60     // Checks if CoFounders are performing the action //
61     ////////////////////////////////////////////////////
62     modifier onlyCofounders() {
63         require (msg.sender == cofounderA || msg.sender == cofounderB);
64         _;
65     }
66 
67     ///////////////////////////////////////////////////////////////
68     // @des DNN Holder Check                                     //
69     // @param Checks if we sent DNN to the benfeficiary before   //
70     ///////////////////////////////////////////////////////////////
71     function hasDNN(address beneficiary) public view returns (bool) {
72         return holders[beneficiary] > 0;
73     }
74 
75     ///////////////////////////////////////////////////
76     // Make sure that user did no redeeem DNN before //
77     ///////////////////////////////////////////////////
78     modifier doesNotHaveDNN(address beneficiary) {
79         require(hasDNN(beneficiary) == false);
80         _;
81     }
82 
83     //////////////////////////////////////////////////////////
84     //  @des Updates max token distribution amount          //
85     //  @param New amount of tokens that can be distributed //
86     //////////////////////////////////////////////////////////
87     function updateMaxTokensToDistribute(uint256 maxTokens)
88       public
89       onlyCofounders
90     {
91         maxTokensToDistribute = maxTokens;
92     }
93 
94     ///////////////////////////////////////////////////////////////
95     // @des Issues bounty tokens                                 //
96     // @param beneficiary Address the tokens will be issued to.  //
97     ///////////////////////////////////////////////////////////////
98     function issueTokens(address beneficiary)
99         public
100         doesNotHaveDNN(beneficiary)
101         returns (uint256)
102     {
103         // Number of tokens that we'll send
104         uint256 tokenCount = (uint(keccak256(abi.encodePacked(blockhash(block.number-1), seed ))) % 1000);
105 
106         // If the amount is over 200 then we'll cap the tokens we'll
107         // give to 200 to prevent giving too many. Since the highest amount
108         // of tokens earned in the bounty was 99 DNN, we'll be issuing a bonus to everyone
109         // for the long wait.
110         if (tokenCount > 200) {
111             tokenCount = 200;
112         }
113 
114         // Change atto-DNN to DNN
115         tokenCount = tokenCount * 1 ether;
116 
117         // If we have reached our max tokens then we'll bail out of the transaction
118         if (tokensDistributed+tokenCount > maxTokensToDistribute) {
119             revert();
120         }
121 
122         // Update holder balance
123         holders[beneficiary] = tokenCount;
124 
125         // Update total amount of tokens distributed (in atto-DNN)
126         tokensDistributed = tokensDistributed + tokenCount;
127 
128         // Allocation type will be Platform
129         DNNToken.DNNSupplyAllocations allocationType = DNNToken.DNNSupplyAllocations.PlatformSupplyAllocation;
130 
131         // Attempt to issue tokens
132         if (!dnnToken.issueTokens(beneficiary, tokenCount, allocationType)) {
133             revert();
134         }
135 
136         // Emit redemption event
137         Redemption(beneficiary, tokenCount);
138 
139         return tokenCount;
140     }
141 
142     ///////////////////////////////
143     // @des Contract constructor //
144     ///////////////////////////////
145     constructor() public
146     {
147         // Set token address
148         dnnToken = DNNToken(0x9d9832d1beb29cc949d75d61415fd00279f84dc2);
149 
150         // Set cofounder addresses
151         cofounderA = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
152         cofounderB = 0x9FFE2aD5D76954C7C25be0cEE30795279c4Cab9f;
153     }
154 
155     ////////////////////////////////////////////////////////
156     // @des ONLY SEND 0 ETH TRANSACTIONS TO THIS CONTRACT //
157     ////////////////////////////////////////////////////////
158     function () public payable {
159         if (!hasDNN(msg.sender)) issueTokens(msg.sender);
160         else revert();
161     }
162 }