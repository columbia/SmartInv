1 pragma solidity ^0.4.18;
2 
3 
4 //该合约参考自openzeppelin的开源代码
5 //1.使用SafeMath库防止运算溢出
6 //2.使用Ownable,Pausable合约来做权限控制
7 //3.ERC20Basic,ERC20都是接口，ERC20扩展了ERC20Basic，实现了授权转移
8 //4.BasicToken,StandardToken,PausableToken是具体实现
9 //
10 
11 
12 /**
13  * 
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19   function totalSupply() public view returns (uint256);
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230 //   function Ownable() public {
231 //     owner = msg.sender;
232 //   }
233    constructor() public {
234       owner = msg.sender;
235   }
236 
237 
238   /**
239    * @dev Throws if called by any account other than the owner.
240    */
241   modifier onlyOwner() {
242     require(msg.sender == owner);
243     _;
244   }
245 
246 
247   /**
248    * @dev Allows the current owner to transfer control of the contract to a newOwner.
249    * @param newOwner The address to transfer ownership to.
250    */
251   function transferOwnership(address newOwner) public onlyOwner {
252     require(newOwner != address(0));
253     emit OwnershipTransferred(owner, newOwner);
254     owner = newOwner;
255   }
256 
257 }
258 
259 
260 
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is not paused.
274    */
275   modifier whenNotPaused() {
276     require(!paused);
277     _;
278   }
279 
280   /**
281    * @dev Modifier to make a function callable only when the contract is paused.
282    */
283   modifier whenPaused() {
284     require(paused);
285     _;
286   }
287 
288   /**
289    * @dev called by the owner to pause, triggers stopped state
290    */
291   function pause() onlyOwner whenNotPaused public {
292     paused = true;
293     emit Pause();
294   }
295 
296   /**
297    * @dev called by the owner to unpause, returns to normal state
298    */
299   function unpause() onlyOwner whenPaused public {
300     paused = false;
301     emit Unpause();
302   }
303 }
304 
305 /**
306  * @title Pausable token
307  * @dev StandardToken modified with pausable transfers.
308  **/
309 contract PausableToken is StandardToken, Pausable {
310 
311   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
312     return super.transfer(_to, _value);
313   }
314 
315   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
316     return super.transferFrom(_from, _to, _value);
317   }
318 
319   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
320     return super.approve(_spender, _value);
321   }
322 
323   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
324     return super.increaseApproval(_spender, _addedValue);
325   }
326 
327   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
328     return super.decreaseApproval(_spender, _subtractedValue);
329   }
330 }
331 
332 
333 
334 contract HPPOToken is PausableToken {
335     string  public  constant name = "HPPO";
336     string  public  constant symbol = "HPPO";
337     uint8   public  constant decimals = 18;
338 
339     modifier validDestination( address to )
340     {
341         require(to != address(0x0));
342         require(to != address(this));
343         _;
344     }
345 
346     constructor ( uint _totalTokenAmount ) public
347     {
348 
349         totalSupply_ = _totalTokenAmount;
350         balances[msg.sender] = _totalTokenAmount;
351         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
352     }
353 
354     //转移token
355     function transfer(address _to, uint _value) public validDestination(_to) returns (bool) 
356     {
357         return super.transfer(_to, _value);
358     }
359 
360     //转移别人授权给自己的token
361     function transferFrom(address _from, address _to, uint _value) public validDestination(_to) returns (bool) 
362     {
363         return super.transferFrom(_from, _to, _value);
364     }
365 
366     event Burn(address indexed _burner, uint _value);
367 
368    
369      //销毁token
370     function burn(uint _value) public returns (bool)
371     {
372         balances[msg.sender] = balances[msg.sender].sub(_value);
373         totalSupply_ = totalSupply_.sub(_value);
374         emit Burn(msg.sender, _value);
375         emit Transfer(msg.sender, address(0x0), _value);
376         return true;
377     }
378 
379     // 销毁别人授权的token
380     function burnFrom(address _from, uint256 _value) public returns (bool) 
381     {
382         assert( transferFrom( _from, msg.sender, _value ) );
383         return burn(_value);
384     }
385 
386     //转移合约的所有权给新的地址
387     function transferOwnership(address newOwner) public  {
388         super.transferOwnership(newOwner);
389     }
390 
391     //合约所有者可以增发token
392     function addTotalSupply(uint256 _value) public onlyOwner {
393     	totalSupply_ = totalSupply_.add(_value);
394     	balances[msg.sender]=balances[msg.sender].add(_value);
395     	emit Transfer(address(0x0), msg.sender, _value);
396     }
397 }