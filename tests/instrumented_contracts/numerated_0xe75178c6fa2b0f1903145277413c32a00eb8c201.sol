1 pragma solidity ^0.4.13;
2 // **-----------------------------------------------
3 // 0.4.13+commit.0fb4cb1a
4 // [Assistive Reality ARX ERC20 token & crowdsale contract w/10% dev alloc]
5 // [https://aronline.io/icoinfo]
6 // [v3.2 final released 10/09/17 final masterARXsale32mainnet.sol]
7 // [Adapted from Ethereum standard crowdsale contract]
8 // [Contact staff@aronline.io for any queries]
9 // [Join us in changing the world]
10 // [aronline.io]
11 // **-----------------------------------------------
12 // ERC Token Standard #20 Interface
13 // https://github.com/ethereum/EIPs/issues/20
14 // -------------------------------------------------
15 // Security reviews completed 10/09/17 [passed OK]
16 // Functional reviews completed 10/09/17 [passed OK]
17 // Final code revision and regression test cycle complete 10/09/17 [passed]
18 // https://github.com/assistivereality/ico/blob/master/3.2crowdsaletestsARXmainnet.txt
19 // -------------------------------------------------
20 contract owned { // security reviewed 10/09/17
21     address public owner;
22 
23     function owned() {
24         owner = msg.sender;
25     }
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30     function transferOwnership(address newOwner) onlyOwner {
31         owner = newOwner;
32     }
33 }
34 
35 contract SafeMath { // security reviewed 10/09/17
36   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
37     uint256 c = a * b;
38     safeAssert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
43     safeAssert(b > 0);
44     uint256 c = a / b;
45     safeAssert(a == b * c + a % b);
46     return c;
47   }
48 
49   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
50     safeAssert(b <= a);
51     return a - b;
52   }
53 
54   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
55     uint256 c = a + b;
56     safeAssert(c>=a && c>=b);
57     return c;
58   }
59 
60   function safeAssert(bool assertion) internal {
61     if (!assertion) revert();
62   }
63 }
64 
65 contract ERC20Interface is owned, SafeMath { // security reviewed 10/09/17
66     function totalSupply() constant returns (uint256 tokenTotalSupply);
67     function balanceOf(address _owner) constant returns (uint256 balance);
68     function transfer(address _to, uint256 _value) returns (bool success);
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
70     function approve(address _spender, uint256 _value) returns (bool success);
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
72     event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Burn(address _from, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     event Refund(address indexed _refunder, uint256 _value);
77 }
78 
79 contract ARXCrowdsale is ERC20Interface { // security reviewed 10/09/17
80     // deployment variables for dynamic supply token
81     string  public constant standard              = "ARX";
82     string  public constant name                  = "Assistive Reality";
83     string  public constant symbol                = "ARX";
84     uint8   public constant decimals              = 18;
85     uint256 _totalSupply                          = 0;
86 
87     // multi-sig addresses and price variable
88     address public admin = owner;                               // admin address
89     address public beneficiaryMultiSig;                         // beneficiaryMultiSig (founder group) multi-sig wallet account
90     address public foundationFundMultisig;                      // foundationFundMultisig multi-sig wallet address - Assistive Reality foundation fund
91     uint256 public tokensPerEthPrice;                           // priceVar e.g. 2,000 tokens per Eth
92 
93     // uint256 values for min,max,caps,tracking
94     uint256 public amountRaisedInWei;                           // total amount raised in Wei e.g. 21 000 000 000 000 000 000 = 21 Eth
95     uint256 public fundingMaxInWei;                             // funding max in Wei e.g. 21 000 000 000 000 000 000 = 21 Eth
96     uint256 public fundingMinInWei;                             // funding min in Wei e.g. 11 000 000 000 000 000 000 = 11 Eth
97     uint256 public fundingMaxInEth;                             // funding max in Eth (approx) e.g. 21 Eth
98     uint256 public fundingMinInEth;                             // funding min in Eth (approx) e.g. 11 Eth
99     uint256 public remainingCapInWei;                           // amount of cap remaining to raise in Wei e.g. 1 200 000 000 000 000 000 = 1.2 Eth remaining
100     uint256 public remainingCapInEth;                           // amount of cap remaining to raise in Eth (approx) e.g. 1
101     uint256 public foundationFundTokenCountInWei;               // 10% additional tokens generated and sent to foundationFundMultisig/Assistive Reality foundation, 18 decimals
102 
103     // loop control, ICO startup and limiters
104     string  public CurrentStatus                  = "";         // current crowdsale status
105     uint256 public fundingStartBlock;                           // crowdsale start block#
106     uint256 public fundingEndBlock;                             // crowdsale end block#
107     bool    public isCrowdSaleFinished            = false;      // boolean for crowdsale completed or not
108     bool    public isCrowdSaleSetup               = false;      // boolean for crowdsale setup
109     bool    public halted                         = false;      // boolean for halted or not
110     bool    public founderTokensAvailable         = false;      // variable to set false after generating founderTokens
111 
112     // balance mapping and transfer allowance array
113     mapping(address => uint256) balances;
114     mapping(address => mapping (address => uint256)) allowed;
115     event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Burn(address _from, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119     event Refund(address indexed _refunder, uint256 _value);
120 
121     // default function, map admin
122     function ARXCrowdsale() onlyOwner {
123       admin = msg.sender;
124       CurrentStatus = "Crowdsale deployed to chain";
125     }
126 
127     // total number of tokens issued so far, normalised
128     function totalSupply() constant returns (uint256 tokenTotalSupply) {
129         tokenTotalSupply = safeDiv(_totalSupply,1 ether);
130     }
131 
132     // get the account balance
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     // returns crowdsale max funding in Eth, low res
138     function fundingMaxInEth() constant returns (uint256 fundingMaximumInEth) {
139       fundingMaximumInEth = safeDiv(fundingMaxInWei,1 ether);
140     }
141 
142     // returns crowdsale min funding in Eth, low res
143     function fundingMinInEth() constant returns (uint256 fundingMinimumInEth) {
144       fundingMinimumInEth = safeDiv(fundingMinInWei,1 ether);
145     }
146 
147     // returns crowdsale progress (funds raised) in Eth, low res
148     function amountRaisedInEth() constant returns (uint256 amountRaisedSoFarInEth) {
149       amountRaisedSoFarInEth = safeDiv(amountRaisedInWei,1 ether);
150     }
151 
152     // returns crowdsale remaining cap (hardcap) in Eth, low res
153     function remainingCapInEth() constant returns (uint256 remainingHardCapInEth) {
154       remainingHardCapInEth = safeDiv(remainingCapInWei,1 ether);
155     }
156 
157     // ERC20 token transfer function
158     function transfer(address _to, uint256 _amount) returns (bool success) {
159         require(!(_to == 0x0));
160         if ((balances[msg.sender] >= _amount)
161         && (_amount > 0)
162         && ((safeAdd(balances[_to],_amount) > balances[_to]))) {
163             balances[msg.sender] = safeSub(balances[msg.sender], _amount);
164             balances[_to] = safeAdd(balances[_to], _amount);
165             Transfer(msg.sender, _to, _amount);
166             return true;
167         } else {
168             return false;
169         }
170     }
171 
172     // ERC20 token transferFrom function
173     function transferFrom(
174         address _from,
175         address _to,
176         uint256 _amount) returns (bool success) {
177         require(!(_to == 0x0));
178         if ((balances[_from] >= _amount)
179         && (allowed[_from][msg.sender] >= _amount)
180         && (_amount > 0)
181         && (safeAdd(balances[_to],_amount) > balances[_to])) {
182             balances[_from] = safeSub(balances[_from], _amount);
183             allowed[_from][msg.sender] = safeSub((allowed[_from][msg.sender]),_amount);
184             balances[_to] = safeAdd(balances[_to], _amount);
185             Transfer(_from, _to, _amount);
186             return true;
187         } else {
188             return false;
189         }
190     }
191 
192     // ERC20 allow _spender to withdraw, multiple times, up to the _value amount
193     function approve(address _spender, uint256 _amount) returns (bool success) {
194         //Fix for known double-spend https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#
195         //Input must either set allow amount to 0, or have 0 already set, to workaround issue
196         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
197         allowed[msg.sender][_spender] = _amount;
198         Approval(msg.sender, _spender, _amount);
199         return true;
200     }
201 
202     // ERC20 return allowance for given owner spender pair
203     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204         return allowed[_owner][_spender];
205     }
206 
207     // setup the CrowdSale parameters
208     function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
209         if ((msg.sender == admin)
210         && (!(isCrowdSaleSetup))
211         && (!(beneficiaryMultiSig > 0))
212         && (!(fundingMaxInWei > 0))) {
213             // mainnet values
214             beneficiaryMultiSig = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;
215             foundationFundMultisig = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;
216 
217             // mainnet funding targets with 18 decimals
218             fundingMaxInWei = 70000000000000000000000; //70 000 000 000 000 000 000 000 = 70,000 Eth (hard cap) - crowdsale no longer accepts Eth after this value
219             fundingMinInWei = 3500000000000000000000;   //3 500 000 000 000 000 000 000 =  3,500 Eth (soft cap) - crowdsale is considered success after this value
220 
221             // value of ARX token for mainnet. if hardcap is reached, this results in 280,000,000 ARX tokens in general supply (+28,000,000 in the foundationFundMultisig for a total supply of 308,000,000)
222             tokensPerEthPrice = 4000; // 4,000 tokens per Eth
223 
224             // update values
225             fundingMaxInEth = safeDiv(fundingMaxInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
226             fundingMinInEth = safeDiv(fundingMinInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
227             remainingCapInWei = fundingMaxInWei;
228             remainingCapInEth = safeDiv(remainingCapInWei,1 ether); //approximate to 1 Eth due to resolution, provided for ease/viewing only
229             fundingStartBlock = _fundingStartBlock;
230             fundingEndBlock = _fundingEndBlock;
231 
232             // configure crowdsale
233             isCrowdSaleSetup = true;
234             CurrentStatus = "Crowdsale is setup";
235             return "Crowdsale is setup";
236         } else if (msg.sender != admin) {
237             return "not authorized";
238         } else  {
239             return "campaign cannot be changed";
240         }
241     }
242 
243     // default payable function when sending ether to this contract
244     function () payable {
245       require(msg.data.length == 0);
246       BuyTokens();
247     }
248 
249     function BuyTokens() payable {
250       // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
251       require((!(msg.value == 0))
252       && (!(halted))
253       && (isCrowdSaleSetup)
254       && (!((safeAdd(amountRaisedInWei,msg.value)) > fundingMaxInWei))
255       && (block.number >= fundingStartBlock)
256       && (block.number <= fundingEndBlock)
257       && (!(isCrowdSaleFinished)));
258 
259       // 1. vars
260       address recipient = msg.sender; // to simplify refunding
261       uint256 amount = msg.value;
262       uint256 rewardTransferAmount = 0;
263 
264       // 2. effects
265       amountRaisedInWei = safeAdd(amountRaisedInWei,amount);
266       remainingCapInWei = safeSub(fundingMaxInWei,amountRaisedInWei);
267       rewardTransferAmount = safeMul(amount,tokensPerEthPrice);
268 
269       // 3. interaction
270       balances[recipient] = safeAdd(balances[recipient], rewardTransferAmount);
271       _totalSupply = safeAdd(_totalSupply, rewardTransferAmount);
272       Transfer(this, recipient, rewardTransferAmount);
273       Buy(recipient, amount, rewardTransferAmount);
274     }
275 
276     function AllocateFounderTokens() onlyOwner {
277       require(isCrowdSaleFinished && founderTokensAvailable && (foundationFundTokenCountInWei == 0));
278 
279       // calculate additional 10% tokens to allocate for foundation developer distributions
280       foundationFundTokenCountInWei = safeMul((safeDiv(amountRaisedInWei,10)), tokensPerEthPrice);
281 
282       // generate and send foundation developer token distributions
283       balances[foundationFundMultisig] = safeAdd(balances[foundationFundMultisig], foundationFundTokenCountInWei);
284 
285       _totalSupply = safeAdd(_totalSupply, foundationFundTokenCountInWei);
286       Transfer(this, foundationFundMultisig, foundationFundTokenCountInWei);
287       Buy(foundationFundMultisig, 0, foundationFundTokenCountInWei);
288       founderTokensAvailable = false;
289     }
290 
291     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
292       require(isCrowdSaleFinished && (amountRaisedInWei >= fundingMinInWei));
293       beneficiaryMultiSig.transfer(_amount);
294     }
295 
296     function checkGoalReached() onlyOwner returns (bytes32 response) { // return crowdfund status to owner for each result case, update public constant
297       require (!(halted) && isCrowdSaleSetup);
298 
299       if ((amountRaisedInWei < fundingMinInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // ICO in progress, under softcap
300         founderTokensAvailable = false;
301         isCrowdSaleFinished = false;
302         CurrentStatus = "In progress (Eth < Softcap)";
303         return "In progress (Eth < Softcap)";
304       } else if ((amountRaisedInWei < fundingMinInWei) && (block.number < fundingStartBlock)) { // ICO has not started
305         founderTokensAvailable = false;
306         isCrowdSaleFinished = false;
307         CurrentStatus = "Crowdsale is setup";
308         return "Crowdsale is setup";
309       } else if ((amountRaisedInWei < fundingMinInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap
310         founderTokensAvailable = false;
311         isCrowdSaleFinished = true;
312         CurrentStatus = "Unsuccessful (Eth < Softcap)";
313         return "Unsuccessful (Eth < Softcap)";
314       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei >= fundingMaxInWei)) { // ICO ended, at hardcap!
315         if (foundationFundTokenCountInWei == 0) {
316           founderTokensAvailable = true;
317           isCrowdSaleFinished = true;
318           CurrentStatus = "Successful (Eth >= Hardcap)!";
319           return "Successful (Eth >= Hardcap)!";
320         } else if (foundationFundTokenCountInWei > 0) {
321           founderTokensAvailable = false;
322           isCrowdSaleFinished = true;
323           CurrentStatus = "Successful (Eth >= Hardcap)!";
324           return "Successful (Eth >= Hardcap)!";
325         }
326       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei < fundingMaxInWei) && (block.number > fundingEndBlock)) { // ICO ended, over softcap!
327         if (foundationFundTokenCountInWei == 0) {
328           founderTokensAvailable = true;
329           isCrowdSaleFinished = true;
330           CurrentStatus = "Successful (Eth >= Softcap)!";
331           return "Successful (Eth >= Softcap)!";
332         } else if (foundationFundTokenCountInWei > 0) {
333           founderTokensAvailable = false;
334           isCrowdSaleFinished = true;
335           CurrentStatus = "Successful (Eth >= Softcap)!";
336           return "Successful (Eth >= Softcap)!";
337         }
338       } else if ((amountRaisedInWei >= fundingMinInWei) && (amountRaisedInWei < fundingMaxInWei) && (block.number <= fundingEndBlock)) { // ICO in progress, over softcap!
339         founderTokensAvailable = false;
340         isCrowdSaleFinished = false;
341         CurrentStatus = "In progress (Eth >= Softcap)!";
342         return "In progress (Eth >= Softcap)!";
343       }
344     }
345 
346     function refund() { // any contributor can call this to have their Eth returned, if not halted, soft cap not reached and deadline expires
347       require (!(halted)
348       && (amountRaisedInWei < fundingMinInWei)
349       && (block.number > fundingEndBlock)
350       && (balances[msg.sender] > 0));
351       //Proceed with refund
352       uint256 ARXbalance = balances[msg.sender];
353       balances[msg.sender] = 0;
354       _totalSupply = safeSub(_totalSupply, ARXbalance);
355       uint256 ethValue = safeDiv(ARXbalance, tokensPerEthPrice);
356       amountRaisedInWei = safeSub(amountRaisedInWei, ethValue);
357       msg.sender.transfer(ethValue);
358       Burn(msg.sender, ARXbalance);
359       Refund(msg.sender, ethValue);
360     }
361 
362     function halt() onlyOwner { // halt the crowdsale
363         halted = true;
364         CurrentStatus = "Halted";
365     }
366 
367     function unhalt() onlyOwner { // resume the crowdsale
368         halted = false;
369         CurrentStatus = "Unhalted";
370         checkGoalReached();
371     }
372 }