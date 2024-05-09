1 pragma solidity 0.4.24;
2 
3 /**
4  * Contrato del Token NEOX
5  */
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129 
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 
137 /**
138  * @title Standard ERC20 token
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179   
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 /**
216  * @title Burnable Token
217  * @dev Token of the sender that can be irreversibly burned (destroyed).
218  */
219 contract BurnableToken is BasicToken, Ownable {
220 
221   event Burn(address indexed burner, uint256 value);
222 
223   /**
224    * @dev Burns a specific amount of tokens.
225    * @param _value The amount of token to be burned.
226    */
227   function burn(uint256 _value) public {
228     _burn(msg.sender, _value);
229   }
230 
231   function _burn(address _who, uint256 _value) internal{
232     require(_value <= balances[_who]);
233     // no need to require value <= totalSupply, since that would imply the
234     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
235 
236     balances[_who] = balances[_who].sub(_value);
237     totalSupply = totalSupply.sub(_value);
238     emit Burn(_who, _value);
239     emit Transfer(_who, address(0), _value);
240   }
241 }
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
247  */
248 contract MintableToken is StandardToken, Ownable {
249   event Mint(address indexed to, uint256 amount);
250 
251   modifier hasMintPermission() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256   /**
257    * @dev Function to mint tokens
258    * @param _to The address that will receive the minted tokens.
259    * @param _amount The amount of tokens to mint.
260    * @return A boolean that indicates if the operation was successful.
261    */
262   function mint(address _to, uint256 _amount)
263     hasMintPermission
264     public
265     returns (bool)
266   {
267     totalSupply = totalSupply.add(_amount);
268     balances[_to] = balances[_to].add(_amount);
269     emit Mint(_to, _amount);
270     emit Transfer(address(0), _to, _amount);
271     return true;
272   }
273 }
274 
275 
276 /**
277  * @title Pausable
278  * @dev Base contract which allows children to implement an emergency stop mechanism.
279  */
280 
281  
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is not paused.
290    */
291   modifier whenNotPaused() {
292     require(!paused);
293     _;
294   }
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is paused.
298    */
299   modifier whenPaused() {
300     require(paused);
301     _;
302   }
303 
304   /**
305    * @dev called by the owner to pause, triggers stopped state
306    */
307   function pause() onlyOwner whenNotPaused public {
308     paused = true;
309     Pause();
310   }
311 
312   /**
313    * @dev called by the owner to unpause, returns to normal state
314    */
315   function unpause() onlyOwner whenPaused public {
316     paused = false;
317     Unpause();
318   }
319 }
320 
321 
322 
323 contract PausableToken is StandardToken, Pausable {
324 
325   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
326     return super.transfer(_to, _value);
327   }
328 
329   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
330     return super.transferFrom(_from, _to, _value);
331   }
332 
333   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
334     return super.approve(_spender, _value);
335   }
336 
337   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
338     return super.increaseApproval(_spender, _addedValue);
339   }
340 
341   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
342     return super.decreaseApproval(_spender, _subtractedValue);
343   }
344 }
345 
346 
347 contract NEOX is PausableToken, MintableToken, BurnableToken {
348     string public constant name = "NEOX";
349     string public constant symbol = "NEOX";
350     uint8 public constant decimals = 18;
351 }