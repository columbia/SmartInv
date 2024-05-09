1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 
9 library Math {
10   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
11     return a >= b ? a : b;
12   }
13 
14   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
15     return a < b ? a : b;
16   }
17 
18   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
19     return a >= b ? a : b;
20   }
21 
22   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
23     return a < b ? a : b;
24   }
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner {
90     require(newOwner != address(0));      
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20Basic {
103   uint256 public totalSupply;
104   function balanceOf(address who) constant returns (uint256);
105   function transfer(address to, uint256 value) returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) constant returns (uint256);
115   function transferFrom(address from, address to, uint256 value) returns (bool);
116   function approve(address spender, uint256 value) returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances. 
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) returns (bool) {
135     require(_to != address(0));
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of. 
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) constant returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
174     require(_to != address(0));
175 
176     var _allowance = allowed[_from][msg.sender];
177 
178     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
179     // require (_value <= _allowance);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = _allowance.sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) returns (bool) {
194 
195     // To change the approve amount you first have to reduce the addresses`
196     //  allowance to zero by calling `approve(_spender, 0)` if it is not
197     //  already 0 to mitigate the race condition described here:
198     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
200 
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
213     return allowed[_owner][_spender];
214   }
215   
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until 
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval (address _spender, uint _addedValue) 
223     returns (bool success) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   function decreaseApproval (address _spender, uint _subtractedValue) 
230     returns (bool success) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 
250 contract MintableToken is StandardToken, Ownable {
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256 
257   modifier canMint() {
258     require(!mintingFinished);
259     _;
260   }
261 
262   /**
263    * @dev Function to mint tokens
264    * @param _to The address that will receive the minted tokens.
265    * @param _amount The amount of tokens to mint.
266    * @return A boolean that indicates if the operation was successful.
267    */
268   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
269     totalSupply = totalSupply.add(_amount);
270     balances[_to] = balances[_to].add(_amount);
271     Mint(_to, _amount);
272     Transfer(0x0, _to, _amount);
273     return true;
274   }
275 
276   /**
277    * @dev Function to stop minting new tokens.
278    * @return True if the operation was successful.
279    */
280   function finishMinting() onlyOwner returns (bool) {
281     mintingFinished = true;
282     MintFinished();
283     return true;
284   }
285 }
286 
287 /**
288  * @title Agile Connect ERC20 token
289  *
290  * @dev Implemantation of the ABC token.
291  */
292 contract ABCToken is MintableToken {
293 
294     string public name = "ABCToken";
295     string public symbol = "ABC";
296     uint256 public decimals = 18; 
297 
298     /**
299      * This unnamed function is called whenever someone tries to send ether to it 
300      */
301     function() {
302       revert();
303       // Prevents accidental sending of ether
304     }
305 
306 }
307 
308 /**
309  * @title Agile Connect presale contract
310  */
311 contract ABCPresale is Ownable {
312   using SafeMath for uint256;
313 
314   ABCToken public token;
315 
316   uint256 public startBlock;
317   uint256 public endBlock;
318   bool public presaleClosedManually = false;
319   bool public isFinalized = false;
320   address public founders;
321   address public developer;
322   uint256 public weiRaised;
323   uint public rate = 181818; // Token Price 0.00055 ETH
324 
325   uint public hardcap = 5550 ether; // 10090899 ABC
326   uint public softcap = 5500 ether; // 9999990 ABC
327   uint founders_abc = 2500 ether; //   5000000 ABC
328   uint developer_abc = 15 ether; //    30000 ABC
329 
330   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
331   event Finalized();
332   event ClosedManually();
333 
334   function ABCPresale(uint256 _startBlock, uint256 _endBlock, address _founders, address _developer) {
335     require(_startBlock >= block.number);
336     require(_endBlock >= _startBlock);
337 
338     token = createTokenContract();
339     startBlock = _startBlock;
340     endBlock = _endBlock;
341     founders = _founders;
342     developer = _developer;
343   }
344 
345   function createTokenContract() internal returns (ABCToken) {
346     return new ABCToken();
347   }
348 
349   function () payable {
350     buyTokens(msg.sender);
351   }
352 
353   function buyTokens(address beneficiary) payable {
354     require(beneficiary != 0x0);
355     require(validPurchase());
356 
357     uint256 weiAmount = msg.value;
358 
359     uint256 tokens = weiAmount.div(100).mul(rate);
360 
361     weiRaised = weiRaised.add(weiAmount);
362 
363     token.mint(beneficiary, tokens);
364     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
365 
366     forwardFunds();
367   }
368 
369   function forwardFunds() internal {
370     founders.transfer(msg.value);
371   }
372 
373   function validPurchase() internal constant returns (bool) {
374     uint256 current = block.number;
375     bool withinPeriod = current >= startBlock && current <= endBlock;
376     bool nonZeroPurchase = msg.value != 0;
377     bool withinCap = weiRaised.add(msg.value) <= hardcap;
378     bool biggerThanLeftBound = msg.value >= 300 finney;
379     bool smallerThanRightBound = msg.value <= 1000 ether;
380     return withinPeriod && nonZeroPurchase && withinCap && biggerThanLeftBound && smallerThanRightBound && !presaleClosedManually && !isFinalized;
381   }
382 
383   function hasEnded() public constant returns (bool) {
384     bool capReached = weiRaised >= softcap;
385     return block.number > endBlock || capReached || presaleClosedManually || isFinalized;
386   }
387 
388   function changeTokenOwner(address newOwner) onlyOwner {
389     token.transferOwnership(newOwner);
390   }
391 
392   function closePresale() onlyOwner {
393     require(!isFinalized);
394     require(!presaleClosedManually);
395     require(block.number > startBlock && block.number < endBlock);
396     presaleClosedManually = true;
397     
398     finalization();
399     ClosedManually();
400 
401     isFinalized = true;
402   }
403 
404   function finalize() onlyOwner {
405     require(!isFinalized);
406     require(hasEnded());
407 
408     finalization();
409     Finalized();
410     
411     isFinalized = true;
412   }
413 
414   function finalization() internal {
415     token.mint(developer, developer_abc.mul(2000));
416     token.mint(founders, founders_abc.mul(2000));
417   }
418 
419 }