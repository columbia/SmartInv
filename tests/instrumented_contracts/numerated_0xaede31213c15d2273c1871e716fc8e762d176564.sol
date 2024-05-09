1 pragma solidity ^0.4.13;
2 // **-----------------------------------------------
3 // [Assistive Reality ARX ERC20 token & crowdsale contract w/10% dev alloc]
4 // [https://aronline.io/icoinfo]
5 // [v3.2 final released 05/09/17 final masterARXsale32mainnet.sol]
6 // [Adapted from Ethereum standard crowdsale contract]
7 // [Contact staff@aronline.io for any queries]
8 // [Join us in changing the world]
9 // [aronline.io]
10 // **-----------------------------------------------
11 // ERC Token Standard #20 Interface
12 // https://github.com/ethereum/EIPs/issues/20
13 // -------------------------------------------------
14 // Security reviews completed 05/09/17 [passed OK]
15 // Functional reviews completed 05/09/17 [passed OK]
16 // Final code revision and regression test cycle complete 05/09/17 [passed]
17 // https://github.com/assistivereality/ico/blob/master/3.2crowdsaletestsARXmainnet.txt
18 // -------------------------------------------------
19 contract owned { // security reviewed 05/09/17
20     address public owner;
21 
22     function owned() {
23         owner = msg.sender;
24     }
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29     function transferOwnership(address newOwner) onlyOwner {
30         owner = newOwner;
31     }
32 }
33 
34 contract SafeMath { // security reviewed 05/09/17
35   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
36     uint256 c = a * b;
37     safeAssert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
42     safeAssert(b > 0);
43     uint256 c = a / b;
44     safeAssert(a == b * c + a % b);
45     return c;
46   }
47 
48   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
49     safeAssert(b <= a);
50     return a - b;
51   }
52 
53   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
54     uint256 c = a + b;
55     safeAssert(c>=a && c>=b);
56     return c;
57   }
58 
59   function safeAssert(bool assertion) internal {
60     if (!assertion) revert();
61   }
62 }
63 
64 contract ERC20Interface is owned, SafeMath { // security reviewed 05/09/17
65     function totalSupply() constant returns (uint256 tokenTotalSupply);
66     function balanceOf(address _owner) constant returns (uint256 balance);
67     function transfer(address _to, uint256 _value) returns (bool success);
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
69     function approve(address _spender, uint256 _value) returns (bool success);
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71     event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Burn(address _from, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     event Refund(address indexed _refunder, uint256 _value);
76 }
77 
78 contract ARXCrowdsale is ERC20Interface { // security reviewed 05/09/17
79     // deployment variables for dynamic supply token
80     string  public constant standard              = "ARX";
81     string  public constant name                  = "ARX";
82     string  public constant symbol                = "ARX";
83     uint8   public constant decimals              = 18;
84     uint256 _totalSupply                          = 0;
85 
86     // multi-sig addresses and price variable
87     address public admin = owner;                               // admin address
88     address public beneficiaryMultiSig;                         // beneficiaryMultiSig (founder group) multi-sig wallet account
89     address public foundationFundMultisig;                      // foundationFundMultisig multi-sig wallet address - Assistive Reality foundation fund
90     uint256 public tokensPerEthPrice;                           // priceVar e.g. 2,000 tokens per Eth
91 
92     // uint256 values for min,max,caps,tracking
93     uint256 public amountRaisedInWei;                           // total amount raised in Wei e.g. 21 000 000 000 000 000 000 = 21 Eth
94     uint256 public fundingMaxInWei;                             // funding max in Wei e.g. 21 000 000 000 000 000 000 = 21 Eth
95     uint256 public fundingMinInWei;                             // funding min in Wei e.g. 11 000 000 000 000 000 000 = 11 Eth
96     uint256 public fundingMaxInEth;                             // funding max in Eth (approx) e.g. 21 Eth
97     uint256 public fundingMinInEth;                             // funding min in Eth (approx) e.g. 11 Eth
98     uint256 public remainingCapInWei;                           // amount of cap remaining to raise in Wei e.g. 1 200 000 000 000 000 000 = 1.2 Eth remaining
99     uint256 public remainingCapInEth;                           // amount of cap remaining to raise in Eth (approx) e.g. 1
100     uint256 public foundationFundTokenCountInWei;               // 10% additional tokens generated and sent to foundationFundMultisig/Assistive Reality foundation, 18 decimals
101 
102     // loop control, ICO startup and limiters
103     string  public CurrentStatus                  = "";         // current crowdsale status
104     uint256 public fundingStartBlock;                           // crowdsale start block#
105     uint256 public fundingEndBlock;                             // crowdsale end block#
106     bool    public isCrowdSaleFinished            = false;      // boolean for crowdsale completed or not
107     bool    public isCrowdSaleSetup               = false;      // boolean for crowdsale setup
108     bool    public halted                         = false;      // boolean for halted or not
109     bool    public founderTokensAvailable         = false;      // variable to set false after generating founderTokens
110 
111     // balance mapping and transfer allowance array
112     mapping(address => uint256) balances;
113     mapping(address => mapping (address => uint256)) allowed;
114     event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Burn(address _from, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118     event Refund(address indexed _refunder, uint256 _value);
119 
120     // default function, map admin
121     function ARXCrowdsale() onlyOwner {
122       admin = msg.sender;
123       CurrentStatus = "Crowdsale deployed to chain";
124     }
125 
126     // total number of tokens issued so far, normalised
127     function totalSupply() constant returns (uint256 tokenTotalSupply) {
128         tokenTotalSupply = safeDiv(_totalSupply,1 ether);
129     }
130 
131     // get the account balance
132     function balanceOf(address _owner) constant returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136     // returns approximate crowdsale max funding in Eth
137     function fundingMaxInEth() constant returns (uint256 fundingMaximumInEth) {
138       fundingMaximumInEth = safeDiv(fundingMaxInWei,1 ether);
139     }
140 
141     // returns approximate crowdsale min funding in Eth
142     function fundingMinInEth() constant returns (uint256 fundingMinimumInEth) {
143       fundingMinimumInEth = safeDiv(fundingMinInWei,1 ether);
144     }
145 
146     // returns approximate crowdsale progress (funds raised) in Eth
147     function amountRaisedInEth() constant returns (uint256 amountRaisedSoFarInEth) {
148       amountRaisedSoFarInEth = safeDiv(amountRaisedInWei,1 ether);
149     }
150 
151     // returns approximate crowdsale remaining cap (hardcap) in Eth
152     function remainingCapInEth() constant returns (uint256 remainingHardCapInEth) {
153       remainingHardCapInEth = safeDiv(remainingCapInWei,1 ether);
154     }
155 
156     // ERC20 token transfer function
157     function transfer(address _to, uint256 _amount) returns (bool success) {
158         require(!(_to == 0x0));
159         if ((balances[msg.sender] >= _amount)
160         && (_amount > 0)
161         && ((safeAdd(balances[_to],_amount) > balances[_to]))) {
162             balances[msg.sender] = safeSub(balances[msg.sender], _amount);
163             balances[_to] = safeAdd(balances[_to], _amount);
164             Transfer(msg.sender, _to, _amount);
165             return true;
166         } else {
167             return false;
168         }
169     }
170 
171     // ERC20 token transferFrom function
172     function transferFrom(
173         address _from,
174         address _to,
175         uint256 _amount) returns (bool success) {
176         require(!(_to == 0x0));
177         if ((balances[_from] >= _amount)
178         && (allowed[_from][msg.sender] >= _amount)
179         && (_amount > 0)
180         && (safeAdd(balances[_to],_amount) > balances[_to])) {
181             balances[_from] = safeSub(balances[_from], _amount);
182             allowed[_from][msg.sender] = safeSub((allowed[_from][msg.sender]),_amount);
183             balances[_to] = safeAdd(balances[_to], _amount);
184             Transfer(_from, _to, _amount);
185             return true;
186         } else {
187             return false;
188         }
189     }
190 
191     // ERC20 allow _spender to withdraw, multiple times, up to the _value amount
192     function approve(address _spender, uint256 _amount) returns (bool success) {
193         allowed[msg.sender][_spender] = _amount;
194         Approval(msg.sender, _spender, _amount);
195         return true;
196     }
197 
198     // ERC20 return allowance for given owner spender pair
199     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
200         return allowed[_owner][_spender];
201     }
202 
203     // setup the CrowdSale parameters
204     function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
205         if ((msg.sender == admin)
206         && (!(isCrowdSaleSetup))
207         && (!(beneficiaryMultiSig > 0))
208         && (!(fundingMaxInWei > 0))) {
209             // mainnet values
210             beneficiaryMultiSig = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;
211             foundationFundMultisig = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;
212 
213             // mainnet funding targets with 18 decimals
214             fundingMaxInWei = 70000000000000000000000; //70 000 000 000 000 000 000 000 = 70,000 Eth (hard cap) - crowdsale no longer accepts Eth after this value
215             fundingMinInWei = 7000000000000000000000;   //7 000 000 000 000 000 000 000 =  7,000 Eth (soft cap) - crowdsale is considered success after this value
216 
217             // value of ARX token for mainnet. if hardcap is reached, this results in 280,000,000 ARX tokens in general supply (+28,000,000 in the foundationFundMultisig for a total supply of 308,000,000)
218             tokensPerEthPrice = 4000; // 4,000 tokens per Eth
219 
220             // update values
221             fundingMaxInEth = safeDiv(fundingMaxInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
222             fundingMinInEth = safeDiv(fundingMinInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
223             remainingCapInWei = fundingMaxInWei;
224             remainingCapInEth = safeDiv(remainingCapInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
225             fundingStartBlock = _fundingStartBlock;
226             fundingEndBlock = _fundingEndBlock;
227 
228             // configure crowdsale
229             isCrowdSaleSetup = true;
230             CurrentStatus = "Crowdsale is setup";
231             return "Crowdsale is setup";
232         } else if (msg.sender != admin) {
233             return "not authorized";
234         } else  {
235             return "campaign cannot be changed";
236         }
237     }
238 
239     // default payable function when sending ether to this contract
240     function () payable {
241       require(msg.data.length == 0);
242       BuyTokens();
243     }
244 
245     function BuyTokens() payable {
246       // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
247       require((!(msg.value == 0))
248       && (!(halted))
249       && (isCrowdSaleSetup)
250       && (!((safeAdd(amountRaisedInWei,msg.value)) > fundingMaxInWei))
251       && (block.number >= fundingStartBlock)
252       && (block.number <= fundingEndBlock)
253       && (!(isCrowdSaleFinished)));
254 
255       // 1. vars
256       address recipient = msg.sender; // to simplify refunding
257       uint256 amount = msg.value;
258       uint256 rewardTransferAmount = 0;
259 
260       // 2. effects
261       amountRaisedInWei = safeAdd(amountRaisedInWei,amount);
262       remainingCapInWei = safeSub(fundingMaxInWei,amountRaisedInWei);
263       rewardTransferAmount = safeMul(amount,tokensPerEthPrice);
264 
265       // 3. interaction
266       balances[recipient] = safeAdd(balances[recipient], rewardTransferAmount);
267       _totalSupply = safeAdd(_totalSupply, rewardTransferAmount);
268       Transfer(this, recipient, rewardTransferAmount);
269       Buy(recipient, amount, rewardTransferAmount);
270     }
271 
272     function AllocateFounderTokens() onlyOwner {
273       require(isCrowdSaleFinished && founderTokensAvailable && (foundationFundTokenCountInWei == 0));
274 
275       // calculate additional 10% tokens to allocate for foundation developer distributions
276       foundationFundTokenCountInWei = safeMul((safeDiv(amountRaisedInWei,10)), tokensPerEthPrice);
277 
278       // generate and send foundation developer token distributions
279       balances[foundationFundMultisig] = safeAdd(balances[foundationFundMultisig], foundationFundTokenCountInWei);
280 
281       _totalSupply = safeAdd(_totalSupply, foundationFundTokenCountInWei);
282       Transfer(this, foundationFundMultisig, foundationFundTokenCountInWei);
283       Buy(foundationFundMultisig, 0, foundationFundTokenCountInWei);
284       founderTokensAvailable = false;
285     }
286 
287     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
288       require(isCrowdSaleFinished && (amountRaisedInWei >= fundingMinInWei));
289       beneficiaryMultiSig.transfer(_amount);
290     }
291 
292     function checkGoalReached() onlyOwner returns (bytes32 response) { // return crowdfund status to owner for each result case, update public constant
293       require (!(halted) && isCrowdSaleSetup);
294 
295       if ((amountRaisedInWei < fundingMinInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
296         founderTokensAvailable = false;
297         isCrowdSaleFinished = false;
298         CurrentStatus = "In progress (Eth < Softcap)";
299         return "In progress (Eth < Softcap)";
300       } else if ((amountRaisedInWei < fundingMinInWei) && (block.number < fundingStartBlock)) { // ICO has not started
301         founderTokensAvailable = false;
302         isCrowdSaleFinished = false;
303         CurrentStatus = "Crowdsale is setup";
304         return "Crowdsale is setup";
305       } else if ((amountRaisedInWei < fundingMinInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
306         founderTokensAvailable = false;
307         isCrowdSaleFinished = true;
308         CurrentStatus = "Unsuccessful (Eth < Softcap)";
309         return "Unsuccessful (Eth < Softcap)";
310       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei >= fundingMaxInWei)) { // ICO ended, at hardcap!
311         if (foundationFundTokenCountInWei == 0) {
312           founderTokensAvailable = true;
313           isCrowdSaleFinished = true;
314           CurrentStatus = "Successful (Eth >= Hardcap)!";
315           return "Successful (Eth >= Hardcap)!";
316         } else if (foundationFundTokenCountInWei > 0) {
317           founderTokensAvailable = false;
318           isCrowdSaleFinished = true;
319           CurrentStatus = "Successful (Eth >= Hardcap)!";
320           return "Successful (Eth >= Hardcap)!";
321         }
322       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei < fundingMaxInWei) && (block.number > fundingEndBlock)) { // ICO ended, over softcap!
323         if (foundationFundTokenCountInWei == 0) {
324           founderTokensAvailable = true;
325           isCrowdSaleFinished = true;
326           CurrentStatus = "Successful (Eth >= Softcap)!";
327           return "Successful (Eth >= Softcap)!";
328         } else if (foundationFundTokenCountInWei > 0) {
329           founderTokensAvailable = false;
330           isCrowdSaleFinished = true;
331           CurrentStatus = "Successful (Eth >= Softcap)!";
332           return "Successful (Eth >= Softcap)!";
333         }
334       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei < fundingMaxInWei) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
335         founderTokensAvailable = false;
336         isCrowdSaleFinished = false;
337         CurrentStatus = "In progress (Eth >= Softcap)!";
338         return "In progress (Eth >= Softcap)!";
339       }
340     }
341 
342     function refund() { // any contributor can call this to have their Eth returned, if not halted, soft cap not reached and deadline expires
343       require (!(halted)
344       && (amountRaisedInWei < fundingMinInWei)
345       && (block.number > fundingEndBlock)
346       && (balances[msg.sender] > 0));
347 
348       uint256 ARXbalance = balances[msg.sender];
349       balances[msg.sender] = 0;
350       _totalSupply = safeSub(_totalSupply, ARXbalance);
351       uint256 ethValue = safeDiv(ARXbalance, tokensPerEthPrice);
352       amountRaisedInWei = safeSub(amountRaisedInWei, ethValue);
353       msg.sender.transfer(ethValue);
354       Burn(msg.sender, ARXbalance);
355       Refund(msg.sender, ethValue);
356     }
357 
358     function halt() onlyOwner { // halt the crowdsale
359         halted = true;
360         CurrentStatus = "Halted";
361     }
362 
363     function unhalt() onlyOwner { // resume the crowdsale
364         halted = false;
365         CurrentStatus = "Unhalted";
366         checkGoalReached();
367     }
368 }