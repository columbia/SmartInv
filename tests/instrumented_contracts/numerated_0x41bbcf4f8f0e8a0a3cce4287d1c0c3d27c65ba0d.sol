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
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14       address indexed previousOwner,
15       address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to transfer control of the contract to a newOwner.
37     * @param newOwner The address to transfer ownership to.
38     */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45     /**
46     * @dev Allows the current owner to relinquish control of the contract.
47     */
48     function renounceOwnership() public onlyOwner {
49         emit OwnershipRenounced(owner);
50         owner = address(0);
51     }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60     /**
61     * @dev Multiplies two numbers, throws on overflow.
62     */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64         if (a == 0) {
65             return 0;
66         }
67         c = a * b;
68         assert(c / a == b);
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two numbers, truncating the quotient.
74     */
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         // assert(b > 0); // Solidity automatically throws when dividing by 0
77         // uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79         return a / b;
80     }
81 
82     /**
83     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84     */
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89 
90     /**
91     * @dev Adds two numbers, throws on overflow.
92     */
93     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
94         c = a + b;
95         assert(c >= a);
96         return c;
97     }
98 }
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106     function totalSupply() public view returns (uint256);
107     function balanceOf(address who) public view returns (uint256);
108     function transfer(address to, uint256 value) public returns (bool);
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117     function allowance(address owner, address spender) public view returns (uint256);
118     function transferFrom(address from, address to, uint256 value) public returns (bool);
119     function approve(address spender, uint256 value) public returns (bool);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract BasicToken is ERC20Basic {
124     using SafeMath for uint256;
125 
126     mapping(address => uint256) balances;
127 
128     uint256 totalSupply_;
129 
130     /**
131     * @dev total number of tokens in existence
132     */
133     function totalSupply() public view returns (uint256) {
134         return totalSupply_;
135     }
136 
137     /**
138     * @dev transfer token for a specified address
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transfer(address _to, uint256 _value) public returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145 
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Gets the balance of the specified address.
154     * @param _owner The address to query the the balance of.
155     * @return An uint256 representing the amount owned by the passed address.
156     */
157     function balanceOf(address _owner) public view returns (uint256) {
158         return balances[_owner];
159     }
160 
161 }
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171     mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174     /**
175     * @dev Transfer tokens from one address to another
176     * @param _from address The address which you want to send tokens from
177     * @param _to address The address which you want to transfer to
178     * @param _value uint256 the amount of tokens to be transferred
179     */
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value <= allowed[_from][msg.sender]);
184 
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188         emit Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194     *
195     * Beware that changing an allowance with this method brings the risk that someone may use both the old
196     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199     * @param _spender The address which will spend the funds.
200     * @param _value The amount of tokens to be spent.
201     */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Function to check the amount of tokens that an owner allowed to a spender.
210     * @param _owner address The address which owns the funds.
211     * @param _spender address The address which will spend the funds.
212     * @return A uint256 specifying the amount of tokens still available for the spender.
213     */
214     function allowance(address _owner, address _spender) public view returns (uint256) {
215         return allowed[_owner][_spender];
216     }
217 
218     /**
219     * @dev Increase the amount of tokens that an owner allowed to a spender.
220     *
221     * approve should be called when allowed[_spender] == 0. To increment
222     * allowed value is better to use this function to avoid 2 calls (and wait until
223     * the first transaction is mined)
224     * From MonolithDAO Token.sol
225     * @param _spender The address which will spend the funds.
226     * @param _addedValue The amount of tokens to increase the allowance by.
227     */
228     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     /**
235     * @dev Decrease the amount of tokens that an owner allowed to a spender.
236     *
237     * approve should be called when allowed[_spender] == 0. To decrement
238     * allowed value is better to use this function to avoid 2 calls (and wait until
239     * the first transaction is mined)
240     * From MonolithDAO Token.sol
241     * @param _spender The address which will spend the funds.
242     * @param _subtractedValue The amount of tokens to decrease the allowance by.
243     */
244     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245         uint oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue > oldValue) {
247           allowed[msg.sender][_spender] = 0;
248         } else {
249           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250         }
251         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 }
255 
256 contract MintableToken is StandardToken, Ownable {
257     event Mint(address indexed to, uint256 amount);
258     event MintFinished();
259 
260     bool public mintingFinished = false;
261 
262 
263     modifier canMint() {
264         require(!mintingFinished);
265         _;
266     }
267 
268     /**
269     * @dev Function to mint tokens
270     * @param _to The address that will receive the minted tokens.
271     * @param _amount The amount of tokens to mint.
272     * @return A boolean that indicates if the operation was successful.
273     */
274     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
275         totalSupply_ = totalSupply_.add(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         emit Mint(_to, _amount);
278         emit Transfer(address(0), _to, _amount);
279         return true;
280     }
281 
282     /**
283     * @dev Function to stop minting new tokens.
284     * @return True if the operation was successful.
285     */
286     function finishMinting() onlyOwner canMint public returns (bool) {
287         mintingFinished = true;
288         emit MintFinished();
289         return true;
290     }
291 }
292 
293 
294 contract CappedToken is MintableToken {
295 
296     uint256 public cap;
297 
298     constructor(uint256 _cap) public {
299         require(_cap > 0);
300         cap = _cap;
301     }
302 
303     /**
304     * @dev Function to mint tokens
305     * @param _to The address that will receive the minted tokens.
306     * @param _amount The amount of tokens to mint.
307     * @return A boolean that indicates if the operation was successful.
308     */
309     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310         require(totalSupply_.add(_amount) <= cap);
311         return super.mint(_to, _amount);
312     }
313 
314 }
315 
316 contract Pausable is Ownable {
317     event Pause();
318     event Unpause();
319 
320     bool public paused = false;
321 
322 
323     /**
324     * @dev Modifier to make a function callable only when the contract is not paused.
325     */
326     modifier whenNotPaused() {
327         require(!paused);
328         _;
329     }
330 
331     /**
332     * @dev Modifier to make a function callable only when the contract is paused.
333     */
334     modifier whenPaused() {
335         require(paused);
336         _;
337     }
338 
339     /**
340     * @dev called by the owner to pause, triggers stopped state
341     */
342     function pause() onlyOwner whenNotPaused public {
343         paused = true;
344         emit Pause();
345     }
346 
347     /**
348     * @dev called by the owner to unpause, returns to normal state
349     */
350     function unpause() onlyOwner whenPaused public {
351         paused = false;
352         emit Unpause();
353     }
354 }
355 
356 contract PausableToken is StandardToken, Pausable {
357     
358     mapping (address => bool) public frozenAccount;
359     event FrozenFunds(address target, bool frozen);
360 
361     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
362         require(!frozenAccount[msg.sender]);
363         return super.transfer(_to, _value);
364     }
365 
366     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
367         require(!frozenAccount[_from]);
368         return super.transferFrom(_from, _to, _value);
369     }
370 
371     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
372         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
373         return super.approve(_spender, _value);
374     }
375 
376     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
377         return super.increaseApproval(_spender, _addedValue);
378     }
379 
380     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
381         return super.decreaseApproval(_spender, _subtractedValue);
382     }
383   
384   
385     /**
386     * @dev Function to batch send tokens
387     * @param _receivers The addresses that will receive the tokens.
388     * @param _value The amount of tokens to send.
389     */
390     function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
391         require(!frozenAccount[msg.sender]);
392         uint cnt = _receivers.length;
393         uint256 amount = uint256(cnt).mul(_value);
394         require(cnt > 0 && cnt <= 500);
395         require(_value > 0 && balances[msg.sender] >= amount);
396     
397         balances[msg.sender] = balances[msg.sender].sub(amount);
398         for (uint i = 0; i < cnt; i++) {
399             require (_receivers[i] != 0x0);
400             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
401             emit Transfer(msg.sender, _receivers[i], _value);
402         }
403         return true;
404     }
405     
406     /**
407     * @dev Function to batch send tokens
408     * @param _receivers The addresses that will receive the tokens.
409     * @param _values The array of amount to send.
410     */
411     function batchTransferValues(address[] _receivers, uint256[] _values) public whenNotPaused returns (bool) {
412         require(!frozenAccount[msg.sender]);
413         uint cnt = _receivers.length;
414         require(cnt == _values.length);
415         require(cnt > 0 && cnt <= 500);
416         
417         uint256 amount = 0;
418         for (uint i = 0; i < cnt; i++) {
419             require (_values[i] != 0);
420             amount = amount.add(_values[i]);
421         }
422         
423         require(balances[msg.sender] >= amount);
424     
425         balances[msg.sender] = balances[msg.sender].sub(amount);
426         for (uint j = 0; j < cnt; j++) {
427             require (_receivers[j] != 0x0);
428             balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);
429             emit Transfer(msg.sender, _receivers[j], _values[j]);
430         }
431         return true;
432     }
433   
434     /**
435     * @dev Function to batch freeze accounts
436     * @param _addresses The addresses that will be frozen/unfrozen.
437     * @param _freeze To freeze or not.
438     */
439     function batchFreeze(address[] _addresses, bool _freeze) onlyOwner public {
440         for (uint i = 0; i < _addresses.length; i++) {
441             frozenAccount[_addresses[i]] = _freeze;
442             emit FrozenFunds(_addresses[i], _freeze);
443         }
444     }
445 }
446 
447 contract MallToken is CappedToken, PausableToken {
448     string public constant name = "M商城";
449     string public constant symbol = "MALL";
450     uint8 public constant decimals = 18;
451 
452     uint256 public constant INITIAL_SUPPLY = 0;
453     uint256 public constant MAX_SUPPLY = 10 * 10000 * 10000 * (10 ** uint256(decimals));
454 
455     /**
456     * @dev Constructor that gives msg.sender all of existing tokens.
457     */
458     constructor() CappedToken(MAX_SUPPLY) public {
459         totalSupply_ = INITIAL_SUPPLY;
460         balances[msg.sender] = INITIAL_SUPPLY;
461         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
462     }
463 
464     /**
465     * @dev Function to mint tokens
466     * @param _to The address that will receive the minted tokens.
467     * @param _amount The amount of tokens to mint.
468     * @return A boolean that indicates if the operation was successful.
469     */
470     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
471         return super.mint(_to, _amount);
472     }
473 
474     /**
475     * @dev Function to stop minting new tokens.
476     * @return True if the operation was successful.
477     */
478     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
479         return super.finishMinting();
480     }
481 
482     /**
483     * @dev Allows the current owner to transfer control of the contract to a newOwner.
484     * @param newOwner The address to transfer ownership to.
485     */
486     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
487         super.transferOwnership(newOwner);
488     }
489 
490     /**
491     * The fallback function.
492     */
493     function() payable public {
494         revert();
495     }
496 }