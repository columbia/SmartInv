1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10     return 0;
11   }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73     
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) onlyOwner public {
89     require(newOwner != address(0));
90     OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  * @dev Implementation of the basic standard token.
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) allowed;
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145 
146     uint256 _allowance = allowed[_from][msg.sender];
147 
148     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
149     // require (_value <= _allowance);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    */
190   function increaseApproval (address _spender, uint _addedValue)
191     public returns (bool success) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   function decreaseApproval (address _spender, uint _subtractedValue)
198     public returns (bool success) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 }
209 
210 /**
211  * @title Burnable Token
212  * @dev Token that can be irreversibly burned (destroyed).
213  */
214 contract BurnableToken is StandardToken {
215 
216   /**
217    * @dev Burns a specific amount of tokens.
218    * @param _value The amount of token to be burned.
219    */
220   function burn(uint _value)
221     public
222   {
223     require(_value > 0);
224 
225     address burner = msg.sender;
226     balances[burner] = balances[burner].sub(_value);
227     totalSupply = totalSupply.sub(_value);
228     Burn(burner, _value);
229   }
230 
231   event Burn(address indexed burner, uint indexed value);
232 }
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract MintableToken is StandardToken, Ownable {
241   event Mint(address indexed to, uint256 amount);
242   event MintFinished();
243 
244   bool public mintingFinished = false;
245 
246 
247   modifier canMint() {
248     require(!mintingFinished);
249     _;
250   }
251 
252   /**
253    * @dev Function to mint tokens
254    * @param _to The address that will receive the minted tokens.
255    * @param _amount The amount of tokens to mint.
256    * @return A boolean that indicates if the operation was successful.
257    */
258   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
259     totalSupply = totalSupply.add(_amount);
260     balances[_to] = balances[_to].add(_amount);
261     Mint(_to, _amount);
262     Transfer(0x0, _to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner public returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 //contract hrnCoin is MintableToken, BurnableToken {
278 contract hrnCoin is MintableToken, BurnableToken {
279 
280   string public constant name = 'Human Resource Network';
281   string public constant symbol = 'HRN';
282   uint8 public constant decimals = 2;
283   uint256 public constant InitialSupply = 8000000000 * (10 ** uint256(decimals));
284 
285   uint256 public totalSupply;
286 
287   function hrnCoin() public {
288     totalSupply=InitialSupply;
289     balances[msg.sender]=InitialSupply;
290   }
291 }