1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title SimpleToken
216  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
217  * Note they can later distribute these tokens as they wish using `transfer` and other
218  * `StandardToken` functions.
219  */
220 contract FIN is StandardToken {
221   string public constant name = "Financial Incentive Network Points";
222   string public constant symbol = "FIN";
223   uint8 public constant decimals = 18; // solium-disable-line uppercase
224 
225   uint256 private constant OFFSET = 10 ** uint256(decimals);
226   uint256 private constant BILLION = (10 ** 9) * OFFSET; // 1 billion is a 1 followed by 9 zeroes
227   
228   uint256 private TOTAL_SUPPLY;
229 
230   constructor(address _holderA, address _holderB, address _holderC) public {
231     balances[_holderA] = BILLION;
232     emit Transfer(0x0, _holderA, BILLION);
233 
234     balances[_holderB] = BILLION;
235     emit Transfer(0x0, _holderB, BILLION);
236 
237     balances[_holderC] = BILLION / 2;
238     emit Transfer(0x0, _holderC, BILLION / 2);
239     
240     TOTAL_SUPPLY = balances[_holderA] + balances[_holderB] + balances[_holderC];
241   }
242   
243   function totalSupply() public view returns (uint256) {
244       return TOTAL_SUPPLY;
245   }
246 }
247 
248 
249 interface TokenValidator {
250   function check(
251     address _token,
252     address _user
253   ) external returns(byte result);
254 
255   function check(
256     address _token,
257     address _from,
258     address _to,
259     uint256 _amount
260   ) external returns (byte result);
261 }
262 
263 
264 interface ValidatedToken {
265   event Validation(
266     byte    indexed result,
267     address indexed user
268   );
269 
270   event Validation(
271     byte    indexed result,
272     address indexed from,
273     address indexed to,
274     uint256         value
275   );
276 }
277 
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291 
292   /**
293    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
294    * account.
295    */
296   function Ownable() public {
297     owner = msg.sender;
298   }
299 
300   /**
301    * @dev Throws if called by any account other than the owner.
302    */
303   modifier onlyOwner() {
304     require(msg.sender == owner);
305     _;
306   }
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param newOwner The address to transfer ownership to.
311    */
312   function transferOwnership(address newOwner) public onlyOwner {
313     require(newOwner != address(0));
314     OwnershipTransferred(owner, newOwner);
315     owner = newOwner;
316   }
317 
318 }
319 
320 
321 contract ReferenceToken is Ownable, ERC20, ValidatedToken {
322     using SafeMath for uint256;
323 
324     string internal mName;
325     string internal mSymbol;
326 
327     uint256 internal mGranularity;
328     uint256 internal mTotalSupply;
329 
330     mapping(address => uint) internal mBalances;
331     mapping(address => mapping(address => bool)) internal mAuthorized;
332     mapping(address => mapping(address => uint256)) internal mAllowed;
333 
334     uint8 public decimals = 18;
335 
336     // Single validator
337     TokenValidator internal validator;
338 
339     constructor(
340         string         _name,
341         string         _symbol,
342         uint256        _granularity,
343         TokenValidator _validator
344     ) public {
345         require(_granularity >= 1);
346 
347         mName = _name;
348         mSymbol = _symbol;
349         mTotalSupply = 0;
350         mGranularity = _granularity;
351         validator = TokenValidator(_validator);
352     }
353 
354     // Validation Helpers
355 
356     function validate(address _user) internal returns (byte) {
357         byte checkResult = validator.check(this, _user);
358         emit Validation(checkResult, _user);
359         return checkResult;
360     }
361 
362     function validate(
363         address _from,
364         address _to,
365         uint256 _amount
366     ) internal returns (byte) {
367         byte checkResult = validator.check(this, _from, _to, _amount);
368         emit Validation(checkResult, _from, _to, _amount);
369         return checkResult;
370     }
371 
372     // Status Code Helpers
373 
374     function isOk(byte _statusCode) internal pure returns (bool) {
375         return (_statusCode & hex"0F") == 1;
376     }
377 
378     function requireOk(byte _statusCode) internal pure {
379         require(isOk(_statusCode));
380     }
381 
382     function name() public constant returns (string) {
383         return mName;
384     }
385 
386     function symbol() public constant returns(string) {
387         return mSymbol;
388     }
389 
390     function granularity() public constant returns(uint256) {
391         return mGranularity;
392     }
393 
394     function totalSupply() public constant returns(uint256) {
395         return mTotalSupply;
396     }
397 
398     function balanceOf(address _tokenHolder) public constant returns (uint256) {
399         return mBalances[_tokenHolder];
400     }
401 
402     function isMultiple(uint256 _amount) internal view returns (bool) {
403       return _amount.div(mGranularity).mul(mGranularity) == _amount;
404     }
405 
406     function approve(address _spender, uint256 _amount) public returns (bool success) {
407         if(validate(msg.sender, _spender, _amount) != 1) { return false; }
408 
409         mAllowed[msg.sender][_spender] = _amount;
410         emit Approval(msg.sender, _spender, _amount);
411         return true;
412     }
413 
414     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
415         return mAllowed[_owner][_spender];
416     }
417 
418     function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
419         requireOk(validate(_tokenHolder));
420         require(isMultiple(_amount));
421 
422         mTotalSupply = mTotalSupply.add(_amount);
423         mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);
424 
425         emit Transfer(0x0, _tokenHolder, _amount);
426     }
427 
428     function transfer(address _to, uint256 _amount) public returns (bool success) {
429         doSend(msg.sender, _to, _amount);
430         return true;
431     }
432 
433     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
434         require(_amount <= mAllowed[_from][msg.sender]);
435 
436         mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
437         doSend(_from, _to, _amount);
438         return true;
439     }
440 
441     function doSend(
442         address _from,
443         address _to,
444         uint256 _amount
445     ) internal {
446         require(canTransfer(_from, _to, _amount));
447 
448         mBalances[_from] = mBalances[_from].sub(_amount);
449         mBalances[_to] = mBalances[_to].add(_amount);
450 
451         emit Transfer(_from, _to, _amount);
452     }
453 
454     function canTransfer(
455         address _from,
456         address _to,
457         uint256 _amount
458     ) internal returns (bool) {
459         return (
460             (_to != address(0)) // Forbid sending to 0x0 (=burning)
461             && isMultiple(_amount)
462             && (mBalances[_from] >= _amount) // Ensure enough funds
463             && isOk(validate(_from, _to, _amount)) // Ensure passes validation
464         );
465     }
466 }
467 
468 
469 contract Lunar is ReferenceToken {
470     constructor(TokenValidator _validator)
471       ReferenceToken("Lunar Token - SAMPLE NO VALUE", "LNRX", 1, _validator)
472       public {
473           uint256 supply = 5000000;
474 
475           mTotalSupply = supply;
476           mBalances[msg.sender] = supply;
477 
478           emit Transfer(0x0, msg.sender, supply);
479       }
480 }
481 
482 
483 contract SimpleAuthorization is TokenValidator, Ownable {
484     mapping(address => bool) private auths;
485 
486     constructor() public {}
487 
488     function check(
489         address /* token */,
490         address _address
491     ) external returns (byte resultCode) {
492         if (auths[_address]) {
493             return hex"11";
494         } else {
495             return hex"10";
496         }
497     }
498 
499     function check(
500         address /* _token */,
501         address _from,
502         address _to,
503         uint256 /* _amount */
504     ) external returns (byte resultCode) {
505         if (auths[_from] && auths[_to]) {
506             return hex"11";
507         } else {
508             return hex"10";
509         }
510     }
511 
512     function setAuthorized(address _address, bool _status) public onlyOwner {
513         auths[_address] = _status;
514     }
515 }