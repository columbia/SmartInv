1 pragma solidity ^0.4.23;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   constructor() public {
8     owner = msg.sender;
9   }
10 
11   modifier restricted() {
12     if (msg.sender == owner) _;
13   }
14 
15   function setCompleted(uint completed) public restricted {
16     last_completed_migration = completed;
17   }
18 
19   function upgrade(address new_address) public restricted {
20     Migrations upgraded = Migrations(new_address);
21     upgraded.setCompleted(last_completed_migration);
22   }
23 }
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     emit OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67   /**
68    * @dev Allows the current owner to relinquish control of the contract.
69    */
70   function renounceOwnership() public onlyOwner {
71     emit OwnershipRenounced(owner);
72     owner = address(0);
73   }
74 }
75 
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     if (a == 0) {
89       return 0;
90     }
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   function totalSupply() public view returns (uint256);
133   function balanceOf(address who) public view returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender)
144     public view returns (uint256);
145 
146   function transferFrom(address from, address to, uint256 value)
147     public returns (bool);
148 
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(
151     address indexed owner,
152     address indexed spender,
153     uint256 value
154   );
155 }
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
166   uint256 totalSupply_;
167 
168   /**
169   * @dev total number of tokens in existence
170   */
171   function totalSupply() public view returns (uint256) {
172     return totalSupply_;
173   }
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[msg.sender]);
183 
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     emit Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(
219     address _from,
220     address _to,
221     uint256 _value
222   )
223     public
224     returns (bool)
225   {
226     require(_to != address(0));
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    *
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(
260     address _owner,
261     address _spender
262    )
263     public
264     view
265     returns (uint256)
266   {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    *
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(
304     address _spender,
305     uint _subtractedValue
306   )
307     public
308     returns (bool)
309   {
310     uint oldValue = allowed[msg.sender][_spender];
311     if (_subtractedValue > oldValue) {
312       allowed[msg.sender][_spender] = 0;
313     } else {
314       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315     }
316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317     return true;
318   }
319 
320 }
321 
322 
323 
324  /**
325  * @title OpetToken token
326  * @dev Simple ERC20 Token example, with paused transfer and whitelisting
327  */
328 contract OpetToken is StandardToken, Ownable {
329 
330   string public constant name = "Opet Token";
331   string public constant symbol = "OPET";
332   uint32 public constant decimals = 18;
333 
334   bool public transferPaused = true;
335 
336   mapping(address => bool) public whitelistedTransfer;
337   mapping(address => bool) public tokenLockedAddresses;
338 
339   constructor() public {
340     balances[msg.sender] = 100000000 * (10 ** uint(decimals));
341     totalSupply_ = balances[msg.sender];
342     emit Transfer(address(0), msg.sender, balances[msg.sender]);
343   }
344 
345   // The modifier checks, if address can send tokens or not at current contract state.
346   modifier transferable() {
347     require(!transferPaused || whitelistedTransfer[msg.sender] || msg.sender == owner);
348     require(!tokenLockedAddresses[msg.sender]);
349     _;
350   }
351 
352   /**
353    * @dev Function to unpause transfer restriction
354    */
355   function unpauseTransfer() onlyOwner public {
356     transferPaused = false;
357   }
358 
359 
360   function transferFrom(address _from, address _to, uint256 _value) transferable public returns (bool) {
361       return super.transferFrom(_from, _to, _value);
362   }
363 
364   function transfer(address _to, uint256 _value) transferable public returns (bool) {
365     return super.transfer(_to, _value);
366   }
367 
368   function sendAirdrops(address[] _addresses, uint256[] _amounts) public {
369     require(_addresses.length == _amounts.length);
370     for(uint i = 0; i < _addresses.length; i++){
371       transfer(_addresses[i], _amounts[i]);
372     }
373   }
374 
375   function addWhitelistedTransfer(address[] _addresses) public onlyOwner {
376     for(uint i = 0; i < _addresses.length; i++){
377       whitelistedTransfer[_addresses[i]] = true;
378     }
379   }
380 
381   function removeWhitelistedTransfer(address[] _addresses) public onlyOwner {
382     for(uint i = 0; i < _addresses.length; i++){
383       whitelistedTransfer[_addresses[i]] = false;
384     }
385   }
386 
387   function addToTokenLocked(address[] _addresses) public onlyOwner {
388     for(uint i = 0; i < _addresses.length; i++){
389       tokenLockedAddresses[_addresses[i]] = true;
390     }
391   }
392 
393   function removeFromTokenLocked(address[] _addresses) public onlyOwner {
394     for(uint i = 0; i < _addresses.length; i++){
395       tokenLockedAddresses[_addresses[i]] = false;
396     }
397   }
398 }