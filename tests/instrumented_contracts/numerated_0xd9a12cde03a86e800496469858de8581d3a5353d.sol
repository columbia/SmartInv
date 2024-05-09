1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   /**
95   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 /**
253  * @title SafeERC20
254  * @dev Wrappers around ERC20 operations that throw on failure.
255  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
256  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
257  */
258 library SafeERC20 {
259   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
260     assert(token.transfer(to, value));
261   }
262 
263   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
264     assert(token.transferFrom(from, to, value));
265   }
266 
267   function safeApprove(ERC20 token, address spender, uint256 value) internal {
268     assert(token.approve(spender, value));
269   }
270 }
271 
272 /**
273  * @title Contracts that should be able to recover tokens
274  * @author SylTi
275  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
276  * This will prevent any accidental loss of tokens.
277  */
278 contract CanReclaimToken is Ownable {
279   using SafeERC20 for ERC20Basic;
280 
281   /**
282    * @dev Reclaim all ERC20Basic compatible tokens
283    * @param token ERC20Basic The address of the token contract
284    */
285   function reclaimToken(ERC20Basic token) external onlyOwner {
286     uint256 balance = token.balanceOf(this);
287     token.safeTransfer(owner, balance);
288   }
289 
290 }
291 
292 /**
293  * @title Pausable
294  * @dev Base contract which allows children to implement an emergency stop mechanism.
295  */
296 contract Pausable is Ownable {
297   event Pause();
298   event Unpause();
299 
300   bool public paused = false;
301 
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is not paused.
305    */
306   modifier whenNotPaused() {
307     require(!paused);
308     _;
309   }
310 
311   /**
312    * @dev Modifier to make a function callable only when the contract is paused.
313    */
314   modifier whenPaused() {
315     require(paused);
316     _;
317   }
318 
319   /**
320    * @dev called by the owner to pause, triggers stopped state
321    */
322   function pause() onlyOwner whenNotPaused public {
323     paused = true;
324     Pause();
325   }
326 
327   /**
328    * @dev called by the owner to unpause, returns to normal state
329    */
330   function unpause() onlyOwner whenPaused public {
331     paused = false;
332     Unpause();
333   }
334 }
335 
336 contract YUPToken is Ownable, StandardToken, CanReclaimToken, Pausable {
337     using SafeMath for uint256;
338     
339     /****************************************************************************
340 
341     NOTE:   This is Crowdholding's YUP token smart contract, meant to replace the
342             initial YUPIE deployed at: 0x0F33bb20a282A7649C7B3AFf644F084a9348e933
343 
344     ****************************************************************************/
345 
346     
347     /** State variables **/
348     string public constant name = "YUP";
349     string public constant symbol = "YUP";
350     uint256 public constant decimals = 18;
351     address public timelockVault;
352     address public bountyFund;
353     address public seedFund;
354     address public reserveFund;
355     address public vestingVault;
356     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
357     bool public finalized;
358     
359     event IsFinalized(uint256 _time);   //Event to signal that contract is closed for balance loading
360     
361     /** Modifiers **/
362     modifier isFinalized() {
363         require(finalized == true);
364         _;
365     }
366     
367     modifier notFinalized() {
368         require(finalized == false);
369         _;
370     }
371     
372     /** Constructor **/
373     function YUPToken(
374         address _timelockVault,
375         address _bountyFund,
376         address _seedFund,
377         address _reserveFund,
378         address _vestingVault
379     ) public {
380         totalSupply_ = 445 * (10**6) * (10**decimals);  //445 million tokens (with 18 decimals)
381         timelockVault = _timelockVault;
382         bountyFund = _bountyFund;
383         seedFund = _seedFund;
384         reserveFund = _reserveFund;
385         vestingVault = _vestingVault;
386         finalized = false;
387         
388         /*********************************************************************
389         
390         presaleShare            =>   109441916283952000000000000      //24.59%
391         crowdsaleShare          =>   90808083716048200000000000       //20.41%
392         bountyShare             =>   totalSupply_.div(100);           // 1%
393         seedShare               =>   totalSupply_.div(100).mul(5);    // 5%
394         reserveShare            =>   totalSupply_.div(100).mul(10);   //10%
395         futureUseShare          =>   totalSupply_.div(100).mul(19);   //19%
396         teamAndAdvisorsShare    =>   totalSupply_.div(100).mul(20);   //20%
397         
398         *********************************************************************/
399         
400         balances[timelockVault] = 193991920000000000000000000;      //presaleShare + futureUseShare = 43.59%
401         Transfer(0x0, address(timelockVault), 193991920000000000000000000);
402         
403         balances[bountyFund] = totalSupply_.div(100);               //bountyShare
404         Transfer(0x0, address(bountyFund), totalSupply_.div(100));
405         
406         balances[seedFund] = totalSupply_.div(100).mul(5);          //seedShare
407         Transfer(0x0, address(seedFund), totalSupply_.div(100).mul(5));
408         
409         balances[reserveFund] = totalSupply_.div(100).mul(10);      //reserveShare
410         Transfer(0x0, address(reserveFund), totalSupply_.div(100).mul(10));
411         
412         balances[vestingVault] = totalSupply_.div(100).mul(20);     //teamAndAdvisorsShare
413         Transfer(0x0, address(vestingVault), totalSupply_.div(100).mul(20));
414     }
415     
416     /** Overridden transfer method to facilitate emergency pausing **/
417     function transfer(address _to, uint256 _value) public whenNotPaused isFinalized returns (bool) {
418         return super.transfer(_to, _value);
419     }
420     
421     /** Overridden transferFrom method to facilitate emergency pausing **/
422     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isFinalized returns (bool) {
423         return super.transferFrom(_from, _to, _value);
424     }
425     
426     /** Allows owner to finalize contract **/
427     function finalize() public notFinalized onlyOwner {
428         finalized = true;
429         IsFinalized(now);
430     }
431     
432     /** Facilitates the assignment of investor addresses and amounts (only before contract is finalized) **/
433     function loadBalances(uint256[] data) public notFinalized onlyOwner {
434         for (uint256 i = 0; i < data.length; i++) {
435             address addr = address(data[i] & (D160 - 1));
436             uint256 amount = data[i] / D160;
437             
438             balances[addr] = amount;
439             Transfer(0x0, addr, amount);
440         }
441     }
442 }