1 pragma solidity ^0.4.18;
2 // -------------------------------------------------
3 // ethPoker.io EPX token - Presale & ICO token sale contract
4 // contact admin@ethpoker.io for queries
5 // Revision 20b
6 // Refunds integrated, full test suite 20r passed
7 // -------------------------------------------------
8 // ERC Token Standard #20 interface:
9 // https://github.com/ethereum/EIPs/issues/20
10 // EPX contract sources:
11 // https://github.com/EthPokerIO/ethpokerIO
12 // ------------------------------------------------
13 // 2018 improvements:
14 // - Updates to comply with latest Solidity versioning (0.4.18):
15 // -   Classification of internal/private vs public functions
16 // -   Specification of pure functions such as SafeMath integrated functions
17 // -   Conversion of all constant to view or pure dependant on state changed
18 // -   Full regression test of code updates
19 // -   Revision of block number timing for new Ethereum block times
20 // - Removed duplicate Buy/Transfer event call in buyEPXtokens function (ethScan output verified)
21 // - Burn event now records number of EPX tokens burned vs Refund event Eth
22 // - Transfer event now fired when beneficiaryWallet withdraws
23 // - Gas req optimisation for payable function to maximise compatibility
24 // - Going live for initial Presale round 02/03/2018
25 // -------------------------------------------------
26 // Security reviews passed - cycle 20r
27 // Functional reviews passed - cycle 20r
28 // Final code revision and regression test cycle passed - cycle 20r
29 // -------------------------------------------------
30 
31 contract owned {
32   address public owner;
33 
34   function owned() internal {
35     owner = msg.sender;
36   }
37   modifier onlyOwner {
38     require(msg.sender == owner);
39     _;
40   }
41 }
42 
43 contract safeMath {
44   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a * b;
46     safeAssert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
51     safeAssert(b > 0);
52     uint256 c = a / b;
53     safeAssert(a == b * c + a % b);
54     return c;
55   }
56 
57   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
58     safeAssert(b <= a);
59     return a - b;
60   }
61 
62   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     safeAssert(c>=a && c>=b);
65     return c;
66   }
67 
68   function safeAssert(bool assertion) internal pure {
69     if (!assertion) revert();
70   }
71 }
72 
73 contract StandardToken is owned, safeMath {
74   function balanceOf(address who) view public returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract EPXCrowdsale is owned, safeMath {
80   // owner/admin & token reward
81   address        public admin                     = owner;    // admin address
82   StandardToken  public tokenReward;                          // address of the token used as reward
83 
84   // deployment variables for static supply sale
85   uint256 private initialTokenSupply;
86   uint256 private tokensRemaining;
87 
88   // multi-sig addresses and price variable
89   address private beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account
90 
91   // uint256 values for min,max,caps,tracking
92   uint256 public amountRaisedInWei;                           //
93   uint256 public fundingMinCapInWei;                          //
94 
95   // loop control, ICO startup and limiters
96   string  public CurrentStatus                    = "";        // current crowdsale status
97   uint256 public fundingStartBlock;                           // crowdsale start block#
98   uint256 public fundingEndBlock;                             // crowdsale end block#
99   bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
100   bool    private areFundsReleasedToBeneficiary  = false;     // boolean for founder to receive Eth or not
101   bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
102 
103   event Transfer(address indexed from, address indexed to, uint256 value);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
106   event Refund(address indexed _refunder, uint256 _value);
107   event Burn(address _from, uint256 _value);
108   mapping(address => uint256) balancesArray;
109   mapping(address => uint256) usersEPXfundValue;
110 
111   // default function, map admin
112   function EPXCrowdsale() public onlyOwner {
113     admin = msg.sender;
114     CurrentStatus = "Crowdsale deployed to chain";
115   }
116 
117   // total number of tokens initially
118   function initialEPXSupply() public view returns (uint256 initialEPXtokenCount) {
119     return safeDiv(initialTokenSupply,10000); // div by 10,000 for display normalisation (4 decimals)
120   }
121 
122   // remaining number of tokens
123   function remainingEPXSupply() public view returns (uint256 remainingEPXtokenCount) {
124     return safeDiv(tokensRemaining,10000); // div by 10,000 for display normalisation (4 decimals)
125   }
126 
127   // setup the CrowdSale parameters
128   function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) public onlyOwner returns (bytes32 response) {
129     if ((msg.sender == admin)
130     && (!(isCrowdSaleSetup))
131     && (!(beneficiaryWallet > 0))) {
132       // init addresses
133       beneficiaryWallet                       = 0x7A29e1343c6a107ce78199F1b3a1d2952efd77bA;
134       tokenReward                             = StandardToken(0x0C686Cd98F816bf63C037F39E73C1b7A35b51D4C);
135 
136       // funding targets
137       fundingMinCapInWei                      = 30000000000000000000;                       // ETH 300 + 000000000000000000 18 dec wei
138 
139       // update values
140       amountRaisedInWei                       = 0;
141       initialTokenSupply                      = 200000000000;                               // 20,000,000 + 4 dec resolution
142       tokensRemaining                         = initialTokenSupply;
143       fundingStartBlock                       = _fundingStartBlock;
144       fundingEndBlock                         = _fundingEndBlock;
145 
146       // configure crowdsale
147       isCrowdSaleSetup                        = true;
148       isCrowdSaleClosed                       = false;
149       CurrentStatus                           = "Crowdsale is setup";
150       return "Crowdsale is setup";
151     } else if (msg.sender != admin) {
152       return "not authorised";
153     } else  {
154       return "campaign cannot be changed";
155     }
156   }
157 
158   function checkPrice() internal view returns (uint256 currentPriceValue) {
159     if (block.number >= fundingStartBlock+177534) { // 30-day price change/final 30day change
160       return (7600); //30days-end   =7600ARX:1ETH
161     } else if (block.number >= fundingStartBlock+124274) { //3 week mark/over 21days
162       return (8200); //3w-30days    =8200ARX:1ETH
163     } else if (block.number >= fundingStartBlock) { // start [0 hrs]
164       return (8800); //0-3weeks     =8800ARX:1ETH
165     }
166   }
167 
168   // default payable function when sending ether to this contract
169   function () public payable {
170     // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
171     require(!(msg.value == 0)
172     && (msg.data.length == 0)
173     && (block.number <= fundingEndBlock)
174     && (block.number >= fundingStartBlock)
175     && (tokensRemaining > 0));
176 
177     // 1. vars
178     uint256 rewardTransferAmount    = 0;
179 
180     // 2. effects
181     amountRaisedInWei               = safeAdd(amountRaisedInWei, msg.value);
182     rewardTransferAmount            = ((safeMul(msg.value, checkPrice())) / 100000000000000);
183 
184     // 3. interaction
185     tokensRemaining                 = safeSub(tokensRemaining, rewardTransferAmount);
186     tokenReward.transfer(msg.sender, rewardTransferAmount);
187 
188     // 4. events
189     usersEPXfundValue[msg.sender]   = safeAdd(usersEPXfundValue[msg.sender], msg.value);
190     Buy(msg.sender, msg.value, rewardTransferAmount);
191   }
192 
193   function beneficiaryMultiSigWithdraw(uint256 _amount) public onlyOwner {
194     require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
195     beneficiaryWallet.transfer(_amount);
196     Transfer(this, beneficiaryWallet, _amount);
197   }
198 
199   function checkGoalReached() public onlyOwner { // return crowdfund status to owner for each result case, update public vars
200     // update state & status variables
201     require (isCrowdSaleSetup);
202     if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
203       areFundsReleasedToBeneficiary = false;
204       isCrowdSaleClosed = false;
205       CurrentStatus = "In progress (Eth < Softcap)";
206     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started
207       areFundsReleasedToBeneficiary = false;
208       isCrowdSaleClosed = false;
209       CurrentStatus = "Crowdsale is setup";
210     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
211       areFundsReleasedToBeneficiary = false;
212       isCrowdSaleClosed = true;
213       CurrentStatus = "Unsuccessful (Eth < Softcap)";
214     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens bought!
215       areFundsReleasedToBeneficiary = true;
216       isCrowdSaleClosed = true;
217       CurrentStatus = "Successful (EPX >= Hardcap)!";
218     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { // ICO ended, over softcap!
219       areFundsReleasedToBeneficiary = true;
220       isCrowdSaleClosed = true;
221       CurrentStatus = "Successful (Eth >= Softcap)!";
222     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
223       areFundsReleasedToBeneficiary = true;
224       isCrowdSaleClosed = false;
225       CurrentStatus = "In progress (Eth >= Softcap)!";
226     }
227   }
228 
229   function refund() public { // any contributor can call this to have their Eth returned. user's purchased EPX tokens are burned prior refund of Eth.
230     //require minCap not reached
231     require ((amountRaisedInWei < fundingMinCapInWei)
232     && (isCrowdSaleClosed)
233     && (block.number > fundingEndBlock)
234     && (usersEPXfundValue[msg.sender] > 0));
235 
236     //burn user's token EPX token balance, refund Eth sent
237     uint256 ethRefund = usersEPXfundValue[msg.sender];
238     balancesArray[msg.sender] = 0;
239     usersEPXfundValue[msg.sender] = 0;
240 
241     //record Burn event with number of EPX tokens burned
242     Burn(msg.sender, usersEPXfundValue[msg.sender]);
243 
244     //send Eth back
245     msg.sender.transfer(ethRefund);
246 
247     //record Refund event with number of Eth refunded in transaction
248     Refund(msg.sender, ethRefund);
249   }
250 }