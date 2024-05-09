1 pragma solidity ^0.4.18;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 /**
43  * @title Pausable
44  * @dev Base contract which allows children to implement an emergency stop mechanism.
45  */
46 contract Pausable is Ownable {
47   event Pause();
48   event Unpause();
49 
50   bool public paused = false;
51 
52   /**
53    * @dev Modifier to make a function callable only when the contract is not paused.
54    */
55   modifier whenNotPaused() {
56     require(!paused);
57     _;
58   }
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is paused.
62    */
63   modifier whenPaused() {
64     require(paused);
65     _;
66   }
67 
68   /**
69    * @dev called by the owner to pause, triggers stopped state
70    */
71   function pause() onlyOwner whenNotPaused public {
72     paused = true;
73     Pause();
74   }
75 
76   /**
77    * @dev called by the owner to unpause, returns to normal state
78    */
79   function unpause() onlyOwner whenPaused public {
80     paused = false;
81     Unpause();
82   }
83 }
84 
85 // File: zeppelin-solidity/contracts/math/SafeMath.sol
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   function div(uint256 a, uint256 b) internal pure returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106   }
107 
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint256 a, uint256 b) internal pure returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public;
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 // File: zeppelin-solidity/contracts/token/BasicToken.sol
135 
136 /**
137  * @title Basic token
138  * @dev Basic version of StandardToken, with no allowances.
139  */
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) balances;
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public {
151     require(_to != address(0));
152     require(_value <= balances[msg.sender]);
153 
154     // SafeMath.sub will throw if there is not enough balance.
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     Transfer(msg.sender, _to, _value);
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 // File: zeppelin-solidity/contracts/token/ERC20.sol
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public;
180   function approve(address spender, uint256 value) public;
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: zeppelin-solidity/contracts/token/StandardToken.sol
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     Transfer(_from, _to, _value);
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273   }
274 
275 }
276 
277 // File: zeppelin-solidity/contracts/token/PausableToken.sol
278 
279 /**
280  * @title Pausable token
281  *
282  * @dev StandardToken modified with pausable transfers.
283  **/
284 
285 contract PausableToken is StandardToken, Pausable {
286 
287   function transfer(address _to, uint256 _value) public whenNotPaused {
288     return super.transfer(_to, _value);
289   }
290 
291   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused {
292     return super.transferFrom(_from, _to, _value);
293   }
294 
295   function approve(address _spender, uint256 _value) public whenNotPaused {
296     return super.approve(_spender, _value);
297   }
298 
299   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused {
300     return super.increaseApproval(_spender, _addedValue);
301   }
302 
303   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused {
304     return super.decreaseApproval(_spender, _subtractedValue);
305   }
306 }
307 
308 // File: contracts/Zhennong.sol
309 // *
310 // 真农庄园平台是一个具有创新性、革命性的生态农庄经营权数字证券化交易平台
311 // 真农庄园平台为用户提供基于区块链的生态农庄经营权数字证券化、生态农庄经营权数字化、融资、信任、激励、交易与共享解决方案
312 // 真农庄园平台具有公平、公开、安全、高效等特性，同时该平台也将是传统农庄经营方式在区块链应用中的升级。
313 // 即：该平台将为生态共享农庄经营权数字证券化，将会为更多的生态共享农庄、产业技术团队孵化的摇篮。
314 /// @title Zhennong Contract
315 contract Zhennong is PausableToken {
316     using SafeMath for uint256;
317 
318     /// Constant token specific fields
319     string public constant name = "真农庄园";
320     string public constant symbol = "工分";
321     uint256 public constant decimals = 18;
322 
323     /**
324      * CONSTRUCTOR 
325      * 
326      */
327     function Zhennong(address _owner) 
328         public 
329         {
330         totalSupply = 580000000000000000000000000;
331         owner = _owner;
332         paused = false;
333         
334         balances[owner] = totalSupply;
335         Transfer(address(0), owner, totalSupply);
336         
337     }
338 }