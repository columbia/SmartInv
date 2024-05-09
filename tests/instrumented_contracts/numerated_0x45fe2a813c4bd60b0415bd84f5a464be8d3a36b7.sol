1 /* solium-disable-next-line linebreak-style */
2 pragma solidity ^0.4.24;
3 
4 // Implements a simple ownership model with 2-phase transfer.
5 contract Owned {
6 
7     address public owner;
8     address public proposedOwner;
9 
10     constructor() public
11     {
12         owner = msg.sender;
13     }
14 
15 
16     modifier onlyOwner() {
17         require(isOwner(msg.sender) == true, 'Require owner to execute transaction');
18         _;
19     }
20 
21 
22     function isOwner(address _address) public view returns (bool) {
23         return (_address == owner);
24     }
25 
26 
27     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool success) {
28         require(_proposedOwner != address(0), 'Require proposedOwner != address(0)');
29         require(_proposedOwner != address(this), 'Require proposedOwner != address(this)');
30         require(_proposedOwner != owner, 'Require proposedOwner != owner');
31 
32         proposedOwner = _proposedOwner;
33         return true;
34     }
35 
36 
37     function completeOwnershipTransfer() public returns (bool success) {
38         require(msg.sender == proposedOwner, 'Require msg.sender == proposedOwner');
39 
40         owner = msg.sender;
41         proposedOwner = address(0);
42 
43         return true;
44     }
45 }
46 
47 // ----------------------------------------------------------------------------
48 // OpsManaged - Implements an Owner and Ops Permission Model
49 // ----------------------------------------------------------------------------
50 contract OpsManaged is Owned {
51 
52     address public opsAddress;
53 
54 
55     constructor() public
56         Owned()
57     {
58     }
59 
60 
61     modifier onlyOwnerOrOps() {
62         require(isOwnerOrOps(msg.sender), 'Require only owner or ops');
63         _;
64     }
65 
66 
67     function isOps(address _address) public view returns (bool) {
68         return (opsAddress != address(0) && _address == opsAddress);
69     }
70 
71 
72     function isOwnerOrOps(address _address) public view returns (bool) {
73         return (isOwner(_address) || isOps(_address));
74     }
75 
76 
77     function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool success) {
78         require(_newOpsAddress != owner, 'Require newOpsAddress != owner');
79         require(_newOpsAddress != address(this), 'Require newOpsAddress != address(this)');
80 
81         opsAddress = _newOpsAddress;
82 
83         return true;
84     }
85 }
86 
87 // ----------------------------------------------------------------------------
88 // Finalizable - Implement Finalizable (Crowdsale) model
89 // ----------------------------------------------------------------------------
90 contract Finalizable is OpsManaged {
91 
92     FinalizableState public finalized;
93     
94     enum FinalizableState { 
95         None,
96         Finalized
97     }
98 
99     event Finalized();
100 
101 
102     constructor() public OpsManaged()
103     {
104         finalized = FinalizableState.None;
105     }
106 
107 
108     function finalize() public onlyOwner returns (bool success) {
109         require(finalized == FinalizableState.None, 'Require !finalized');
110 
111         finalized = FinalizableState.Finalized;
112 
113         emit Finalized();
114 
115         return true;
116     }
117 }
118 
119 // ----------------------------------------------------------------------------
120 // Math - Implement Math Library
121 // ----------------------------------------------------------------------------
122 library Math {
123 
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 r = a + b;
126 
127         require(r >= a, 'Require r >= a');
128 
129         return r;
130     }
131 
132 
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(a >= b, 'Require a >= b');
135 
136         return a - b;
137     }
138 
139 
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 r = a * b;
146 
147         require(r / a == b, 'Require r / a == b');
148 
149         return r;
150     }
151 
152 
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a / b;
155     }
156 }
157 
158 // ----------------------------------------------------------------------------
159 // ERC20Interface - Standard ERC20 Interface Definition
160 // Based on the final ERC20 specification at:
161 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162 // ----------------------------------------------------------------------------
163 contract ERC20Interface {
164 
165     event Transfer(address indexed _from, address indexed _to, uint256 _value);
166     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
167 
168     function balanceOf(address _owner) public view returns (uint256 balance);
169     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
170 
171     function transfer(address _to, uint256 _value) public returns (bool success);
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
173     function approve(address _spender, uint256 _value) public returns (bool success);
174 }
175 
176 // ----------------------------------------------------------------------------
177 // ERC20Token - Standard ERC20 Implementation
178 // ----------------------------------------------------------------------------
179 contract ERC20Token is ERC20Interface {
180 
181     using Math for uint256;
182 
183     string public  name;
184     string public symbol;
185     uint8 public decimals;
186     uint256 public totalSupply;
187 
188     mapping(address => uint256) internal balances;
189     mapping(address => mapping (address => uint256)) allowed;
190 
191 
192     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
193         name = _name;
194         symbol = _symbol;
195         decimals = _decimals;
196         totalSupply = _totalSupply;
197 
198         // The initial balance of tokens is assigned to the given token holder address.
199         balances[_initialTokenHolder] = _totalSupply;
200         allowed[_initialTokenHolder][_initialTokenHolder] = balances[_initialTokenHolder];
201 
202         // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
203         emit Transfer(0x0, _initialTokenHolder, _totalSupply);
204     }
205 
206 
207     function balanceOf(address _owner) public view returns (uint256 balance) {
208         return balances[_owner];
209     }
210 
211 
212     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 
216 
217     function transfer(address _to, uint256 _value) public returns (bool success) { 
218         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
219             balances[msg.sender] = balances[msg.sender].sub(_value);
220             balances[_to] = balances[_to].add(_value);
221 
222             emit Transfer(msg.sender, _to, _value);
223 
224             return true;
225         } else { 
226             return false;
227         }
228     }
229 
230 
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
232         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
233             balances[_from] = balances[_from].sub(_value);
234             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235             balances[_to] = balances[_to].add(_value);
236 
237             emit Transfer(_from, _to, _value);
238 
239             return true;
240         } else { 
241             return false;
242         }
243     }
244 
245 
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         allowed[msg.sender][_spender] = _value;
248 
249         emit Approval(msg.sender, _spender, _value);
250 
251         return true;
252     }
253 }
254 
255 // ----------------------------------------------------------------------------
256 // FinalizableToken - Extension to ERC20Token with ops and finalization
257 // ----------------------------------------------------------------------------
258 
259 //
260 // ERC20 token with the following additions:
261 //    1. Owner/Ops Ownership
262 //    2. Finalization
263 //
264 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
265 
266     using Math for uint256;
267 
268 
269     // The constructor will assign the initial token supply to the owner (msg.sender).
270     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
271         ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
272         Finalizable()
273     {
274     }
275 
276 
277     function transfer(address _to, uint256 _value) public returns (bool success) {
278         validateTransfer(msg.sender, _to);
279 
280         return super.transfer(_to, _value);
281     }
282 
283 
284     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
285         validateTransfer(msg.sender, _to);
286 
287         return super.transferFrom(_from, _to, _value);
288     }
289 
290 
291     function validateTransfer(address _sender, address _to) internal view {
292         // Once the token is finalized, everybody can transfer tokens.
293         if (finalized == FinalizableState.Finalized) {
294             return;
295         }
296         
297 
298         if (isOwner(_to)) {
299             return;
300         }
301 
302         // Before the token is finalized, only owner and ops are allowed to initiate transfers.
303         // This allows them to move tokens while the sale is still in private sale.
304         require(isOwnerOrOps(_sender), 'Require is owner or ops allowed to initiate transfer');
305     }
306 }
307 
308 
309 
310 // ----------------------------------------------------------------------------
311 // PBTT Token Contract Configuration
312 // ----------------------------------------------------------------------------
313 contract PBTTTokenConfig {
314 
315     string  internal constant TOKEN_SYMBOL      = 'PBTT';
316     string  internal constant TOKEN_NAME        = 'Purple Butterfly Token (PBTT)';
317     uint8   internal constant TOKEN_DECIMALS    = 3;
318 
319     uint256 internal constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
320     uint256 internal constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
321 }
322 
323 
324 // ----------------------------------------------------------------------------
325 // PBTT Token Contract
326 // ----------------------------------------------------------------------------
327 contract PBTTToken is FinalizableToken, PBTTTokenConfig {
328       
329     uint256 public buyPriceEth = 0.0002 ether;                              // Buy price for PBTT
330     uint256 public sellPriceEth = 0.0001 ether;                             // Sell price for PBTT
331     uint256 public gasForPBTT = 0.005 ether;                                // Eth from contract against PBTT to pay tx (10 times sellPriceEth)
332     uint256 public PBTTForGas = 1;                                          // PBTT to contract against eth to pay tx
333     uint256 public gasReserve = 1 ether;                                    // Eth amount that remains in the contract for gas and can't be sold
334 
335     // Minimal eth balance of sender and recipient, ensure that no account receiving
336     // the token has less than the necessary Ether to pay the fees
337     uint256 public minBalanceForAccounts = 0.005 ether;                     
338     uint256 public totalTokenSold = 0;
339     
340     enum HaltState { 
341         Unhalted,
342         Halted        
343     }
344 
345     HaltState public halts;
346 
347     constructor() public
348         FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
349     {
350         halts = HaltState.Unhalted;
351         finalized = FinalizableState.None;
352     }
353 
354     function transfer(address _to, uint256 _value) public returns (bool success) {
355         require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');
356 
357         // Prevents drain and spam
358         require(_value >= PBTTForGas, 'Token amount is not enough to transfer'); 
359          
360         if (!isOwnerOrOps(msg.sender) && _to == address(this)) {
361             // Trade PBTT against eth by sending to the token contract
362             sellPBTTAgainstEther(_value);                             
363             return true;
364         } else {
365             if(isOwnerOrOps(msg.sender)) {
366                 return super.transferFrom(owner, _to, _value);
367             }
368             return super.transfer(_to, _value);
369         }
370     }
371 
372     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
373         require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');
374         return super.transferFrom(_from, _to, _value);
375     }
376     
377     //Change PPBT Selling and Buy Price
378     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) public onlyOwnerOrOps {
379         // Set prices to buy and sell PBTT
380         buyPriceEth = newBuyPriceEth;                                       
381         sellPriceEth = newSellPriceEth;
382     }
383 
384     function setGasForPBTT(uint256 newGasAmountInWei) public onlyOwnerOrOps {
385         gasForPBTT = newGasAmountInWei;
386     }
387 
388     //set PBTT to contract against eth to pay tx
389     function setPBTTForGas(uint256 newPBTTAmount) public onlyOwnerOrOps {
390         PBTTForGas = newPBTTAmount;
391     }
392 
393     function setGasReserve(uint256 newGasReserveInWei) public onlyOwnerOrOps {
394         gasReserve = newGasReserveInWei;
395     }
396 
397     function setMinBalance(uint256 minimumBalanceInWei) public onlyOwnerOrOps {
398         minBalanceForAccounts = minimumBalanceInWei;
399     }
400 
401     function getTokenRemaining() public view returns (uint256 total){
402         return (TOKEN_TOTALSUPPLY.div(DECIMALSFACTOR)).sub(totalTokenSold);
403     }
404 
405     /* User buys PBTT and pays in Ether */
406     function buyPBTTAgainstEther() private returns (uint256 tokenAmount) {
407         // Avoid dividing 0, sending small amounts and spam
408         require(buyPriceEth > 0, 'buyPriceEth must be > 0');
409         require(msg.value >= buyPriceEth, 'Transfer money must be enough for 1 token');
410         
411         // Calculate the amount of PBTT
412         tokenAmount = (msg.value.mul(DECIMALSFACTOR)).div(buyPriceEth);                
413         
414         // Check if it has enough to sell
415         require(balances[owner] >= tokenAmount, 'Not enough token balance');
416         
417         // Add the amount to buyer's balance
418         balances[msg.sender] = balances[msg.sender].add(tokenAmount);            
419 
420         // Subtract amount from PBTT balance
421         balances[owner] = balances[owner].sub(tokenAmount);
422 
423         // Execute an event reflecting the change
424         emit Transfer(owner, msg.sender, tokenAmount);                           
425         
426         totalTokenSold = totalTokenSold + tokenAmount;
427 		
428         return tokenAmount;
429     }
430 
431     function sellPBTTAgainstEther(uint256 amount) private returns (uint256 revenue) {
432         // Avoid selling and spam
433         require(sellPriceEth > 0, 'sellPriceEth must be > 0');
434         
435         require(amount >= PBTTForGas, 'Sell token amount must be larger than PBTTForGas value');
436 
437         // Check if the sender has enough to sell
438         require(balances[msg.sender] >= amount, 'Token balance is not enough to sold');
439         
440         require(msg.sender.balance >= minBalanceForAccounts, 'Seller balance must be enough to pay the transaction fee');
441         
442         // Revenue = eth that will be send to the user
443         revenue = (amount.div(DECIMALSFACTOR)).mul(sellPriceEth);                                 
444 
445         // Keep min amount of eth in contract to provide gas for transactions
446         uint256 remaining = address(this).balance.sub(revenue);
447         require(remaining >= gasReserve, 'Remaining contract balance is not enough for reserved');
448 
449         // Add the token amount to owner balance
450         balances[owner] = balances[owner].add(amount);         
451         // Subtract the amount from seller's token balance
452         balances[msg.sender] = balances[msg.sender].sub(amount);            
453 
454         // transfer eth
455         // 'msg.sender.transfer' means the contract sends ether to 'msg.sender'
456         // It's important to do this last to avoid recursion attacks
457         msg.sender.transfer(revenue);
458  
459         // Execute an event reflecting on the change
460         emit Transfer(msg.sender, owner, amount);                            
461         return revenue;   
462     }
463 
464     // Allows a token holder to burn tokens. Once burned, tokens are permanently
465     // removed from the total supply.
466     function burn(uint256 _amount) public returns (bool success) {
467         require(_amount > 0, 'Token amount to burn must be larger than 0');
468 
469         address account = msg.sender;
470         require(_amount <= balanceOf(account), 'You cannot burn token you dont have');
471 
472         balances[account] = balances[account].sub(_amount);
473         totalSupply = totalSupply.sub(_amount);
474         return true;
475     }
476 
477     // Allows the owner to reclaim tokens that are assigned to the token contract itself.
478     function reclaimTokens() public onlyOwner returns (bool success) {
479 
480         address account = address(this);
481         uint256 amount = balanceOf(account);
482 
483         if (amount == 0) {
484             return false;
485         }
486 
487         balances[account] = balances[account].sub(amount);
488         balances[owner] = balances[owner].add(amount);
489 
490         return true;
491     }
492 
493     // Allows the owner to withdraw that are assigned to the token contract itself.
494     function withdrawFundToOwner() public onlyOwner {
495         // transfer to owner
496         uint256 eth = address(this).balance; 
497         owner.transfer(eth);
498     }
499 
500     // Allows the owner to withdraw all fund from contract to owner's specific adress
501     function withdrawFundToAddress(address _ownerOtherAdress) public onlyOwner {
502         // transfer to owner
503         uint256 eth = address(this).balance; 
504         _ownerOtherAdress.transfer(eth);
505     }
506 
507     /* Halts or unhalts direct trades without the sell/buy functions below */
508     function haltsTrades() public onlyOwnerOrOps returns (bool success) {
509         halts = HaltState.Halted;
510         return true;
511     }
512 
513     function unhaltsTrades() public onlyOwnerOrOps returns (bool success) {
514         halts = HaltState.Unhalted;
515         return true;
516     }
517 
518     function() public payable { 
519         if(msg.sender != owner) {
520             require(finalized == FinalizableState.Finalized, 'Require smart contract is finalized');
521             require(halts == HaltState.Unhalted, 'Require smart contract is not halted');
522             
523             buyPBTTAgainstEther(); 
524         }
525     } 
526 
527 }