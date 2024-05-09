1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: contracts/FUTC.sol
258 
259 /**
260  * Holders of FUTC can claim tokens fed to it using the claimTokens()
261  * function. This contract will be fed several tokens automatically by other Futereum
262  * contracts.
263  */
264 contract FUTC is StandardToken {
265   using SafeMath for uint;
266 
267   string public constant name = "Futereum Centurian";
268   string public constant symbol = "FUTC";
269   uint8 public constant decimals = 0;
270 
271   address public admin;
272   uint public totalEthReleased = 0;
273 
274   mapping(address => uint) public ethReleased;
275   address[] public trackedTokens;
276   mapping(address => bool) public isTokenTracked;
277   mapping(address => uint) public totalTokensReleased;
278   mapping(address => mapping(address => uint)) public tokensReleased;
279 
280   constructor() public {
281     admin = msg.sender;
282     totalSupply_ = 100000;
283     balances[admin] = totalSupply_;
284     emit Transfer(address(0), admin, totalSupply_);
285   }
286 
287   function () public payable {}
288 
289   modifier onlyAdmin() {
290     require(msg.sender == admin);
291     _;
292   }
293 
294   function changeAdmin(address _receiver) onlyAdmin external {
295     admin = _receiver;
296   }
297 
298   /**
299    * Claim your eth.
300    */
301   function claimEth() external {
302     claimEthFor(msg.sender);
303   }
304 
305   // Claim eth for address
306   function claimEthFor(address payee) public {
307     require(balances[payee] > 0);
308 
309     uint totalReceived = address(this).balance.add(totalEthReleased);
310     uint payment = totalReceived.mul(
311       balances[payee]).div(
312         totalSupply_).sub(
313           ethReleased[payee]
314     );
315 
316     require(payment != 0);
317     require(address(this).balance >= payment);
318 
319     ethReleased[payee] = ethReleased[payee].add(payment);
320     totalEthReleased = totalEthReleased.add(payment);
321 
322     payee.transfer(payment);
323   }
324 
325   // Claim your tokens
326   function claimMyTokens() external {
327     claimTokensFor(msg.sender);
328   }
329 
330   // Claim on behalf of payee address
331   function claimTokensFor(address payee) public {
332     require(balances[payee] > 0);
333 
334     for (uint16 i = 0; i < trackedTokens.length; i++) {
335       claimToken(trackedTokens[i], payee);
336     }
337   }
338 
339   /**
340    * Transfers the unclaimed token amount for the given token and address
341    * @param _tokenAddr The address of the ERC20 token
342    * @param _payee The address of the payee (FUTC holder)
343    */
344   function claimToken(address _tokenAddr, address _payee) public {
345     require(balances[_payee] > 0);
346     require(isTokenTracked[_tokenAddr]);
347 
348     uint payment = getUnclaimedTokenAmount(_tokenAddr, _payee);
349     if (payment == 0) {
350       return;
351     }
352 
353     ERC20 Token = ERC20(_tokenAddr);
354     require(Token.balanceOf(address(this)) >= payment);
355     tokensReleased[address(Token)][_payee] = tokensReleased[address(Token)][_payee].add(payment);
356     totalTokensReleased[address(Token)] = totalTokensReleased[address(Token)].add(payment);
357     Token.transfer(_payee, payment);
358   }
359 
360   /**
361    * Returns the amount of a token (tokenAddr) that payee can claim
362    * @param tokenAddr The address of the ERC20 token
363    * @param payee The address of the payee
364    */
365   function getUnclaimedTokenAmount(address tokenAddr, address payee) public view returns (uint) {
366     ERC20 Token = ERC20(tokenAddr);
367     uint totalReceived = Token.balanceOf(address(this)).add(totalTokensReleased[address(Token)]);
368     uint payment = totalReceived.mul(
369       balances[payee]).div(
370         totalSupply_).sub(
371           tokensReleased[address(Token)][payee]
372     );
373     return payment;
374   }
375 
376   function transfer(address _to, uint256 _value) public returns (bool) {
377     require(msg.sender != _to);
378     uint startingBalance = balances[msg.sender];
379     require(super.transfer(_to, _value));
380 
381     transferChecks(msg.sender, _to, _value, startingBalance);
382     return true;
383   }
384 
385   function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
386     require(_from != _to);
387     uint startingBalance = balances[_from];
388     require(super.transferFrom(_from, _to, _value));
389 
390     transferChecks(_from, _to, _value, startingBalance);
391     return true;
392   }
393 
394   function transferChecks(address from, address to, uint checks, uint startingBalance) internal {
395 
396     // proportional amount of eth released already
397     uint claimedEth = ethReleased[from].mul(
398       checks).div(
399         startingBalance
400     );
401 
402     // increment to's released eth
403     ethReleased[to] = ethReleased[to].add(claimedEth);
404 
405     // decrement from's released eth
406     ethReleased[from] = ethReleased[from].sub(claimedEth);
407 
408     for (uint16 i = 0; i < trackedTokens.length; i++) {
409       address tokenAddr = trackedTokens[i];
410 
411       // proportional amount of token released already
412       uint claimed = tokensReleased[tokenAddr][from].mul(
413         checks).div(
414           startingBalance
415       );
416 
417       // increment to's released token
418       tokensReleased[tokenAddr][to] = tokensReleased[tokenAddr][to].add(claimed);
419 
420       // decrement from's released token
421       tokensReleased[tokenAddr][from] = tokensReleased[tokenAddr][from].sub(claimed);
422     }
423   }
424 
425   function trackToken(address _addr) onlyAdmin external {
426     require(_addr != address(0));
427     require(!isTokenTracked[_addr]);
428     trackedTokens.push(_addr);
429     isTokenTracked[_addr] = true;
430   }
431 
432   /*
433    * However unlikely, it is possible that the number of tracked tokens
434    * reaches the point that would make the gas cost of transferring FUTC
435    * exceed the block gas limit. This function allows the admin to remove
436    * a token from the tracked token list thus reducing the number of loops
437    * required in transferChecks, lowering the gas cost of transfer. The
438    * remaining balance of this token is sent back to the token's contract.
439    *
440    * Removal is irreversible.
441    *
442    * @param _addr The address of the ERC token to untrack
443    * @param _position The index of the _addr in the trackedTokens array.
444    * Use web3 to cycle through and find the index position.
445    */
446   function unTrackToken(address _addr, uint16 _position) onlyAdmin external {
447     require(isTokenTracked[_addr]);
448     require(trackedTokens[_position] == _addr);
449 
450     ERC20(_addr).transfer(_addr, ERC20(_addr).balanceOf(address(this)));
451     trackedTokens[_position] = trackedTokens[trackedTokens.length-1];
452     delete trackedTokens[trackedTokens.length-1];
453     trackedTokens.length--;
454   }
455 }