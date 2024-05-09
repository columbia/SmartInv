1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipRenounced(address indexed previousOwner);
12     event OwnershipTransferred(
13       address indexed previousOwner,
14       address indexed newOwner
15     );
16 
17 
18     /**
19     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20     * account.
21     */
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /**
27     * @dev Throws if called by any account other than the owner.
28     */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     /**
35     * @dev Allows the current owner to transfer control of the contract to a newOwner.
36     * @param newOwner The address to transfer ownership to.
37     */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44     /**
45     * @dev Allows the current owner to relinquish control of the contract.
46     */
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipRenounced(owner);
49         owner = address(0);
50     }
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58 
59     /**
60     * @dev Multiplies two numbers, throws on overflow.
61     */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
63         if (a == 0) {
64             return 0;
65         }
66         c = a * b;
67         assert(c / a == b);
68         return c;
69     }
70 
71     /**
72     * @dev Integer division of two numbers, truncating the quotient.
73     */
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         // assert(b > 0); // Solidity automatically throws when dividing by 0
76         // uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78         return a / b;
79     }
80 
81     /**
82     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
83     */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         assert(b <= a);
86         return a - b;
87     }
88 
89     /**
90     * @dev Adds two numbers, throws on overflow.
91     */
92     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
93         c = a + b;
94         assert(c >= a);
95         return c;
96     }
97 }
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105     function totalSupply() public view returns (uint256);
106     function balanceOf(address who) public view returns (uint256);
107     function transfer(address to, uint256 value) public returns (bool);
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116     function allowance(address owner, address spender) public view returns (uint256);
117     function transferFrom(address from, address to, uint256 value) public returns (bool);
118     function approve(address spender, uint256 value) public returns (bool);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract BasicToken is ERC20Basic {
123     using SafeMath for uint256;
124 
125     mapping(address => uint256) balances;
126 
127     uint256 totalSupply_;
128 
129     /**
130     * @dev total number of tokens in existence
131     */
132     function totalSupply() public view returns (uint256) {
133         return totalSupply_;
134     }
135 
136     /**
137     * @dev transfer token for a specified address
138     * @param _to The address to transfer to.
139     * @param _value The amount to be transferred.
140     */
141     function transfer(address _to, uint256 _value) public returns (bool) {
142         require(_to != address(0));
143         require(_value <= balances[msg.sender]);
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Gets the balance of the specified address.
153     * @param _owner The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function balanceOf(address _owner) public view returns (uint256) {
157         return balances[_owner];
158     }
159 
160 }
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173     /**
174     * @dev Transfer tokens from one address to another
175     * @param _from address The address which you want to send tokens from
176     * @param _to address The address which you want to transfer to
177     * @param _value uint256 the amount of tokens to be transferred
178     */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193     *
194     * Beware that changing an allowance with this method brings the risk that someone may use both the old
195     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198     * @param _spender The address which will spend the funds.
199     * @param _value The amount of tokens to be spent.
200     */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208     * @dev Function to check the amount of tokens that an owner allowed to a spender.
209     * @param _owner address The address which owns the funds.
210     * @param _spender address The address which will spend the funds.
211     * @return A uint256 specifying the amount of tokens still available for the spender.
212     */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218     * @dev Increase the amount of tokens that an owner allowed to a spender.
219     *
220     * approve should be called when allowed[_spender] == 0. To increment
221     * allowed value is better to use this function to avoid 2 calls (and wait until
222     * the first transaction is mined)
223     * From MonolithDAO Token.sol
224     * @param _spender The address which will spend the funds.
225     * @param _addedValue The amount of tokens to increase the allowance by.
226     */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234     * @dev Decrease the amount of tokens that an owner allowed to a spender.
235     *
236     * approve should be called when allowed[_spender] == 0. To decrement
237     * allowed value is better to use this function to avoid 2 calls (and wait until
238     * the first transaction is mined)
239     * From MonolithDAO Token.sol
240     * @param _spender The address which will spend the funds.
241     * @param _subtractedValue The amount of tokens to decrease the allowance by.
242     */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246           allowed[msg.sender][_spender] = 0;
247         } else {
248           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 }
254 
255 contract MintableToken is StandardToken, Ownable {
256     event Mint(address indexed to, uint256 amount);
257     event MintFinished();
258 
259     bool public mintingFinished = false;
260 
261 
262     modifier canMint() {
263         require(!mintingFinished);
264         _;
265     }
266 
267     /**
268     * @dev Function to mint tokens
269     * @param _to The address that will receive the minted tokens.
270     * @param _amount The amount of tokens to mint.
271     * @return A boolean that indicates if the operation was successful.
272     */
273     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
274         totalSupply_ = totalSupply_.add(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         emit Mint(_to, _amount);
277         emit Transfer(address(0), _to, _amount);
278         return true;
279     }
280 
281     /**
282     * @dev Function to stop minting new tokens.
283     * @return True if the operation was successful.
284     */
285     function finishMinting() onlyOwner canMint public returns (bool) {
286         mintingFinished = true;
287         emit MintFinished();
288         return true;
289     }
290 }
291 
292 
293 contract CappedToken is MintableToken {
294 
295     uint256 public cap;
296 
297     constructor(uint256 _cap) public {
298         require(_cap > 0);
299         cap = _cap;
300     }
301 
302     /**
303     * @dev Function to mint tokens
304     * @param _to The address that will receive the minted tokens.
305     * @param _amount The amount of tokens to mint.
306     * @return A boolean that indicates if the operation was successful.
307     */
308     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
309         require(totalSupply_.add(_amount) <= cap);
310         return super.mint(_to, _amount);
311     }
312 
313 }
314 
315 contract Pausable is Ownable {
316     event Pause();
317     event Unpause();
318 
319     bool public paused = false;
320 
321 
322     /**
323     * @dev Modifier to make a function callable only when the contract is not paused.
324     */
325     modifier whenNotPaused() {
326         require(!paused);
327         _;
328     }
329 
330     /**
331     * @dev Modifier to make a function callable only when the contract is paused.
332     */
333     modifier whenPaused() {
334         require(paused);
335         _;
336     }
337 
338     /**
339     * @dev called by the owner to pause, triggers stopped state
340     */
341     function pause() onlyOwner whenNotPaused public {
342         paused = true;
343         emit Pause();
344     }
345 
346     /**
347     * @dev called by the owner to unpause, returns to normal state
348     */
349     function unpause() onlyOwner whenPaused public {
350         paused = false;
351         emit Unpause();
352     }
353 }
354 
355 contract PausableToken is StandardToken, Pausable {
356     
357     mapping (address => bool) public frozenAccount;
358     event FrozenFunds(address target, bool frozen);
359 
360     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
361         require(!frozenAccount[msg.sender]);
362         return super.transfer(_to, _value);
363     }
364 
365     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
366         require(!frozenAccount[_from]);
367         return super.transferFrom(_from, _to, _value);
368     }
369 
370     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
371         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
372         return super.approve(_spender, _value);
373     }
374 
375     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
376         return super.increaseApproval(_spender, _addedValue);
377     }
378 
379     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380         return super.decreaseApproval(_spender, _subtractedValue);
381     }
382   
383   
384     /**
385     * @dev Function to batch send tokens
386     * @param _receivers The addresses that will receive the tokens.
387     * @param _value The amount of tokens to send.
388     */
389     function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
390         require(!frozenAccount[msg.sender]);
391         uint cnt = _receivers.length;
392         uint256 amount = uint256(cnt).mul(_value);
393         require(cnt > 0 && cnt <= 500);
394         require(_value > 0 && balances[msg.sender] >= amount);
395     
396         balances[msg.sender] = balances[msg.sender].sub(amount);
397         for (uint i = 0; i < cnt; i++) {
398             require (_receivers[i] != 0x0);
399             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
400             emit Transfer(msg.sender, _receivers[i], _value);
401         }
402         return true;
403     }
404     
405     /**
406     * @dev Function to batch send tokens
407     * @param _receivers The addresses that will receive the tokens.
408     * @param _values The array of amount to send.
409     */
410     function batchTransferValues(address[] _receivers, uint256[] _values) public whenNotPaused returns (bool) {
411         require(!frozenAccount[msg.sender]);
412         uint cnt = _receivers.length;
413         require(cnt == _values.length);
414         require(cnt > 0 && cnt <= 500);
415         
416         uint256 amount = 0;
417         for (uint i = 0; i < cnt; i++) {
418             require (_values[i] != 0);
419             amount = amount.add(_values[i]);
420         }
421         
422         require(balances[msg.sender] >= amount);
423     
424         balances[msg.sender] = balances[msg.sender].sub(amount);
425         for (uint j = 0; j < cnt; j++) {
426             require (_receivers[j] != 0x0);
427             balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);
428             emit Transfer(msg.sender, _receivers[j], _values[j]);
429         }
430         return true;
431     }
432   
433     /**
434     * @dev Function to batch freeze accounts
435     * @param _addresses The addresses that will be frozen/unfrozen.
436     * @param _freeze To freeze or not.
437     */
438     function batchFreeze(address[] _addresses, bool _freeze) onlyOwner public {
439         for (uint i = 0; i < _addresses.length; i++) {
440             frozenAccount[_addresses[i]] = _freeze;
441             emit FrozenFunds(_addresses[i], _freeze);
442         }
443     }
444 }
445 
446 contract RichToken is CappedToken, PausableToken {
447     string public constant name = "Rich";
448     string public constant symbol = "RICH";
449     uint8 public constant decimals = 18;
450 
451     uint256 public constant INITIAL_SUPPLY = 0;
452     uint256 public constant MAX_SUPPLY = 100 * 10000 * 10000 * (10 ** uint256(decimals));
453 
454     /**
455     * @dev Constructor that gives msg.sender all of existing tokens.
456     */
457     constructor() CappedToken(MAX_SUPPLY) public {
458         totalSupply_ = INITIAL_SUPPLY;
459         balances[msg.sender] = INITIAL_SUPPLY;
460         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
461     }
462 
463     /**
464     * @dev Function to mint tokens
465     * @param _to The address that will receive the minted tokens.
466     * @param _amount The amount of tokens to mint.
467     * @return A boolean that indicates if the operation was successful.
468     */
469     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
470         return super.mint(_to, _amount);
471     }
472 
473     /**
474     * @dev Function to stop minting new tokens.
475     * @return True if the operation was successful.
476     */
477     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
478         return super.finishMinting();
479     }
480 
481     /**
482     * @dev Allows the current owner to transfer control of the contract to a newOwner.
483     * @param newOwner The address to transfer ownership to.
484     */
485     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
486         super.transferOwnership(newOwner);
487     }
488 
489     /**
490     * The fallback function.
491     */
492     function() payable public {
493         revert();
494     }
495 }