1 pragma solidity ^0.4.21;
2 
3 //import "./zeppelin/StandardToken.sol";
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     emit Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 contract VortixTokenUSD is StandardToken, Ownable {
260     
261   // EVENTS
262   event Mint(address indexed to, uint256 amount, uint256 priceUsd);
263   event MintFinished();
264   event TransferableChanged(bool transferable);
265   // PUBLIC FUNCTIONS
266 
267   // Only owner can send ether to this contract (If required)
268   function() public onlyOwner {}
269 
270   // Check transfer ability and sender address before transfer
271   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
272     return super.transfer(_to, _value);
273   }
274 
275   // Check transfer ability and sender address before transfer
276   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
277     return super.transferFrom(_from, _to, _value);
278   }
279 
280   /// @dev Function to mint tokens.
281   /// @param _to The address that will receive the minted tokens.
282   /// @param _amount The amount of tokens to mint.
283   /// @param _priceUsd The price of minted token at moment of purchase in USD with 18 decimals.
284   /// @return A boolean that indicates if the operation was successful.
285   function mint(address _to, uint256 _amount, uint256 _priceUsd) onlyOwner canMint public returns (bool) {
286     totalSupply_ = totalSupply_.add(_amount);
287     balances[_to] = balances[_to].add(_amount);
288     if (_priceUsd != 0) {
289       uint256 amountUsd = _amount.mul(_priceUsd).div(10**18);
290       totalCollected = totalCollected.add(amountUsd);
291     }
292     emit Mint(_to, _amount, _priceUsd);
293     emit Transfer(0x0, _to, _amount);
294     return true;
295   }
296 
297   /// @dev Function to stop minting new tokens.
298   /// @return A boolean that indicates if the operation was successful.
299   function finishMinting() onlyOwner canMint public returns (bool) {
300     mintingFinished = true;
301     emit MintFinished();
302     return true;
303   }
304 
305   /// @dev Change ability to transfer tokens by users.
306   /// @return A boolean that indicates if the operation was successful.
307   function setTransferable(bool _transferable) onlyOwner public returns (bool) {
308     require(transferable != _transferable);
309     transferable = _transferable;
310     emit TransferableChanged(transferable);
311     return true;
312   }
313 
314   // MODIFIERS
315 
316   modifier canMint() {
317     require(!mintingFinished);
318     _;
319   }
320 
321   modifier canTransfer() {
322     require(transferable || msg.sender == owner);
323     _;
324   }
325 
326   // FIELDS
327 
328   // Standard fields used to describe the token
329   string public name = "Vortix$";
330   string public symbol = "VTX$";
331   string public version = "H0.1";
332   uint8 public decimals = 8;
333 
334   // At the start of the token existence token is not transferable
335   bool public transferable = false;
336 
337   // Will be set to true when minting tokens will be finished
338   bool public mintingFinished = false;
339 
340   // Amount of USD (with 8 decimals) collected during sale phase
341   uint256 public totalCollected;
342 }