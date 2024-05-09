1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
10     */
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     /**
17     * @dev Adds two numbers, throws on overflow.
18     */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 
25     /**
26      * @dev Multiplies two numbers, throws on overflow.
27      */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32         uint256 c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 /*
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80     event Pause();
81     event Unpause();
82 
83     bool public paused = false;
84 
85 
86     /*
87      * @dev Modifier to make a function callable only when the contract is not paused.
88      */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95      * @dev Modifier to make a function callable only when the contract is paused.
96      */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /*
103      * @dev called by the owner to pause, triggers stopped state
104      */
105     function pause() onlyOwner whenNotPaused public {
106         paused = true;
107         Pause();
108     }
109 
110     /*
111      * @dev called by the owner to unpause, returns to normal state
112      */
113     function unpause() onlyOwner whenPaused public {
114         paused = false;
115         Unpause();
116     }
117 }
118 
119 /*
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125     function totalSupply() public view returns (uint256);
126 
127     function balanceOf(address who) public view returns (uint256);
128 
129     function transfer(address to, uint256 value) public returns (bool);
130 
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139     function allowance(address owner, address spender) public view returns (uint256);
140 
141     function transferFrom(address from, address to, uint256 value) public returns (bool);
142 
143     function approve(address spender, uint256 value) public returns (bool);
144 
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title ERC223 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/223
151  */
152 contract ERC223 is ERC20 {
153     function transfer(address to, uint value, bytes data) public returns (bool ok);
154 
155     function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
156 
157     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
158 }
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165     using SafeMath for uint256;
166 
167     mapping(address => uint256) balances;
168 
169     uint256 totalSupply_;
170 
171     /**
172     * @dev total number of tokens in existence
173     */
174     function totalSupply() public view returns (uint256) {
175         return totalSupply_;
176     }
177 
178     /**
179     * @dev transfer token for a specified address
180     * @param _to The address to transfer to.
181     * @param _value The amount to be transferred.
182     */
183     function transfer(address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[msg.sender]);
186 
187         // SafeMath.sub will throw if there is not enough balance.
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         Transfer(msg.sender, _to, _value);
191         return true;
192     }
193 
194     /**
195     * @dev Gets the balance of the specified address.
196     * @param _owner The address to query the the balance of.
197     * @return An uint256 representing the amount owned by the passed address.
198     */
199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return balances[_owner];
201     }
202 
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214     mapping(address => mapping(address => uint256)) allowed;
215 
216 
217     /**
218      * @dev Transfer tokens from one address to another
219      * @param _from address The address which you want to send tokens from
220      * @param _to address The address which you want to transfer to
221      * @param _value uint256 the amount of tokens to be transferred
222      */
223     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224         require(_to != address(0));
225         require(_value <= balances[_from]);
226         require(_value <= allowed[_from][msg.sender]);
227 
228         balances[_from] = balances[_from].sub(_value);
229         balances[_to] = balances[_to].add(_value);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231         Transfer(_from, _to, _value);
232         return true;
233     }
234 
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237      *
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param _spender The address which will spend the funds.
243      * @param _value The amount of tokens to be spent.
244      */
245     function approve(address _spender, uint256 _value) public returns (bool) {
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248         return true;
249     }
250 
251     /**
252      * @dev Function to check the amount of tokens that an owner allowed to a spender.
253      * @param _owner address The address which owns the funds.
254      * @param _spender address The address which will spend the funds.
255      * @return A uint256 specifying the amount of tokens still available for the spender.
256      */
257     function allowance(address _owner, address _spender) public view returns (uint256) {
258         return allowed[_owner][_spender];
259     }
260 
261     /**
262      * @dev Increase the amount of tokens that an owner allowed to a spender.
263      *
264      * approve should be called when allowed[_spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * @param _spender The address which will spend the funds.
269      * @param _addedValue The amount of tokens to increase the allowance by.
270      */
271     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276 
277     /**
278      * @dev Decrease the amount of tokens that an owner allowed to a spender.
279      *
280      * approve should be called when allowed[_spender] == 0. To decrement
281      * allowed value is better to use this function to avoid 2 calls (and wait until
282      * the first transaction is mined)
283      * From MonolithDAO Token.sol
284      * @param _spender The address which will spend the funds.
285      * @param _subtractedValue The amount of tokens to decrease the allowance by.
286      */
287     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288         uint oldValue = allowed[msg.sender][_spender];
289         if (_subtractedValue > oldValue) {
290             allowed[msg.sender][_spender] = 0;
291         } else {
292             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293         }
294         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295         return true;
296     }
297 
298 }
299 
300 /**
301  * @title Standard ERC223 token
302  */
303 contract Standard223Token is ERC223, StandardToken {
304     //function that is called when a user or another contract wants to transfer funds
305     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
306         //filtering if the target is a contract with bytecode inside it
307         require(super.transfer(_to, _value));
308         // do a normal token transfer
309         if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
310         return true;
311     }
312 
313     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
314         require(super.transferFrom(_from, _to, _value));
315         // do a normal token transfer
316         if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
317         return true;
318     }
319 
320     //function that is called when transaction target is a contract
321     function contractFallback(address _from, address _to, uint _value, bytes _data) private returns (bool success) {
322         ERC223Receiver receiver = ERC223Receiver(_to);
323         return receiver.tokenFallback(_from, _value, _data);
324     }
325 
326     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
327     function isContract(address _addr) internal view returns (bool is_contract) {
328         // retrieve the size of the code on target address, this needs assembly
329         uint length;
330         assembly {length := extcodesize(_addr)}
331         return length > 0;
332     }
333 }
334 
335 /**
336  * @title Burnable Token
337  * @dev Token that can be irreversibly burned (destroyed).
338  */
339 contract BurnableToken is BasicToken, Ownable {
340 
341     event Burn(address indexed burner, uint256 value);
342 
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param _value The amount of token to be burned.
346      */
347     function burn(uint256 _value) onlyOwner public {
348         require(_value <= balances[msg.sender]);
349         // no need to require value <= totalSupply, since that would imply the
350         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
351 
352         address burner = msg.sender;
353         balances[burner] = balances[burner].sub(_value);
354         totalSupply_ = totalSupply_.sub(_value);
355         Burn(burner, _value);
356     }
357 }
358 
359 
360 /**
361  * @title Frozen token
362  * @dev Simple ERC20 Token example, with freeze token of one account
363  */
364 contract FrozenToken is Ownable {
365     mapping(address => bool) public frozenAccount;
366 
367     event FrozenFunds(address target, bool frozen);
368 
369     function freezeAccount(address target, bool freeze) public onlyOwner {
370         frozenAccount[target] = freeze;
371         FrozenFunds(target, freeze);
372     }
373 
374     modifier requireNotFrozen(address from){
375         require(!frozenAccount[from]);
376         _;
377     }
378 }
379 
380 
381 contract ERC223Receiver {
382     /**
383      * @dev Standard ERC223 function that will handle incoming token transfers.
384      *
385      * @param _from  Token sender address.
386      * @param _value Amount of tokens.
387      * @param _data  Transaction metadata.
388      */
389     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool ok);
390 }
391 
392 
393 
394 /**
395  * ERC20 token
396  * SLT
397  */
398 contract SocialLendingToken is Pausable, BurnableToken, Standard223Token, FrozenToken {
399 
400     string public name;
401     string public symbol;
402     uint public decimals;
403     address public airdroper;
404 
405 
406     function SocialLendingToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
407         totalSupply_ = _initialSupply;
408         name = _name;
409         symbol = _symbol;
410         decimals = _decimals;
411         airdroper = msg.sender;
412         balances[msg.sender] = _initialSupply;
413         Transfer(0x0, msg.sender, _initialSupply);
414     }
415 
416     function transfer(address _to, uint _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_to) returns (bool) {
417         return transfer(_to, _value, new bytes(0));
418     }
419 
420     function transferFrom(address _from, address _to, uint _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_from) requireNotFrozen(_to) returns (bool) {
421         return transferFrom(_from, _to, _value, new bytes(0));
422     }
423 
424     function approve(address _spender, uint _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_spender) returns (bool) {
425         return super.approve(_spender, _value);
426     }
427 
428     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_spender) returns (bool) {
429         return super.increaseApproval(_spender, _addedValue);
430     }
431 
432     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_spender) returns (bool) {
433         return super.decreaseApproval(_spender, _subtractedValue);
434     }
435 
436     ////ERC223
437     function transfer(address _to, uint _value, bytes _data) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_to) returns (bool success) {
438         return super.transfer(_to, _value, _data);
439     }
440 
441     function transferFrom(address _from, address _to, uint _value, bytes _data) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_from) requireNotFrozen(_to) returns (bool success) {
442         return super.transferFrom(_from, _to, _value, _data);
443     }
444 
445     event Airdrop(address indexed from, uint addressCount, uint totalAmount);
446     event AirdropDiff(address indexed from, uint addressCount, uint totalAmount);
447     event SetAirdroper(address indexed airdroper);
448 
449     function setAirdroper(address _airdroper) public onlyOwner returns (bool){
450         require(_airdroper != address(0) && _airdroper != airdroper);
451         airdroper = _airdroper;
452         SetAirdroper(_airdroper);
453         return true;
454     }
455 
456     modifier onlyAirdroper(){
457         require(msg.sender == airdroper);
458         _;
459     }
460 
461     /**
462      * @dev airdrop token to address list, each address distributes the same number of token
463      *
464      * @param _addresses address list to distributes
465      * @param _value Amount of tokens.
466      */
467     function airdrop(uint _value, address[] _addresses) public whenNotPaused onlyAirdroper returns (bool success){
468         uint addressCount = _addresses.length;
469         require(addressCount > 0 && addressCount <= 1000);
470         uint totalAmount = _value.mul(addressCount);
471         require(_value > 0 && balances[msg.sender] >= totalAmount);
472 
473         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
474         for (uint i = 0; i < addressCount; i++) {
475             require(_addresses[i] != address(0));
476             balances[_addresses[i]] = balances[_addresses[i]].add(_value);
477             Transfer(msg.sender, _addresses[i], _value);
478         }
479         Airdrop(msg.sender, addressCount, totalAmount);
480         return true;
481     }
482 
483     function airdropDiff(uint[] _values, address[] _addresses) public whenNotPaused onlyAirdroper returns (bool success){
484         uint addressCount = _addresses.length;
485 
486         require(addressCount == _values.length);
487         require(addressCount > 0 && addressCount <= 1000);
488 
489         uint totalAmount = 0;
490         for (uint i = 0; i < addressCount; i++) {
491             require(_values[i] > 0);
492             totalAmount = totalAmount.add(_values[i]);
493         }
494         require(balances[msg.sender] >= totalAmount);
495         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
496         for (uint j = 0; j < addressCount; j++) {
497             require(_addresses[j] != address(0));
498             balances[_addresses[j]] = balances[_addresses[j]].add(_values[j]);
499             Transfer(msg.sender, _addresses[j], _values[j]);
500         }
501         AirdropDiff(msg.sender, addressCount, totalAmount);
502         return true;
503     }
504 }