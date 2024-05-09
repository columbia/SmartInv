1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8     function totalSupply() public view returns (uint256);
9 
10     function balanceOf(address _who) public view returns (uint256);
11 
12     function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15     function transfer(address _to, uint256 _value) public returns (bool);
16 
17     function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20     function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23     event Transfer(
24         address indexed from,
25         address indexed to,
26         uint256 value
27     );
28 
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param _newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address _newOwner) public onlyOwner {
70         _transferOwnership(_newOwner);
71     }
72 
73     /**
74      * @dev Transfers control of the contract to a newOwner.
75      * @param _newOwner The address to transfer ownership to.
76      */
77     function _transferOwnership(address _newOwner) internal {
78         require(_newOwner != address(0));
79         emit OwnershipTransferred(owner, _newOwner);
80         owner = _newOwner;
81     }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that revert on error
87  */
88 library SafeMath {
89 
90     /**
91     * @dev Multiplies two numbers, reverts on overflow.
92     */
93     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
94         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95         // benefit is lost if 'b' is also tested.
96         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97         if (_a == 0) {
98             return 0;
99         }
100 
101         uint256 c = _a * _b;
102         require(c / _a == _b);
103 
104         return c;
105     }
106 
107     /**
108     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
109     */
110     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
111         require(_b > 0); // Solidity only automatically asserts when dividing by 0
112         uint256 c = _a / _b;
113         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
114 
115         return c;
116     }
117 
118     /**
119     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
120     */
121     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
122         require(_b <= _a);
123         uint256 c = _a - _b;
124 
125         return c;
126     }
127 
128     /**
129     * @dev Adds two numbers, reverts on overflow.
130     */
131     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
132         uint256 c = _a + _b;
133         require(c >= _a);
134 
135         return c;
136     }
137 
138     /**
139     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
140     * reverts when dividing by zero.
141     */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b != 0);
144         return a % b;
145     }
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/issues/20
153  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20 {
156     using SafeMath for uint256;
157 
158     mapping(address => uint256) balances;
159 
160     mapping (address => mapping (address => uint256)) internal allowed;
161 
162     uint256 totalSupply_;
163 
164     /**
165     * @dev Total number of tokens in existence
166     */
167     function totalSupply() public view returns (uint256) {
168         return totalSupply_;
169     }
170 
171     /**
172     * @dev Gets the balance of the specified address.
173     * @param _owner The address to query the the balance of.
174     * @return An uint256 representing the amount owned by the passed address.
175     */
176     function balanceOf(address _owner) public view returns (uint256) {
177         return balances[_owner];
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190     public
191     view
192     returns (uint256)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198     * @dev Transfer token for a specified address
199     * @param _to The address to transfer to.
200     * @param _value The amount to be transferred.
201     */
202     function transfer(address _to, uint256 _value) public returns (bool) {
203         require(_value <= balances[msg.sender]);
204         require(_to != address(0));
205 
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         emit Transfer(msg.sender, _to, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param _spender The address which will spend the funds.
219      * @param _value The amount of tokens to be spent.
220      */
221     function approve(address _spender, uint256 _value) public returns (bool) {
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224         return true;
225     }
226 
227     /**
228      * @dev Transfer tokens from one address to another
229      * @param _from address The address which you want to send tokens from
230      * @param _to address The address which you want to transfer to
231      * @param _value uint256 the amount of tokens to be transferred
232      */
233     function transferFrom(
234         address _from,
235         address _to,
236         uint256 _value
237     )
238     public
239     returns (bool)
240     {
241         require(_value <= balances[_from]);
242         require(_value <= allowed[_from][msg.sender]);
243         require(_to != address(0));
244 
245         balances[_from] = balances[_from].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248         emit Transfer(_from, _to, _value);
249         return true;
250     }
251 
252     /**
253      * @dev Increase the amount of tokens that an owner allowed to a spender.
254      * approve should be called when allowed[_spender] == 0. To increment
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      * @param _spender The address which will spend the funds.
259      * @param _addedValue The amount of tokens to increase the allowance by.
260      */
261     function increaseApproval(
262         address _spender,
263         uint256 _addedValue
264     )
265     public
266     returns (bool)
267     {
268         allowed[msg.sender][_spender] = (
269         allowed[msg.sender][_spender].add(_addedValue));
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 
274     /**
275      * @dev Decrease the amount of tokens that an owner allowed to a spender.
276      * approve should be called when allowed[_spender] == 0. To decrement
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * @param _spender The address which will spend the funds.
281      * @param _subtractedValue The amount of tokens to decrease the allowance by.
282      */
283     function decreaseApproval(
284         address _spender,
285         uint256 _subtractedValue
286     )
287     public
288     returns (bool)
289     {
290         uint256 oldValue = allowed[msg.sender][_spender];
291         if (_subtractedValue >= oldValue) {
292             allowed[msg.sender][_spender] = 0;
293         } else {
294             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295         }
296         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297         return true;
298     }
299 
300 }
301 
302 interface ERC223Receiver {
303 
304     function tokenFallback(address _from, uint256 _value, bytes _data) external;
305 
306 }
307 
308 /**
309  * Secure Crypto Payments ERC223 token contract
310  *
311  * Designed and developed by BlockSoft.biz
312  */
313 contract SecureCryptoToken is StandardToken, Ownable {
314     using SafeMath for uint256;
315 
316     event Release();
317     event AddressLocked(address indexed _address, uint256 _time);
318     event TokensReverted(address indexed _address, uint256 _amount);
319     event AddressLockedByKYC(address indexed _address);
320     event KYCVerified(address indexed _address);
321     event TokensRevertedByKYC(address indexed _address, uint256 _amount);
322     event SetTechAccount(address indexed _address);
323 
324     string public constant name = "Secure Crypto Payments";
325 
326     string public constant symbol = "SEC";
327 
328     string public constant standard = "ERC223";
329 
330     uint256 public constant decimals = 8;
331 
332     bool public released = false;
333     bool public ignoreKYCLockup = false;
334 
335     address public tokensWallet;
336     address public techAccount;
337 
338     mapping(address => uint) public lockedAddresses;
339     mapping(address => bool) public verifiedKYCAddresses;
340 
341     modifier isReleased() {
342         require(released || msg.sender == tokensWallet || msg.sender == owner || msg.sender == techAccount);
343         require(lockedAddresses[msg.sender] <= now);
344         if (!ignoreKYCLockup) {
345             require(verifiedKYCAddresses[msg.sender]);
346         }
347         _;
348     }
349 
350     modifier hasAddressLockupPermission() {
351         require(msg.sender == owner || msg.sender == techAccount);
352         _;
353     }
354 
355     constructor() public {
356         owner = 0xc8F9bFc1B5b77A44484b27ebF4583f1E0207EBb5;
357         tokensWallet = owner;
358         verifiedKYCAddresses[owner] = true;
359 
360         techAccount = 0x41D621De050A551F5f0eBb83D1332C75339B61E4;
361         verifiedKYCAddresses[techAccount] = true;
362         emit SetTechAccount(techAccount);
363 
364         totalSupply_ = 121000000 * (10 ** decimals);
365         balances[tokensWallet] = totalSupply_;
366         emit Transfer(0x0, tokensWallet, totalSupply_);
367     }
368 
369     function lockAddress(address _address, uint256 _time) public hasAddressLockupPermission returns (bool) {
370         require(_address != owner && _address != tokensWallet && _address != techAccount);
371         require(balances[_address] == 0 && lockedAddresses[_address] == 0 && _time > now);
372         lockedAddresses[_address] = _time;
373 
374         emit AddressLocked(_address, _time);
375         return true;
376     }
377 
378     function revertTokens(address _address) public hasAddressLockupPermission returns (bool) {
379         require(lockedAddresses[_address] > now && balances[_address] > 0);
380 
381         uint256 amount = balances[_address];
382         balances[tokensWallet] = balances[tokensWallet].add(amount);
383         balances[_address] = 0;
384 
385         emit Transfer(_address, tokensWallet, amount);
386         emit TokensReverted(_address, amount);
387 
388         return true;
389     }
390 
391     function lockAddressByKYC(address _address) public hasAddressLockupPermission returns (bool) {
392         require(released);
393         require(balances[_address] == 0 && verifiedKYCAddresses[_address]);
394 
395         verifiedKYCAddresses[_address] = false;
396         emit AddressLockedByKYC(_address);
397 
398         return true;
399     }
400 
401     function verifyKYC(address _address) public hasAddressLockupPermission returns (bool) {
402         verifiedKYCAddresses[_address] = true;
403         emit KYCVerified(_address);
404 
405         return true;
406     }
407 
408     function revertTokensByKYC(address _address) public hasAddressLockupPermission returns (bool) {
409         require(!verifiedKYCAddresses[_address] && balances[_address] > 0);
410 
411         uint256 amount = balances[_address];
412         balances[tokensWallet] = balances[tokensWallet].add(amount);
413         balances[_address] = 0;
414 
415         emit Transfer(_address, tokensWallet, amount);
416         emit TokensRevertedByKYC(_address, amount);
417 
418         return true;
419     }
420 
421     function setKYCLockupIgnoring(bool _ignoreFlag) public onlyOwner {
422         ignoreKYCLockup = _ignoreFlag;
423     }
424 
425     function release() public onlyOwner returns (bool) {
426         require(!released);
427         released = true;
428         emit Release();
429         return true;
430     }
431 
432     function getOwner() public view returns (address) {
433         return owner;
434     }
435 
436     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
437         if (released && balances[_to] == 0) {
438             verifiedKYCAddresses[_to] = true;
439         }
440 
441         if (super.transfer(_to, _value)) {
442             uint codeLength;
443             assembly {
444                 codeLength := extcodesize(_to)
445             }
446             if (codeLength > 0) {
447                 ERC223Receiver receiver = ERC223Receiver(_to);
448                 receiver.tokenFallback(msg.sender, _value, msg.data);
449             }
450 
451             return true;
452         }
453 
454         return false;
455     }
456 
457     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
458         if (released && balances[_to] == 0) {
459             verifiedKYCAddresses[_to] = true;
460         }
461 
462         if (super.transferFrom(_from, _to, _value)) {
463             uint codeLength;
464             assembly {
465                 codeLength := extcodesize(_to)
466             }
467             if (codeLength > 0) {
468                 ERC223Receiver receiver = ERC223Receiver(_to);
469                 receiver.tokenFallback(_from, _value, msg.data);
470             }
471 
472             return true;
473         }
474 
475         return false;
476     }
477 
478     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
479         return super.approve(_spender, _value);
480     }
481 
482     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
483         return super.increaseApproval(_spender, _addedValue);
484     }
485 
486     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
487         return super.decreaseApproval(_spender, _subtractedValue);
488     }
489 
490     function transferOwnership(address newOwner) public onlyOwner {
491         require(newOwner != owner);
492         require(lockedAddresses[newOwner] < now);
493         address oldOwner = owner;
494         super.transferOwnership(newOwner);
495 
496         if (oldOwner != tokensWallet) {
497             allowed[tokensWallet][oldOwner] = 0;
498             emit Approval(tokensWallet, oldOwner, 0);
499         }
500 
501         if (owner != tokensWallet) {
502             allowed[tokensWallet][owner] = balances[tokensWallet];
503             emit Approval(tokensWallet, owner, balances[tokensWallet]);
504         }
505 
506         verifiedKYCAddresses[newOwner] = true;
507         emit KYCVerified(newOwner);
508     }
509 
510     function changeTechAccountAddress(address _address) public onlyOwner {
511         require(_address != address(0) && _address != techAccount);
512         require(lockedAddresses[_address] < now);
513 
514         techAccount = _address;
515         emit SetTechAccount(techAccount);
516 
517         verifiedKYCAddresses[_address] = true;
518         emit KYCVerified(_address);
519     }
520 
521 }