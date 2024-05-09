1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 // File: contracts/Lockup.sol
49 
50 pragma solidity ^0.4.18;
51 
52 
53 /**
54  * @title Lockup
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Lockup is Ownable {
58 
59 	uint256 public lockup_time;
60 
61 	function Lockup(uint256 _lockUp_release_time)public{
62 
63 		lockup_time = _lockUp_release_time; 
64 	}
65 
66 
67 	/**
68 	* @dev Function to check token is locked or not
69 	* @return A bool that indicates if the operation was successful.
70 	*/
71 	function isLockup() public view returns(bool){
72 		return (now >= lockup_time);
73 	}
74 
75 	/**
76 	* @dev Function to get token lockup time
77 	* @return A uint256 that indicates if the operation was successful.
78 	*/
79 	function getLockup()public view returns (uint256) {
80 		return lockup_time;
81 	}
82 
83 	/**
84 	* @dev Function to update token lockup time
85 	* @return A bool that indicates if the operation was successful.
86 	*/
87 	function updateLockup(uint256 _newLockUpTime) onlyOwner public returns(bool){
88 
89 		require( _newLockUpTime > now );
90 
91 		lockup_time = _newLockUpTime;
92 
93 		return true;
94 	}
95 }
96 
97 // File: zeppelin-solidity/contracts/math/SafeMath.sol
98 
99 pragma solidity ^0.4.18;
100 
101 
102 /**
103  * @title SafeMath
104  * @dev Math operations with safety checks that throw on error
105  */
106 library SafeMath {
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     if (a == 0) {
109       return 0;
110     }
111     uint256 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 
135 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
136 
137 pragma solidity ^0.4.18;
138 
139 
140 /**
141  * @title ERC20Basic
142  * @dev Simpler version of ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/179
144  */
145 contract ERC20Basic {
146   uint256 public totalSupply;
147   function balanceOf(address who) public view returns (uint256);
148   function transfer(address to, uint256 value) public returns (bool);
149   event Transfer(address indexed from, address indexed to, uint256 value);
150 }
151 
152 // File: zeppelin-solidity/contracts/token/BasicToken.sol
153 
154 pragma solidity ^0.4.18;
155 
156 
157 
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) balances;
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     // SafeMath.sub will throw if there is not enough balance.
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 // File: zeppelin-solidity/contracts/token/ERC20.sol
196 
197 pragma solidity ^0.4.18;
198 
199 
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: zeppelin-solidity/contracts/token/StandardToken.sol
213 
214 pragma solidity ^0.4.18;
215 
216 
217 
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
287     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 // File: zeppelin-solidity/contracts/token/MintableToken.sol
315 
316 pragma solidity ^0.4.18;
317 
318 
319 
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     totalSupply = totalSupply.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     Mint(_to, _amount);
351     Transfer(address(0), _to, _amount);
352     return true;
353   }
354 
355   /**
356    * @dev Function to stop minting new tokens.
357    * @return True if the operation was successful.
358    */
359   function finishMinting() onlyOwner canMint public returns (bool) {
360     mintingFinished = true;
361     MintFinished();
362     return true;
363   }
364 }
365 
366 // File: contracts/COTCoin.sol
367 
368 pragma solidity ^0.4.18;
369 
370 
371 
372 
373 contract COTCoin is MintableToken{
374 	using SafeMath for uint256;
375 
376 	Lockup public lockup;
377 
378 	string public constant name = 'CosplayToken';
379 	string public constant symbol = 'COT';
380 	uint8 public constant decimals = 18;
381 
382 	//the default total tokens
383 	//契約オーナー最初持っているトークン量、トークン最大発行量-10億個、default:1000000000
384 	uint256 public constant _totalSupply = (10**9)*10**18; 
385 
386 	address public _saleToken_owner;
387 	address public _unsaleToken_owner;
388 
389 
390 	function COTCoin(address _saleToken_wallet, address _unsaleToken_wallet, address _lockUp_address)public{
391 
392 		lockup = Lockup(_lockUp_address);
393 		
394 		_saleToken_owner = _saleToken_wallet; 
395 
396 		_unsaleToken_owner = _unsaleToken_wallet;
397 
398 	    //40％量COTはセール期間に用
399 	    uint256 _remainingSaleSupply = (_totalSupply*40/100);
400 
401 		//send all of token to owner in the begining.
402 		//最初的に、契約生成するときに40%トークンは契約オーナーに上げる
403 		require(mint(_saleToken_wallet, _remainingSaleSupply));
404 
405 		//最初的に、契約生成するときに60%トークンは契約オーナーに上げる
406 		require(mint(_unsaleToken_wallet, (_totalSupply-_remainingSaleSupply)));
407 
408 		//これ以上トークンを新規発行できないようにする。
409 		finishMinting();
410 
411 	}
412 
413   	/**
414 	* @dev Function to sell token to other user
415 	* @param _to The address that will receive the tokens.
416 	* @param _value The token amount that token holding owner want to give user
417 	* @return A uint256 that indicates if the operation was successful.
418 	*/
419 	function sellToken(address _to, uint256 _value)onlyOwner public returns (bool) {
420 
421 		require(_to != address(0));
422 
423 		require(_to != _saleToken_owner);
424 
425 		require(balances[_saleToken_owner] > 0);
426 
427 		require(_value <= balances[_saleToken_owner]);
428 
429 		// SafeMath.sub will throw if there is not enough balance.
430 
431 		//minus the holding tokens from owner
432 		balances[_saleToken_owner] = balances[_saleToken_owner].sub(_value);
433 
434 		//plus the holding tokens to buyer
435 		//トークンを購入したいユーザーはトークンをプラス
436 		balances[_to] = balances[_to].add(_value);
437 
438 		Transfer(address(0), _to , _value);
439 		return true;
440 	}
441 
442 	/**
443 	* @dev transfer token for a specified address
444 	* @param _to The address to transfer to.
445 	* @param _value The amount to be transferred.
446 	// override this method to check token lockup time.
447 	*/
448 	function transfer(address _to, uint256 _value) public returns (bool) {
449 		require(_to != address(0));
450 		require(_value <= balances[msg.sender]);
451 
452 		//オーナー以外の人たちはトークン交換できる解放時間後で、交換できます
453 		if( ( msg.sender != _saleToken_owner ) && ( msg.sender != _unsaleToken_owner ) ){
454 			require(lockup.isLockup());
455 		}
456 
457 		// SafeMath.sub will throw if there is not enough balance.
458 		balances[msg.sender] = balances[msg.sender].sub(_value);
459 		balances[_to] = balances[_to].add(_value);
460 		Transfer(msg.sender, _to, _value);
461 
462 		return true;
463 	}
464 	
465 }