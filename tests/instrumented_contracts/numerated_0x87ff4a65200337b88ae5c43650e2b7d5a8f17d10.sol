1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.8.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   uint256 totalSupply_;
124 
125   /**
126   * @dev total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev transfer token for a specified address
134   * @param _to The address to transfer to.
135   * @param _value The amount to be transferred.
136   */
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[msg.sender]);
140 
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is Ownable {
259   event Pause();
260   event Unpause();
261 
262   bool public paused = false;
263 
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is not paused.
267    */
268   modifier whenNotPaused() {
269     require(!paused);
270     _;
271   }
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is paused.
275    */
276   modifier whenPaused() {
277     require(paused);
278     _;
279   }
280 
281   /**
282    * @dev called by the owner to pause, triggers stopped state
283    */
284   function pause() onlyOwner whenNotPaused public {
285     paused = true;
286     Pause();
287   }
288 
289   /**
290    * @dev called by the owner to unpause, returns to normal state
291    */
292   function unpause() onlyOwner whenPaused public {
293     paused = false;
294     Unpause();
295   }
296 }
297 
298 /**
299  * @title Pausable token
300  * @dev StandardToken modified with pausable transfers.
301  **/
302 contract PausableToken is StandardToken, Pausable {
303 
304   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
305     return super.transfer(_to, _value);
306   }
307 
308   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
309     return super.transferFrom(_from, _to, _value);
310   }
311 
312   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
313     return super.approve(_spender, _value);
314   }
315 
316   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
317     return super.increaseApproval(_spender, _addedValue);
318   }
319 
320   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
321     return super.decreaseApproval(_spender, _subtractedValue);
322   }
323 }
324 
325 /**
326  * @title Claimable
327  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
328  * This allows the new owner to accept the transfer.
329  */
330 contract Claimable is Ownable {
331   address public pendingOwner;
332 
333   /**
334    * @dev Modifier throws if called by any account other than the pendingOwner.
335    */
336   modifier onlyPendingOwner() {
337     require(msg.sender == pendingOwner);
338     _;
339   }
340 
341   /**
342    * @dev Allows the current owner to set the pendingOwner address.
343    * @param newOwner The address to transfer ownership to.
344    */
345   function transferOwnership(address newOwner) onlyOwner public {
346     pendingOwner = newOwner;
347   }
348 
349   /**
350    * @dev Allows the pendingOwner address to finalize the transfer.
351    */
352   function claimOwnership() onlyPendingOwner public {
353     OwnershipTransferred(owner, pendingOwner);
354     owner = pendingOwner;
355     pendingOwner = address(0);
356   }
357 }
358 
359 /**
360  * @title Coiin
361  *
362 */
363 
364 contract CoiinToken is StandardToken, Ownable, Claimable, PausableToken {
365     string public constant name = "Coiin";
366     string public constant symbol = "II";
367     uint8 public constant decimals = 2;
368 
369     event Fused();
370 
371     bool public fused = false;
372 
373    /**
374      * @dev Constructor that gives msg.sender all of existing tokens.
375      * @param _tokenBank    Address to which all the tokens are going to be debited to.
376      */
377     function CoiinToken(address _tokenBank) public {
378         require(_tokenBank != address(0));
379         
380         totalSupply_ = 1000000000001 * (10 ** uint256(decimals));
381         balances[_tokenBank] = totalSupply_;
382     }
383 
384     /** 
385     * @dev function to allow the owner to withdraw any ETH balance associated with this contract address
386     * onlyOwner can call this, so it's safe to initiate a transfer 
387     */
388     function withdraw() onlyOwner public {
389         msg.sender.transfer(this.balance);
390     }
391 
392  	/**
393  	 * @dev Modifier to make a function callable only when the contract is not fused.
394  	 */
395     modifier whenNotFused() {
396         require(!fused);
397         _;
398     }
399 
400     function pause() whenNotFused public {
401         return super.pause();
402     }
403 
404  	 /** 
405  	 * @dev Function to set the value of the fuse internal variable.  Note that there is 
406  	 * no "unfuse" functionality, by design.
407  	 */
408     function fuse() whenNotFused onlyOwner public {
409         fused = true;
410 
411         Fused();
412     }
413 }