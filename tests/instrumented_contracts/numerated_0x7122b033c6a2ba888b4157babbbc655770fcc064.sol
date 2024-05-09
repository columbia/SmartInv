1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     assert(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(
33     ERC20 token,
34     address from,
35     address to,
36     uint256 value
37   )
38     internal
39   {
40     assert(token.transferFrom(from, to, value));
41   }
42 
43   function safeApprove(ERC20 token, address spender, uint256 value) internal {
44     assert(token.approve(spender, value));
45   }
46 }
47 
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     if (a == 0) {
112       return 0;
113     }
114     c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   /**
120   * @dev Integer division of two numbers, truncating the quotient.
121   */
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     // uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return a / b;
127   }
128 
129   /**
130   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131   */
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   /**
138   * @dev Adds two numbers, throws on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
141     c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   uint256 totalSupply_;
159 
160   /**
161   * @dev total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[msg.sender]);
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 
194 
195 
196 
197 
198 /**
199  * @title ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 contract ERC20 is ERC20Basic {
203   function allowance(address owner, address spender) public view returns (uint256);
204   function transferFrom(address from, address to, uint256 value) public returns (bool);
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     emit Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    *
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param _spender The address which will spend the funds.
249    * @param _value The amount of tokens to be spent.
250    */
251   function approve(address _spender, uint256 _value) public returns (bool) {
252     allowed[msg.sender][_spender] = _value;
253     emit Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifying the amount of tokens still available for the spender.
262    */
263   function allowance(address _owner, address _spender) public view returns (uint256) {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
278     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 
307 
308 
309 
310 
311 
312 
313 /**
314  * @title Contracts that should be able to recover tokens
315  * @author SylTi
316  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
317  * This will prevent any accidental loss of tokens.
318  */
319 contract CanReclaimToken is Ownable {
320   using SafeERC20 for ERC20Basic;
321 
322   /**
323    * @dev Reclaim all ERC20Basic compatible tokens
324    * @param token ERC20Basic The address of the token contract
325    */
326   function reclaimToken(ERC20Basic token) external onlyOwner {
327     uint256 balance = token.balanceOf(this);
328     token.safeTransfer(owner, balance);
329   }
330 
331 }
332 
333 
334 
335 /**
336  * @title SimpleToken
337  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
338  * Note they can later distribute these tokens as they wish using `transfer` and other
339  * `StandardToken` functions.
340  */
341 contract ZealeumToken is StandardToken, CanReclaimToken {
342 
343   string public name = "Zealeum"; // solium-disable-line uppercase
344   string public symbol = "ZEAL"; // solium-disable-line uppercase
345   uint8 public constant decimals = 18; // solium-disable-line uppercase
346 
347   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
348 
349   /**
350    * @dev Constructor that gives msg.sender all of existing tokens.
351    */
352   constructor() public {
353     totalSupply_ = INITIAL_SUPPLY;
354     balances[msg.sender] = INITIAL_SUPPLY;
355     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
356   }
357 
358 }