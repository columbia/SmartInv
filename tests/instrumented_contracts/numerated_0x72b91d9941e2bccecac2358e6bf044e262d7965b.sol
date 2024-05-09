1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Basic token
28  * @dev Basic version of StandardToken, with no allowances.
29  */
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   uint256 totalSupply_;
36 
37   /**
38   * @dev total number of tokens in existence
39   */
40   function totalSupply() public view returns (uint256) {
41     return totalSupply_;
42   }
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 /**
72  * @title Standard ERC20 token
73  *
74  * @dev Implementation of the basic standard token.
75  * @dev https://github.com/ethereum/EIPs/issues/20
76  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82 
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    *
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    * @param _spender The address which will spend the funds.
135    * @param _addedValue The amount of tokens to increase the allowance by.
136    */
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   /**
144    * @dev Decrease the amount of tokens that an owner allowed to a spender.
145    *
146    * approve should be called when allowed[_spender] == 0. To decrement
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _subtractedValue The amount of tokens to decrease the allowance by.
152    */
153   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 /**
167  * @title Ownable
168  * @dev The Ownable contract has an owner address, and provides basic authorization control
169  * functions, this simplifies the implementation of "user permissions".
170  */
171 contract Ownable {
172   address public owner;
173 
174 
175   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177 
178   /**
179    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180    * account.
181    */
182   function Ownable() public {
183     owner = msg.sender;
184   }
185 
186   /**
187    * @dev Throws if called by any account other than the owner.
188    */
189   modifier onlyOwner() {
190     require(msg.sender == owner);
191     _;
192   }
193 
194   /**
195    * @dev Allows the current owner to transfer control of the contract to a newOwner.
196    * @param newOwner The address to transfer ownership to.
197    */
198   function transferOwnership(address newOwner) public onlyOwner {
199     require(newOwner != address(0));
200     OwnershipTransferred(owner, newOwner);
201     owner = newOwner;
202   }
203 
204 }
205 
206 /**
207  * @title Mintable token
208  * @dev Simple ERC20 Token example, with mintable token creation
209  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
210  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
211  */
212 contract MintableToken is StandardToken, Ownable {
213   event Mint(address indexed to, uint256 amount);
214   event MintFinished();
215 
216   bool public mintingFinished = false;
217 
218 
219   modifier canMint() {
220     require(!mintingFinished);
221     _;
222   }
223 
224   /**
225    * @dev Function to mint tokens
226    * @param _to The address that will receive the minted tokens.
227    * @param _amount The amount of tokens to mint.
228    * @return A boolean that indicates if the operation was successful.
229    */
230   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
231     totalSupply_ = totalSupply_.add(_amount);
232     balances[_to] = balances[_to].add(_amount);
233     Mint(_to, _amount);
234     Transfer(address(0), _to, _amount);
235     return true;
236   }
237 
238   /**
239    * @dev Function to stop minting new tokens.
240    * @return True if the operation was successful.
241    */
242   function finishMinting() onlyOwner canMint public returns (bool) {
243     mintingFinished = true;
244     MintFinished();
245     return true;
246   }
247 }
248 
249 /**
250  * @title SafeMath
251  * @dev Math operations with safety checks that throw on error
252  */
253 library SafeMath {
254 
255   /**
256   * @dev Multiplies two numbers, throws on overflow.
257   */
258   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259     if (a == 0) {
260       return 0;
261     }
262     uint256 c = a * b;
263     assert(c / a == b);
264     return c;
265   }
266 
267   /**
268   * @dev Integer division of two numbers, truncating the quotient.
269   */
270   function div(uint256 a, uint256 b) internal pure returns (uint256) {
271     // assert(b > 0); // Solidity automatically throws when dividing by 0
272     uint256 c = a / b;
273     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
274     return c;
275   }
276 
277   /**
278   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
279   */
280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281     assert(b <= a);
282     return a - b;
283   }
284 
285   /**
286   * @dev Adds two numbers, throws on overflow.
287   */
288   function add(uint256 a, uint256 b) internal pure returns (uint256) {
289     uint256 c = a + b;
290     assert(c >= a);
291     return c;
292   }
293 }
294 
295 /**
296  * @title Burnable Token
297  * @dev Token that can be irreversibly burned (destroyed).
298  */
299 contract BurnableToken is BasicToken {
300 
301   event Burn(address indexed burner, uint256 value);
302 
303   /**
304    * @dev Burns a specific amount of tokens.
305    * @param _value The amount of token to be burned.
306    */
307   function burn(uint256 _value) public {
308     require(_value <= balances[msg.sender]);
309     // no need to require value <= totalSupply, since that would imply the
310     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
311 
312     address burner = msg.sender;
313     balances[burner] = balances[burner].sub(_value);
314     totalSupply_ = totalSupply_.sub(_value);
315     Burn(burner, _value);
316   }
317 }
318 
319 /**
320  * @title Claimable
321  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
322  * This allows the new owner to accept the transfer.
323  */
324 contract Claimable is Ownable {
325   address public pendingOwner;
326 
327   /**
328    * @dev Modifier throws if called by any account other than the pendingOwner.
329    */
330   modifier onlyPendingOwner() {
331     require(msg.sender == pendingOwner);
332     _;
333   }
334 
335   /**
336    * @dev Allows the current owner to set the pendingOwner address.
337    * @param newOwner The address to transfer ownership to.
338    */
339   function transferOwnership(address newOwner) onlyOwner public {
340     pendingOwner = newOwner;
341   }
342 
343   /**
344    * @dev Allows the pendingOwner address to finalize the transfer.
345    */
346   function claimOwnership() onlyPendingOwner public {
347     OwnershipTransferred(owner, pendingOwner);
348     owner = pendingOwner;
349     pendingOwner = address(0);
350   }
351 }
352 
353 /**
354  * @title LibreCash token contract.
355  * @dev ERC20 token contract.
356  * @dev Project website: https://libreсash.com
357  * @dev Mail: support[@]librecash.com
358  */
359 contract LibreCash is MintableToken, BurnableToken, Claimable {
360     string public constant name = "LibreCash";
361     string public constant symbol = "Libre";
362     uint32 public constant decimals = 18;
363 }