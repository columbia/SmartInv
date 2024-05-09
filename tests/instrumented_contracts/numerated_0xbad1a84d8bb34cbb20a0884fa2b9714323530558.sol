1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20   
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40   
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61     
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
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
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 }
95 
96 
97 
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic, Ownable {
133     
134   using SafeMath for uint256;
135   
136   event TokensBurned(address from, uint256 value);
137   event TokensMinted(address to, uint256 value);
138 
139   mapping(address => uint256) balances;
140   mapping(address => bool) blacklisted;
141 
142   uint256 totalSupply_;
143 
144   /**
145   * @dev total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return totalSupply_;
149   }
150   
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(!blacklisted[msg.sender] && !blacklisted[_to]);
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     emit Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176   
177   
178   
179   function addToBlacklist(address[] _addrs) public onlyOwner returns(bool) {
180       for(uint i=0; i < _addrs.length; i++) {
181           blacklisted[_addrs[i]] = true;
182       }
183       return true;
184   }
185   
186   
187   function removeFromBlacklist(address _addr) public onlyOwner returns(bool) {
188       require(blacklisted[_addr]);
189       blacklisted[_addr] = false;
190       return true;
191   }
192   
193 
194 }
195 
196 
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(!blacklisted[_from] && !blacklisted[_to] && !blacklisted[msg.sender]);
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     require(!blacklisted[_spender] && !blacklisted[msg.sender]);
242     allowed[msg.sender][_spender] = _value;
243     emit Approval(msg.sender, _spender, _value);
244     return true;
245   }
246   
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257   
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
270     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    *
279    * approve should be called when allowed[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param _spender The address which will spend the funds.
284    * @param _subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287     uint oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue > oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 }
297 
298 
299 
300 
301 /**
302  * @title Pausable
303  * @dev Base contract which allows children to implement an emergency stop mechanism.
304  */
305 contract Pausable is Ownable {
306     
307   event Pause();
308   event Unpause();
309 
310   bool public paused = true;
311 
312 
313   /**
314    * @dev Modifier to make a function callable only when the contract is not paused
315    * or when the owner is invoking the function.
316    */
317   modifier whenNotPaused() {
318     require(!paused || msg.sender == owner);
319     _;
320   }
321   
322 
323   /**
324    * @dev Modifier to make a function callable only when the contract is paused.
325    */
326   modifier whenPaused() {
327     require(paused);
328     _;
329   }
330 
331 
332   /**
333    * @dev called by the owner to pause, triggers stopped state
334    */
335   function pause() onlyOwner whenNotPaused public {
336     paused = true;
337     emit Pause();
338   }
339   
340 
341   /**
342    * @dev called by the owner to unpause, returns to normal state
343    */
344   function unpause() onlyOwner whenPaused public {
345     paused = false;
346     emit Unpause();
347   }
348 }
349 
350 
351 
352 
353 /**
354  * @title Pausable token
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 contract PausableToken is StandardToken, Pausable {
358 
359   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
360     return super.transfer(_to, _value);
361   }
362 
363 
364   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transferFrom(_from, _to, _value);
366   }
367   
368 
369   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
370     return super.approve(_spender, _value);
371   }
372   
373 
374   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
375     return super.increaseApproval(_spender, _addedValue);
376   }
377   
378 
379   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380     return super.decreaseApproval(_spender, _subtractedValue);
381   }
382 }
383 
384 
385 
386 
387 contract LMA is PausableToken {
388     
389     string public  name;
390     string public symbol;
391     uint8 public decimals;
392     uint256 public totalSupply;
393 
394     /**
395      * Constructor initializes the name, symbol, decimals and total 
396      * supply of the token. The owner of the contract which is initially 
397      * the ICO contract will receive the entire total supply. 
398      * */
399     constructor() public {
400         name = "Lamoneda";
401         symbol = "LMA";
402         decimals = 18;
403         totalSupply = 500000000e18;
404         balances[owner] = totalSupply;
405         emit Transfer(address(this), owner, totalSupply);
406     }
407     
408     function burnFrom(address _addr, uint256 _value) public onlyOwner returns(bool) {
409         require(balanceOf(_addr) >= _value);
410         balances[_addr] = balances[_addr].sub(_value);
411         totalSupply = totalSupply.sub(_value);
412         emit Transfer(_addr, 0x0, _value);
413         emit TokensBurned(_addr, _value);
414         return true;
415     }
416   
417   
418     function mintTo(address _addr, uint256 _value) public onlyOwner returns(bool) {
419         require(!blacklisted[_addr]);
420         balances[_addr] = balances[_addr].add(_value);
421         totalSupply = totalSupply.add(_value);
422         emit Transfer(address(this), _addr, _value);
423         emit TokensMinted(_addr, _value);
424         return true;
425     }
426 }