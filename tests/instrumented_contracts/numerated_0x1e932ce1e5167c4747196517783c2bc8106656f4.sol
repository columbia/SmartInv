1 // **-----------------------------------------------
2 // EthBet.io Token sale contract
3 // Final revision 16a
4 // Refunds integrated, full test suite passed
5 // **-----------------------------------------------
6 // ERC Token Standard #20 Interface
7 // https://github.com/ethereum/EIPs/issues/20
8 // -------------------------------------------------
9 // Price configuration:
10 // First Day Bonus    +50% = 1,500 EBET  = 1 ETH       [blocks: start   -> s+3600]
11 // First Week Bonus   +40% = 1,400 EBET  = 1 ETH       [blocks: s+3601  -> s+25200]
12 // Second Week Bonus  +30% = 1,300 EBET  = 1 ETH       [blocks: s+25201 -> s+50400]
13 // Third Week Bonus   +25% = 1,250 EBET  = 1 ETH       [blocks: s+50401 -> s+75600]
14 // Final Week Bonus   +15% = 1,150 EBET  = 1 ETH       [blocks: s+75601 -> end]
15 // -------------------------------------------------
16 contract owned {
17     address public owner;
18 
19     function owned() {
20         owner = msg.sender;
21     }
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26     function transferOwnership(address newOwner) onlyOwner {
27         owner = newOwner;
28     }
29 }
30 
31 contract safeMath {
32   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
33     uint256 c = a * b;
34     safeAssert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
39     safeAssert(b > 0);
40     uint256 c = a / b;
41     safeAssert(a == b * c + a % b);
42     return c;
43   }
44 
45   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
46     safeAssert(b <= a);
47     return a - b;
48   }
49 
50   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
51     uint256 c = a + b;
52     safeAssert(c>=a && c>=b);
53     return c;
54   }
55 
56   function safeAssert(bool assertion) internal {
57     if (!assertion) revert();
58   }
59 }
60 
61 contract StandardToken is owned, safeMath {
62   function balanceOf(address who) constant returns (uint256);
63   function transfer(address to, uint256 value) returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract EBETCrowdsale is owned, safeMath {
68   // owner/admin & token reward
69   address        public admin                     = owner;   // admin address
70   StandardToken  public tokenReward;                          // address of the token used as reward
71 
72   // deployment variables for static supply sale
73   uint256 public initialSupply;
74   uint256 public tokensRemaining;
75 
76   // multi-sig addresses and price variable
77   address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account, live is 0x00F959866E977698D14a36eB332686304a4d6AbA
78   uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,500 tokens per Eth
79 
80   // uint256 values for min,max,caps,tracking
81   uint256 public amountRaisedInWei;                           //
82   uint256 public fundingMinCapInWei;                          //
83 
84   // loop control, ICO startup and limiters
85   string  public CurrentStatus                   = "";        // current crowdsale status
86   uint256 public fundingStartBlock;                           // crowdsale start block#
87   uint256 public fundingEndBlock;                             // crowdsale end block#
88   bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
89   bool    public areFundsReleasedToBeneficiary   = false;     // boolean for founder to receive Eth or not
90   bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
91 
92   event Transfer(address indexed from, address indexed to, uint256 value);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94   event Buy(address indexed _sender, uint256 _eth, uint256 _EBET);
95   event Refund(address indexed _refunder, uint256 _value);
96   event Burn(address _from, uint256 _value);
97   mapping(address => uint256) balancesArray;
98   mapping(address => uint256) fundValue;
99 
100   // default function, map admin
101   function EBETCrowdsale() onlyOwner {
102     admin = msg.sender;
103     CurrentStatus = "Crowdsale deployed to chain";
104   }
105 
106   // total number of tokens initially
107   function initialEBETSupply() constant returns (uint256 tokenTotalSupply) {
108       tokenTotalSupply = safeDiv(initialSupply,100);
109   }
110 
111   // remaining number of tokens
112   function remainingSupply() constant returns (uint256 tokensLeft) {
113       tokensLeft = tokensRemaining;
114   }
115 
116   // setup the CrowdSale parameters
117   function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
118       if ((msg.sender == admin)
119       && (!(isCrowdSaleSetup))
120       && (!(beneficiaryWallet > 0))){
121           // init addresses
122           tokenReward                             = StandardToken(0x7D5Edcd23dAa3fB94317D32aE253eE1Af08Ba14d);  //mainnet is 0x7D5Edcd23dAa3fB94317D32aE253eE1Af08Ba14d //testnet = 0x75508c2B1e46ea29B7cCf0308d4Cb6f6af6211e0
123           beneficiaryWallet                       = 0x00F959866E977698D14a36eB332686304a4d6AbA;   // mainnet is 0x00F959866E977698D14a36eB332686304a4d6AbA //testnet = 0xDe6BE2434E8eD8F74C8392A9eB6B6F7D63DDd3D7
124           tokensPerEthPrice                       = 1500;                                         // set day1 initial value floating priceVar 1,500 tokens per Eth
125 
126           // funding targets
127           fundingMinCapInWei                      = 300000000000000000000;                          //300000000000000000000 =  300 Eth (min cap) - crowdsale is considered success after this value  //testnet 6000000000000000000 = 6Eth
128 
129           // update values
130           amountRaisedInWei                       = 0;
131           initialSupply                           = 750000000;                                      //   7,500,000 + 2 decimals = 750000000 //testnet 1100000 =11,000
132           tokensRemaining                         = safeDiv(initialSupply,100);
133 
134           fundingStartBlock                       = _fundingStartBlock;
135           fundingEndBlock                         = _fundingEndBlock;
136 
137           // configure crowdsale
138           isCrowdSaleSetup                        = true;
139           isCrowdSaleClosed                       = false;
140           CurrentStatus                           = "Crowdsale is setup";
141 
142           //gas reduction experiment
143           setPrice();
144           return "Crowdsale is setup";
145       } else if (msg.sender != admin) {
146           return "not authorized";
147       } else  {
148           return "campaign cannot be changed";
149       }
150     }
151 
152     function setPrice() {
153       // Price configuration:
154       // First Day Bonus    +50% = 1,500 EBET  = 1 ETH       [blocks: start -> s+3600]
155       // First Week Bonus   +40% = 1,400 EBET  = 1 ETH       [blocks: s+3601  -> s+25200]
156       // Second Week Bonus  +30% = 1,300 EBET  = 1 ETH       [blocks: s+25201 -> s+50400]
157       // Third Week Bonus   +25% = 1,250 EBET  = 1 ETH       [blocks: s+50401 -> s+75600]
158       // Final Week Bonus   +15% = 1,150 EBET  = 1 ETH       [blocks: s+75601 -> endblock]
159       if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+3600) { // First Day Bonus    +50% = 1,500 EBET  = 1 ETH  [blocks: start -> s+24]
160         tokensPerEthPrice=1500;
161       } else if (block.number >= fundingStartBlock+3601 && block.number <= fundingStartBlock+25200) { // First Week Bonus   +40% = 1,400 EBET  = 1 ETH  [blocks: s+25 -> s+45]
162         tokensPerEthPrice=1400;
163       } else if (block.number >= fundingStartBlock+25201 && block.number <= fundingStartBlock+50400) { // Second Week Bonus  +30% = 1,300 EBET  = 1 ETH  [blocks: s+46 -> s+65]
164         tokensPerEthPrice=1300;
165       } else if (block.number >= fundingStartBlock+50401 && block.number <= fundingStartBlock+75600) { // Third Week Bonus   +25% = 1,250 EBET  = 1 ETH  [blocks: s+66 -> s+85]
166         tokensPerEthPrice=1250;
167       } else if (block.number >= fundingStartBlock+75601 && block.number <= fundingEndBlock) { // Final Week Bonus   +15% = 1,150 EBET  = 1 ETH  [blocks: s+86 -> endBlock]
168         tokensPerEthPrice=1150;
169       }
170     }
171 
172     // default payable function when sending ether to this contract
173     function () payable {
174       require(msg.data.length == 0);
175       BuyEBETtokens();
176     }
177 
178     function BuyEBETtokens() payable {
179       // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
180       require(!(msg.value == 0)
181       && (isCrowdSaleSetup)
182       && (block.number >= fundingStartBlock)
183       && (block.number <= fundingEndBlock)
184       && (tokensRemaining > 0));
185 
186       // 1. vars
187       uint256 rewardTransferAmount    = 0;
188 
189       // 2. effects
190       setPrice();
191       amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);
192       rewardTransferAmount            = safeDiv(safeMul(msg.value,tokensPerEthPrice),10000000000000000);
193 
194       // 3. interaction
195       tokensRemaining                 = safeSub(tokensRemaining, safeDiv(rewardTransferAmount,100));  // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached
196       tokenReward.transfer(msg.sender, rewardTransferAmount);
197 
198       // 4. events
199       fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);
200       Transfer(this, msg.sender, msg.value);
201       Buy(msg.sender, msg.value, rewardTransferAmount);
202     }
203 
204     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
205       require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
206       beneficiaryWallet.transfer(_amount);
207     }
208 
209     function checkGoalReached() onlyOwner returns (bytes32 response) { // return crowdfund status to owner for each result case, update public constant
210       // update state & status variables
211       require (isCrowdSaleSetup);
212       if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
213         areFundsReleasedToBeneficiary = false;
214         isCrowdSaleClosed = false;
215         CurrentStatus = "In progress (Eth < Softcap)";
216         return "In progress (Eth < Softcap)";
217       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started
218         areFundsReleasedToBeneficiary = false;
219         isCrowdSaleClosed = false;
220         CurrentStatus = "Crowdsale is setup";
221         return "Crowdsale is setup";
222       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
223         areFundsReleasedToBeneficiary = false;
224         isCrowdSaleClosed = true;
225         CurrentStatus = "Unsuccessful (Eth < Softcap)";
226         return "Unsuccessful (Eth < Softcap)";
227       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens gone
228           areFundsReleasedToBeneficiary = true;
229           isCrowdSaleClosed = true;
230           CurrentStatus = "Successful (EBET >= Hardcap)!";
231           return "Successful (EBET >= Hardcap)!";
232       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { // ICO ended, over softcap!
233           areFundsReleasedToBeneficiary = true;
234           isCrowdSaleClosed = true;
235           CurrentStatus = "Successful (Eth >= Softcap)!";
236           return "Successful (Eth >= Softcap)!";
237       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
238         areFundsReleasedToBeneficiary = true;
239         isCrowdSaleClosed = false;
240         CurrentStatus = "In progress (Eth >= Softcap)!";
241         return "In progress (Eth >= Softcap)!";
242       }
243       setPrice();
244     }
245 
246     function refund() { // any contributor can call this to have their Eth returned. user's purchased EBET tokens are burned prior refund of Eth.
247       //require minCap not reached
248       require ((amountRaisedInWei < fundingMinCapInWei)
249       && (isCrowdSaleClosed)
250       && (block.number > fundingEndBlock)
251       && (fundValue[msg.sender] > 0));
252 
253       //burn user's token EBET token balance, refund Eth sent
254       uint256 ethRefund = fundValue[msg.sender];
255       balancesArray[msg.sender] = 0;
256       fundValue[msg.sender] = 0;
257       Burn(msg.sender, ethRefund);
258 
259       //send Eth back, burn tokens
260       msg.sender.transfer(ethRefund);
261       Refund(msg.sender, ethRefund);
262     }
263 }