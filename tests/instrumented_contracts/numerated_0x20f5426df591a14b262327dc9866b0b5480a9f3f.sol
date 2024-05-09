1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   uint256 totalSupply_;
69 
70   /**
71   * @dev total number of tokens in existence
72   */
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 /**
252  * @title Destructible
253  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
254  */
255 contract Destructible is Ownable {
256 
257   function Destructible() public payable { }
258 
259   /**
260    * @dev Transfers the current balance to the owner and terminates the contract.
261    */
262   function destroy() onlyOwner public {
263     selfdestruct(owner);
264   }
265 
266   function destroyAndSend(address _recipient) onlyOwner public {
267     selfdestruct(_recipient);
268   }
269 }
270 
271 
272 
273 /**
274  * @title iBitcoin
275  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
276  * Note they can later distribute these tokens as they wish using `transfer` and other
277  * `StandardToken` functions.
278  */
279 contract iBitcoin is StandardToken, Destructible {
280   string public name; // solium-disable-line uppercase
281   string public symbol; // solium-disable-line uppercase
282   uint8 public decimals; // solium-disable-line uppercase
283   
284   /**
285    * @dev Constructor that gives msg.sender all of existing tokens.
286    */
287   function iBitcoin(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
288 	balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
289     totalSupply_ = _initialAmount;                        // Update total supply
290     name = _tokenName;                                   // Set the name for display purposes
291     decimals = _decimalUnits;                            // Amount of decimals for display purposes
292     symbol = _tokenSymbol;   
293 	Transfer(0x0, msg.sender, totalSupply_);
294   }
295 
296   function () payable public {}
297   
298   function reclaimEther() external onlyOwner {
299     assert(owner.send(this.balance));
300   }
301   
302   function reclaimTokien(address _contract, address _to, uint256 _value) external onlyOwner {
303     ERC20 c = ERC20(_contract);
304 	c.transfer(_to, _value);
305   }
306   
307 }