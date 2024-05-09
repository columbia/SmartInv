1 pragma solidity ^0.4.24;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) returns (bool);
20   function approve(address spender, uint256 value) returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 /**
24  * @title Basic token
25  * @dev Basic version of StandardToken, with no allowances. 
26  */
27 contract BasicToken is ERC20Basic {
28   using SafeMath for uint256;
29 
30   mapping(address => uint256) balances;
31 
32   /**
33   * @dev transfer token for a specified address
34   * @param _to The address to transfer to.
35   * @param _value The amount to be transferred.
36   */
37   function transfer(address _to, uint256 _value) returns (bool) {
38     require(_to != address(0));
39 
40     // SafeMath.sub will throw if there is not enough balance.
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   /**
48   * @dev Gets the balance of the specified address.
49   * @param _owner The address to query the the balance of. 
50   * @return An uint256 representing the amount owned by the passed address.
51   */
52   function balanceOf(address _owner) constant returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 /**
58  * @title Standard ERC20 token
59  *
60  * @dev Implementation of the basic standard token.
61  * @dev https://github.com/ethereum/EIPs/issues/20
62  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
63  */
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68 
69   /**
70    * @dev Transfer tokens from one address to another
71    * @param _from address The address which you want to send tokens from
72    * @param _to address The address which you want to transfer to
73    * @param _value uint256 the amount of tokens to be transferred
74    */
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76     require(_to != address(0));
77 
78     var _allowance = allowed[_from][msg.sender];
79 
80     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
81     // require (_value <= _allowance);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = _allowance.sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   /**
91    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    * @param _spender The address which will spend the funds.
93    * @param _value The amount of tokens to be spent.
94    */
95   function approve(address _spender, uint256 _value) returns (bool) {
96 
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling `approve(_spender, 0)` if it is not
99     //  already 0 to mitigate the race condition described here:
100     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102 
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   /**
109    * @dev Function to check the amount of tokens that an owner allowed to a spender.
110    * @param _owner address The address which owns the funds.
111    * @param _spender address The address which will spend the funds.
112    * @return A uint256 specifying the amount of tokens still available for the spender.
113    */
114   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115     return allowed[_owner][_spender];
116   }
117   
118   /**
119    * approve should be called when allowed[_spender] == 0. To increment
120    * allowed value is better to use this function to avoid 2 calls (and wait until 
121    * the first transaction is mined)
122    * From MonolithDAO Token.sol
123    */
124   function increaseApproval (address _spender, uint _addedValue) 
125     returns (bool success) {
126     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval (address _spender, uint _subtractedValue) 
132     returns (bool success) {
133     uint oldValue = allowed[msg.sender][_spender];
134     if (_subtractedValue > oldValue) {
135       allowed[msg.sender][_spender] = 0;
136     } else {
137       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
138     }
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143 }
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() {
161     owner = msg.sender;
162   }
163 
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner {
179     require(newOwner != address(0));      
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 /**
186  * @title Mintable token
187  * @dev Simple ERC20 Token example, with mintable token creation
188  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
189  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
190  */
191 contract MintableToken is StandardToken, Ownable {
192   event Mint(address indexed to, uint256 amount);
193   event MintFinished();
194 
195   bool public mintingFinished = false;
196 
197 
198   modifier canMint() {
199     require(!mintingFinished);
200     _;
201   }
202 
203   /**
204    * @dev Function to mint tokens
205    * @param _to The address that will receive the minted tokens.
206    * @param _amount The amount of tokens to mint.
207    * @return A boolean that indicates if the operation was successful.
208    */
209   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
210     totalSupply = totalSupply.add(_amount);
211     balances[_to] = balances[_to].add(_amount);
212     Mint(_to, _amount);
213     Transfer(0x0, _to, _amount);
214     return true;
215   }
216 
217   /**
218    * @dev Function to stop minting new tokens.
219    * @return True if the operation was successful.
220    */
221   function finishMinting() onlyOwner returns (bool) {
222     mintingFinished = true;
223     MintFinished();
224     return true;
225   }
226 }
227 /**
228  * @title SafeMath
229  * @dev Math operations with safety checks that throw on error
230  */
231 library SafeMath {
232   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
233     uint256 c = a * b;
234     assert(a == 0 || c / a == b);
235     return c;
236   }
237 
238   function div(uint256 a, uint256 b) internal constant returns (uint256) {
239     // assert(b > 0); // Solidity automatically throws when dividing by 0
240     uint256 c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242     return c;
243   }
244 
245   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   function add(uint256 a, uint256 b) internal constant returns (uint256) {
251     uint256 c = a + b;
252     assert(c >= a);
253     return c;
254   }
255 }
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = true;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused public {
287     paused = true;
288     Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public {
295     paused = false;
296     Unpause();
297   }
298 }
299 /**
300  * @title Pausable token
301  *
302  * @dev StandardToken modified with pausable transfers.
303  **/
304 contract PausableToken is StandardToken, Pausable {
305 
306   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
307     return super.transfer(_to, _value);
308   }
309 
310   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
315     return super.approve(_spender, _value);
316   }
317 
318   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
319     return super.increaseApproval(_spender, _addedValue);
320   }
321 
322   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
323     return super.decreaseApproval(_spender, _subtractedValue);
324   }
325 }
326 /**
327  * contract MinterStorePool
328  **/
329 contract MinterStorePool is PausableToken, MintableToken {
330 
331   string public constant name = "MinterStorePool";
332   string public constant symbol = "MSP";
333   uint8 public constant decimals = 18;
334 }
335 /**
336  * contract MinterStorePoolCrowdsale
337  **/
338 contract MinterStorePoolCrowdsale is Ownable {
339 
340 using SafeMath for uint;
341 
342 address public multisigWallet;
343 uint public startRound;
344 uint public periodRound;
345 uint public altCapitalization;
346 uint public totalCapitalization;
347 
348 MinterStorePool public token = new MinterStorePool ();
349 
350 function MinterStorePoolCrowdsale () public {
351 	multisigWallet = 0xdee04DfdC6C93D51468ba5cd90457Ac0B88055FD;
352 	startRound = 1534118340;
353 	periodRound = 80;
354 	altCapitalization = 0;
355 	totalCapitalization = 2000 ether;
356 	}
357 
358 modifier CrowdsaleIsOn() {
359 	require(now >= startRound && now <= startRound + periodRound * 1 days);
360 	_;
361 	}
362 modifier TotalCapitalization() {
363 	require(multisigWallet.balance + altCapitalization <= totalCapitalization);
364 	_;
365 	}
366 
367 function setMultisigWallet (address newMultisigWallet) public onlyOwner {
368 	require(newMultisigWallet != 0X0);
369 	multisigWallet = newMultisigWallet;
370 	}
371 	
372 function setStartRound (uint newStartRound) public onlyOwner {
373 	startRound = newStartRound;
374 	}
375 function setPeriodRound (uint newPeriodRound) public onlyOwner {
376 	periodRound = newPeriodRound;
377 	} 
378 function setAltCapitalization (uint newAltCapitalization) public onlyOwner {
379 	altCapitalization = newAltCapitalization;
380 	}
381 function setTotalCapitalization (uint newTotalCapitalization) public onlyOwner {
382 	totalCapitalization = newTotalCapitalization;
383 	}
384 	
385 function () external payable {
386 	createTokens (msg.sender, msg.value);
387 	}
388 
389 function createTokens (address recipient, uint etherDonat) internal CrowdsaleIsOn TotalCapitalization {
390 	require(etherDonat > 0); // etherDonat in wei
391 	require(recipient != 0X0);
392 	multisigWallet.transfer(etherDonat);
393     uint tokens = 10000000000000; //0,00001 btc
394 	token.mint(recipient, tokens);
395 	}
396 
397 function customCreateTokens(address recipient, uint btcDonat) public CrowdsaleIsOn TotalCapitalization onlyOwner {
398 	require(btcDonat > 0); // etherDonat in wei
399 	require(recipient != 0X0);
400     uint tokens = btcDonat;
401 	token.mint(recipient, tokens);
402 	}
403 
404 function retrieveTokens (address addressToken, address wallet) public onlyOwner {
405 	ERC20 alientToken = ERC20 (addressToken);
406 	alientToken.transfer(wallet, alientToken.balanceOf(this));
407 	}
408 
409 function finishMinting () public onlyOwner {
410 	token.finishMinting();
411 	}
412 
413 function setOwnerToken (address newOwnerToken) public onlyOwner {
414 	require(newOwnerToken != 0X0);
415 	token.transferOwnership(newOwnerToken); 
416 	}
417 }