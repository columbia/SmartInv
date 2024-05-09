1 pragma solidity ^0.4.13;
2 // -------------------------------------------------
3 // 0.4.13+commit.0fb4cb1a
4 // [Assistive Reality ARX token ETH cap presale contract]
5 // [Contact staff@aronline.io for any queries]
6 // [Join us in changing the world]
7 // [aronline.io]
8 // -------------------------------------------------
9 // ERC Token Standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 // -------------------------------------------------
12 // 1,000 ETH capped Pre-sale contract
13 // Security reviews completed 26/09/17 [passed OK]
14 // Functional reviews completed 26/09/17 [passed OK]
15 // Final code revision and regression test cycle complete 26/09/17 [passed OK]
16 // -------------------------------------------------
17 
18 contract owned {
19     address public owner;
20 
21     function owned() {
22         owner = msg.sender;
23     }
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28     function transferOwnership(address newOwner) onlyOwner {
29         owner = newOwner;
30     }
31 }
32 
33 contract safeMath {
34   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
35     uint256 c = a * b;
36     safeAssert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
41     safeAssert(b > 0);
42     uint256 c = a / b;
43     safeAssert(a == b * c + a % b);
44     return c;
45   }
46 
47   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
48     safeAssert(b <= a);
49     return a - b;
50   }
51 
52   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
53     uint256 c = a + b;
54     safeAssert(c>=a && c>=b);
55     return c;
56   }
57 
58   function safeAssert(bool assertion) internal {
59     if (!assertion) revert();
60   }
61 }
62 
63 contract ERC20Interface is owned, safeMath {
64   function balanceOf(address _owner) constant returns (uint256 balance);
65   function transfer(address _to, uint256 _value) returns (bool success);
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
67   function approve(address _spender, uint256 _value) returns (bool success);
68   function increaseApproval (address _spender, uint _addedValue) returns (bool success);
69   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
70   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
72   event Transfer(address indexed _from, address indexed _to, uint256 _value);
73   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 contract ARXpresale is owned, safeMath {
77   // owner/admin & token reward
78   address         public admin                   = owner;     // admin address
79   ERC20Interface  public tokenReward;                         // address of the token used as reward
80 
81   // multi-sig addresses and price variable
82   address public foundationWallet;                            // foundationMultiSig (foundation fund) or wallet account, for company operations/licensing of Assistive Reality products
83   address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account, live is 0x00F959866E977698D14a36eB332686304a4d6AbA
84   uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,500 tokens per Eth
85 
86   // uint256 values for min,max caps & tracking
87   uint256 public amountRaisedInWei;                           // 0 initially (0)
88   uint256 public fundingMinCapInWei;                          // 100 ETH (10%) (100 000 000 000 000 000 000)
89   uint256 public fundingMaxCapInWei;                          // 1,000 ETH in Wei (1000 000 000 000 000 000 000)
90   uint256 public fundingRemainingAvailableInEth;              // ==((fundingMaxCapInWei - amountRaisedInWei)/1 ether); (resolution will only be to integer)
91 
92   // loop control, ICO startup and limiters
93   string  public currentStatus                   = "";        // current presale status
94   uint256 public fundingStartBlock;                           // presale start block#
95   uint256 public fundingEndBlock;                             // presale end block#
96   bool    public isPresaleClosed                 = false;     // presale completion boolean
97   bool    public isPresaleSetup                  = false;     // boolean for presale setup
98 
99   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
100   event Transfer(address indexed _from, address indexed _to, uint256 _value);
101   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102   event Refund(address indexed _refunder, uint256 _value);
103   event Burn(address _from, uint256 _value);
104 
105   mapping(address => uint256) balances;
106   mapping(address => uint256) fundValue;
107 
108   // default function, map admin
109   function ARXpresale() onlyOwner {
110     admin = msg.sender;
111     currentStatus = "presale deployed to chain";
112   }
113 
114   // setup the presale parameters
115   function Setuppresale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
116       if ((msg.sender == admin)
117       && (!(isPresaleSetup))
118       && (!(beneficiaryWallet > 0))){
119           // init addresses
120           tokenReward                             = ERC20Interface(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);   // mainnet is 0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5
121           beneficiaryWallet                       = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;                   // mainnet is 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f
122           foundationWallet                        = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;                   // mainnet is 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA
123           tokensPerEthPrice                       = 8000;                                                         // set day1 presale value floating priceVar 8,000 ARX tokens per 1 ETH
124 
125           // funding targets
126           fundingMinCapInWei                      = 100000000000000000000;                                        // 100000000000000000000  = 100 Eth (min cap) //testnet 2500000000000000000   = 2.5 Eth
127           fundingMaxCapInWei                      = 1000000000000000000000;                                       // 1000000000000000000000 = 1000 Eth (max cap) //testnet 6500000000000000000  = 6.5 Eth
128 
129           // update values
130           amountRaisedInWei                       = 0;                                                            // init value to 0
131           fundingRemainingAvailableInEth          = safeDiv(fundingMaxCapInWei,1 ether);
132 
133           fundingStartBlock                       = _fundingStartBlock;
134           fundingEndBlock                         = _fundingEndBlock;
135 
136           // configure presale
137           isPresaleSetup                          = true;
138           isPresaleClosed                         = false;
139           currentStatus                           = "presale is setup";
140 
141           //gas reduction experiment
142           setPrice();
143           return "presale is setup";
144       } else if (msg.sender != admin) {
145           return "not authorized";
146       } else  {
147           return "campaign cannot be changed";
148       }
149     }
150 
151     function setPrice() {
152       // Price configuration mainnet:
153       // Day 0-1 Price   1 ETH = 8000 ARX [blocks: start    -> s+3600]  0 - +24hr
154       // Day 1-3 Price   1 ETH = 7250 ARX [blocks: s+3601   -> s+10800] +24hr - +72hr
155       // Day 3-5 Price   1 ETH = 6750 ARX [blocks: s+10801  -> s+18000] +72hr - +120hr
156       // Dau 5-7 Price   1 ETH = 6250 ARX [blocks: s+18001  -> <=fundingEndBlock] = +168hr (168/24 = 7 [x])
157 
158       if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+3600) { // 8000 ARX Day 1 level only
159         tokensPerEthPrice=8000;
160       } else if (block.number >= fundingStartBlock+3601 && block.number <= fundingStartBlock+10800) { // 7250 ARX Day 2,3
161         tokensPerEthPrice=7250;
162       } else if (block.number >= fundingStartBlock+10801 && block.number <= fundingStartBlock+18000) { // 6750 ARX Day 4,5
163         tokensPerEthPrice=6750;
164       } else if (block.number >= fundingStartBlock+18001 && block.number <= fundingEndBlock) { // 6250 ARX Day 6,7
165         tokensPerEthPrice=6250;
166       } else {
167         tokensPerEthPrice=6250; // default back out to this value instead of failing to return or return 0/halting;
168       }
169     }
170 
171     // default payable function when sending ether to this contract
172     function () payable {
173       require(msg.data.length == 0);
174       BuyARXtokens();
175     }
176 
177     function BuyARXtokens() payable {
178       // 0. conditions (length, presale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
179       require(!(msg.value == 0)
180       && (isPresaleSetup)
181       && (block.number >= fundingStartBlock)
182       && (block.number <= fundingEndBlock)
183       && !(safeAdd(amountRaisedInWei,msg.value) > fundingMaxCapInWei));
184 
185       // 1. vars
186       uint256 rewardTransferAmount    = 0;
187 
188       // 2. effects
189       setPrice();
190       amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);
191       rewardTransferAmount            = safeMul(msg.value,tokensPerEthPrice);
192       fundingRemainingAvailableInEth  = safeDiv(safeSub(fundingMaxCapInWei,amountRaisedInWei),1 ether);
193 
194       // 3. interaction
195       tokenReward.transfer(msg.sender, rewardTransferAmount);
196       fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);
197 
198       // 4. events
199       Transfer(this, msg.sender, msg.value);
200       Buy(msg.sender, msg.value, rewardTransferAmount);
201     }
202 
203     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
204       require(amountRaisedInWei >= fundingMinCapInWei);
205       beneficiaryWallet.transfer(_amount);
206     }
207 
208     function checkGoalandPrice() onlyOwner returns (bytes32 response) {
209       // update state & status variables
210       require (isPresaleSetup);
211       if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // presale in progress, under softcap
212         currentStatus = "In progress (Eth < Softcap)";
213         return "In progress (Eth < Softcap)";
214       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // presale has not started
215         currentStatus = "presale is setup";
216         return "presale is setup";
217       } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, under softcap
218         currentStatus = "Unsuccessful (Eth < Softcap)";
219         return "Unsuccessful (Eth < Softcap)";
220       } else if (amountRaisedInWei >= fundingMaxCapInWei) {  // presale successful, at hardcap!
221           currentStatus = "Successful (ARX >= Hardcap)!";
222           return "Successful (ARX >= Hardcap)!";
223       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, over softcap!
224           currentStatus = "Successful (Eth >= Softcap)!";
225           return "Successful (Eth >= Softcap)!";
226       } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number <= fundingEndBlock)) { // presale in progress, over softcap!
227         currentStatus = "In progress (Eth >= Softcap)!";
228         return "In progress (Eth >= Softcap)!";
229       }
230       setPrice();
231     }
232 
233     function refund() { // any contributor can call this to have their Eth returned. user's purchased ARX tokens are burned prior refund of Eth.
234       //require minCap not reached
235       require ((amountRaisedInWei < fundingMinCapInWei)
236       && (isPresaleClosed)
237       && (block.number > fundingEndBlock)
238       && (fundValue[msg.sender] > 0));
239 
240       //burn user's token ARX token balance, refund Eth sent
241       uint256 ethRefund = fundValue[msg.sender];
242       balances[msg.sender] = 0;
243       fundValue[msg.sender] = 0;
244       Burn(msg.sender, ethRefund);
245 
246       //send Eth back, burn tokens
247       msg.sender.transfer(ethRefund);
248       Refund(msg.sender, ethRefund);
249     }
250 
251     function withdrawRemainingTokens(uint256 _amountToPull) onlyOwner {
252       require(block.number >= fundingEndBlock);
253       tokenReward.transfer(msg.sender, _amountToPull);
254     }
255 
256     function updateStatus() onlyOwner {
257       require((block.number >= fundingEndBlock) || (amountRaisedInWei >= fundingMaxCapInWei));
258       isPresaleClosed = true;
259       currentStatus = "packagesale is closed";
260     }
261   }