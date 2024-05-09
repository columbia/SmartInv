1 pragma solidity ^0.4.11;
2 
3 
4 // **-----------------------------------------------
5 // Betstreak Token sale contract
6 // Revision 1.1
7 // Refunds integrated, full test suite passed
8 // **-----------------------------------------------
9 // ERC Token Standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 // -------------------------------------------------
12 // ICO configuration:
13 // Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]
14 // First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+3601  -> s+50400]
15 // Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+25201 -> s+75600]
16 // Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+50401 -> s+100800]
17 // Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+75601 -> end]
18 // -------------------------------------------------
19 
20 contract owned {
21     address public owner;
22   
23 	
24     function owned() {
25         owner = msg.sender;
26         
27     }
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32     function transferOwnership(address newOwner) onlyOwner {
33         owner = newOwner;
34     }
35 }
36 
37 contract safeMath {
38   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
39     uint256 c = a * b;
40     safeAssert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
45     safeAssert(b > 0);
46     uint256 c = a / b;
47     safeAssert(a == b * c + a % b);
48     return c;
49   }
50 
51   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
52     safeAssert(b <= a);
53     return a - b;
54   }
55 
56   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
57     uint256 c = a + b;
58     safeAssert(c>=a && c>=b);
59     return c;
60   }
61 
62   function safeAssert(bool assertion) internal {
63     if (!assertion) revert();
64   }
65 }
66 
67 contract StandardToken is owned, safeMath {
68   function balanceOf(address who) constant returns (uint256);
69   function transfer(address to, uint256 value) returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BetstreakICO is owned, safeMath {
74     
75   // owner/admin & token reward
76   address        public admin = owner;      // admin address
77   StandardToken  public tokenReward;        // address of the token used as reward
78   
79 
80   // deployment variables for static supply sale
81   uint256 public initialSupply;
82 
83   uint256 public tokensRemaining;
84 
85   // multi-sig addresses and price variable
86   address public beneficiaryWallet;
87   // beneficiaryMultiSig (founder group) or wallet account, live is 0x361e14cC5b3CfBa5D197D8a9F02caf71B3dca6Fd
88   
89   
90   uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,300 tokens per Eth
91 
92   // uint256 values for min,max,caps,tracking
93   uint256 public amountRaisedInWei;                           //
94   uint256 public fundingMinCapInWei;                          //
95 
96   // loop control, ICO startup and limiters
97   string  public CurrentStatus                   = "";        // current crowdsale status
98   uint256 public fundingStartBlock;                           // crowdsale start block#
99   uint256 public fundingEndBlock;                             // crowdsale end block#
100   bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
101   bool    public areFundsReleasedToBeneficiary   = false;     // boolean for founders to receive Eth or not
102   bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
103 
104   event Transfer(address indexed from, address indexed to, uint256 value);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106   event Buy(address indexed _sender, uint256 _eth, uint256 _BST);
107   event Refund(address indexed _refunder, uint256 _value);
108   event Burn(address _from, uint256 _value);
109   mapping(address => uint256) balancesArray;
110   mapping(address => uint256) fundValue;
111 
112   // default function, map admin
113   function BetstreakICO() onlyOwner {
114     admin = msg.sender;
115     CurrentStatus = "Crowdsale deployed to chain";
116   }
117 
118   // total number of tokens initially
119   function initialBSTSupply() constant returns (uint256 tokenTotalSupply) {
120       tokenTotalSupply = safeDiv(initialSupply,100); 
121   }
122 
123   // remaining number of tokens
124   function remainingSupply() constant returns (uint256 tokensLeft) {
125       tokensLeft = tokensRemaining;
126   }
127 
128   // setup the CrowdSale parameters
129   function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
130       
131       if ((msg.sender == admin)
132       && (!(isCrowdSaleSetup))  
133       && (!(beneficiaryWallet > 0))){
134       
135           // init addresses
136           tokenReward                             = StandardToken(0xA7F40CCD6833a65dD514088F4d419Afd9F0B0B52);  
137           
138           
139           
140           beneficiaryWallet                       = 0x361e14cC5b3CfBa5D197D8a9F02caf71B3dca6Fd;
141           
142          
143           tokensPerEthPrice                       = 1300;                                         
144           // set day1 initial value floating priceVar 1,300 tokens per Eth
145 
146           // funding targets
147           fundingMinCapInWei                      = 1000000000000000000000;                          
148           //300000000000000000000 =  1000 Eth (min cap) - crowdsale is considered success after this value  
149           //testnet 5000000000000000000 = 5Eth
150 
151 
152           // update values
153           amountRaisedInWei                       = 0;
154           initialSupply                           = 20000000000;                                      
155           //   200,000,000 + 2 decimals = 200,000,000,00 
156           //testnet 1100000 = 11,000
157           
158           tokensRemaining                         = safeDiv(initialSupply,100);
159 
160           fundingStartBlock                       = _fundingStartBlock;
161           fundingEndBlock                         = _fundingEndBlock;
162 
163           // configure crowdsale
164           isCrowdSaleSetup                        = true;
165           isCrowdSaleClosed                       = false;
166           CurrentStatus                           = "Crowdsale is setup";
167 
168           //gas reduction experiment
169           setPrice();
170           return "Crowdsale is setup";
171           
172       } else if (msg.sender != admin) {
173           return "not authorized";
174           
175       } else  {
176           return "campaign cannot be changed";
177       }
178     }
179 
180 
181     function setPrice() {
182         
183         // ICO configuration:
184         // Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]
185         // First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+25201  -> s+50400]
186         // Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+50401 -> s+75600]
187         // Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+75601 -> s+100800]
188         // Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+100801 -> end]
189         
190       if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+25200) { 
191           // Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]
192           
193         tokensPerEthPrice=1300;
194         
195       } else if (block.number >= fundingStartBlock+25201 && block.number <= fundingStartBlock+50400) { 
196           // First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+25201  -> s+50400]
197           
198         tokensPerEthPrice=1200;
199         
200       } else if (block.number >= fundingStartBlock+50401 && block.number <= fundingStartBlock+75600) { 
201           // Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+50401 -> s+75600]
202           
203         tokensPerEthPrice=1100;
204         
205       } else if (block.number >= fundingStartBlock+75601 && block.number <= fundingStartBlock+100800) { 
206           // Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+75601 -> s+100800]
207           
208         tokensPerEthPrice=1050;
209         
210       } else if (block.number >= fundingStartBlock+100801 && block.number <= fundingEndBlock) { 
211           // Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+100801 -> end]
212           
213         tokensPerEthPrice=1000;
214       }
215     }
216 
217     // default payable function when sending ether to this contract
218     function () payable {
219       require(msg.data.length == 0);
220       BuyBSTtokens();
221     }
222 
223     function BuyBSTtokens() payable {
224         
225       // 0. conditions (length, crowdsale setup, zero check, 
226       //exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
227       require(!(msg.value == 0)
228       && (isCrowdSaleSetup)
229       && (block.number >= fundingStartBlock)
230       && (block.number <= fundingEndBlock)
231       && (tokensRemaining > 0));
232 
233       // 1. vars
234       uint256 rewardTransferAmount    = 0;
235 
236       // 2. effects
237       setPrice();
238       amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);
239       rewardTransferAmount            = safeDiv(safeMul(msg.value,tokensPerEthPrice),10000000000000000);
240 
241       // 3. interaction
242       tokensRemaining                 = safeSub(tokensRemaining, safeDiv(rewardTransferAmount,100));  
243       // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached
244       tokenReward.transfer(msg.sender, rewardTransferAmount);
245 
246       // 4. events
247       fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);
248       Transfer(this, msg.sender, msg.value);
249       Buy(msg.sender, msg.value, rewardTransferAmount);
250     }
251     
252 
253     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
254       require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
255       beneficiaryWallet.transfer(_amount);
256     }
257 
258     function checkGoalReached() onlyOwner returns (bytes32 response) {
259         
260         // return crowdfund status to owner for each result case, update public constant
261         // update state & status variables
262       require (isCrowdSaleSetup);
263       
264       if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { 
265         // ICO in progress, under softcap
266         areFundsReleasedToBeneficiary = false;
267         isCrowdSaleClosed = false;
268         CurrentStatus = "In progress (Eth < Softcap)";
269         return "In progress (Eth < Softcap)";
270         
271       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started
272         areFundsReleasedToBeneficiary = false;
273         isCrowdSaleClosed = false;
274         CurrentStatus = "Presale is setup";
275         return "Presale is setup";
276         
277         
278       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
279         areFundsReleasedToBeneficiary = false;
280         isCrowdSaleClosed = true;
281         CurrentStatus = "Unsuccessful (Eth < Softcap)";
282         return "Unsuccessful (Eth < Softcap)";
283         
284       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens gone
285           areFundsReleasedToBeneficiary = true;
286           isCrowdSaleClosed = true;
287           CurrentStatus = "Successful (BST >= Hardcap)!";
288           return "Successful (BST >= Hardcap)!";
289           
290           
291       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { 
292           
293           // ICO ended, over softcap!
294           areFundsReleasedToBeneficiary = true;
295           isCrowdSaleClosed = true;
296           CurrentStatus = "Successful (Eth >= Softcap)!";
297           return "Successful (Eth >= Softcap)!";
298           
299           
300       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { 
301           
302           // ICO in progress, over softcap!
303         areFundsReleasedToBeneficiary = true;
304         isCrowdSaleClosed = false;
305         CurrentStatus = "In progress (Eth >= Softcap)!";
306         return "In progress (Eth >= Softcap)!";
307       }
308       
309       setPrice();
310     }
311 
312     function refund() { 
313         
314         // any contributor can call this to have their Eth returned. 
315         // user's purchased BST tokens are burned prior refund of Eth.
316         //require minCap not reached
317         
318       require ((amountRaisedInWei < fundingMinCapInWei)
319       && (isCrowdSaleClosed)
320       && (block.number > fundingEndBlock)
321       && (fundValue[msg.sender] > 0));
322 
323       //burn user's token BST token balance, refund Eth sent
324       uint256 ethRefund = fundValue[msg.sender];
325       balancesArray[msg.sender] = 0;
326       fundValue[msg.sender] = 0;
327       Burn(msg.sender, ethRefund);
328 
329       //send Eth back, burn tokens
330       msg.sender.transfer(ethRefund);
331       Refund(msg.sender, ethRefund);
332     }
333 }