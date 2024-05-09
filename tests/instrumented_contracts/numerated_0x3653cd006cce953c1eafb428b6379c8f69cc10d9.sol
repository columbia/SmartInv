1 pragma solidity ^0.4.15;
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
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Contracts that should not own Ether
47  * @author Remco Bloemen <remco@2π.com>
48  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
49  * in the contract, it will allow the owner to reclaim this ether.
50  * @notice Ether can still be send to this contract by:
51  * calling functions labeled `payable`
52  * `selfdestruct(contract_address)`
53  * mining directly to the contract address
54 */
55 contract HasNoEther is Ownable {
56 
57   /**
58   * @dev Constructor that rejects incoming Ether
59   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
60   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
61   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
62   * we could use assembly to access msg.value.
63   */
64   function HasNoEther() payable {
65     require(msg.value == 0);
66   }
67 
68   /**
69    * @dev Disallows direct send by settings a default function without the `payable` flag.
70    */
71   function() external {
72   }
73 
74   /**
75    * @dev Transfer all Ether held by the contract to the owner.
76    */
77   function reclaimEther() external onlyOwner {
78     assert(owner.send(this.balance));
79   }
80 }
81 
82 /**
83  * @title ERC20Basic
84  * @dev Simpler version of ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/179
86  */
87 contract ERC20Basic {
88   uint256 public totalSupply;
89   function balanceOf(address who) public constant returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract DetailedERC20 is ERC20 {
106   string public name;
107   string public symbol;
108   uint8 public decimals;
109 
110   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
111     name = _name;
112     symbol = _symbol;
113     decimals = _decimals;
114   }
115 }
116 
117 contract IAMPTToken is DetailedERC20("AMPT Token", "AMPT", 6) {
118 }
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that throw on error
123  */
124 library SafeMath {
125   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
126     uint256 c = a * b;
127     assert(a == 0 || c / a == b);
128     return c;
129   }
130 
131   function div(uint256 a, uint256 b) internal constant returns (uint256) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return c;
136   }
137 
138   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   function add(uint256 a, uint256 b) internal constant returns (uint256) {
144     uint256 c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) balances;
158 
159   /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[msg.sender]);
167 
168     // SafeMath.sub will throw if there is not enough balance.
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public constant returns (uint256 balance) {
181     return balances[_owner];
182   }
183 
184 }
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
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public constant returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 /**
282  * @title Pausable
283  * @dev Base contract which allows children to implement an emergency stop mechanism.
284  */
285 contract Pausable is Ownable {
286   event Pause();
287   event Unpause();
288 
289   bool public paused = false;
290 
291 
292   /**
293    * @dev Modifier to make a function callable only when the contract is not paused.
294    */
295   modifier whenNotPaused() {
296     require(!paused);
297     _;
298   }
299 
300   /**
301    * @dev Modifier to make a function callable only when the contract is paused.
302    */
303   modifier whenPaused() {
304     require(paused);
305     _;
306   }
307 
308   /**
309    * @dev called by the owner to pause, triggers stopped state
310    */
311   function pause() onlyOwner whenNotPaused public {
312     paused = true;
313     Pause();
314   }
315 
316   /**
317    * @dev called by the owner to unpause, returns to normal state
318    */
319   function unpause() onlyOwner whenPaused public {
320     paused = false;
321     Unpause();
322   }
323 }
324 
325 /**
326  * @title Pausable token
327  *
328  * @dev StandardToken modified with pausable transfers.
329  **/
330 
331 contract PausableToken is StandardToken, Pausable {
332 
333   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
334     return super.transfer(_to, _value);
335   }
336 
337   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
338     return super.transferFrom(_from, _to, _value);
339   }
340 
341   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
342     return super.approve(_spender, _value);
343   }
344 
345   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
346     return super.increaseApproval(_spender, _addedValue);
347   }
348 
349   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
350     return super.decreaseApproval(_spender, _subtractedValue);
351   }
352 }
353 
354 contract AMPTToken is HasNoEther, IAMPTToken, PausableToken {
355     function AMPTToken() public {
356         totalSupply = 1000000000 * (10 ** uint256(decimals));
357         owner = msg.sender;
358         balances[owner] = totalSupply;
359     }
360 }