1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * 
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     emit Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * @dev Increase the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _addedValue The amount of tokens to increase the allowance by.
174    */
175   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   /**
182    * @dev Decrease the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To decrement
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _subtractedValue The amount of tokens to decrease the allowance by.
190    */
191   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 
205 
206 /**
207  * @title Ownable
208  * @dev The Ownable contract has an owner address, and provides basic authorization control
209  * functions, this simplifies the implementation of "user permissions".
210  */
211 contract Ownable {
212   address public owner;
213 
214 
215   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217 
218   /**
219    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
220    * account.
221    */
222 //   function Ownable() public {
223 //     owner = msg.sender;
224 //   }
225    constructor() public {
226       owner = msg.sender;
227   }
228 
229 
230   /**
231    * @dev Throws if called by any account other than the owner.
232    */
233   modifier onlyOwner() {
234     require(msg.sender == owner);
235     _;
236   }
237 
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     require(newOwner != address(0));
245     emit OwnershipTransferred(owner, newOwner);
246     owner = newOwner;
247   }
248 
249 }
250 
251 
252 
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
264   /**
265    * @dev Modifier to make a function callable only when the contract is not paused.
266    */
267   modifier whenNotPaused() {
268     require(!paused);
269     _;
270   }
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is paused.
274    */
275   modifier whenPaused() {
276     require(paused);
277     _;
278   }
279 
280   /**
281    * @dev called by the owner to pause, triggers stopped state
282    */
283   function pause() onlyOwner whenNotPaused public {
284     paused = true;
285     emit Pause();
286   }
287 
288   /**
289    * @dev called by the owner to unpause, returns to normal state
290    */
291   function unpause() onlyOwner whenPaused public {
292     paused = false;
293     emit Unpause();
294   }
295 }
296 
297 /**
298  * @title Pausable token
299  * @dev StandardToken modified with pausable transfers.
300  **/
301 contract PausableToken is StandardToken, Pausable {
302 
303   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
304     return super.transfer(_to, _value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transferFrom(_from, _to, _value);
309   }
310 
311   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
312     return super.approve(_spender, _value);
313   }
314 
315   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
316     return super.increaseApproval(_spender, _addedValue);
317   }
318 
319   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
320     return super.decreaseApproval(_spender, _subtractedValue);
321   }
322 }
323 
324 
325 
326 contract TBCToken is PausableToken {
327     string  public  constant name = "Talent Business Coin";
328     string  public  constant symbol = "TBC";
329     uint8   public  constant decimals = 18;
330 
331     modifier validDestination( address to )
332     {
333         require(to != address(0x0));
334         require(to != address(this));
335         _;
336     }
337 
338     constructor ( uint _totalTokenAmount ) public
339     {
340 
341         totalSupply_ = _totalTokenAmount;
342         balances[msg.sender] = _totalTokenAmount;
343         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
344     }
345 
346     //转移token
347     function transfer(address _to, uint _value) public validDestination(_to) returns (bool) 
348     {
349         return super.transfer(_to, _value);
350     }
351 
352     //转移别人授权给自己的token
353     function transferFrom(address _from, address _to, uint _value) public validDestination(_to) returns (bool) 
354     {
355         return super.transferFrom(_from, _to, _value);
356     }
357 
358     event Burn(address indexed _burner, uint _value);
359 
360    
361      //销毁token
362     function burn(uint _value) public returns (bool)
363     {
364         balances[msg.sender] = balances[msg.sender].sub(_value);
365         totalSupply_ = totalSupply_.sub(_value);
366         emit Burn(msg.sender, _value);
367         emit Transfer(msg.sender, address(0x0), _value);
368         return true;
369     }
370 
371     // 销毁别人授权的token
372     function burnFrom(address _from, uint256 _value) public returns (bool) 
373     {
374         assert( transferFrom( _from, msg.sender, _value ) );
375         return burn(_value);
376     }
377 
378     //转移合约的所有权给新的地址
379     function transferOwnership(address newOwner) public  {
380         super.transferOwnership(newOwner);
381     }
382 
383     //合约所有者可以增发token
384     function addTotalSupply(uint256 _value) public onlyOwner {
385     	totalSupply_ = totalSupply_.add(_value);
386     	balances[msg.sender]=balances[msg.sender].add(_value);
387     	emit Transfer(address(0x0), msg.sender, _value);
388     }
389 }