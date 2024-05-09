1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipRenounced(address indexed previousOwner);
63     event OwnershipTransferred(
64         address indexed previousOwner,
65         address indexed newOwner
66     );
67 
68 
69     /**
70      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71      * account.
72      */
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param _newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address _newOwner) public onlyOwner {
90         _transferOwnership(_newOwner);
91     }
92 
93     /**
94      * @dev Transfers control of the contract to a newOwner.
95      * @param _newOwner The address to transfer ownership to.
96      */
97     function _transferOwnership(address _newOwner) internal {
98         require(_newOwner != address(0));
99         emit OwnershipTransferred(owner, _newOwner);
100         owner = _newOwner;
101     }
102 }
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110     function totalSupply() public view returns (uint256);
111     function balanceOf(address who) public view returns (uint256);
112     function transfer(address to, uint256 value) public returns (bool);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121     function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124     function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127     function approve(address spender, uint256 value) public returns (bool);
128     event Approval(
129         address indexed owner,
130         address indexed spender,
131         uint256 value
132     );
133 }
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140     using SafeMath for uint256;
141 
142     mapping(address => uint256) balances;
143 
144     uint256 totalSupply_;
145 
146     /**
147     * @dev Total number of tokens in existence
148     */
149     function totalSupply() public view returns (uint256) {
150         return totalSupply_;
151     }
152 
153     /**
154     * @dev Transfer token for a specified address
155     * @param _to The address to transfer to.
156     * @param _value The amount to be transferred.
157     */
158     function transfer(address _to, uint256 _value) public returns (bool) {
159         require(_to != address(0));
160         require(_value <= balances[msg.sender]);
161 
162         balances[msg.sender] = balances[msg.sender].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         emit Transfer(msg.sender, _to, _value);
165         return true;
166     }
167 
168     /**
169     * @dev Gets the balance of the specified address.
170     * @param _owner The address to query the the balance of.
171     * @return An uint256 representing the amount owned by the passed address.
172     */
173     function balanceOf(address _owner) public view returns (uint256) {
174         return balances[_owner];
175     }
176 
177 }
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * @dev https://github.com/ethereum/EIPs/issues/20
184  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188     mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191     /**
192      * @dev Transfer tokens from one address to another
193      * @param _from address The address which you want to send tokens from
194      * @param _to address The address which you want to transfer to
195      * @param _value uint256 the amount of tokens to be transferred
196      */
197     function transferFrom(
198         address _from,
199         address _to,
200         uint256 _value
201     )
202     public
203     returns (bool)
204     {
205         require(_to != address(0));
206         require(_value <= balances[_from]);
207         require(_value <= allowed[_from][msg.sender]);
208 
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      *
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param _spender The address which will spend the funds.
224      * @param _value The amount of tokens to be spent.
225      */
226     function approve(address _spender, uint256 _value) public returns (bool) {
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     /**
233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
234      * @param _owner address The address which owns the funds.
235      * @param _spender address The address which will spend the funds.
236      * @return A uint256 specifying the amount of tokens still available for the spender.
237      */
238     function allowance(
239         address _owner,
240         address _spender
241     )
242     public
243     view
244     returns (uint256)
245     {
246         return allowed[_owner][_spender];
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      *
252      * approve should be called when allowed[_spender] == 0. To increment
253      * allowed value is better to use this function to avoid 2 calls (and wait until
254      * the first transaction is mined)
255      * From MonolithDAO Token.sol
256      * @param _spender The address which will spend the funds.
257      * @param _addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseApproval(
260         address _spender,
261         uint _addedValue
262     )
263     public
264     returns (bool)
265     {
266         allowed[msg.sender][_spender] = (
267         allowed[msg.sender][_spender].add(_addedValue));
268         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269         return true;
270     }
271 
272     /**
273      * @dev Decrease the amount of tokens that an owner allowed to a spender.
274      *
275      * approve should be called when allowed[_spender] == 0. To decrement
276      * allowed value is better to use this function to avoid 2 calls (and wait until
277      * the first transaction is mined)
278      * From MonolithDAO Token.sol
279      * @param _spender The address which will spend the funds.
280      * @param _subtractedValue The amount of tokens to decrease the allowance by.
281      */
282     function decreaseApproval(
283         address _spender,
284         uint _subtractedValue
285     )
286     public
287     returns (bool)
288     {
289         uint oldValue = allowed[msg.sender][_spender];
290         if (_subtractedValue > oldValue) {
291             allowed[msg.sender][_spender] = 0;
292         } else {
293             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294         }
295         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296         return true;
297     }
298 
299 }
300 
301 /**
302  * @title Burnable Token
303  * @dev Token that can be irreversibly burned (destroyed).
304  */
305 contract BurnableToken is BasicToken {
306 
307     event Burn(address indexed burner, uint256 value);
308 
309     /**
310      * @dev Burns a specific amount of tokens.
311      * @param _value The amount of token to be burned.
312      */
313     function burn(uint256 _value) public {
314         _burn(msg.sender, _value);
315     }
316 
317     function _burn(address _who, uint256 _value) internal {
318         require(_value <= balances[_who]);
319         // no need to require value <= totalSupply, since that would imply the
320         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
321 
322         balances[_who] = balances[_who].sub(_value);
323         totalSupply_ = totalSupply_.sub(_value);
324         emit Burn(_who, _value);
325         emit Transfer(_who, address(0), _value);
326     }
327 }
328 
329 contract WellToken is StandardToken, BurnableToken, Ownable {
330     using SafeMath for uint256;
331 
332     event Mint(address indexed to, uint256 amount);
333     event Release();
334     event AddressLocked(address indexed _address, uint256 _time);
335     event AddressLockedByKYC(address indexed _address);
336     event KYCVerified(address indexed _address);
337     event TokensRevertedByKYC(address indexed _address, uint256 _amount);
338     event SetTechAccount(address indexed _address);
339 
340     string public constant name = "WELL Token";
341 
342     string public constant symbol = "WELL";
343 
344     string public constant standard = "ERC20";
345 
346     uint256 public constant decimals = 18;
347 
348     uint256 public constant TOKENS_MAXIMUM_SUPPLY = 1500000000 * (10 ** decimals);
349 
350     bool public released = false;
351 
352     address public tokensWallet;
353     address public mintingOracle;
354     address public techAccount;
355 
356     mapping(address => uint) public lockedAddresses;
357     mapping(address => bool) public verifiedKYCAddresses;
358 
359     modifier isReleased() {
360         require(released || msg.sender == tokensWallet || msg.sender == owner || msg.sender == techAccount);
361         require(lockedAddresses[msg.sender] <= now);
362         require(verifiedKYCAddresses[msg.sender]);
363         _;
364     }
365 
366     modifier hasAddressLockupPermission() {
367         require(msg.sender == owner || msg.sender == techAccount);
368         _;
369     }
370 
371     modifier hasMintPermission() {
372         require(msg.sender == mintingOracle);
373         _;
374     }
375 
376     constructor() public {
377         owner = 0x6c2386fFf587539484c9d65628df7301A4a7Fc10;
378         mintingOracle = owner;
379         tokensWallet = owner;
380         verifiedKYCAddresses[owner] = true;
381 
382         techAccount = 0x41D621De050A551F5f0eBb83D1332C75339B61E4;
383         verifiedKYCAddresses[techAccount] = true;
384         emit SetTechAccount(techAccount);
385 
386         balances[tokensWallet] = totalSupply_;
387         emit Transfer(0x0, tokensWallet, totalSupply_);
388     }
389 
390     function lockAddress(address _address, uint256 _time) public hasAddressLockupPermission returns (bool) {
391         require(_address != owner && _address != tokensWallet && _address != techAccount);
392         require(balances[_address] == 0 && lockedAddresses[_address] == 0 && _time > now);
393         lockedAddresses[_address] = _time;
394 
395         emit AddressLocked(_address, _time);
396         return true;
397     }
398 
399     function lockAddressByKYC(address _address) public hasAddressLockupPermission returns (bool) {
400         require(released);
401         require(balances[_address] == 0 && verifiedKYCAddresses[_address]);
402 
403         verifiedKYCAddresses[_address] = false;
404         emit AddressLockedByKYC(_address);
405 
406         return true;
407     }
408 
409     function verifyKYC(address _address) public hasAddressLockupPermission returns (bool) {
410         verifiedKYCAddresses[_address] = true;
411         emit KYCVerified(_address);
412 
413         return true;
414     }
415 
416     function revertTokensByKYC(address _address) public hasAddressLockupPermission returns (bool) {
417         require(!verifiedKYCAddresses[_address] && balances[_address] > 0);
418 
419         uint256 amount = balances[_address];
420         balances[tokensWallet] = balances[tokensWallet].add(amount);
421         balances[_address] = 0;
422 
423         emit Transfer(_address, tokensWallet, amount);
424         emit TokensRevertedByKYC(_address, amount);
425 
426         return true;
427     }
428 
429     function release() public onlyOwner returns (bool) {
430         require(!released);
431         released = true;
432         emit Release();
433         return true;
434     }
435 
436     function getOwner() public view returns (address) {
437         return owner;
438     }
439 
440     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
441         if (released) {
442             verifiedKYCAddresses[_to] = true;
443         }
444 
445         return super.transfer(_to, _value);
446     }
447 
448     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
449         if (released) {
450             verifiedKYCAddresses[_to] = true;
451         }
452 
453         return super.transferFrom(_from, _to, _value);
454     }
455 
456     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
457         return super.approve(_spender, _value);
458     }
459 
460     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
461         return super.increaseApproval(_spender, _addedValue);
462     }
463 
464     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
465         return super.decreaseApproval(_spender, _subtractedValue);
466     }
467 
468     function transferOwnership(address newOwner) public onlyOwner {
469         require(newOwner != owner);
470         require(lockedAddresses[newOwner] < now);
471         address oldOwner = owner;
472         super.transferOwnership(newOwner);
473 
474         if (oldOwner != tokensWallet) {
475             allowed[tokensWallet][oldOwner] = 0;
476             emit Approval(tokensWallet, oldOwner, 0);
477         }
478 
479         if (owner != tokensWallet) {
480             allowed[tokensWallet][owner] = balances[tokensWallet];
481             emit Approval(tokensWallet, owner, balances[tokensWallet]);
482         }
483 
484         verifiedKYCAddresses[newOwner] = true;
485         emit KYCVerified(newOwner);
486     }
487 
488     function changeTechAccountAddress(address _address) public onlyOwner {
489         require(_address != address(0) && _address != techAccount);
490         require(lockedAddresses[_address] < now);
491 
492         techAccount = _address;
493         emit SetTechAccount(techAccount);
494 
495         verifiedKYCAddresses[_address] = true;
496         emit KYCVerified(_address);
497     }
498 
499     function mint(
500         address _to,
501         uint256 _amount
502     )
503     public
504     hasMintPermission
505     returns (bool)
506     {
507         totalSupply_ = totalSupply_.add(_amount);
508         require(totalSupply_ > 0);
509         require(totalSupply_ <= TOKENS_MAXIMUM_SUPPLY);
510 
511         balances[_to] = balances[_to].add(_amount);
512         emit Mint(_to, _amount);
513         emit Transfer(address(0), _to, _amount);
514 
515         return true;
516     }
517 
518     function setMintingOracle(address _address) public hasMintPermission {
519         require(_address != address(0) && _address != mintingOracle);
520 
521         mintingOracle = _address;
522     }
523 
524 }