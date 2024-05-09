1 pragma solidity ^0.4.18;
2 // **-----------------------------------------------
3 // MoyToken Open Distribution Smart Contract.
4 // 30,000,000 tokens available via unique Open Distribution. 
5 // POWTokens Contract @ POWToken.eth
6 // Open Dsitribution Opens at the 1st Block of 2018.
7 // All operations can be monitored at etherscan.io
8 
9 // -----------------------------------------------
10 // ERC Token Standard #20 Interface
11 // https://github.com/ethereum/EIPs/issues/20
12 // -------------------------------------------------
13 
14 contract owned {
15     address public owner;
16 
17     function owned() public {
18         owner = msg.sender;
19     }
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24     function transferOwnership(address newOwner) public onlyOwner {
25         owner = newOwner;
26     }
27 }
28 
29 contract safeMath {
30   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a * b;
32     safeAssert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
37     safeAssert(b > 0);
38     uint256 c = a / b;
39     safeAssert(a == b * c + a % b);
40     return c;
41   }
42 
43   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
44     safeAssert(b <= a);
45     return a - b;
46   }
47 
48   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     safeAssert(c>=a && c>=b);
51     return c;
52   }
53 
54   function safeAssert(bool assertion) internal pure {
55     if (!assertion) revert();
56   }
57 }
58 
59 contract StandardToken is owned, safeMath {
60   function balanceOf(address who) public constant returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract MoyTokenOpenDistribution is owned, safeMath {
66   // owner/admin & token reward
67   address        public admin = owner;      //admin address
68   StandardToken  public tokenContract;     // address of MoibeTV MOY ERC20 Standard Token.
69 
70   // deployment variables for static supply sale
71   uint256 public initialSupply;
72   uint256 public tokensRemaining;
73 
74   // multi-sig addresses and price variable
75   address public budgetWallet;      // budgetMultiSig for PowerLineUp.
76   uint256 public tokensPerEthPrice;      // set initial value floating priceVar.
77     
78   // uint256 values for min,max,caps,tracking
79   uint256 public amountRaised;                           
80   uint256 public fundingCap;                          
81 
82   // loop control, startup and limiters
83   string  public CurrentStatus = "";                          // current OpenDistribution status
84   uint256 public fundingStartBlock;                           // OpenDistribution start block#
85   uint256 public fundingEndBlock;                             // OpenDistribution end block#
86   bool    public isOpenDistributionClosed = false;            // OpenDistribution completion boolean
87   bool    public areFundsReleasedToBudget= false;             // boolean for MoibeTV to receive Eth or not, this allows MoibeTV to use Ether only if goal reached.
88   bool    public isOpenDistributionSetup = false;             // boolean for OpenDistribution setup
89 
90   event Transfer(address indexed from, address indexed to, uint256 value); 
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92   event Buy(address indexed _sender, uint256 _eth, uint256 _MOY);
93   mapping(address => uint256) balancesArray;
94   mapping(address => uint256) fundValue;
95 
96   // default function, map admin
97   function MoyOpenDistribution() public onlyOwner {
98     admin = msg.sender;
99     CurrentStatus = "Tokens Released, Open Distribution deployed to chain";
100   }
101 
102   // total number of tokens initially
103   function initialMoySupply() public constant returns (uint256 tokenTotalSupply) {
104       tokenTotalSupply = safeDiv(initialSupply,100);
105   }
106 
107   // remaining number of tokens
108   function remainingSupply() public constant returns (uint256 tokensLeft) {
109       tokensLeft = tokensRemaining;
110   }
111 
112   // setup the OpenDistribution parameters
113   function setupOpenDistribution(uint256 _fundingStartBlock, uint256 _fundingEndBlock, address _tokenContract, address _budgetWallet) public onlyOwner returns (bytes32 response) {
114       if ((msg.sender == admin)
115       && (!(isOpenDistributionSetup))
116       && (!(budgetWallet > 0))){
117           // init addresses
118           tokenContract = StandardToken(_tokenContract);                             //MoibeTV MOY tokens Smart Contract.
119           budgetWallet = _budgetWallet;                 //Budget multisig.
120           tokensPerEthPrice = 1000;                                                  //Regular Price 1 ETH = 1000 MOY.
121           
122           fundingCap = 3;                                        
123 
124           // update values
125           amountRaised = 0;
126           initialSupply = 30000000;                                      
127           tokensRemaining = safeDiv(initialSupply,1);
128 
129           fundingStartBlock = _fundingStartBlock;
130           fundingEndBlock = _fundingEndBlock;
131 
132           // configure OpenDistribution
133           isOpenDistributionSetup = true;
134           isOpenDistributionClosed = false;
135           CurrentStatus = "OpenDistribution is setup";
136 
137           //gas reduction experiment
138           setPrice();
139           return "OpenDistribution is setup";
140       } else if (msg.sender != admin) {
141           return "Not Authorized";
142       } else  {
143           return "Campaign cannot be changed.";
144       }
145     }
146 
147     function setPrice() public {  //Verificar si es necesario que sea pública. 
148 
149       //Funding Starts at the 1st Block of the Year. The very 1st block of the year is 4830771 UTC+14(Christmas Islands).      
150       //After that, all the CrowdSale is measured in UTC-11(Fiji), to give chance until the very last block of each day.    
151         if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+11520) { // First Day 300% Bonus, 1 ETH = 3000 MOY.
152         tokensPerEthPrice = 3000; 
153       } else if (block.number >= fundingStartBlock+11521 && block.number <= fundingStartBlock+46080) { // First Week 200% Bonus, 1 ETH = 2000 MOY.
154         tokensPerEthPrice = 2000; //Regular Price for All Stages.
155       } else if (block.number >= fundingStartBlock+46081 && block.number <= fundingStartBlock+86400) { // Second Week 150% Bonus, 1 ETH = 1500 MOY.
156         tokensPerEthPrice = 2000; //Regular Price for All Stages.
157       } else if (block.number >= fundingStartBlock+86401 && block.number <= fundingEndBlock) { // Regular Sale, final price for all users 1 ETH = 1000 MOY. 
158         tokensPerEthPrice = 1000; //Regular Price for All Stages.
159       }  
160          }
161 
162     // default payable function when sending ether to this contract
163     function () public payable {
164       require(msg.data.length == 0);
165       BuyMOYTokens();
166     }
167 
168     function BuyMOYTokens() public payable {
169       // 0. conditions (length, OpenDistribution setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc.)
170       require(!(msg.value == 0)
171       && (isOpenDistributionSetup)
172       && (block.number >= fundingStartBlock)
173       && (block.number <= fundingEndBlock)
174       && (tokensRemaining > 0));
175 
176       // 1. vars
177       uint256 rewardTransferAmount = 0;
178 
179       // 2. effects
180       setPrice();
181       amountRaised = safeAdd(amountRaised,msg.value);
182       rewardTransferAmount = safeDiv(safeMul(msg.value,tokensPerEthPrice),1);
183 
184       // 3. interaction
185       tokensRemaining = safeSub(tokensRemaining, safeDiv(rewardTransferAmount,1));  // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached.
186       tokenContract.transfer(msg.sender, rewardTransferAmount);
187 
188       // 4. events
189       fundValue[msg.sender] = safeAdd(fundValue[msg.sender], msg.value);
190       Transfer(this, msg.sender, msg.value); 
191       Buy(msg.sender, msg.value, rewardTransferAmount);
192     }
193 
194     function budgetMultiSigWithdraw(uint256 _amount) public onlyOwner {
195       require(areFundsReleasedToBudget && (amountRaised >= fundingCap));
196       budgetWallet.transfer(_amount);
197     }
198 
199     function checkGoalReached() public onlyOwner returns (bytes32 response) { // return OpenDistribution status to owner for each result case, update public constant.
200       // update state & status variables
201       require (isOpenDistributionSetup);
202       if ((amountRaised < fundingCap) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // OpenDistribution in progress waiting for hardcap.
203         areFundsReleasedToBudget = false;
204         isOpenDistributionClosed = false;
205         CurrentStatus = "OpenDistribution in progress, waiting to reach goal.";
206         return "OpenDistribution in progress.";
207       } else if ((amountRaised < fundingCap) && (block.number < fundingStartBlock)) { // OpenDistribution has not started.
208         areFundsReleasedToBudget = false;
209         isOpenDistributionClosed = false;
210         CurrentStatus = "OpenDistribution is setup";
211         return "OpenDistribution is setup";
212       } else if ((amountRaised < fundingCap) && (block.number > fundingEndBlock)) { // OpenDistribution ended, total not achieved.
213         areFundsReleasedToBudget = false;
214         isOpenDistributionClosed = true;
215         CurrentStatus = "OpenDistribution is Over.";
216         return "OpenDistribution is Over";
217       } else if ((amountRaised >= fundingCap) && (tokensRemaining == 0)) { // Distribution ended, all tokens gone.
218           areFundsReleasedToBudget = true;
219           isOpenDistributionClosed = true;
220           CurrentStatus = "Successful OpenDistribution.";
221           return "Successful OpenDistribution.";
222       } else if ((amountRaised >= fundingCap) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { // OpenDistribution ended.
223           areFundsReleasedToBudget = true;
224           isOpenDistributionClosed = true;
225           CurrentStatus = "Successful OpenDistribution.";
226           return "Successful OpenDistribution";
227       } else if ((amountRaised >= fundingCap) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { // OpenDistribution in progress, objetive achieved!
228         areFundsReleasedToBudget = true;
229         isOpenDistributionClosed = false;
230         CurrentStatus = "OpenDistribution in Progress, Goal Achieved.";
231         return "Goal Achieved.";
232       }
233       setPrice();
234     }
235 }