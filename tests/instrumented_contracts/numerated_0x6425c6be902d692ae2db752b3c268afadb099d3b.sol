1 pragma solidity ^0.4.18;
2 
3 // ----------------- 
4 //begin Ownable.sol
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
48 //end Ownable.sol
49 // ----------------- 
50 //begin ERC20Basic.sol
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   uint256 public totalSupply;
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 //end ERC20Basic.sol
65 // ----------------- 
66 //begin SafeMath.sol
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 //end SafeMath.sol
102 // ----------------- 
103 //begin Pausable.sol
104 
105 
106 
107 /**
108  * @title Pausable
109  * @dev Base contract which allows children to implement an emergency stop mechanism.
110  */
111 contract Pausable is Ownable {
112   event Pause();
113   event Unpause();
114 
115   bool public paused = false;
116 
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is not paused.
120    */
121   modifier whenNotPaused() {
122     require(!paused);
123     _;
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is paused.
128    */
129   modifier whenPaused() {
130     require(paused);
131     _;
132   }
133 
134   /**
135    * @dev called by the owner to pause, triggers stopped state
136    */
137   function pause() onlyOwner whenNotPaused public {
138     paused = true;
139     Pause();
140   }
141 
142   /**
143    * @dev called by the owner to unpause, returns to normal state
144    */
145   function unpause() onlyOwner whenPaused public {
146     paused = false;
147     Unpause();
148   }
149 }
150 
151 //end Pausable.sol
152 // ----------------- 
153 //begin BasicToken.sol
154 
155 
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256 balance) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 //end BasicToken.sol
194 // ----------------- 
195 //begin ERC20.sol
196 
197 
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address owner, address spender) public view returns (uint256);
205   function transferFrom(address from, address to, uint256 value) public returns (bool);
206   function approve(address spender, uint256 value) public returns (bool);
207   event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 //end ERC20.sol
211 // ----------------- 
212 //begin StandardToken.sol
213 
214 
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225   mapping (address => mapping (address => uint256)) internal allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235     require(_to != address(0));
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248    *
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(address _owner, address _spender) public view returns (uint256) {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 //end StandardToken.sol
312 // ----------------- 
313 //begin MintableToken.sol
314 
315 
316 
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344     totalSupply = totalSupply.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     Mint(_to, _amount);
347     Transfer(address(0), _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() onlyOwner canMint public returns (bool) {
356     mintingFinished = true;
357     MintFinished();
358     return true;
359   }
360 }
361 
362 //end MintableToken.sol
363 // ----------------- 
364 //begin PausableToken.sol
365 
366 /**
367  * @title Pausable token
368  *
369  * @dev StandardToken modified with pausable transfers.
370  **/
371 
372 contract PausableToken is StandardToken, Pausable {
373 
374   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
375     return super.transfer(_to, _value);
376   }
377 
378   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
379     return super.transferFrom(_from, _to, _value);
380   }
381 
382   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
383     return super.approve(_spender, _value);
384   }
385 
386   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
387     return super.increaseApproval(_spender, _addedValue);
388   }
389 
390   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
391     return super.decreaseApproval(_spender, _subtractedValue);
392   }
393 }
394 
395 //end PausableToken.sol
396 // ----------------- 
397 //begin RestartEnergyToken.sol
398 
399 contract RestartEnergyToken is MintableToken, PausableToken {
400     string public name = "RED MWAT";
401     string public symbol = "MWAT";
402     uint256 public decimals = 18;
403 }
404 
405 //end RestartEnergyToken.sol