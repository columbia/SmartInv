1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address newOwner) public onlyOwner {
256     require(newOwner != address(0));
257     emit OwnershipTransferred(owner, newOwner);
258     owner = newOwner;
259   }
260 
261 }
262 
263 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
309 
310 /**
311  * @title Burnable Token
312  * @dev Token that can be irreversibly burned (destroyed).
313  */
314 contract BurnableToken is BasicToken {
315 
316   event Burn(address indexed burner, uint256 value);
317 
318   /**
319    * @dev Burns a specific amount of tokens.
320    * @param _value The amount of token to be burned.
321    */
322   function burn(uint256 _value) public {
323     _burn(msg.sender, _value);
324   }
325 
326   function _burn(address _who, uint256 _value) internal {
327     require(_value <= balances[_who]);
328     // no need to require value <= totalSupply, since that would imply the
329     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
330 
331     balances[_who] = balances[_who].sub(_value);
332     totalSupply_ = totalSupply_.sub(_value);
333     emit Burn(_who, _value);
334     emit Transfer(_who, address(0), _value);
335   }
336 }
337 
338 // File: contracts/robonomics/XRT.sol
339 
340 contract XRT is MintableToken, BurnableToken {
341     string public constant name     = "Robonomics Beta";
342     string public constant symbol   = "XRT";
343     uint   public constant decimals = 9;
344 
345     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
346 
347     constructor() public {
348         totalSupply_ = INITIAL_SUPPLY;
349         balances[msg.sender] = INITIAL_SUPPLY;
350         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
351     }
352 }