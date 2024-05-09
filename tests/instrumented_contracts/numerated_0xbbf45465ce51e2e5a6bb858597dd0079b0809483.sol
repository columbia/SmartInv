1 pragma solidity 0.5.8;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, revert on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev See https://eips.ethereum.org/EIPS/eip-20
61  */
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address who) external view returns (uint256);
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86     address internal _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Revert if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner(), "The caller must be owner");
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allow the current owner to transfer control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address newOwner) public onlyOwner {
117         _transferOwnership(newOwner);
118     }
119 
120     /**
121      * @dev Transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function _transferOwnership(address newOwner) internal {
125         require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  * @dev Implementation of the basic standard token.
134  */
135 contract StandardToken is IERC20 {
136     using SafeMath for uint256;
137 
138     mapping (address => uint256) internal _balances;
139 
140     mapping (address => mapping (address => uint256)) internal _allowed;
141 
142     uint256 internal _totalSupply;
143     
144     /**
145      * @dev Total number of tokens in existence.
146      */
147     function totalSupply() public view returns (uint256) {
148         return _totalSupply;
149     }
150 
151     /**
152      * @dev Get the balance of the specified address.
153      * @param owner The address to query the balance of.
154      * @return A uint256 representing the amount owned by the passed address.
155      */
156     function balanceOf(address owner) public view returns (uint256) {
157         return _balances[owner];
158     }
159 
160     /**
161      * @dev Function to check the amount of tokens that an owner allowed to a spender.
162      * @param owner The address which owns the funds.
163      * @param spender The address which will spend the funds.
164      * @return A uint256 specifying the amount of tokens still available for the spender.
165      */
166     function allowance(address owner, address spender) public view returns (uint256) {
167         return _allowed[owner][spender];
168     }
169 
170     /**
171      * @dev Transfer tokens to a specified address.
172      * @param to The address to transfer to.
173      * @param value The amount to be transferred.
174      */
175     function transfer(address to, uint256 value) public returns (bool) {
176         _transfer(msg.sender, to, value);
177         return true;
178     }
179 
180     /**
181      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param spender The address which will spend the funds.
187      * @param value The amount of tokens to be spent.
188      */
189     function approve(address spender, uint256 value) public returns (bool) {
190         _approve(msg.sender, spender, value);
191         return true;
192     }
193 
194     /**
195      * @dev Transfer tokens from one address to another.
196      * Note that while this function emits an Approval event, this is not required as per the specification,
197      * and other compliant implementations may not emit the event.
198      * @param from The address which you want to send tokens from.
199      * @param to The address which you want to transfer to.
200      * @param value The amount of tokens to be transferred.
201      */
202     function transferFrom(address from, address to, uint256 value) public returns (bool) {
203         _transfer(from, to, value);
204         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
205         return true;
206     }
207 
208     /**
209      * @dev Increase the amount of tokens that an owner allowed to a spender.
210      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param addedValue The amount of tokens to increase the allowance by.
217      */
218     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
219         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
220         return true;
221     }
222 
223     /**
224      * @dev Decrease the amount of tokens that an owner allowed to a spender.
225      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * Emits an Approval event.
230      * @param spender The address which will spend the funds.
231      * @param subtractedValue The amount of tokens to decrease the allowance by.
232      */
233     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
234         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
235         return true;
236     }
237 
238     /**
239      * @dev Transfer tokens for a specified address.
240      * @param from The address to transfer from.
241      * @param to The address to transfer to.
242      * @param value The amount to be transferred.
243      */
244     function _transfer(address from, address to, uint256 value) internal {
245         require(to != address(0), "Cannot transfer to the zero address");
246 
247         _balances[from] = _balances[from].sub(value);
248         _balances[to] = _balances[to].add(value);
249         emit Transfer(from, to, value);
250     }
251 
252     /**
253      * @dev Approve an address to spend another addresses' tokens.
254      * @param owner The address that owns the tokens.
255      * @param spender The address that will spend the tokens.
256      * @param value The number of tokens that can be spent.
257      */
258     function _approve(address owner, address spender, uint256 value) internal {
259         require(spender != address(0), "Cannot approve to the zero address");
260         require(owner != address(0), "Setter cannot be the zero address");
261 
262         _allowed[owner][spender] = value;
263         emit Approval(owner, spender, value);
264     }
265 
266 }
267 
268 /**
269  * @title Pausable
270  * @dev Base contract which allows children to implement an emergency stop mechanism.
271  */
272 contract Pausable is Ownable {
273     event Pause();
274     event Unpause();
275 
276     bool public paused = false;
277 
278 
279     /**
280      * @dev Modifier to make a function callable only when the contract is not paused.
281      */
282     modifier whenNotPaused() {
283         require(!paused, "Only when the contract is not paused");
284         _;
285     }
286 
287     /**
288      * @dev Modifier to make a function callable only when the contract is paused.
289      */
290     modifier whenPaused() {
291         require(paused, "Only when the contract is paused");
292         _;
293     }
294 
295     /**
296      * @dev Called by the owner to pause, trigger stopped state.
297      */
298     function pause() public onlyOwner whenNotPaused {
299         paused = true;
300         emit Pause();
301     }
302 
303     /**
304      * @dev Called by the owner to unpause, return to normal state.
305      */
306     function unpause() public onlyOwner whenPaused {
307         paused = false;
308         emit Unpause();
309     }
310 }
311 
312 /**
313  * @title PausableToken
314  * @dev ERC20 modified with pausable transfers.
315  */
316 contract PausableToken is StandardToken, Pausable {
317 
318     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319         return super.transfer(_to, _value);
320     }
321 
322     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323         return super.transferFrom(_from, _to, _value);
324     }
325 
326     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327         return super.approve(_spender, _value);
328     }
329 
330     function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331         return super.increaseAllowance(_spender, _addedValue);
332     }
333 
334     function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335         return super.decreaseAllowance(_spender, _subtractedValue);
336     }
337 }
338 /**
339  *  @title FreezableToken
340  */
341 contract FreezableToken is PausableToken {
342     mapping(address=>bool) internal _frozenAccount;
343 
344     event FrozenAccount(address indexed target, bool frozen);
345 
346     /**
347      * @dev Return whether the specified address is frozen.
348      * @param account A specified address.
349      */
350     function frozenAccount(address account) public view returns(bool){
351         return _frozenAccount[account];
352     }
353 
354     /**
355      * @dev Check if the specified address is frozen. Require the specified address not to be frozen.
356      * @param account A specified address.
357      */
358     function frozenCheck(address account) internal view {
359         require(!frozenAccount(account), "Address has been frozen");
360     }
361 
362     /**
363      * @dev Modify the frozen status of the specified address.
364      * @param account A specified address.
365      * @param frozen Frozen status, true: freeze, false: unfreeze.
366      */
367     function freeze(address account, bool frozen) public onlyOwner {
368   	    _frozenAccount[account] = frozen;
369   	    emit FrozenAccount(account, frozen);
370     }
371 
372     /**
373      * @dev Rewrite the transfer function to check if the address participating is frozen.
374      */
375     function transfer(address _to, uint256 _value) public returns (bool) {
376         frozenCheck(msg.sender);
377         frozenCheck(_to);
378         return super.transfer(_to, _value);
379     }
380 
381     /**
382      * @dev Rewrite the transferFrom function to check if the address participating is frozen.
383      */
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
385         frozenCheck(msg.sender);
386         frozenCheck(_from);
387         frozenCheck(_to);
388         return super.transferFrom(_from, _to, _value);
389     }   
390 }
391 
392 contract AICCToken is FreezableToken {
393     string public constant name = "AICloudChain"; // name of Token.
394     string public constant symbol = "AICC"; // symbol of Token.
395     uint8 public constant decimals = 18;
396     uint256 private constant INIT_TOTALSUPPLY = 30000000;
397 
398     mapping (address => uint256) public releaseTime;
399     mapping (address => uint256) public lockAmount;
400 
401     event LockToken(address indexed beneficiary, uint256 releaseTime, uint256 releaseAmount);
402     event ReleaseToken(address indexed user, uint256 releaseAmount);
403 
404     /**
405      * @dev Constructor.
406      */
407     constructor() public {
408         _totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
409         _owner = 0x06C7B9Ce4f2Fee058DE2A79F75DEC55092C229Aa;
410         _balances[_owner] = _totalSupply;
411         emit Transfer(address(0), _owner, _totalSupply);
412     }
413 
414     /**
415      * @dev Send the tokens to the beneficiary and lock it, and the timestamp and quantity of lock can be set by owner.
416      * @param _beneficiary A specified address.
417      * @param _releaseTime The timestamp of release token.
418      * @param _releaseAmount The amount of release token.
419      */
420     function lockToken(address _beneficiary, uint256 _releaseTime, uint256 _releaseAmount) public onlyOwner returns(bool) {
421         require(lockAmount[_beneficiary] == 0, "The address has been locked");
422         require(_beneficiary != address(0), "The target address cannot be the zero address");
423         require(_releaseAmount > 0, "The amount must be greater than 0");
424         require(_releaseTime > now, "The time must be greater than current time");
425         frozenCheck(_beneficiary);
426         lockAmount[_beneficiary] = _releaseAmount;
427         releaseTime[_beneficiary] = _releaseTime;
428         _balances[_owner] = _balances[_owner].sub(_releaseAmount); // Remove this part of the locked tokens from the owner.
429         emit LockToken(_beneficiary, _releaseTime, _releaseAmount);
430         return true;
431     }
432 
433     /**
434      * @dev Implement the basic functions of releasing tokens.
435      */
436     function releaseToken(address _owner) public whenNotPaused returns(bool) {
437         frozenCheck(_owner);
438         uint256 amount = releasableAmount(_owner);
439         require(amount > 0, "No releasable tokens");
440         _balances[_owner] = _balances[_owner].add(amount);
441         lockAmount[_owner] = 0;
442         emit ReleaseToken(_owner, amount);
443         return true;
444     }
445 
446     /**
447      * @dev Get the amount of current timestamp that can be released.
448      * @param addr A specified address.
449      */
450     function releasableAmount(address addr) public view returns(uint256) {
451         if(lockAmount[addr] != 0 && now > releaseTime[addr]) {
452             return lockAmount[addr];
453         } else {
454             return 0;
455         }
456      }
457     
458     /**
459      * @dev Rewrite the transfer function to automatically unlock the locked tokens.
460      */
461     function transfer(address to, uint256 value) public returns (bool) {
462         if(releasableAmount(msg.sender) > 0) {
463             releaseToken(msg.sender);
464         }
465         return super.transfer(to, value);
466     }
467 
468     /**
469      * @dev Rewrite the transferFrom function to automatically unlock the locked tokens.
470      */
471     function transferFrom(address from, address to, uint256 value) public returns (bool) {
472         if(releasableAmount(from) > 0) {
473             releaseToken(from);
474         }
475         return super.transferFrom(from, to, value);
476     }
477 
478     /**
479      * @dev Transfer tokens to multiple addresses.
480      */
481     function batchTransfer(address[] memory addressList, uint256[] memory amountList) public onlyOwner returns (bool) {
482         uint256 length = addressList.length;
483         require(addressList.length == amountList.length, "Inconsistent array length");
484         require(length > 0 && length <= 150, "Invalid number of transfer objects");
485         uint256 amount;
486         for (uint256 i = 0; i < length; i++) {
487             frozenCheck(addressList[i]);
488             require(amountList[i] > 0, "The transfer amount cannot be 0");
489             require(addressList[i] != address(0), "Cannot transfer to the zero address");
490             amount = amount.add(amountList[i]);
491             _balances[addressList[i]] = _balances[addressList[i]].add(amountList[i]);
492             emit Transfer(msg.sender, addressList[i], amountList[i]);
493         }
494         require(_balances[msg.sender] >= amount, "Not enough tokens to transfer");
495         _balances[msg.sender] = _balances[msg.sender].sub(amount);
496         return true;
497     }
498 }