1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 // File: zeppelin-solidity/contracts/token/BasicToken.sol
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 // File: zeppelin-solidity/contracts/token/ERC20.sol
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: zeppelin-solidity/contracts/token/StandardToken.sol
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
188 
189 /**
190  * @title Burnable Token
191  * @dev Token that can be irreversibly burned (destroyed).
192  */
193 contract BurnableToken is StandardToken {
194 
195     event Burn(address indexed burner, uint256 value);
196 
197     /**
198      * @dev Burns a specific amount of tokens.
199      * @param _value The amount of token to be burned.
200      */
201     function burn(uint256 _value) public {
202         require(_value > 0);
203 
204         address burner = msg.sender;
205         balances[burner] = balances[burner].sub(_value);
206         totalSupply = totalSupply.sub(_value);
207         Burn(burner, _value);
208     }
209 }
210 
211 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
212 
213 /**
214  * @title Ownable
215  * @dev The Ownable contract has an owner address, and provides basic authorization control
216  * functions, this simplifies the implementation of "user permissions".
217  */
218 contract Ownable {
219   address public owner;
220 
221 
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   function Ownable() {
230     owner = msg.sender;
231   }
232 
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address newOwner) onlyOwner public {
248     require(newOwner != address(0));
249     OwnershipTransferred(owner, newOwner);
250     owner = newOwner;
251   }
252 
253 }
254 
255 // File: zeppelin-solidity/contracts/token/MintableToken.sol
256 
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 
264 contract MintableToken is StandardToken, Ownable {
265   event Mint(address indexed to, uint256 amount);
266   event MintFinished();
267 
268   bool public mintingFinished = false;
269 
270 
271   modifier canMint() {
272     require(!mintingFinished);
273     _;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
283     totalSupply = totalSupply.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     Mint(_to, _amount);
286     Transfer(0x0, _to, _amount);
287     return true;
288   }
289 
290   /**
291    * @dev Function to stop minting new tokens.
292    * @return True if the operation was successful.
293    */
294   function finishMinting() onlyOwner public returns (bool) {
295     mintingFinished = true;
296     MintFinished();
297     return true;
298   }
299 }
300 
301 // File: contracts/AidCoin.sol
302 
303 /**
304  * @title AidCoin
305  */
306 contract AidCoin is MintableToken, BurnableToken {
307     string public name = "AidCoin";
308     string public symbol = "AID";
309     uint256 public decimals = 18;
310     uint256 public maxSupply = 100000000 * (10 ** decimals);
311 
312     function AidCoin() public {
313 
314     }
315 
316     modifier canTransfer(address _from, uint _value) {
317         require(mintingFinished);
318         _;
319     }
320 
321     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) public returns (bool) {
322         return super.transfer(_to, _value);
323     }
324 
325     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) public returns (bool) {
326         return super.transferFrom(_from, _to, _value);
327     }
328 }
329 
330 // File: contracts/JulyAirdrop.sol
331 
332 /**
333  * @title JulyAirdrop
334  */
335 contract JulyAirdrop is Ownable {
336   using SafeMath for uint256;
337 
338   address airdropWallet;
339   mapping (address => uint256) public claimedAirdropTokens;
340   mapping (address => uint256) public previousAirdropSurplus;
341   mapping (address => uint256) public remainingAirdropSurplus;
342   address[] public remainingAirdropSurplusAddresses;
343 
344   AidCoin public token;
345 
346   constructor(address _airdropWallet, address _token) public {
347     require(_airdropWallet != address(0));
348     require(_token != address(0));
349 
350     airdropWallet = _airdropWallet;
351     token = AidCoin(_token);
352   }
353 
354   function setPreviousSurplus(address[] users, uint256[] amounts) public onlyOwner {
355     require(users.length > 0);
356     require(amounts.length > 0);
357     require(users.length == amounts.length);
358 
359     for (uint i = 0; i < users.length; i++) {
360       address to = users[i];
361       uint256 value = amounts[i];
362       previousAirdropSurplus[to] = value;
363     }
364   }
365 
366   function multisend(address[] users, uint256[] amounts) public onlyOwner {
367     require(users.length > 0);
368     require(amounts.length > 0);
369     require(users.length == amounts.length);
370 
371     for (uint i = 0; i < users.length; i++) {
372       address to = users[i];
373       uint256 value = (amounts[i] * (10 ** 18)).mul(75).div(1000);
374 
375       if (claimedAirdropTokens[to] == 0) {
376         claimedAirdropTokens[to] = value;
377 
378         if (value > previousAirdropSurplus[to]) {
379           value = value.sub(previousAirdropSurplus[to]);
380           token.transferFrom(airdropWallet, to, value);
381         } else {
382           remainingAirdropSurplus[to] = previousAirdropSurplus[to].sub(value);
383           remainingAirdropSurplusAddresses.push(to);
384         }
385       }
386     }
387   }
388 
389   function getRemainingAirdropSurplusAddressesLength() view public returns (uint) {
390     return remainingAirdropSurplusAddresses.length;
391   }
392 }
393 
394 // File: contracts/OctoberAirdrop.sol
395 
396 /**
397  * @title OctoberAirdrop
398  */
399 contract OctoberAirdrop is Ownable {
400 	using SafeMath for uint256;
401 
402 	address airdropWallet;
403 	mapping (address => uint256) public claimedAirdropTokens;
404 	mapping (address => uint256) public remainingAirdropSurplus;
405 	address[] public remainingAirdropSurplusAddresses;
406 
407 	JulyAirdrop previousAirdrop;
408 	AidCoin public token;
409 
410 	constructor(address _airdropWallet, address _token, address _previousAirdrop) public {
411 		require(_airdropWallet != address(0));
412 		require(_token != address(0));
413 		require(_previousAirdrop != address(0));
414 
415 		airdropWallet = _airdropWallet;
416 		token = AidCoin(_token);
417 		previousAirdrop = JulyAirdrop(_previousAirdrop);
418 	}
419 
420 	function multisend(address[] users, uint256[] amounts) public onlyOwner {
421 		require(users.length > 0);
422 		require(amounts.length > 0);
423 		require(users.length == amounts.length);
424 
425 		for (uint i = 0; i < users.length; i++) {
426 			address to = users[i];
427 			uint256 value = (amounts[i] * (10 ** 18)).mul(125).div(1000);
428 
429 			if (claimedAirdropTokens[to] == 0) {
430 				claimedAirdropTokens[to] = value;
431 
432 				uint256 previousSurplus = previousAirdrop.remainingAirdropSurplus(to);
433 				if (value > previousSurplus) {
434 					value = value.sub(previousSurplus);
435 					token.transferFrom(airdropWallet, to, value);
436 				} else {
437 					remainingAirdropSurplus[to] = previousSurplus.sub(value);
438 					remainingAirdropSurplusAddresses.push(to);
439 				}
440 			}
441 		}
442 	}
443 
444 	function getRemainingAirdropSurplusAddressesLength() view public returns (uint) {
445 		return remainingAirdropSurplusAddresses.length;
446 	}
447 }