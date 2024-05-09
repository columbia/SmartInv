1 pragma solidity ^0.4.18;
2 
3 /**
4  * create by Edison zhu
5  * Add, subtract, multiply and divide using safe calculation
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     if (newOwner != address(0)) {
79       owner = newOwner;
80     }
81   }
82 
83 }
84 
85 /**
86  * Contract administrator can suspend the contract in an emergency and stop the transfer
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91   event Pause();
92   event Unpause();
93 
94   bool public paused = false;
95 
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is not paused.
99    */
100   modifier whenNotPaused() {
101     require(!paused);
102     _;
103   }
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is paused.
107    */
108   modifier whenPaused() {
109     require(paused);
110     _;
111   }
112 
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() onlyOwner whenNotPaused public {
117     paused = true;
118     emit Pause();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() onlyOwner whenPaused public {
125     paused = false;
126     emit Unpause();
127   }
128 
129 }
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) balances;
162 
163   uint256 totalSupply_;
164 
165   /**
166   * @dev total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180     
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187   
188 
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256 balance) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223     
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * 
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * 
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282     uint oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue > oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 /**
295  * @title Mintable token
296  * @dev Simple ERC20 Token example, with mintable token creation
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     emit Mint(_to, _amount);
320     emit Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     emit MintFinished();
331     return true;
332   }
333 }
334 
335 /**
336  * @title Capped token
337  * @dev Mintable token with a token cap.
338  */
339 contract CappedToken is MintableToken {
340 
341   uint256 public cap;
342 
343   function CappedToken(uint256 _cap) public {
344     require(_cap > 0);
345     cap = _cap;
346   }
347 
348   /**
349    * @dev Function to mint tokens
350    * @param _to The address that will receive the minted tokens.
351    * @param _amount The amount of tokens to mint.
352    * @return A boolean that indicates if the operation was successful.
353    */
354   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
355     require(totalSupply_.add(_amount) <= cap);
356 
357     return super.mint(_to, _amount);
358   }
359 
360 }
361 
362 /**
363  * @dev function 계약 일시 중지
364  */
365 contract PausableToken is StandardToken, Pausable {
366 
367   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
368     return super.transfer(_to, _value);
369   }
370 
371   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
372     return super.transferFrom(_from, _to, _value);
373   }
374 
375   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
376     return super.approve(_spender, _value);
377   }
378 
379   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
380     return super.increaseApproval(_spender, _addedValue);
381   }
382 
383   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
384     return super.decreaseApproval(_spender, _subtractedValue);
385   }
386 
387 /**
388  * @dev function 일괄 전송
389  */
390 function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
391     uint receiverCount = _receivers.length;
392     uint256 amount = _value.mul(uint256(receiverCount));
393     /* require(receiverCount > 0 && receiverCount <= 20); */
394     require(receiverCount > 0);
395     require(_value > 0 && balances[msg.sender] >= amount);
396 
397     balances[msg.sender] = balances[msg.sender].sub(amount);
398     for (uint i = 0; i < receiverCount; i++) {
399         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
400         Transfer(msg.sender, _receivers[i], _value);
401     }
402     return true;
403   }
404 }
405 
406 /**
407  * 호출자가 손에있는 토큰을 파괴하면 총 토큰의 양이 그에 따라 줄어 듭니다.
408  * @title Burnable Token
409  * @dev Token that can be irreversibly burned (destroyed).
410  */
411 contract BurnableToken is BasicToken {
412 
413   event Burn(address indexed burner, uint256 value);
414 
415   /**
416    * @dev Burns a specific amount of tokens.
417    * @param _value The amount of token to be burned.
418    */
419   function burn(uint256 _value) public {
420     require(_value <= balances[msg.sender]);
421 
422 
423     address burner = msg.sender;
424     balances[burner] = balances[burner].sub(_value);
425     totalSupply_ = totalSupply_.sub(_value);
426     emit Burn(burner, _value);
427     emit Transfer(burner, address(0), _value);
428   }
429 }
430 
431 contract AdvanceToken is StandardToken,Ownable{
432     mapping (address => bool) public frozenAccount;
433     //계정 잠금
434   event FrozenFunds(address target, bool frozen);
435   
436   function freezeAccount(address target, bool freeze)  public onlyOwner{
437         frozenAccount[target] = freeze;
438         FrozenFunds(target, freeze);
439     }
440     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
441       require(_to != address(0));
442       require(!frozenAccount[msg.sender]);
443 
444       require(balances[_from] >= _value);
445       require(balances[ _to].add(_value) >= balances[ _to]);
446 
447       balances[_from] =balances[_from].sub(_value);
448       balances[_to] =balances[_from].add(_value);
449 
450       emit Transfer(_from, _to, _value);
451       return true;
452   }
453   
454      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
455         require(allowed[_from][msg.sender] >= _value);
456         require(!frozenAccount[_from]);
457         require(!frozenAccount[_to]);
458         
459         success =  _transfer(_from, _to, _value);
460         allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value);
461   }
462 
463     
464 
465 }
466 
467 contract SHPToken is CappedToken, PausableToken, BurnableToken,AdvanceToken {
468 
469     string public constant name = "Sheep Coin";
470     string public constant symbol = "SHEEP";
471     uint8 public constant decimals = 18;
472 
473     uint256 private constant TOKEN_CAP = 1 * (10 ** uint256(decimals));
474     uint256 private constant TOKEN_INITIAL = 500000000 * (10 ** uint256(decimals));
475 
476     function SHPToken() public CappedToken(TOKEN_CAP) {
477       totalSupply_ = TOKEN_INITIAL;
478 
479       balances[msg.sender] = TOKEN_INITIAL;
480       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
481 
482       paused = true;
483   }
484 }