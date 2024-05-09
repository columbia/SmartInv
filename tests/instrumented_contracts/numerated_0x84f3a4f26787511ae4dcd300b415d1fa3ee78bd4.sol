1 pragma solidity ^0.4.18;
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
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public constant returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67 
68   function div(uint256 a, uint256 b) internal constant returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public constant returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public constant returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153 
154     uint256 _allowance = allowed[_from][msg.sender];
155 
156     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
157     // require (_value <= _allowance);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = _allowance.sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * approve should be called when allowed[_spender] == 0. To increment
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    */
198   function increaseApproval (address _spender, uint _addedValue)
199     returns (bool success) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   function decreaseApproval (address _spender, uint _subtractedValue)
206     returns (bool success) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(0x0, _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 /**
264  * @title Pausable
265  * @dev Base contract which allows children to implement an emergency stop mechanism.
266  */
267 contract Pausable is Ownable {
268   event Pause();
269   event Unpause();
270 
271   bool public paused = false;
272 
273 
274   /**
275    * @dev Modifier to make a function callable only when the contract is not paused.
276    */
277   modifier whenNotPaused() {
278     require(!paused);
279     _;
280   }
281 
282   /**
283    * @dev Modifier to make a function callable only when the contract is paused.
284    */
285   modifier whenPaused() {
286     require(paused);
287     _;
288   }
289 
290   /**
291    * @dev called by the owner to pause, triggers stopped state
292    */
293   function pause() onlyOwner whenNotPaused public {
294     paused = true;
295     Pause();
296   }
297 
298   /**
299    * @dev called by the owner to unpause, returns to normal state
300    */
301   function unpause() onlyOwner whenPaused public {
302     paused = false;
303     Unpause();
304   }
305 }
306 
307 /**
308  * @title Pausable token
309  *
310  * @dev StandardToken modified with pausable transfers.
311  **/
312 
313 contract PausableToken is StandardToken, Pausable {
314 
315   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
316     return super.transfer(_to, _value);
317   }
318 
319   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
320     return super.transferFrom(_from, _to, _value);
321   }
322 
323   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
324     return super.approve(_spender, _value);
325   }
326 
327   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
328     return super.increaseApproval(_spender, _addedValue);
329   }
330 
331   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
332     return super.decreaseApproval(_spender, _subtractedValue);
333   }
334 }
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract BurnableToken is StandardToken {
341 
342     event Burn(address indexed burner, uint256 value);
343 
344     /**
345      * @dev Burns a specific amount of tokens.
346      * @param _value The amount of token to be burned.
347      */
348     function burn(uint256 _value) public {
349         require(_value > 0);
350 
351         address burner = msg.sender;
352         balances[burner] = balances[burner].sub(_value);
353         totalSupply = totalSupply.sub(_value);
354         Burn(burner, _value);
355     }
356 }
357 
358 /**
359  * @title ModulumToken
360  * @dev ModulumToken is ERC20-compilant, mintable, pausable and burnable.
361  */
362 contract ModulumToken is MintableToken, PausableToken, BurnableToken {
363 
364   // Token information
365   string public name = "Modulum Token";
366   string public symbol = "MDL";
367   uint256 public decimals = 18;
368 
369   /**
370    * @dev Contructor
371    */
372   function ModulumToken() {
373   }
374 }