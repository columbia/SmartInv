1 pragma solidity ^0.4.19;
2 
3 contract CrowdsaleParameters {
4     ///////////////////////////////////////////////////////////////////////////
5     // Production Config
6     ///////////////////////////////////////////////////////////////////////////
7 
8     // ICO period timestamps:
9     // 1524182400 = April 20, 2018.
10     // 1529452800 = June 20, 2018.
11 
12     uint256 public constant generalSaleStartDate = 1524182400;
13     uint256 public constant generalSaleEndDate = 1529452800;
14 
15     ///////////////////////////////////////////////////////////////////////////
16     // QA Config
17     ///////////////////////////////////////////////////////////////////////////
18 
19 
20     ///////////////////////////////////////////////////////////////////////////
21     // Configuration Independent Parameters
22     ///////////////////////////////////////////////////////////////////////////
23 
24     struct AddressTokenAllocation {
25         address addr;
26         uint256 amount;
27     }
28 
29     AddressTokenAllocation internal generalSaleWallet = AddressTokenAllocation(0x5aCdaeF4fa410F38bC26003d0F441d99BB19265A, 22800000);
30     AddressTokenAllocation internal bounty = AddressTokenAllocation(0xc1C77Ff863bdE913DD53fD6cfE2c68Dfd5AE4f7F, 2000000);
31     AddressTokenAllocation internal partners = AddressTokenAllocation(0x307744026f34015111B04ea4D3A8dB9FdA2650bb, 3200000);
32     AddressTokenAllocation internal team = AddressTokenAllocation(0xCC4271d219a2c33a92aAcB4C8D010e9FBf664D1c, 12000000);
33     AddressTokenAllocation internal featureDevelopment = AddressTokenAllocation(0x06281A31e1FfaC1d3877b29150bdBE93073E043B, 0);
34 }
35 
36 
37 contract Owned {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43     *  Constructor
44     *
45     *  Sets contract owner to address of constructor caller
46     */
47     function Owned() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     /**
57     *  Change Owner
58     *
59     *  Changes ownership of this contract. Only owner can call this method.
60     *
61     * @param newOwner - new owner's address
62     */
63     function changeOwner(address newOwner) onlyOwner public {
64         require(newOwner != address(0));
65         require(newOwner != owner);
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   /**
96   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 contract SBIToken is Owned, CrowdsaleParameters {
114     using SafeMath for uint256;
115     /* Public variables of the token */
116     string public standard = 'ERC20/SBI';
117     string public name = 'Subsoil Blockchain Investitions';
118     string public symbol = 'SBI';
119     uint8 public decimals = 18;
120 
121     /* Arrays of all balances */
122     mapping (address => uint256) private balances;
123     mapping (address => mapping (address => uint256)) private allowed;
124     mapping (address => mapping (address => bool)) private allowanceUsed;
125 
126     /* This generates a public event on the blockchain that will notify clients */
127 
128     event Transfer(address indexed from, address indexed to, uint tokens);
129     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
130     event Issuance(uint256 _amount); // triggered when the total supply is increased
131     event Destruction(uint256 _amount); // triggered when the total supply is decreased
132 
133     event NewSBIToken(address _token);
134 
135     /* Miscellaneous */
136     uint256 public totalSupply = 0; // 40000000;
137     bool public transfersEnabled = true;
138 
139     /**
140     *  Constructor
141     *
142     *  Initializes contract with initial supply tokens to the creator of the contract
143     */
144 
145     function SBIToken() public {
146         owner = msg.sender;
147         mintToken(generalSaleWallet);
148         mintToken(bounty);
149         mintToken(partners);
150         mintToken(team);
151         emit NewSBIToken(address(this));
152     }
153 
154     modifier transfersAllowed {
155         require(transfersEnabled);
156         _;
157     }
158 
159     modifier onlyPayloadSize(uint size) {
160         assert(msg.data.length >= size + 4);
161         _;
162     }
163 
164     /**
165     *  1. Associate crowdsale contract address with this Token
166     *  2. Allocate general sale amount
167     *
168     * @param _crowdsaleAddress - crowdsale contract address
169     */
170     function approveCrowdsale(address _crowdsaleAddress) external onlyOwner {
171         approveAllocation(generalSaleWallet, _crowdsaleAddress);
172     }
173 
174     function approveAllocation(AddressTokenAllocation tokenAllocation, address _crowdsaleAddress) internal {
175         uint uintDecimals = decimals;
176         uint exponent = 10**uintDecimals;
177         uint amount = tokenAllocation.amount * exponent;
178 
179         allowed[tokenAllocation.addr][_crowdsaleAddress] = amount;
180         emit Approval(tokenAllocation.addr, _crowdsaleAddress, amount);
181     }
182 
183     /**
184     *  Get token balance of an address
185     *
186     * @param _address - address to query
187     * @return Token balance of _address
188     */
189     function balanceOf(address _address) public constant returns (uint256 balance) {
190         return balances[_address];
191     }
192 
193     /**
194     *  Get token amount allocated for a transaction from _owner to _spender addresses
195     *
196     * @param _owner - owner address, i.e. address to transfer from
197     * @param _spender - spender address, i.e. address to transfer to
198     * @return Remaining amount allowed to be transferred
199     */
200 
201     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 
205     /**
206     *  Send coins from sender's address to address specified in parameters
207     *
208     * @param _to - address to send to
209     * @param _value - amount to send in Wei
210     */
211 
212     function transfer(address _to, uint256 _value) public transfersAllowed onlyPayloadSize(2*32) returns (bool success) {
213         require(_to != address(0));
214         require(_value <= balances[msg.sender]);
215         balances[msg.sender] = balances[msg.sender].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         emit Transfer(msg.sender, _to, _value);
218         return true;
219     }
220 
221     /**
222     *  Create token and credit it to target address
223     *  Created tokens need to vest
224     *
225     */
226     function mintToken(AddressTokenAllocation tokenAllocation) internal {
227 
228         uint uintDecimals = decimals;
229         uint exponent = 10**uintDecimals;
230         uint mintedAmount = tokenAllocation.amount * exponent;
231 
232         // Mint happens right here: Balance becomes non-zero from zero
233         balances[tokenAllocation.addr] += mintedAmount;
234         totalSupply += mintedAmount;
235 
236         // Emit Issue and Transfer events
237         emit Issuance(mintedAmount);
238         emit Transfer(address(this), tokenAllocation.addr, mintedAmount);
239     }
240 
241     /**
242     *  Allow another contract to spend some tokens on your behalf
243     *
244     * @param _spender - address to allocate tokens for
245     * @param _value - number of tokens to allocate
246     * @return True in case of success, otherwise false
247     */
248     function approve(address _spender, uint256 _value) public onlyPayloadSize(2*32) returns (bool success) {
249         require(_value == 0 || allowanceUsed[msg.sender][_spender] == false);
250         allowed[msg.sender][_spender] = _value;
251         allowanceUsed[msg.sender][_spender] = false;
252         emit Approval(msg.sender, _spender, _value);
253         return true;
254     }
255 
256     /**
257     *  A contract attempts to get the coins. Tokens should be previously allocated
258     *
259     * @param _to - address to transfer tokens to
260     * @param _from - address to transfer tokens from
261     * @param _value - number of tokens to transfer
262     * @return True in case of success, otherwise false
263     */
264     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed onlyPayloadSize(3*32) returns (bool success) {
265         require(_to != address(0));
266         require(_value <= balances[_from]);
267         require(_value <= allowed[_from][msg.sender]);
268         balances[_from] = balances[_from].sub(_value);
269         balances[_to] = balances[_to].add(_value);
270         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271         emit Transfer(_from, _to, _value);
272         return true;
273     }
274 
275     /**
276     *  Default method
277     *
278     *  This unnamed function is called whenever someone tries to send ether to
279     *  it. Just revert transaction because there is nothing that Token can do
280     *  with incoming ether.
281     *
282     *  Missing payable modifier prevents accidental sending of ether
283     */
284     function() public {}
285 
286     /**
287     *  Enable or disable transfers
288     *
289     * @param _enable - True = enable, False = disable
290     */
291     function toggleTransfers(bool _enable) external onlyOwner {
292         transfersEnabled = _enable;
293     }
294 }
295 
296 contract SBITokenCrowdsale is Owned, CrowdsaleParameters {
297     using SafeMath for uint256;
298     string public name = 'Subsoil Blockchain Investitions Crowdsale';
299     /* Token and records */
300     SBIToken private token;
301     address public bank;
302     address saleWalletAddress;
303     uint private tokenMultiplier = 10;
304     uint public totalCollected = 0;
305     uint public saleStartTimestamp;
306     uint public saleStopTimestamp;
307     uint public saleGoal;
308     bool public goalReached = false;
309     uint public preicoTokensPerEth = 27314;
310     uint public tokensPerEth = 10500;
311     mapping (address => uint256) private investmentRecords;
312     address crowdsaleAddress = this;
313     uint256 public constant saleStartDate = 1530403200;
314     uint256 public constant saleEndDate = 1535759940;
315     uint256 public constant preSaleStartDate = 1529020800;
316     uint256 public constant preSaleEndDate = 1530403140;
317     uint public preSaleAmount = 5800000;
318 
319     /* Events */
320     event TokenSale(address indexed tokenReceiver, uint indexed etherAmount, uint indexed tokenAmount, uint tokensPerEther);
321     event FundTransfer(address indexed from, address indexed to, uint indexed amount);
322 
323     /**
324     * Constructor
325     *
326     * @param _tokenAddress - address of token (deployed before this contract)
327     */
328     function SBITokenCrowdsale(address _tokenAddress, address _bankAddress) public {
329         token = SBIToken(_tokenAddress);
330         bank = _bankAddress;
331         tokenMultiplier = tokenMultiplier ** token.decimals();
332         saleWalletAddress = generalSaleWallet.addr;
333         // Initialize sale goal
334         saleGoal = generalSaleWallet.amount;
335     }
336 
337     /**
338     * Is sale active
339     *
340     * @return active - True, if sale is active
341     */
342     function isICOActive() public constant returns (bool active) {
343         active = ((preSaleStartDate <= now) && (now <= saleEndDate) && (!goalReached));
344         return active;
345     }
346 
347     /*
348         eth rate is very volatile
349     */
350     function setTokenRate(uint rate) public onlyOwner {
351         tokensPerEth = rate;
352     }
353 
354     /**
355     *  Process received payment
356     *
357     *  Determine the integer number of tokens that was purchased considering current
358     *  stage, tier bonus, and remaining amount of tokens in the sale wallet.
359     *  Transfer purchased tokens to investorAddress and return unused portion of
360     *  ether (change)
361     *
362     * @param investorAddress - address that ether was sent from
363     * @param amount - amount of Wei received
364     */
365     function processPayment(address investorAddress, uint amount) internal {
366         require(isICOActive());
367         assert(msg.value > 0 finney);
368 
369         // Fund transfer event
370         emit FundTransfer(investorAddress, address(this), amount);
371         uint remainingTokenBalance = token.balanceOf(saleWalletAddress) / tokenMultiplier;
372 
373         // Calculate token amount that is purchased,
374         // truncate to integer
375 
376         uint tokensRate = 0;
377         uint tokenAmount = 0;
378         uint acceptedAmount = 0;
379         uint mainTokens = 0;
380         uint discountTokens = 0;
381 
382         if (preSaleStartDate <= now && now <= preSaleEndDate && remainingTokenBalance > 17000000) {
383           tokensRate = preicoTokensPerEth;
384           discountTokens = remainingTokenBalance - 17000000;
385 
386           uint acceptedPreicoAmount = discountTokens * 1e18 / preicoTokensPerEth; // 212
387           uint acceptedMainAmount = 17000000 * 1e18 / tokensPerEth; // 1619
388           acceptedAmount = acceptedPreicoAmount + acceptedMainAmount;
389 
390           if (acceptedPreicoAmount < amount) {
391             mainTokens = (amount - acceptedPreicoAmount) * tokensPerEth / 1e18;
392             tokenAmount = discountTokens + mainTokens;
393           } else {
394             tokenAmount = preicoTokensPerEth * amount / 1e18;
395           }
396 
397         } else {
398           tokensRate = tokensPerEth;
399           tokenAmount = amount * tokensPerEth / 1e18;
400           acceptedAmount = remainingTokenBalance * tokensPerEth * 1e18;
401         }
402 
403         // Check that stage wallet has enough tokens. If not, sell the rest and
404         // return change.
405         if (remainingTokenBalance <= tokenAmount) {
406             tokenAmount = remainingTokenBalance;
407             goalReached = true;
408         }
409 
410         // Transfer tokens to baker and return ETH change
411         token.transferFrom(saleWalletAddress, investorAddress, tokenAmount * tokenMultiplier);
412         emit TokenSale(investorAddress, amount, tokenAmount, tokensRate);
413 
414         // Return change
415         if (amount > acceptedAmount) {
416             uint change = amount - acceptedAmount;
417             investorAddress.transfer(change);
418             emit FundTransfer(address(this), investorAddress, change);
419         }
420 
421         // Update crowdsale performance
422         investmentRecords[investorAddress] += acceptedAmount;
423         totalCollected += acceptedAmount;
424     }
425 
426     /**
427     *  Transfer ETH amount from contract to bank's address.
428     */
429     function safeWithdrawal() external onlyOwner {
430         bank.transfer(crowdsaleAddress.balance);
431         emit FundTransfer(crowdsaleAddress, bank, crowdsaleAddress.balance);
432     }
433 
434     /**
435     *  Default method
436     *
437     *  Processes all ETH that it receives and credits SBI tokens to sender
438     *  according to current stage bonus
439     */
440     function () external payable {
441         processPayment(msg.sender, msg.value);
442     }
443 
444     /**
445     *  Kill method
446     *
447     *  Destructs this contract
448     */
449     function kill() external onlyOwner {
450         require(!isICOActive());
451         if (crowdsaleAddress.balance > 0) {
452             revert();
453         }
454         if (now < preSaleStartDate) {
455             selfdestruct(owner);
456         }
457         // save the not sold tokens to featureDevelopment wallet
458         uint featureDevelopmentAmount = token.balanceOf(saleWalletAddress);
459         // Transfer tokens to baker and return ETH change
460         token.transferFrom(saleWalletAddress, featureDevelopment.addr, featureDevelopmentAmount);
461         emit FundTransfer(crowdsaleAddress, msg.sender, crowdsaleAddress.balance);
462         selfdestruct(owner);
463     }
464 }