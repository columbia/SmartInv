1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
118 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
119 
120 contract DetailedERC20 is ERC20 {
121   string public name;
122   string public symbol;
123   uint8 public decimals;
124 
125   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
126     name = _name;
127     symbol = _symbol;
128     decimals = _decimals;
129   }
130 }
131 
132 // File: zeppelin-solidity/contracts/math/SafeMath.sol
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139 
140   /**
141   * @dev Multiplies two numbers, throws on overflow.
142   */
143   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144     if (a == 0) {
145       return 0;
146     }
147     uint256 c = a * b;
148     assert(c / a == b);
149     return c;
150   }
151 
152   /**
153   * @dev Integer division of two numbers, truncating the quotient.
154   */
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // assert(b > 0); // Solidity automatically throws when dividing by 0
157     uint256 c = a / b;
158     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159     return c;
160   }
161 
162   /**
163   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
164   */
165   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166     assert(b <= a);
167     return a - b;
168   }
169 
170   /**
171   * @dev Adds two numbers, throws on overflow.
172   */
173   function add(uint256 a, uint256 b) internal pure returns (uint256) {
174     uint256 c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
181 
182 /**
183  * @title Basic token
184  * @dev Basic version of StandardToken, with no allowances.
185  */
186 contract BasicToken is ERC20Basic {
187   using SafeMath for uint256;
188 
189   mapping(address => uint256) balances;
190 
191   uint256 totalSupply_;
192 
193   /**
194   * @dev total number of tokens in existence
195   */
196   function totalSupply() public view returns (uint256) {
197     return totalSupply_;
198   }
199 
200   /**
201   * @dev transfer token for a specified address
202   * @param _to The address to transfer to.
203   * @param _value The amount to be transferred.
204   */
205   function transfer(address _to, uint256 _value) public returns (bool) {
206     require(_to != address(0));
207     require(_value <= balances[msg.sender]);
208 
209     // SafeMath.sub will throw if there is not enough balance.
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public view returns (uint256 balance) {
222     return balances[_owner];
223   }
224 
225 }
226 
227 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
228 
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    *
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(address _owner, address _spender) public view returns (uint256) {
282     return allowed[_owner][_spender];
283   }
284 
285   /**
286    * @dev Increase the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _addedValue The amount of tokens to increase the allowance by.
294    */
295   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
296     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312     uint oldValue = allowed[msg.sender][_spender];
313     if (_subtractedValue > oldValue) {
314       allowed[msg.sender][_spender] = 0;
315     } else {
316       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317     }
318     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322 }
323 
324 // File: contracts/BlockRxToken.sol
325 
326 /** @title BlockRx Digital Token */
327 contract BlockRxToken is DetailedERC20("BlockRx Digital Token", "BKRx", 18), Pausable, StandardToken {
328   using SafeMath for uint256;
329 
330   event Burned(address indexed from, uint256 cents);
331 
332   uint256 public totalSupply; // in BKRx Cents
333   
334   /**
335    * @dev Creates the BlockRx Digital Token (BKRx) with given total supply.
336    * @param _totalSupplyCents total token supply given in BKRx Cents.
337    */
338   function BlockRxToken(uint256 _totalSupplyCents) public {
339     require(_totalSupplyCents > 0);
340     totalSupply = _totalSupplyCents;
341     balances[msg.sender] = totalSupply;
342 
343     pause();
344   }
345 
346   /**
347    * @dev Owner only function for manual assignment of tokens.
348    * Transfers owner's tokens to requested address.
349    * @param _to The address to transfer to.
350    * @param _cents The amount to be transferred given in BKRx Cents.
351    */
352   function assignTokens(address _to, uint256 _cents) public onlyOwner {
353     require(_to != address(0));
354     require(_cents > 0);
355     super.transfer(_to, _cents);
356   }
357 
358   /**
359    * @dev Burns requested amount of sender's tokens.
360    * @param _cents The amount to be burned given in BKRx Cents.
361    */
362   function burn(uint256 _cents) public whenNotPaused {
363     require(_cents > 0);
364 
365     balances[msg.sender] = balanceOf(msg.sender).sub(_cents);
366     totalSupply = totalSupply.sub(_cents);
367 
368     Burned(msg.sender, _cents);
369     // for etherscan.io event tracking
370     Transfer(msg.sender, 0x0, _cents);
371   }
372 
373   // PausableToken functions copied to allow assignTokens() to use super.transfer() even when paused
374 
375   function transfer(address _to, uint256 _cents) public whenNotPaused returns (bool) {
376     return super.transfer(_to, _cents);
377   }
378 
379   function transferFrom(address _from, address _to, uint256 _cents) public whenNotPaused returns (bool) {
380     return super.transferFrom(_from, _to, _cents);
381   }
382 
383   function approve(address _spender, uint256 _cents) public whenNotPaused returns (bool) {
384     return super.approve(_spender, _cents);
385   }
386 
387   function increaseApproval(address _spender, uint _addedCents) public whenNotPaused returns (bool success) {
388     return super.increaseApproval(_spender, _addedCents);
389   }
390 
391   function decreaseApproval(address _spender, uint _subtractedCents) public whenNotPaused returns (bool success) {
392     return super.decreaseApproval(_spender, _subtractedCents);
393   }
394 }