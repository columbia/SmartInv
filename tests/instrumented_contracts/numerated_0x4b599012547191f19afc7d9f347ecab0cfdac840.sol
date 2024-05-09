1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title Operated
38  * @dev The Operated contract has a list of ops addresses, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Operated {
42     mapping(address => bool) private _ops;
43 
44     event OperatorChanged(
45         address indexed operator,
46         bool active
47     );
48 
49     /**
50      * @dev The Operated constructor sets the original ops account of the contract to the sender
51      * account.
52      */
53     constructor() internal {
54         _ops[msg.sender] = true;
55         emit OperatorChanged(msg.sender, true);
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the operations accounts.
60      */
61     modifier onlyOps() {
62         require(isOps(), "only operations accounts are allowed to call this function");
63         _;
64     }
65 
66     /**
67      * @return true if `msg.sender` is an operator.
68      */
69     function isOps() public view returns(bool) {
70         return _ops[msg.sender];
71     }
72 
73     /**
74      * @dev Allows the current operations accounts to give control of the contract to new accounts.
75      * @param _account The address of the new account
76      * @param _active Set active (true) or inactive (false)
77      */
78     function setOps(address _account, bool _active) public onlyOps {
79         _ops[_account] = _active;
80         emit OperatorChanged(_account, _active);
81     }
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90     address private _owner;
91 
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99      * account.
100      */
101     constructor() internal {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /**
107      * @return the address of the owner.
108      */
109     function owner() public view returns(address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner());
118         _;
119     }
120 
121     /**
122      * @return true if `msg.sender` is the owner of the contract.
123      */
124     function isOwner() public view returns(bool) {
125         return msg.sender == _owner;
126     }
127 
128     /**
129      * @dev Allows the current owner to relinquish control of the contract.
130      * @notice Renouncing to ownership will leave the contract without an owner.
131      * It will not be possible to call the functions with the `onlyOwner`
132      * modifier anymore.
133      */
134     function renounceOwnership() public onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139     /**
140      * @dev Allows the current owner to transfer control of the contract to a newOwner.
141      * @param newOwner The address to transfer ownership to.
142      */
143     function transferOwnership(address newOwner) public onlyOwner {
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers control of the contract to a newOwner.
149      * @param newOwner The address to transfer ownership to.
150      */
151     function _transferOwnership(address newOwner) internal {
152         require(newOwner != address(0));
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that revert on error
161  */
162 library SafeMath {
163 
164     /**
165     * @dev Multiplies two numbers, reverts on overflow.
166     */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b);
177 
178         return c;
179     }
180 
181     /**
182     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
183     */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b > 0); // Solidity only automatically asserts when dividing by 0
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
194     */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a);
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203     * @dev Adds two numbers, reverts on overflow.
204     */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a);
208 
209         return c;
210     }
211 
212     /**
213     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
214     * reverts when dividing by zero.
215     */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b != 0);
218         return a % b;
219     }
220 }
221 
222 /**
223  * @title WHISKY TOKEN
224  * @author WHYTOKEN GmbH
225  * @notice WHISKY TOKEN (WHY) stands for a disruptive new possibility in the crypto currency market
226  * due to the combination of High-End Whisky and Blockchain technology.
227  * WHY is a german based token, which lets everyone participate in the lucrative crypto market
228  * with minimal risk and effort through a high-end whisky portfolio as security.
229  */
230 contract WhiskyToken is IERC20, Ownable, Operated {
231     using SafeMath for uint256;
232     using SafeMath for uint64;
233 
234     // ERC20 standard variables
235     string public name = "Whisky Token";
236     string public symbol = "WHY";
237     uint8 public decimals = 18;
238     uint256 public initialSupply = 28100000 * (10 ** uint256(decimals));
239     uint256 public totalSupply;
240 
241     // Address of the ICO contract
242     address public crowdSaleContract;
243 
244     // The asset value of the whisky in EUR cents
245     uint64 public assetValue;
246 
247     // Fee to charge on every transfer (e.g. 15 is 1,5%)
248     uint64 public feeCharge;
249 
250     // Global freeze of all transfers
251     bool public freezeTransfer;
252 
253     // Flag to make all token available
254     bool private tokenAvailable;
255 
256     // Maximum value for feeCharge
257     uint64 private constant feeChargeMax = 20;
258 
259     // Address of the account/wallet which should receive the fees
260     address private feeReceiver;
261 
262     // Mappings of addresses for balances, allowances and frozen accounts
263     mapping(address => uint256) internal balances;
264     mapping(address => mapping (address => uint256)) internal allowed;
265     mapping(address => bool) public frozenAccount;
266 
267     // Event definitions
268     event Fee(address indexed payer, uint256 fee);
269     event FeeCharge(uint64 oldValue, uint64 newValue);
270     event AssetValue(uint64 oldValue, uint64 newValue);
271     event Burn(address indexed burner, uint256 value);
272     event FrozenFunds(address indexed target, bool frozen);
273     event FreezeTransfer(bool frozen);
274 
275     // Constructor which gets called once on contract deployment
276     constructor(address _tokenOwner) public {
277         transferOwnership(_tokenOwner);
278         setOps(_tokenOwner, true);
279         crowdSaleContract = msg.sender;
280         feeReceiver = _tokenOwner;
281         totalSupply = initialSupply;
282         balances[msg.sender] = initialSupply;
283         assetValue = 0;
284         feeCharge = 15;
285         freezeTransfer = true;
286         tokenAvailable = true;
287     }
288 
289     /**
290      * @notice Returns the total supply of tokens.
291      * @dev The total supply is the amount of tokens which are currently in circulation.
292      * @return Amount of tokens in Sip.
293      */
294     function totalSupply() public view returns (uint256) {
295         return totalSupply;
296     }
297 
298     /**
299      * @notice Gets the balance of the specified address.
300      * @dev Gets the balance of the specified address.
301      * @param _owner The address to query the the balance of.
302      * @return An uint256 representing the amount of tokens owned by the passed address.
303      */
304     function balanceOf(address _owner) public view returns (uint256 balance) {
305         if (!tokenAvailable) {
306             return 0;
307         }
308         return balances[_owner];
309     }
310 
311     /**
312      * @dev Internal transfer, can only be called by this contract.
313      * Will throw an exception to rollback the transaction if anything is wrong.
314      * @param _from The address from which the tokens should be transfered from.
315      * @param _to The address to which the tokens should be transfered to.
316      * @param _value The amount of tokens which should be transfered in Sip.
317      */
318     function _transfer(address _from, address _to, uint256 _value) internal {
319         require(_to != address(0), "zero address is not allowed");
320         require(_value >= 1000, "must transfer more than 1000 sip");
321         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
322         require(!frozenAccount[_from], "sender address is frozen");
323         require(!frozenAccount[_to], "receiver address is frozen");
324 
325         uint256 transferValue = _value;
326         if (msg.sender != owner() && msg.sender != crowdSaleContract) {
327             uint256 fee = _value.div(1000).mul(feeCharge);
328             transferValue = _value.sub(fee);
329             balances[feeReceiver] = balances[feeReceiver].add(fee);
330             emit Fee(msg.sender, fee);
331             emit Transfer(_from, feeReceiver, fee);
332         }
333 
334         // SafeMath.sub will throw if there is not enough balance.
335         balances[_from] = balances[_from].sub(_value);
336         balances[_to] = balances[_to].add(transferValue);
337         if (tokenAvailable) {
338             emit Transfer(_from, _to, transferValue);
339         }
340     }
341 
342     /**
343      * @notice Transfer tokens to a specified address. The message sender has to pay the fee.
344      * @dev Calls _transfer with message sender address as _from parameter.
345      * @param _to The address to transfer to.
346      * @param _value The amount to be transferred in Sip.
347      * @return Indicates if the transfer was successful.
348      */
349     function transfer(address _to, uint256 _value) public returns (bool) {
350         _transfer(msg.sender, _to, _value);
351         return true;
352     }
353 
354     /**
355      * @notice Transfer tokens from one address to another. The message sender has to pay the fee.
356      * @dev Calls _transfer with the addresses provided by the transactor.
357      * @param _from The address which you want to send tokens from.
358      * @param _to The address which you want to transfer to.
359      * @param _value The amount of tokens to be transferred in Sip.
360      * @return Indicates if the transfer was successful.
361      */
362     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
363         require(_value <= allowed[_from][msg.sender], "requesting more token than allowed");
364 
365         _transfer(_from, _to, _value);
366         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367         return true;
368     }
369 
370     /**
371      * @notice Approve the passed address to spend the specified amount of tokens on behalf of the transactor.
372      * @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
373      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
374      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
375      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376      * @param _spender The address which is allowed to retrieve the tokens.
377      * @param _value The amount of tokens to be spent in Sip.
378      * @return Indicates if the approval was successful.
379      */
380     function approve(address _spender, uint256 _value) public returns (bool) {
381         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
382         require(_spender != address(0), "zero address is not allowed");
383         require(_value >= 1000, "must approve more than 1000 sip");
384 
385         allowed[msg.sender][_spender] = _value;
386         emit Approval(msg.sender, _spender, _value);
387         return true;
388     }
389 
390     /**
391      * @notice Returns the amount of tokens that the owner allowed to the spender.
392      * @dev Function to check the amount of tokens that an owner allowed to a spender.
393      * @param _owner The address which owns the tokens.
394      * @param _spender The address which is allowed to retrieve the tokens.
395      * @return The amount of tokens still available for the spender in Sip.
396      */
397     function allowance(address _owner, address _spender) public view returns (uint256) {
398         return allowed[_owner][_spender];
399     }
400 
401     /**
402      * @notice Increase the amount of tokens that an owner allowed to a spender.
403      * @dev Approve should be called when allowed[_spender] == 0. To increment
404      * allowed value is better to use this function to avoid 2 calls (and wait until
405      * the first transaction is mined)
406      * From MonolithDAO Token.sol
407      * @param _spender The address which is allowed to retrieve the tokens.
408      * @param _addedValue The amount of tokens to increase the allowance by in Sip.
409      * @return Indicates if the approval was successful.
410      */
411     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
412         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
413         require(_spender != address(0), "zero address is not allowed");
414         require(_addedValue >= 1000, "must approve more than 1000 sip");
415         
416         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
417         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418         return true;
419     }
420 
421     /**
422      * @notice Decrease the amount of tokens that an owner allowed to a spender. 
423      * @dev Approve should be called when allowed[_spender] == 0. To decrement
424      * allowed value is better to use this function to avoid 2 calls (and wait until
425      * the first transaction is mined)
426      * From MonolithDAO Token.sol
427      * @param _spender The address which is allowed to retrieve the tokens.
428      * @param _subtractedValue The amount of tokens to decrease the allowance by in Sip.
429      * @return Indicates if the approval was successful.
430      */
431     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
432         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
433         require(_spender != address(0), "zero address is not allowed");
434         require(_subtractedValue >= 1000, "must approve more than 1000 sip");
435 
436         uint256 oldValue = allowed[msg.sender][_spender];
437         if (_subtractedValue > oldValue) {
438             allowed[msg.sender][_spender] = 0;
439         } else {
440             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
441         }
442         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
443         return true;
444     } 
445 
446     /**
447      * @notice Burns a specific amount of tokens.
448      * @dev Tokens get technically destroyed by this function and are therefore no longer in circulation afterwards.
449      * @param _value The amount of token to be burned in Sip.
450      */
451     function burn(uint256 _value) public {
452         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
453         require(_value <= balances[msg.sender], "address has not enough token to burn");
454         address burner = msg.sender;
455         balances[burner] = balances[burner].sub(_value);
456         totalSupply = totalSupply.sub(_value);
457         emit Burn(burner, _value);
458         emit Transfer(burner, address(0), _value);
459     }
460 
461     /**
462      * @notice Not for public use!
463      * @dev Modifies the assetValue which represents the monetized value (in EUR) of the whisky baking the token.
464      * @param _value The new value of the asset in EUR cents.
465      */
466     function setAssetValue(uint64 _value) public onlyOwner {
467         uint64 oldValue = assetValue;
468         assetValue = _value;
469         emit AssetValue(oldValue, _value);
470     }
471 
472     /**
473      * @notice Not for public use!
474      * @dev Modifies the feeCharge which calculates the fee for each transaction.
475      * @param _value The new value of the feeCharge as fraction of 1000 (e.g. 15 is 1,5%).
476      */
477     function setFeeCharge(uint64 _value) public onlyOwner {
478         require(_value <= feeChargeMax, "can not increase fee charge over it's limit");
479         uint64 oldValue = feeCharge;
480         feeCharge = _value;
481         emit FeeCharge(oldValue, _value);
482     }
483 
484 
485     /**
486      * @notice Not for public use!
487      * @dev Prevents/Allows target from sending & receiving tokens.
488      * @param _target Address to be frozen.
489      * @param _freeze Either to freeze or unfreeze it.
490      */
491     function freezeAccount(address _target, bool _freeze) public onlyOwner {
492         require(_target != address(0), "zero address is not allowed");
493 
494         frozenAccount[_target] = _freeze;
495         emit FrozenFunds(_target, _freeze);
496     }
497 
498     /**
499      * @notice Not for public use!
500      * @dev Globally freeze all transfers for the token.
501      * @param _freeze Freeze or unfreeze every transfer.
502      */
503     function setFreezeTransfer(bool _freeze) public onlyOwner {
504         freezeTransfer = _freeze;
505         emit FreezeTransfer(_freeze);
506     }
507 
508     /**
509      * @notice Not for public use!
510      * @dev Allows the owner to set the address which receives the fees.
511      * @param _feeReceiver the address which should receive fees.
512      */
513     function setFeeReceiver(address _feeReceiver) public onlyOwner {
514         require(_feeReceiver != address(0), "zero address is not allowed");
515         feeReceiver = _feeReceiver;
516     }
517 
518     /**
519      * @notice Not for public use!
520      * @dev Make all tokens available for ERC20 wallets.
521      * @param _available Activate or deactivate all tokens
522      */
523     function setTokenAvailable(bool _available) public onlyOwner {
524         tokenAvailable = _available;
525     }
526 }