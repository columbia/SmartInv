1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48     /**
49     * @dev Multiplies two numbers, throws on overflow.
50     */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two numbers, truncating the quotient.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return c;
68     }
69 
70     /**
71     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     /**
79     * @dev Adds two numbers, throws on overflow.
80     */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
87 
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[msg.sender]);
131 
132         // SafeMath.sub will throw if there is not enough balance.
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param _owner The address to query the the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function balanceOf(address _owner) public view returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148 }
149 
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160     mapping (address => mapping (address => uint256)) internal allowed;
161 
162     /**
163     * @dev Transfer tokens from one address to another
164     * @param _from address The address which you want to send tokens from
165     * @param _to address The address which you want to transfer to
166     * @param _value uint256 the amount of tokens to be transferred
167     */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172 
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182     *
183     * Beware that changing an allowance with this method brings the risk that someone may use both the old
184     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187     * @param _spender The address which will spend the funds.
188     * @param _value The amount of tokens to be spent.
189     */
190     function approve(address _spender, uint256 _value) public returns (bool) {
191         allowed[msg.sender][_spender] = _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197     * @dev Function to check the amount of tokens that an owner allowed to a spender.
198     * @param _owner address The address which owns the funds.
199     * @param _spender address The address which will spend the funds.
200     * @return A uint256 specifying the amount of tokens still available for the spender.
201     */
202     function allowance(address _owner, address _spender) public view returns (uint256) {
203         return allowed[_owner][_spender];
204     }
205 
206     /**
207     * @dev Increase the amount of tokens that an owner allowed to a spender.
208     *
209     * approve should be called when allowed[_spender] == 0. To increment
210     * allowed value is better to use this function to avoid 2 calls (and wait until
211     * the first transaction is mined)
212     * From MonolithDAO Token.sol
213     * @param _spender The address which will spend the funds.
214     * @param _addedValue The amount of tokens to increase the allowance by.
215     */
216     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     } 
221 
222     /**
223     * @dev Decrease the amount of tokens that an owner allowed to a spender.
224     *
225     * approve should be called when allowed[_spender] == 0. To decrement
226     * allowed value is better to use this function to avoid 2 calls (and wait until
227     * the first transaction is mined)
228     * From MonolithDAO Token.sol
229     * @param _spender The address which will spend the funds.
230     * @param _subtractedValue The amount of tokens to decrease the allowance by.
231     */
232     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233         uint oldValue = allowed[msg.sender][_spender];
234         if (_subtractedValue > oldValue) {
235             allowed[msg.sender][_spender] = 0;
236         } else {
237             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243 }
244 
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 contract MintableToken is StandardToken, Ownable {
253     event Mint(address indexed to, uint256 amount);
254     event MintFinished();
255 
256     bool public mintingFinished = false;
257 
258 
259     modifier canMint() {
260         require(!mintingFinished);
261         _;
262     }
263 
264     /**
265     * @dev Function to mint tokens
266     * @param _to The address that will receive the minted tokens.
267     * @param _amount The amount of tokens to mint.
268     * @return A boolean that indicates if the operation was successful.
269     */
270     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
271         totalSupply = totalSupply.add(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         Mint(_to, _amount);
274         Transfer(address(0), _to, _amount);
275         return true;
276     }
277 
278     /**
279     * @dev Function to stop minting new tokens.
280     * @return True if the operation was successful.
281     */
282     function finishMinting() onlyOwner canMint public returns (bool) {
283         mintingFinished = true;
284         MintFinished();
285         return true;
286     }
287 }
288 
289 
290 /**
291  * @title Pausable
292  * @dev Base contract which allows children to implement an emergency stop mechanism.
293  */
294 contract Pausable is Ownable {
295   event Pause();
296   event Unpause();
297 
298   bool public paused = false;
299 
300 
301   /**
302    * @dev Modifier to make a function callable only when the contract is not paused.
303    */
304   modifier whenNotPaused() {
305     require(!paused);
306     _;
307   }
308 
309   /**
310    * @dev Modifier to make a function callable only when the contract is paused.
311    */
312   modifier whenPaused() {
313     require(paused);
314     _;
315   }
316 
317   /**
318    * @dev called by the owner to pause, triggers stopped state
319    */
320   function pause() onlyOwner whenNotPaused public {
321     paused = true;
322     Pause();
323   }
324 
325   /**
326    * @dev called by the owner to unpause, returns to normal state
327    */
328   function unpause() onlyOwner whenPaused public {
329     paused = false;
330     Unpause();
331   }
332 }
333 
334 
335 /**
336  * @title Pausable token
337  * @dev StandardToken modified with pausable transfers.
338  **/
339 contract PausableToken is StandardToken, Pausable {
340 
341   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
346     return super.transferFrom(_from, _to, _value);
347   }
348 
349   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
350     return super.approve(_spender, _value);
351   }
352 
353   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
354     return super.increaseApproval(_spender, _addedValue);
355   }
356 
357   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
358     return super.decreaseApproval(_spender, _subtractedValue);
359   }
360 }
361 
362 
363 /*
364  * CCR Token Smart Contract.  @ 2018 by Kapsus Technoloies Limited (www.kapsustech.com).
365  * Author: Susanta Saren <business@cryptocashbackrebate.com>
366  */
367 
368 contract CCRToken is MintableToken, PausableToken {
369     using SafeMath for uint256;
370 
371     string public constant name = "CryptoCashbackRebate Token";
372     string public constant symbol = "CCR";
373     uint32 public constant decimals = 18;
374 }
375 
376 
377 /*
378  * CCR Token Crowdsale Smart Contract.  @ 2018 by Kapsus Technoloies Limited (www.kapsustech.com).
379  * Author: Susanta Saren <business@cryptocashbackrebate.com>
380  */
381 
382 contract CCRCrowdsale is Ownable {
383 
384     using SafeMath for uint;
385 
386     event TokensPurchased(address indexed buyer, uint256 ether_amount);
387     event CCRCrowdsaleClosed();
388 
389     CCRToken public token = new CCRToken();
390 
391     address public multisigVault = 0x4f39C2f050b07b3c11B08f2Ec452eD603a69839D;
392 
393     uint256 public totalReceived = 0;
394     uint256 public hardcap = 416667 ether;
395     uint256 public minimum = 0.10 ether;
396 
397     uint256 public altDeposits = 0;
398     uint256 public start = 1521338401; // 18 March, 2018 02:00:01 GMT
399     bool public saleOngoing = true;
400 
401     /**
402     * @dev modifier to allow token creation only when the sale IS ON
403     */
404     modifier isSaleOn() {
405     require(start <= now && saleOngoing);
406     _;
407     }
408 
409     /**
410     * @dev modifier to prevent buying tokens below the minimum required
411     */
412     modifier isAtLeastMinimum() {
413     require(msg.value >= minimum);
414     _;
415     }
416 
417     /**
418     * @dev modifier to allow token creation only when the hardcap has not been reached
419     */
420     modifier isUnderHardcap() {
421     require(totalReceived + altDeposits <= hardcap);
422     _;
423     }
424 
425     function CCRCrowdsale() public {
426     token.pause();
427     }
428 
429     /*
430     * @dev Receive eth from the sender
431     * @param sender the sender to receive tokens.
432     */
433     function acceptPayment(address sender) public isAtLeastMinimum isUnderHardcap isSaleOn payable {
434     totalReceived = totalReceived.add(msg.value);
435     multisigVault.transfer(this.balance);
436     TokensPurchased(sender, msg.value);
437   }
438 
439     /**
440     * @dev Allows the owner to set the starting time.
441     * @param _start the new _start
442     */
443     function setStart(uint256 _start) external onlyOwner {
444     start = _start;
445     }
446 
447     /**
448     * @dev Allows the owner to set the minimum purchase.
449     * @param _minimum the new _minimum
450     */
451     function setMinimum(uint256 _minimum) external onlyOwner {
452     minimum = _minimum;
453     }
454 
455     /**
456     * @dev Allows the owner to set the hardcap.
457     * @param _hardcap the new hardcap
458     */
459     function setHardcap(uint256 _hardcap) external onlyOwner {
460     hardcap = _hardcap;
461     }
462 
463     /**
464     * @dev Allows to set the total alt deposit measured in ETH to make sure the hardcap includes other deposits
465     * @param totalAltDeposits total amount ETH equivalent
466     */
467     function setAltDeposits(uint256 totalAltDeposits) external onlyOwner {
468     altDeposits = totalAltDeposits;
469     }
470 
471     /**
472     * @dev Allows the owner to set the multisig contract.
473     * @param _multisigVault the multisig contract address
474     */
475     function setMultisigVault(address _multisigVault) external onlyOwner {
476     require(_multisigVault != address(0));
477     multisigVault = _multisigVault;
478     }
479 
480     /**
481     * @dev Allows the owner to stop the sale
482     * @param _saleOngoing whether the sale is ongoing or not
483     */
484     function setSaleOngoing(bool _saleOngoing) external onlyOwner {
485     saleOngoing = _saleOngoing;
486     }
487 
488     /**
489     * @dev Allows the owner to close the sale and stop accepting ETH.
490     * The ownership of the token contract is transfered to this owner.
491     */
492     function closeSale() external onlyOwner {
493     token.transferOwnership(owner);
494     CCRCrowdsaleClosed();
495     }    
496 
497     /**
498     * @dev Allows the owner to transfer ERC20 tokens to the multisig vault
499     * @param _token the contract address of the ERC20 contract
500     */
501     function retrieveTokens(address _token) external onlyOwner {
502     ERC20 foreignToken = ERC20(_token);
503     foreignToken.transfer(multisigVault, foreignToken.balanceOf(this));
504     }
505 
506     /**
507     * @dev Fallback function which receives ether
508     */
509     function() external payable {
510     acceptPayment(msg.sender);
511     }
512 }