1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Pausable is Ownable {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    */
79   modifier whenNotPaused() {
80     require(!paused);
81     _;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is paused.
86    */
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   /**
93    * @dev called by the owner to pause, triggers stopped state
94    */
95   function pause() onlyOwner whenNotPaused public {
96     paused = true;
97     Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused public {
104     paused = false;
105     Unpause();
106   }
107 }
108 
109 contract Freezable is Ownable {
110 
111   mapping (address => bool) public frozenAccount;
112   event FrozenFunds(address indexed target, bool frozen);
113 
114   /**
115   * @dev freeze an account
116   * @param _target Address to be change frozen status. 
117   */    
118   
119   function freezeAccount(address _target) public onlyOwner {
120       frozenAccount[_target] = true;
121       FrozenFunds(_target, true);
122   }  
123   
124   /**
125   * @dev unfreeze an account
126   * @param _target Address to be change frozen status.  
127   */    
128   
129   function unfreezeAccount(address _target) public onlyOwner {
130       frozenAccount[_target] = false;
131       FrozenFunds(_target, false);
132   }
133   
134 }
135 
136 contract ERC20Basic {
137   uint256 public totalSupply;
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender) public view returns (uint256);
145   function transferFrom(address from, address to, uint256 value) public returns (bool);
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[msg.sender]);
163 
164     // SafeMath.sub will throw if there is not enough balance.
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256 balance) {
177     return balances[_owner];
178   }
179 }
180 
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) public view returns (uint256) {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 }
267 
268 /**
269  * @title Burnable Token
270  * @dev Token that can be irreversibly burned (destroyed).
271  */
272 contract BurnableToken is StandardToken, Ownable {
273 
274   event Burn(address indexed burner, uint256 value);
275 
276   /**
277    * @dev Burns a specific amount of tokens.
278    * @param _value The amount of token to be burned.
279    */
280   function burn(uint256 _value) onlyOwner public {
281     require(_value <= balances[msg.sender]);
282     // no need to require value <= totalSupply, since that would imply the
283     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
284 
285     address burner = msg.sender;
286     balances[burner] = balances[burner].sub(_value);
287     totalSupply = totalSupply.sub(_value);
288     Burn(burner, _value);
289   }
290 }
291 
292 contract PausableToken is StandardToken, Pausable, Freezable {
293 
294   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
295     require(!frozenAccount[msg.sender]);                // Check if sender is frozen
296     require(!frozenAccount[_to]);                       // Check if recipient is frozen
297 	return super.transfer(_to, _value);
298   }
299 
300   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
301     require(!frozenAccount[_from]);                     // Check if sender is frozen
302     require(!frozenAccount[_to]);                       // Check if recipient is frozen
303     return super.transferFrom(_from, _to, _value);
304   }
305 
306   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
307     return super.approve(_spender, _value);
308   }
309 
310   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
311     return super.increaseApproval(_spender, _addedValue);
312   }
313 
314   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
315     return super.decreaseApproval(_spender, _subtractedValue);
316   }
317 }
318 
319 contract PuJaDaToken is PausableToken, BurnableToken {
320   string public name = "PuJaDa";
321   string public symbol = "PJD";
322   uint public decimals = 18;
323   uint256 public INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
324   
325   
326   function PuJaDaToken() public {
327     totalSupply = INITIAL_SUPPLY;
328     balances[msg.sender] = INITIAL_SUPPLY;
329     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
330   }
331 }