1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin/ownership/Ownable.sol
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
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal constant returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: zeppelin/token/ERC20Basic.sol
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 // File: zeppelin/token/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 // File: zeppelin/token/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public constant returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 // File: zeppelin/token/StandardToken.sol
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     uint256 _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval (address _spender, uint _addedValue)
211     returns (bool success) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval (address _spender, uint _subtractedValue)
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 // File: zeppelin/token/MintableToken.sol
232 
233 /**
234  * @title Mintable token
235  * @dev Simple ERC20 Token example, with mintable token creation
236  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
237  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
238  */
239 
240 contract MintableToken is StandardToken, Ownable {
241   event Mint(address indexed to, uint256 amount);
242   event MintFinished();
243 
244   bool public mintingFinished = false;
245 
246 
247   modifier canMint() {
248     require(!mintingFinished);
249     _;
250   }
251 
252   /**
253    * @dev Function to mint tokens
254    * @param _to The address that will receive the minted tokens.
255    * @param _amount The amount of tokens to mint.
256    * @return A boolean that indicates if the operation was successful.
257    */
258   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
259     totalSupply = totalSupply.add(_amount);
260     balances[_to] = balances[_to].add(_amount);
261     Mint(_to, _amount);
262     Transfer(0x0, _to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner public returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 // File: zeppelin/lifecycle/Pausable.sol
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284   event Pause();
285   event Unpause();
286 
287   bool public paused = false;
288 
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!paused);
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(paused);
303     _;
304   }
305 
306   /**
307    * @dev called by the owner to pause, triggers stopped state
308    */
309   function pause() onlyOwner whenNotPaused public {
310     paused = true;
311     Pause();
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() onlyOwner whenPaused public {
318     paused = false;
319     Unpause();
320   }
321 }
322 
323 // File: zeppelin/token/PausableToken.sol
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
354 // File: contracts/NILToken.sol
355 
356 contract NILToken is MintableToken, PausableToken {
357 
358   string public name = "NIL Token";
359 
360   string public symbol = "NIL";
361 
362   uint8 public decimals = 9;
363 
364 }