1 pragma solidity ^0.4.13;
2 
3 contract Versioned {
4     string public version;
5 
6     function Versioned(string _version) public {
7         version = _version;
8     }
9 }
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 contract Pausable is Ownable {
78     bool public paused = false;
79 
80     modifier whenNotPaused() {
81         require(!paused || msg.sender == owner);
82         _;
83     }
84 
85     function pause() onlyOwner public {
86         paused = true;
87     }
88 
89     function unpause() onlyOwner public {
90         paused = false;
91     }
92 }
93 
94 contract Extractable is Ownable {
95     // allow contract to receive ether
96     function () payable public {}
97 
98     // allow to extract ether from contract
99     function extractEther(address withdrawalAddress) public onlyOwner {
100         if (this.balance > 0) {
101             withdrawalAddress.transfer(this.balance);
102         }
103     }
104 
105     // Allow to withdraw ERC20 token from contract
106     function extractToken(address tokenAddress, address withdrawalAddress) public onlyOwner {
107         ERC20Basic tokenContract = ERC20Basic(tokenAddress);
108         uint256 balance = tokenContract.balanceOf(this);
109         if (balance > 0) {
110             tokenContract.transfer(withdrawalAddress, balance);
111         }
112     }
113 }
114 
115 contract Destructible is Ownable {
116 
117   function Destructible() public payable { }
118 
119   /**
120    * @dev Transfers the current balance to the owner and terminates the contract.
121    */
122   function destroy() onlyOwner public {
123     selfdestruct(owner);
124   }
125 
126   function destroyAndSend(address _recipient) onlyOwner public {
127     selfdestruct(_recipient);
128   }
129 }
130 
131 contract ERC20Basic {
132   uint256 public totalSupply;
133   function balanceOf(address who) public view returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[msg.sender]);
151 
152     // SafeMath.sub will throw if there is not enough balance.
153     balances[msg.sender] = balances[msg.sender].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     Transfer(msg.sender, _to, _value);
156     return true;
157   }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163   */
164   function balanceOf(address _owner) public view returns (uint256 balance) {
165     return balances[_owner];
166   }
167 
168 }
169 
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public view returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 contract DetailedERC20 is ERC20 {
178   string public name;
179   string public symbol;
180   uint8 public decimals;
181 
182   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
183     name = _name;
184     symbol = _symbol;
185     decimals = _decimals;
186   }
187 }
188 
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 contract FloatingSupplyToken is Ownable, StandardToken {
278     using SafeMath for uint256;
279     // create new token tranche for contract you own
280     // this increases total supply and credits new tokens to owner
281     function issueTranche(uint256 _amount) public onlyOwner returns (uint256) {
282         require(_amount > 0);
283 
284         totalSupply = totalSupply.add(_amount);
285         balances[owner] = balances[owner].add(_amount);
286 
287         emit Transfer(address(0), owner, _amount);
288         return totalSupply;
289     }
290 
291     // destroy tokens that belongs to you
292     // this decreases your balance and total supply
293     function burn(uint256 _amount) public {
294         require(_amount > 0);
295         require(balances[msg.sender] > 0);
296         require(_amount <= balances[msg.sender]);
297 
298         assert(_amount <= totalSupply);
299 
300         totalSupply = totalSupply.sub(_amount);
301         balances[msg.sender] = balances[msg.sender].sub(_amount);
302 
303         emit Transfer(msg.sender, address(0), _amount);
304     }
305 }
306 
307 contract FundToken is StandardToken {
308     using SafeMath for uint256;
309 
310     // Fund internal balances are held in here
311     mapping (address => mapping (address => uint256)) fundBalances;
312 
313     // Owner of account manages funds on behalf of third parties and
314     // need to keep an account of what belongs to whom
315     mapping (address => bool) public fundManagers;
316 
317     // modifiers
318     // only fund manager can execute that
319     modifier onlyFundManager() {
320         require(fundManagers[msg.sender]);
321         _;
322     }
323 
324     // simple balance management
325     // wrapper for StandardToken to control fundmanager status
326     function transfer(address _to, uint _value) public returns (bool success) {
327         require(!fundManagers[msg.sender]);
328         require(!fundManagers[_to]);
329 
330         return super.transfer(_to, _value);
331     }
332 
333     // events
334 
335     // register address as fund address
336     event RegisterFund(address indexed _fundManager);
337 
338     // remove address from registered funds
339     event DissolveFund(address indexed _fundManager);
340 
341     // owner's tokens moved into the fund
342     event FundTransferIn(address indexed _from, address indexed _fundManager,
343                          address indexed _owner, uint256 _value);
344 
345     // tokens moved from the fund to a regular address
346     event FundTransferOut(address indexed _fundManager, address indexed _from,
347                           address indexed _to, uint256 _value);
348 
349     // tokens moved from the fund to a regular address
350     event FundTransferWithin(address indexed _fundManager, address indexed _from,
351                              address indexed _to, uint256 _value);
352 
353     // fund register/dissolve
354     // register fund status for an address, address must be empty for that
355     function registerFund() public {
356         require(balances[msg.sender] == 0);
357         require(!fundManagers[msg.sender]);
358 
359         fundManagers[msg.sender] = true;
360 
361         emit RegisterFund(msg.sender);
362     }
363 
364     // unregister fund status for an address, address must be empty for that
365     function dissolveFund() public {
366         require(balances[msg.sender] == 0);
367         require(fundManagers[msg.sender]);
368 
369         delete fundManagers[msg.sender];
370 
371         emit DissolveFund(msg.sender);
372     }
373 
374 
375     // funded balance management
376 
377     // returns balance of an account inside the fund
378     function fundBalanceOf(address _fundManager, address _owner) public view returns (uint256) {
379         return fundBalances[_fundManager][_owner];
380     }
381 
382     // Transfer the balance from simple account to account in the fund
383     function fundTransferIn(address _fundManager, address _to, uint256 _amount) public {
384         require(fundManagers[_fundManager]);
385         require(!fundManagers[msg.sender]);
386 
387         require(balances[msg.sender] >= _amount);
388         require(_amount > 0);
389 
390         balances[msg.sender] = balances[msg.sender].sub(_amount);
391         balances[_fundManager] = balances[_fundManager].add(_amount);
392         fundBalances[_fundManager][_to] = fundBalances[_fundManager][_to].add(_amount);
393 
394         emit FundTransferIn(msg.sender, _fundManager, _to, _amount);
395         emit Transfer(msg.sender, _fundManager, _amount);
396     }
397 
398     // Transfer the balance from account in the fund to simple account
399     function fundTransferOut(address _from, address _to, uint256 _amount) public {
400         require(!fundManagers[_to]);
401         require(fundManagers[msg.sender]);
402 
403         require(_amount > 0);
404         require(balances[msg.sender] >= _amount);
405         require(fundBalances[msg.sender][_from] >= _amount);
406         
407         balances[msg.sender] = balances[msg.sender].sub(_amount);
408         balances[_to] = balances[_to].add(_amount);
409         fundBalances[msg.sender][_from] = fundBalances[msg.sender][_from].sub(_amount);
410         
411         if (fundBalances[msg.sender][_from] == 0){
412             delete fundBalances[msg.sender][_from];
413         }
414         
415         emit FundTransferOut(msg.sender, _from, _to, _amount);
416         emit Transfer(msg.sender, _to, _amount);
417     }
418 
419     // Transfer the balance between two accounts within the fund
420     function fundTransferWithin(address _from, address _to, uint256 _amount) public {
421         require(fundManagers[msg.sender]);
422 
423         require(_amount > 0);
424         require(balances[msg.sender] >= _amount);
425         require(fundBalances[msg.sender][_from] >= _amount);
426 
427         fundBalances[msg.sender][_from] = fundBalances[msg.sender][_from].sub(_amount);
428         fundBalances[msg.sender][_to] = fundBalances[msg.sender][_to].add(_amount);
429 
430         if (fundBalances[msg.sender][_from] == 0){
431             delete fundBalances[msg.sender][_from];
432         }
433 
434         emit FundTransferWithin(msg.sender, _from, _to, _amount);
435     }
436 
437     // check fund controls before forwarding call
438     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
439     // If this function is called again it overwrites the current allowance with _value .
440     function approve(address _spender, uint256 _value) public returns (bool success) {
441         require(!fundManagers[msg.sender]);
442 
443         return super.approve(_spender, _value);
444     }
445 
446     // check fund controls before forwarding call to standard token allowance spending function
447     function transferFrom(address _from, address _to,
448                           uint256 _amount) public returns (bool success) {
449         require(!fundManagers[_from]);
450         require(!fundManagers[_to]);
451 
452         return super.transferFrom(_from, _to, _amount);
453     }
454 }
455 
456 contract BurnFundToken is FundToken, FloatingSupplyToken {
457     using SafeMath for uint256;
458 
459     //events
460     // owner's tokens from the managed fund burned
461     event FundBurn(address indexed _fundManager, address indexed _owner, uint256 _value);
462 
463     // destroy tokens that belongs to you
464     // this decreases total supply
465     function burn(uint256 _amount) public {
466         require(!fundManagers[msg.sender]);
467 
468         super.burn(_amount);
469     }
470 
471     // destroy tokens that belong to the fund you control
472     // this decreases that account's balance, fund balance, total supply
473     function fundBurn(address _fundAccount, uint256 _amount) public onlyFundManager {
474         require(fundManagers[msg.sender]);
475         require(balances[msg.sender] != 0);
476         require(fundBalances[msg.sender][_fundAccount] > 0);
477         require(_amount > 0);
478         require(_amount <= fundBalances[msg.sender][_fundAccount]);
479 
480         assert(_amount <= totalSupply);
481         assert(_amount <= balances[msg.sender]);
482 
483         totalSupply = totalSupply.sub(_amount);
484         balances[msg.sender] = balances[msg.sender].sub(_amount);
485         fundBalances[msg.sender][_fundAccount] = fundBalances[msg.sender][_fundAccount].sub(_amount);
486 
487         emit FundBurn(msg.sender, _fundAccount, _amount);
488     }
489 }
490 
491 contract PausableToken is BurnFundToken, Pausable {
492 
493     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
494         return super.transfer(_to, _value);
495     }
496 
497     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
498         return super.transferFrom(_from, _to, _value);
499     }
500 
501     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
502         return super.approve(_spender, _value);
503     }
504 
505     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
506         return super.increaseApproval(_spender, _addedValue);
507     }
508 
509     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
510         return super.decreaseApproval(_spender, _subtractedValue);
511     }
512 
513     function burn(uint256 _amount) public whenNotPaused {
514         return super.burn(_amount);
515     }
516 
517     function fundBurn(address _fundAccount, uint256 _amount) public whenNotPaused {
518         return super.fundBurn(_fundAccount, _amount);
519     }
520 
521     function registerFund() public whenNotPaused {
522         return super.registerFund();
523     }
524 
525     function dissolveFund() public whenNotPaused {
526         return super.dissolveFund();
527     }
528 
529     function fundTransferIn(address _fundManager, address _to, uint256 _amount) public whenNotPaused {
530         return super.fundTransferIn(_fundManager, _to, _amount);
531     }
532 
533     function fundTransferOut(address _from, address _to, uint256 _amount) public whenNotPaused {
534         return super.fundTransferOut(_from, _to, _amount);
535     }
536 
537     function fundTransferWithin(address _from, address _to, uint256 _amount) public whenNotPaused {
538         return super.fundTransferWithin(_from, _to, _amount);
539     }
540 }
541 
542 contract DAXT is PausableToken,
543     DetailedERC20("Digital Asset Exchange Token", "DAXT", 18),
544     Versioned("1.2.0"),
545     Destructible,
546     Extractable {
547 
548 }