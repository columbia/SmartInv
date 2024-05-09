1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  * https://github.com/OpenZeppelin/zeppelin-solidity/
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  * https://github.com/OpenZeppelin/zeppelin-solidity/
23  */
24 contract Ownable {
25   address public owner;                                                     // Operational owner.
26   address public masterOwner = 0xe4925C73851490401b858B657F26E62e9aD20F66;  // for ownership transfer segregation of duty, hard coded to wallet account
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public {
54     require(newOwner != address(0));
55     require(masterOwner == msg.sender); // only master owner can initiate change to ownership
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  * https://github.com/OpenZeppelin/zeppelin-solidity/
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 
104   function cei(uint256 a, uint256 b) internal pure returns (uint256) {
105     return ((a + b - 1) / b) * b;
106   }
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  */
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 
147 
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  * https://github.com/OpenZeppelin/zeppelin-solidity/
154  */
155 contract ERC20 is ERC20Basic {
156   function allowance(address owner, address spender) public view returns (uint256);
157   function transferFrom(address from, address to, uint256 value) public returns (bool);
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 /** This interfaces will be implemented by different VZT contracts in future*/
260 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
261 
262 contract VZToken is StandardToken, Ownable {
263 
264 
265     /* metadata */
266 
267     string public constant name = "VectorZilla Token"; // solium-disable-line uppercase
268     string public constant symbol = "VZT"; // solium-disable-line uppercase
269     string public constant version = "1.0"; // solium-disable-line uppercase
270     uint8 public constant decimals = 18; // solium-disable-line uppercase
271 
272     /* all accounts in wei */
273 
274     uint256 public constant INITIAL_SUPPLY = 100000000 * 10 ** 18; //intial total supply
275     uint256 public constant BURNABLE_UP_TO =  90000000 * 10 ** 18; //burnable up to 90% (90 million) of total supply
276     uint256 public constant VECTORZILLA_RESERVE_VZT = 25000000 * 10 ** 18; //25 million - reserved tokens
277 
278     // Reserved tokens will be sent to this address. this address will be replaced on production:
279     address public constant VECTORZILLA_RESERVE = 0xF63e65c57024886cCa65985ca6E2FB38df95dA11;
280 
281     // - tokenSaleContract receives the whole balance for distribution
282     address public tokenSaleContract;
283 
284     /* Following stuff is to manage regulatory hurdles on who can and cannot use VZT token  */
285     mapping (address => bool) public frozenAccount;
286     event FrozenFunds(address target, bool frozen);
287 
288 
289     /** Modifiers to be used all over the place **/
290 
291     modifier onlyOwnerAndContract() {
292         require(msg.sender == owner || msg.sender == tokenSaleContract);
293         _;
294     }
295 
296 
297     modifier onlyWhenValidAddress( address _addr ) {
298         require(_addr != address(0x0));
299         _;
300     }
301 
302     modifier onlyWhenValidContractAddress(address _addr) {
303         require(_addr != address(0x0));
304         require(_addr != address(this));
305         require(isContract(_addr));
306         _;
307     }
308 
309     modifier onlyWhenBurnable(uint256 _value) {
310         require(totalSupply - _value >= INITIAL_SUPPLY - BURNABLE_UP_TO);
311         _;
312     }
313 
314     modifier onlyWhenNotFrozen(address _addr) {
315         require(!frozenAccount[_addr]);
316         _;
317     }
318 
319     /** End of Modifier Definations */
320 
321     /** Events */
322 
323     event Burn(address indexed burner, uint256 value);
324     event Finalized();
325     //log event whenever withdrawal from this contract address happens
326     event Withdraw(address indexed from, address indexed to, uint256 value);
327 
328     /*
329         Contructor that distributes initial supply between
330         owner and vzt reserve.
331     */
332     function VZToken(address _owner) public {
333         require(_owner != address(0));
334         totalSupply = INITIAL_SUPPLY;
335         balances[_owner] = INITIAL_SUPPLY - VECTORZILLA_RESERVE_VZT; //75 millions tokens
336         balances[VECTORZILLA_RESERVE] = VECTORZILLA_RESERVE_VZT; //25 millions
337         owner = _owner;
338     }
339 
340     /*
341         This unnamed function is called whenever the owner send Ether to fund the gas
342         fees and gas reimbursement.
343     */
344     function () payable public onlyOwner {}
345 
346     /**
347      * @dev transfer `_value` token for a specified address
348      * @param _to The address to transfer to.
349      * @param _value The amount to be transferred.
350      */
351     function transfer(address _to, uint256 _value) 
352         public
353         onlyWhenValidAddress(_to)
354         onlyWhenNotFrozen(msg.sender)
355         onlyWhenNotFrozen(_to)
356         returns(bool) {
357         return super.transfer(_to, _value);
358     }
359 
360     /**
361      * @dev Transfer `_value` tokens from one address (`_from`) to another (`_to`)
362      * @param _from address The address which you want to send tokens from
363      * @param _to address The address which you want to transfer to
364      * @param _value uint256 the amount of tokens to be transferred
365      */
366     function transferFrom(address _from, address _to, uint256 _value) 
367         public
368         onlyWhenValidAddress(_to)
369         onlyWhenValidAddress(_from)
370         onlyWhenNotFrozen(_from)
371         onlyWhenNotFrozen(_to)
372         returns(bool) {
373         return super.transferFrom(_from, _to, _value);
374     }
375 
376     /**
377      * @dev Burns a specific (`_value`) amount of tokens.
378      * @param _value uint256 The amount of token to be burned.
379      */
380     function burn(uint256 _value)
381         public
382         onlyWhenBurnable(_value)
383         onlyWhenNotFrozen(msg.sender)
384         returns (bool) {
385         require(_value <= balances[msg.sender]);
386       // no need to require value <= totalSupply, since that would imply the
387       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
388         address burner = msg.sender;
389         balances[burner] = balances[burner].sub(_value);
390         totalSupply = totalSupply.sub(_value);
391         Burn(burner, _value);
392         Transfer(burner, address(0x0), _value);
393         return true;
394       }
395 
396     /**
397      * Destroy tokens from other account
398      *
399      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
400      *
401      * @param _from the address of the sender
402      * @param _value the amount of money to burn
403      */
404     function burnFrom(address _from, uint256 _value) 
405         public
406         onlyWhenBurnable(_value)
407         onlyWhenNotFrozen(_from)
408         onlyWhenNotFrozen(msg.sender)
409         returns (bool success) {
410         assert(transferFrom( _from, msg.sender, _value ));
411         return burn(_value);
412     }
413 
414     /**
415      * Set allowance for other address and notify
416      *
417      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
418      *
419      * @param _spender The address authorized to spend
420      * @param _value the max amount they can spend
421      * @param _extraData some extra information to send to the approved contract
422      */
423     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
424         public
425         onlyWhenValidAddress(_spender)
426         returns (bool success) {
427         tokenRecipient spender = tokenRecipient(_spender);
428         if (approve(_spender, _value)) {
429             spender.receiveApproval(msg.sender, _value, this, _extraData);
430             return true;
431         }
432     }
433 
434     /**
435      * Freezes account and disables transfers/burning
436      *  This is to manage regulatory hurdlers where contract owner is required to freeze some accounts.
437      */
438     function freezeAccount(address target, bool freeze) external onlyOwner {
439         frozenAccount[target] = freeze;
440         FrozenFunds(target, freeze);
441     }
442 
443     /* Owner withdrawal of an ether deposited from Token ether balance */
444     function withdrawToOwner(uint256 weiAmt) public onlyOwner {
445         // do not allow zero transfer
446         require(weiAmt > 0);
447         owner.transfer(weiAmt);
448         // signal the event for communication only it is meaningful
449         Withdraw(this, msg.sender, weiAmt);
450     }
451 
452 
453     /// @notice This method can be used by the controller to extract mistakenly
454     ///  sent tokens to this contract.
455     /// @param _token The address of the token contract that you want to recover
456     ///  set to 0 in case you want to extract ether.
457     function claimTokens(address _token) external onlyOwner {
458         if (_token == 0x0) {
459             owner.transfer(this.balance);
460             return;
461         }
462         StandardToken token = StandardToken(_token);
463         uint balance = token.balanceOf(this);
464         token.transfer(owner, balance);
465         // signal the event for communication only it is meaningful
466         Withdraw(this, owner, balance);
467     }
468 
469     function setTokenSaleContract(address _tokenSaleContract)
470         external
471         onlyWhenValidContractAddress(_tokenSaleContract)
472         onlyOwner {
473            require(_tokenSaleContract != tokenSaleContract);
474            tokenSaleContract = _tokenSaleContract;
475     }
476 
477     /// @dev Internal function to determine if an address is a contract
478     /// @param _addr address The address being queried
479     /// @return True if `_addr` is a contract
480     function isContract(address _addr) constant internal returns(bool) {
481         if (_addr == 0) {
482             return false;
483         }
484         uint256 size;
485         assembly {
486             size: = extcodesize(_addr)
487         }
488         return (size > 0);
489     }
490 
491     /**
492      * @dev Function to send `_value` tokens to user (`_to`) from sale contract/owner
493      * @param _to address The address that will receive the minted tokens.
494      * @param _value uint256 The amount of tokens to be sent.
495      * @return True if the operation was successful.
496      */
497     function sendToken(address _to, uint256 _value)
498         public
499         onlyWhenValidAddress(_to)
500         onlyOwnerAndContract
501         returns(bool) {
502         address _from = owner;
503         // Check if the sender has enough
504         require(balances[_from] >= _value);
505         // Check for overflows
506         require(balances[_to] + _value > balances[_to]);
507         // Save this for an assertion in the future
508         uint256 previousBalances = balances[_from] + balances[_to];
509         // Subtract from the sender
510         balances[_from] -= _value;
511         // Add the same to the recipient
512         balances[_to] += _value;
513         Transfer(_from, _to, _value);
514         // Asserts are used to use static analysis to find bugs in your code. They should never fail
515         assert(balances[_from] + balances[_to] == previousBalances);
516         return true;
517     }
518     /**
519      * @dev Batch transfer of tokens to addresses from owner's balance
520      * @param addresses address[] The address that will receive the minted tokens.
521      * @param _values uint256[] The amount of tokens to be sent.
522      * @return True if the operation was successful.
523      */
524     function batchSendTokens(address[] addresses, uint256[] _values) 
525         public onlyOwnerAndContract
526         returns (bool) {
527         require(addresses.length == _values.length);
528         require(addresses.length <= 20); //only batches of 20 allowed
529         uint i = 0;
530         uint len = addresses.length;
531         for (;i < len; i++) {
532             sendToken(addresses[i], _values[i]);
533         }
534         return true;
535     }
536 }