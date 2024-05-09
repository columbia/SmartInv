1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title SafeERC20
114  * @dev Wrappers around ERC20 operations that throw on failure.
115  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
116  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
117  */
118 library SafeERC20 {
119   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
120     assert(token.transfer(to, value));
121   }
122 
123   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
124     assert(token.transferFrom(from, to, value));
125   }
126 
127   function safeApprove(ERC20 token, address spender, uint256 value) internal {
128     assert(token.approve(spender, value));
129   }
130 }
131 
132 /**
133  * @title Contracts that should be able to recover tokens
134  * @author SylTi
135  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
136  * This will prevent any accidental loss of tokens.
137  */
138 contract CanReclaimToken is Ownable {
139   using SafeERC20 for ERC20Basic;
140 
141   /**
142    * @dev Reclaim all ERC20Basic compatible tokens
143    * @param token ERC20Basic The address of the token contract
144    */
145   function reclaimToken(ERC20Basic token) external onlyOwner {
146     uint256 balance = token.balanceOf(this);
147     token.safeTransfer(owner, balance);
148   }
149 
150 }
151 
152 /**
153  * @title Basic token
154  * @dev Basic version of StandardToken, with no allowances.
155  */
156 contract BasicToken is ERC20Basic {
157   using SafeMath for uint256;
158 
159   mapping(address => uint256) balances;
160 
161   uint256 totalSupply_;
162 
163   /**
164   * @dev total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_;
168   }
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178 
179     // SafeMath.sub will throw if there is not enough balance.
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public view returns (uint256 balance) {
192     return balances[_owner];
193   }
194 
195 }
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(address _owner, address _spender) public view returns (uint256) {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
264     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Decrease the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 /**
293  * @title CMCT
294  * @dev ERC20-compatible Crowd Machine Compute Token
295  */
296 
297 contract CMCTInterface is ERC20 {
298   function isCMCT() public pure returns(bool isIndeed);
299 }
300 
301 contract CMCT is CMCTInterface, StandardToken, CanReclaimToken {
302   string public name = "Crowd Machine Compute Token";
303   string public symbol = "CMCT";
304   uint8  public decimals = 8;
305   uint256 public INITIAL_SUPPLY = uint(2000000000) * (10 ** uint256(decimals));
306 
307   /**
308    * @dev Allocate the initial supply to the deployer. 
309    */
310   function CMCT() public {
311     totalSupply_ = INITIAL_SUPPLY;
312     balances[msg.sender] = INITIAL_SUPPLY;
313   }
314   
315   /**
316    * @dev This is to catch deployment/configuration errors.
317    */  
318   function isCMCT() public pure returns(bool isIndeed) {
319       return true;
320   }
321 }