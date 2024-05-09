1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   /**
68   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) public view returns (uint256);
134   function transferFrom(address from, address to, uint256 value) public returns (bool);
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   uint256 totalSupply_;
147 
148   /**
149   * @dev total number of tokens in existence
150   */
151   function totalSupply() public view returns (uint256) {
152     return totalSupply_;
153   }
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
179 
180 }
181 
182 
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 
272 contract DetailedERC20 is ERC20 {
273   string public name;
274   string public symbol;
275   uint8 public decimals;
276 
277   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
278     name = _name;
279     symbol = _symbol;
280     decimals = _decimals;
281   }
282 }
283 
284 contract BurnableToken is BasicToken {
285 
286   event Burn(address indexed burner, uint256 value);
287 
288   /**
289    * @dev Burns a specific amount of tokens.
290    * @param _value The amount of token to be burned.
291    */
292   function burn(uint256 _value) public {
293     require(_value <= balances[msg.sender]);
294     // no need to require value <= totalSupply, since that would imply the
295     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
296 
297     address burner = msg.sender;
298     balances[burner] = balances[burner].sub(_value);
299     totalSupply_ = totalSupply_.sub(_value);
300     Burn(burner, _value);
301   }
302 }
303 
304 contract PausableToken is StandardToken, Pausable {
305 
306   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
307     return super.transfer(_to, _value);
308   }
309 
310   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
315     return super.approve(_spender, _value);
316   }
317 
318   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
319     return super.increaseApproval(_spender, _addedValue);
320   }
321 
322   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
323     return super.decreaseApproval(_spender, _subtractedValue);
324   }
325 }
326 
327 contract VUToken is DetailedERC20, BurnableToken, PausableToken {
328     using SafeMath for uint256;
329 
330     uint public constant INITIAL_SUPPLY = 1000000000 * (10**18);
331 
332     /**
333     * @dev Constructor
334     */
335     function VUToken() public
336     DetailedERC20("VU TOKEN", "VU", 18)
337     {
338         totalSupply_ = INITIAL_SUPPLY;
339 
340         balances[msg.sender] = INITIAL_SUPPLY;
341         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
342     }
343 
344     /**
345     * @dev Function to transfer tokens
346     * @param _recipients The addresses that will receive the tokens.
347     * @param _amounts The list of the amounts of tokens to transfer.
348     * @return A boolean that indicates if the operation was successful.
349     */
350     function massTransfer(address[] _recipients, uint[] _amounts) external returns (bool) {
351         require(_recipients.length == _amounts.length);
352 
353         for (uint i = 0; i < _recipients.length; i++) {
354             require(transfer(_recipients[i], _amounts[i]));
355         }
356 
357         return true;
358     }
359 }