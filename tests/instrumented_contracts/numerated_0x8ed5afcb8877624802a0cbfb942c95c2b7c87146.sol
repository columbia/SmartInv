1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address _newOwner) public onlyOwner {
80     _transferOwnership(_newOwner);
81   } 
82 
83   /**
84    * @dev Transfers control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function _transferOwnership(address _newOwner) internal {
88     require(_newOwner != address(0));
89     emit OwnershipTransferred(owner, _newOwner);
90     owner = _newOwner;
91   }
92 }
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is not paused.
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is paused.
115    */
116   modifier whenPaused() {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() onlyOwner whenNotPaused public {
125     paused = true;
126     emit Pause();
127   }
128 
129   /**
130    * @dev called by the owner to unpause, returns to normal state
131    */
132   function unpause() onlyOwner whenPaused public {
133     paused = false;
134     emit Unpause();
135   }
136 }
137 
138 /**
139  * @title ERC20Basic
140  * @dev Simpler version of ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/179
142  */
143 contract ERC20Basic {
144   function totalSupply() public view returns (uint256);
145   function balanceOf(address who) public view returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public view returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 /**
162  * @title Basic token
163  * @dev Basic version of StandardToken, with no allowances.
164  */
165 contract BasicToken is ERC20Basic {
166   using SafeMath for uint256;
167 
168   mapping(address => uint256) balances;
169 
170   uint256 totalSupply_;
171 
172   /**
173   * @dev total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return totalSupply_;
177   }
178 
179   /**
180   * @dev transfer token for a specified address
181   * @param _to The address to transfer to.
182   * @param _value The amount to be transferred.
183   */
184   function transfer(address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[msg.sender]);
187 
188     // SafeMath.sub will throw if there is not enough balance.
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     emit Transfer(msg.sender, _to, _value);
192     return true;
193   }
194 
195   /**
196   * @dev Gets the balance of the specified address.
197   * @param _owner The address to query the the balance of.
198   * @return An uint256 representing the amount owned by the passed address.
199   */
200   function balanceOf(address _owner) public view returns (uint256 balance) {
201     return balances[_owner];
202   }
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 }
298 
299 /**
300  * @title Pausable token
301  * @dev StandardToken modified with pausable transfers.
302  **/
303 contract PausableToken is StandardToken, Pausable {
304 
305   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
306     return super.transfer(_to, _value);
307   }
308 
309   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
310     return super.transferFrom(_from, _to, _value);
311   }
312 
313   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
314     return super.approve(_spender, _value);
315   }
316 
317   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
318     return super.increaseApproval(_spender, _addedValue);
319   }
320 
321   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success){
322     return super.decreaseApproval(_spender, _subtractedValue);
323   }
324 }
325 
326 contract ZhiXinToken is PausableToken {
327   string public constant name = "ZhiXin Token";
328   string public constant symbol = "ZXT";
329   uint public constant decimals = 18;
330   uint public constant INITIAL_SUPPLY = 50 * (10 ** 8) * 10 ** uint(decimals);
331 
332   constructor(address admin) public {
333     totalSupply_ = INITIAL_SUPPLY;
334     balances[admin] = totalSupply_;
335     emit Transfer(address(0x0), admin, totalSupply_);
336   }
337 }