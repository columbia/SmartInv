1 pragma solidity ^0.4.18;
2 // -------------------------------------------------
3 // ethPoker.io EPX token - Presale & ICO token sale contract
4 // Private Pre-sale preloaded sale contract
5 // 150ETH capped contract (only 1.5M tokens @ best 10,000 EPX:1ETH)
6 // 150ETH matches 1:1 ethPoker.io directors injection of 150ETH
7 // contact admin@ethpoker.io for queries
8 // Revision 20b
9 // Refunds integrated, full test suite 20r passed
10 // -------------------------------------------------
11 // ERC Token Standard #20 interface:
12 // https://github.com/ethereum/EIPs/issues/20
13 // EPX contract sources:
14 // https://github.com/EthPokerIO/ethpokerIO
15 // ------------------------------------------------
16 // 2018 improvements:
17 // - Updates to comply with latest Solidity versioning (0.4.18):
18 // -   Classification of internal/private vs public functions
19 // -   Specification of pure functions such as SafeMath integrated functions
20 // -   Conversion of all constant to view or pure dependant on state changed
21 // -   Full regression test of code updates
22 // -   Revision of block number timing for new Ethereum block times
23 // - Removed duplicate Buy/Transfer event call in buyEPXtokens function (ethScan output verified)
24 // - Burn event now records number of EPX tokens burned vs Refund event Eth
25 // - Transfer event now fired when beneficiaryWallet withdraws
26 // - Gas req optimisation for payable function to maximise compatibility
27 // - Going live for initial Presale round 02/03/2018
28 // -------------------------------------------------
29 // Security reviews passed - cycle 20r
30 // Functional reviews passed - cycle 20r
31 // Final code revision and regression test cycle passed - cycle 20r
32 // -------------------------------------------------
33 
34 contract owned {
35   address public owner;
36 
37   function owned() internal {
38     owner = msg.sender;
39   }
40   modifier onlyOwner {
41     require(msg.sender == owner);
42     _;
43   }
44 }
45 
46 contract safeMath {
47   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a * b;
49     safeAssert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
54     safeAssert(b > 0);
55     uint256 c = a / b;
56     safeAssert(a == b * c + a % b);
57     return c;
58   }
59 
60   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
61     safeAssert(b <= a);
62     return a - b;
63   }
64 
65   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     safeAssert(c>=a && c>=b);
68     return c;
69   }
70 
71   function safeAssert(bool assertion) internal pure {
72     if (!assertion) revert();
73   }
74 }
75 
76 contract StandardToken is owned, safeMath {
77   function balanceOf(address who) view public returns (uint256);
78   function transfer(address to, uint256 value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 contract EPXCrowdsale is owned, safeMath {
83   // owner/admin & token reward
84   address        public admin                     = owner;    // admin address
85   StandardToken  public tokenReward;                          // address of the token used as reward
86 
87   // deployment variables for static supply sale
88   uint256 private initialTokenSupply;
89   uint256 private tokensRemaining;
90 
91   // multi-sig addresses and price variable
92   address private beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account
93 
94   // uint256 values for min,max,caps,tracking
95   uint256 public amountRaisedInWei;                           //
96   uint256 public fundingMinCapInWei;                          //
97 
98   // loop control, ICO startup and limiters
99   string  public CurrentStatus                    = "";        // current crowdsale status
100   uint256 public fundingStartBlock;                           // crowdsale start block#
101   uint256 public fundingEndBlock;                             // crowdsale end block#
102   bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
103   bool    private areFundsReleasedToBeneficiary  = false;     // boolean for founder to receive Eth or not
104   bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
105 
106   event Transfer(address indexed from, address indexed to, uint256 value);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
109   event Refund(address indexed _refunder, uint256 _value);
110   event Burn(address _from, uint256 _value);
111   mapping(address => uint256) balancesArray;
112   mapping(address => uint256) usersEPXfundValue;
113 
114   // default function, map admin
115   function EPXCrowdsale() public onlyOwner {
116     admin = msg.sender;
117     CurrentStatus = "Crowdsale deployed to chain";
118   }
119 
120   // total number of tokens initially
121   function initialEPXSupply() public view returns (uint256 initialEPXtokenCount) {
122     return safeDiv(initialTokenSupply,10000); // div by 10,000 for display normalisation (4 decimals)
123   }
124 
125   // remaining number of tokens
126   function remainingEPXSupply() public view returns (uint256 remainingEPXtokenCount) {
127     return safeDiv(tokensRemaining,10000); // div by 10,000 for display normalisation (4 decimals)
128   }
129 
130   // setup the CrowdSale parameters
131   function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) public onlyOwner returns (bytes32 response) {
132     if ((msg.sender == admin)
133     && (!(isCrowdSaleSetup))
134     && (!(beneficiaryWallet > 0))) {
135       // init addresses
136       beneficiaryWallet                       = 0x7A29e1343c6a107ce78199F1b3a1d2952efd77bA;
137       tokenReward                             = StandardToken(0x35BAA72038F127f9f8C8f9B491049f64f377914d);
138 
139       // funding targets
140       fundingMinCapInWei                      = 10000000000000000000;
141 
142       // update values
143       amountRaisedInWei                       = 0;
144       initialTokenSupply                      = 15000000000;
145       tokensRemaining                         = initialTokenSupply;
146       fundingStartBlock                       = _fundingStartBlock;
147       fundingEndBlock                         = _fundingEndBlock;
148 
149       // configure crowdsale
150       isCrowdSaleSetup                        = true;
151       isCrowdSaleClosed                       = false;
152       CurrentStatus                           = "Crowdsale is setup";
153       return "Crowdsale is setup";
154     } else if (msg.sender != admin) {
155       return "not authorised";
156     } else  {
157       return "campaign cannot be changed";
158     }
159   }
160 
161   function checkPrice() internal view returns (uint256 currentPriceValue) {
162     if (block.number >= fundingStartBlock+177534) { // 30-day price change/final 30day change
163       return (8500); //30days-end   =8,500EPX:1ETH
164     } else if (block.number >= fundingStartBlock+124274) { //3 week mark/over 21days
165       return (9250); //3w-30days    =9,250EPX:1ETH
166     } else if (block.number >= fundingStartBlock) { // start [0 hrs]
167       return (10000); //0-3weeks     =10,000EPX:1ETH
168     }
169   }
170 
171   // default payable function when sending ether to this contract
172   function () public payable {
173     // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
174     require(!(msg.value == 0)
175     && (msg.data.length == 0)
176     && (block.number <= fundingEndBlock)
177     && (block.number >= fundingStartBlock)
178     && (tokensRemaining > 0));
179 
180     // 1. vars
181     uint256 rewardTransferAmount    = 0;
182 
183     // 2. effects
184     amountRaisedInWei               = safeAdd(amountRaisedInWei, msg.value);
185     rewardTransferAmount            = ((safeMul(msg.value, checkPrice())) / 100000000000000);
186 
187     // 3. interaction
188     tokensRemaining                 = safeSub(tokensRemaining, rewardTransferAmount);
189     tokenReward.transfer(msg.sender, rewardTransferAmount);
190 
191     // 4. events
192     usersEPXfundValue[msg.sender]   = safeAdd(usersEPXfundValue[msg.sender], msg.value);
193     Buy(msg.sender, msg.value, rewardTransferAmount);
194   }
195 
196   function beneficiaryMultiSigWithdraw(uint256 _amount) public onlyOwner {
197     require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
198     beneficiaryWallet.transfer(_amount);
199     Transfer(this, beneficiaryWallet, _amount);
200   }
201 
202   function checkGoalReached() public onlyOwner { // return crowdfund status to owner for each result case, update public vars
203     // update state & status variables
204     require (isCrowdSaleSetup);
205     if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
206       areFundsReleasedToBeneficiary = false;
207       isCrowdSaleClosed = false;
208       CurrentStatus = "In progress (Eth < Softcap)";
209     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started
210       areFundsReleasedToBeneficiary = false;
211       isCrowdSaleClosed = false;
212       CurrentStatus = "Crowdsale is setup";
213     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
214       areFundsReleasedToBeneficiary = false;
215       isCrowdSaleClosed = true;
216       CurrentStatus = "Unsuccessful (Eth < Softcap)";
217     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens bought!
218       areFundsReleasedToBeneficiary = true;
219       isCrowdSaleClosed = true;
220       CurrentStatus = "Successful (EPX >= Hardcap)!";
221     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { // ICO ended, over softcap!
222       areFundsReleasedToBeneficiary = true;
223       isCrowdSaleClosed = true;
224       CurrentStatus = "Successful (Eth >= Softcap)!";
225     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
226       areFundsReleasedToBeneficiary = true;
227       isCrowdSaleClosed = false;
228       CurrentStatus = "In progress (Eth >= Softcap)!";
229     }
230   }
231 
232   function refund() public { // any contributor can call this to have their Eth returned. user's purchased EPX tokens are burned prior refund of Eth.
233     //require minCap not reached
234     require ((amountRaisedInWei < fundingMinCapInWei)
235     && (isCrowdSaleClosed)
236     && (block.number > fundingEndBlock)
237     && (usersEPXfundValue[msg.sender] > 0));
238 
239     //burn user's token EPX token balance, refund Eth sent
240     uint256 ethRefund = usersEPXfundValue[msg.sender];
241     balancesArray[msg.sender] = 0;
242     usersEPXfundValue[msg.sender] = 0;
243 
244     //record Burn event with number of EPX tokens burned
245     Burn(msg.sender, usersEPXfundValue[msg.sender]);
246 
247     //send Eth back
248     msg.sender.transfer(ethRefund);
249 
250     //record Refund event with number of Eth refunded in transaction
251     Refund(msg.sender, ethRefund);
252   }
253 }