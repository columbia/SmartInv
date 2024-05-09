1 pragma solidity ^0.4.23;
2 
3 // File: contracts/token/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: contracts/token/ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: contracts/token/SafeMath.sol
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     if (a == 0) {
83       return 0;
84     }
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 // File: contracts/token/BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 // File: contracts/token/ERC20.sol
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender)
172     public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value)
175     public returns (bool);
176 
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 }
184 
185 // File: contracts/token/StandardToken.sol
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: contracts/token/BurnableToken.sol
310 
311 /**
312  * @title Burnable Token
313  * @dev Token that can be irreversibly burned (destroyed).
314  */
315 contract BurnableToken is Ownable, StandardToken {
316 
317   event Burn(address indexed from, uint256 value);
318 
319   /**
320     * @dev burns all remaining token supply
321     */
322   function burnRemainingTokens() onlyOwner public {
323     address burner = msg.sender;
324 
325     emit Burn(burner, balances[burner]);
326     balances[burner] = 0;
327     totalSupply_ = 0;
328   }
329 }
330 
331 // File: contracts/Token.sol
332 
333 contract SqueezerToken is StandardToken,BurnableToken {
334 
335   string public constant name = "Squeezer"; // solium-disable-line uppercase
336   string public constant symbol = "SQR"; // solium-disable-line uppercase
337   uint8 public constant decimals = 18; // solium-disable-line uppercase
338 
339   uint256 public constant INITIAL_SUPPLY = 187500000 * (10 ** uint256(decimals));
340 
341   /**
342    * @dev Constructor that gives msg.sender all of existing tokens.
343    */
344   constructor() public {
345     totalSupply_ = INITIAL_SUPPLY;
346     balances[msg.sender] = INITIAL_SUPPLY;
347     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
348   }
349 }