1 pragma solidity ^0.4.13;
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
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
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
184     // SafeMath.sub will throw if there is not enough balance.
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256 balance) {
197     return balances[_owner];
198   }
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
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
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 }
294 
295 /**
296  * @title srOwnable
297  * @dev The srOwnable contract has an owner address, and provides basic authorization control
298  * functions, this simplifies the implementation of "user permissions".
299  */
300 contract srOwnable is Ownable {
301 
302   address public newOwner;
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to an otherOwner.
306    * @param otherOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address otherOwner) onlyOwner {
309     require(otherOwner != address(0));      
310     newOwner = otherOwner;
311   }
312 
313   /**
314    * @dev Finish ownership transfer.
315    */
316   function approveOwnership() {
317     require(msg.sender == newOwner);
318     OwnershipTransferred(owner, newOwner);
319     owner = newOwner;
320     newOwner = address(0);
321   }
322 }
323 
324 /**
325  * @title srPausable
326  * @dev Slightly modified implementation of an emergency stop mechanism.
327  */
328 contract srPausable is Pausable {
329   /**
330    * @dev called by the owner or moderator to pause, triggers stopped state
331    */
332   function pause() onlyOwner whenNotPaused {
333     paused = true;
334     Pause();
335   }
336 
337   /**
338    * @dev called by the owner or moderator to unpause, returns to normal state
339    */
340   function unpause() onlyOwner whenPaused {
341     paused = false;
342     Unpause();
343   }
344 }
345 
346 /**
347  * Pausable token with moderator role and freeze address implementation
348  *
349  **/
350 contract srToken is StandardToken, srPausable, srOwnable {
351 
352   mapping(address => bool) frozen;
353 
354   /**
355    * @dev Allows transfers only when contract is not paused.
356    * @param _to address The address which you want to transfer to
357    * @param _value uint256 the amout of tokens to be transfered
358    */
359   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
360     return super.transfer(_to, _value);    
361   }
362 
363   /**
364    * @dev Allows transfers only when contract is not paused.
365    * @param _from address The address which you want to send tokens from
366    * @param _to address The address which you want to transfer to
367    * @param _value uint256 the amout of tokens to be transfered
368    */
369   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
370     return super.transferFrom(_from, _to, _value);
371   }
372 
373   /**
374    * @dev Allows owner to transfer tokens from one address to another.
375    * @param _from address The address which you want to send tokens from
376    * @param _to address The address which you want to transfer to
377    * @param _value uint256 the amout of tokens to be transfered
378    */
379   function ownerTransferFrom(address _from, address _to, uint256 _value) onlyOwner returns (bool) {
380     balances[_to] = balances[_to].add(_value);
381     balances[_from] = balances[_from].sub(_value);
382     Transfer(_from, _to, _value);
383     return true;
384   }
385 }
386 
387 /**
388  * testc Token
389  **/
390 contract testc is srToken {
391   string public constant version = "0.1";
392   string public constant name = "testc";
393   string public constant symbol = "$tc";
394   uint256 public constant decimals = 2;
395 
396   // fallback function can be used to buy tokens
397   function () external payable {
398     if(msg.value > 0){
399         totalSupply_ = totalSupply_.add(msg.value);
400         balances[msg.sender] = balances[msg.sender].add(msg.value);
401         Transfer(address(0), msg.sender, msg.value);        
402     }
403   }
404 
405   /**
406    * @dev Constructor that gives msg.sender all of existing tokens.
407    */
408   function testc() {
409     uint256 _initialSupply = 0;
410     totalSupply_ = _initialSupply;
411     balances[msg.sender] = _initialSupply;
412   }
413 }