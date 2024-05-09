1 pragma solidity ^0.4.18;
2 // -------------------------------------------------
3 // Assistive Reality ARX Token - ICO token sale contract
4 // contact staff@aronline.io for queries
5 // Revision 20b
6 // Refunds integrated, full test suite 20r passed
7 // -------------------------------------------------
8 // ERC Token Standard #20 interface:
9 // https://github.com/ethereum/EIPs/issues/20
10 // ------------------------------------------------
11 // 2018 improvements:
12 // - Updates to comply with latest Solidity versioning (0.4.18):
13 // -   Classification of internal/private vs public functions
14 // -   Specification of pure functions such as SafeMath integrated functions
15 // -   Conversion of all constant to view or pure dependant on state changed
16 // -   Full regression test of code updates
17 // -   Revision of block number timing for new Ethereum block times
18 // - Removed duplicate Buy/Transfer event call in buyARXtokens function (ethScan output verified)
19 // - Burn event now records number of ARX tokens burned vs Refund event Eth
20 // - Transfer event now fired when beneficiaryWallet withdraws
21 // - Gas req optimisation for payable function to maximise compatibility
22 // - Going live in code ahead of ICO announcement 09th March 2018 19:30 GMT
23 // -------------------------------------------------
24 // Security reviews passed - cycle 20r
25 // Functional reviews passed - cycle 20r
26 // Final code revision and regression test cycle passed - cycle 20r
27 // -------------------------------------------------
28 
29 contract owned {
30   address public owner;
31 
32   function owned() internal {
33     owner = msg.sender;
34   }
35   modifier onlyOwner {
36     require(msg.sender == owner);
37     _;
38   }
39 }
40 
41 contract safeMath {
42   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     safeAssert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
49     safeAssert(b > 0);
50     uint256 c = a / b;
51     safeAssert(a == b * c + a % b);
52     return c;
53   }
54 
55   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
56     safeAssert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     safeAssert(c>=a && c>=b);
63     return c;
64   }
65 
66   function safeAssert(bool assertion) internal pure {
67     if (!assertion) revert();
68   }
69 }
70 
71 contract StandardToken is owned, safeMath {
72   function balanceOf(address who) view public returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ARXCrowdsale is owned, safeMath {
78   // owner/admin & token reward
79   address        public admin                     = owner;    // admin address
80   StandardToken  public tokenReward;                          // address of the token used as reward
81 
82   // deployment variables for static supply sale
83   uint256 private initialTokenSupply;
84   uint256 private tokensRemaining;
85 
86   // multi-sig addresses and price variable
87   address private beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account
88 
89   // uint256 values for min,max,caps,tracking
90   uint256 public amountRaisedInWei;                           //
91   uint256 public fundingMinCapInWei;                          //
92   uint256 public fundingMaxCapInWei;                          //
93 
94   // loop control, ICO startup and limiters
95   string  public CurrentStatus                    = "";        // current crowdsale status
96   uint256 public fundingStartBlock;                           // crowdsale start block#
97   uint256 public fundingEndBlock;                             // crowdsale end block#
98   bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
99   bool    private areFundsReleasedToBeneficiary  = false;     // boolean for founder to receive Eth or not
100   bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
101 
102   event Transfer(address indexed from, address indexed to, uint256 value);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
105   event Refund(address indexed _refunder, uint256 _value);
106   event Burn(address _from, uint256 _value);
107   mapping(address => uint256) balancesArray;
108   mapping(address => uint256) usersARXfundValue;
109 
110   // default function, map admin
111   function ARXCrowdsale() public onlyOwner {
112     admin = msg.sender;
113     CurrentStatus = "Crowdsale deployed to chain";
114   }
115 
116   // total number of tokens initially
117   function initialARXSupply() public view returns (uint256 initialARXtokenCount) {
118     return safeDiv(initialTokenSupply,1000000000000000000); // div by 1000000000000000000 for display normalisation (18 decimals)
119   }
120 
121   // remaining number of tokens
122   function remainingARXSupply() public view returns (uint256 remainingARXtokenCount) {
123     return safeDiv(tokensRemaining,1000000000000000000); // div by 1000000000000000000 for display normalisation (18 decimals)
124   }
125 
126   // setup the CrowdSale parameters
127   function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) public onlyOwner returns (bytes32 response) {
128     if ((msg.sender == admin)
129     && (!(isCrowdSaleSetup))
130     && (!(beneficiaryWallet > 0))) {
131       // init addresses
132       beneficiaryWallet                       = 0x98DE47A1F7F96500276900925B334E4e54b1caD5;
133       tokenReward                             = StandardToken(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);
134 
135       // funding targets
136       fundingMinCapInWei                      = 30000000000000000000;                       // 300  ETH wei
137       initialTokenSupply                      = 277500000000000000000000000;                // 277,500,000 + 18 dec resolution
138 
139       // update values
140       amountRaisedInWei                       = 0;
141       tokensRemaining                         = initialTokenSupply;
142       fundingStartBlock                       = _fundingStartBlock;
143       fundingEndBlock                         = _fundingEndBlock;
144       fundingMaxCapInWei                      = 4500000000000000000000;
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
159     if (block.number >= 5532293) {
160       return (2250);
161     } else if (block.number >= 5490292) {
162       return (2500);
163     } else if (block.number >= 5406291) {
164       return (2750);
165     } else if (block.number >= 5370290) {
166       return (3000);
167     } else if (block.number >= 5352289) {
168       return (3250);
169     } else if (block.number >= 5310289) {
170       return (3500);
171     } else if (block.number >= 5268288) {
172       return (4000);
173     } else if (block.number >= 5232287) {
174       return (4500);
175     } else if (block.number >= fundingStartBlock) {
176       return (5000);
177     }
178   }
179 
180   // default payable function when sending ether to this contract
181   function () public payable {
182     // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
183     require(!(msg.value == 0)
184     && (msg.data.length == 0)
185     && (block.number <= fundingEndBlock)
186     && (block.number >= fundingStartBlock)
187     && (tokensRemaining > 0));
188 
189     // 1. vars
190     uint256 rewardTransferAmount    = 0;
191 
192     // 2. effects
193     amountRaisedInWei               = safeAdd(amountRaisedInWei, msg.value);
194     rewardTransferAmount            = (safeMul(msg.value, checkPrice()));
195 
196     // 3. interaction
197     tokensRemaining                 = safeSub(tokensRemaining, rewardTransferAmount);
198     tokenReward.transfer(msg.sender, rewardTransferAmount);
199 
200     // 4. events
201     usersARXfundValue[msg.sender]   = safeAdd(usersARXfundValue[msg.sender], msg.value);
202     Buy(msg.sender, msg.value, rewardTransferAmount);
203   }
204 
205   function beneficiaryMultiSigWithdraw(uint256 _amount) public onlyOwner {
206     require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
207     beneficiaryWallet.transfer(_amount);
208     Transfer(this, beneficiaryWallet, _amount);
209   }
210 
211   function checkGoalReached() public onlyOwner { // return crowdfund status to owner for each result case, update public vars
212     // update state & status variables
213     require (isCrowdSaleSetup);
214     if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
215       areFundsReleasedToBeneficiary = false;
216       isCrowdSaleClosed = false;
217       CurrentStatus = "In progress (Eth < Softcap)";
218     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started
219       areFundsReleasedToBeneficiary = false;
220       isCrowdSaleClosed = false;
221       CurrentStatus = "Crowdsale is setup";
222     } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
223       areFundsReleasedToBeneficiary = false;
224       isCrowdSaleClosed = true;
225       CurrentStatus = "Unsuccessful (Eth < Softcap)";
226     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens bought!
227       areFundsReleasedToBeneficiary = true;
228       isCrowdSaleClosed = true;
229       CurrentStatus = "Successful (ARX >= Hardcap)!";
230     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { // ICO ended, over softcap!
231       areFundsReleasedToBeneficiary = true;
232       isCrowdSaleClosed = true;
233       CurrentStatus = "Successful (Eth >= Softcap)!";
234     } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
235       areFundsReleasedToBeneficiary = true;
236       isCrowdSaleClosed = false;
237       CurrentStatus = "In progress (Eth >= Softcap)!";
238     }
239   }
240 
241   function refund() public { // any contributor can call this to have their Eth returned. user's purchased ARX tokens are burned prior refund of Eth.
242     //require minCap not reached
243     require ((amountRaisedInWei < fundingMinCapInWei)
244     && (isCrowdSaleClosed)
245     && (block.number > fundingEndBlock)
246     && (usersARXfundValue[msg.sender] > 0));
247 
248     //burn user's token ARX token balance, refund Eth sent
249     uint256 ethRefund = usersARXfundValue[msg.sender];
250     balancesArray[msg.sender] = 0;
251     usersARXfundValue[msg.sender] = 0;
252 
253     //record Burn event with number of ARX tokens burned
254     Burn(msg.sender, usersARXfundValue[msg.sender]);
255 
256     //send Eth back
257     msg.sender.transfer(ethRefund);
258 
259     //record Refund event with number of Eth refunded in transaction
260     Refund(msg.sender, ethRefund);
261   }
262 }