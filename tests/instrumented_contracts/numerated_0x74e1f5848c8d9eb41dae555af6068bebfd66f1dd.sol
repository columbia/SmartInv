1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  * @dev NOTE: Combined ERC20 and ERC20Basic; Changed to interface
55  */
56 interface ERC20 {
57   /* Basic Methods and Events */
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62   
63   /* Allowance Methods and Events */
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 /**
72  * @title Standard ERC20 token
73  *
74  * @dev Implementation of the basic standard token.
75  * @dev https://github.com/ethereum/EIPs/issues/20
76  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20 {
79   
80   /**
81    * @title Basic token
82    * @dev Basic version of StandardToken, with no allowances.
83    */
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170 }
171 
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  * @dev NOTE: Added Transitional Ownership
178  */
179 contract Ownable {
180   address public owner;
181   address public pendingOwner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to begin to transfer control of the contract to a newOwner.
205    * @dev NOTE: Modified to support ownership transfer flow
206    * @param newOwner The address to transfer ownership to.
207    */
208   function transferOwnership(address newOwner) public onlyOwner {
209     require(newOwner != address(0));
210     pendingOwner = newOwner;
211   }
212 
213   /**
214    * @dev Allows the suggested owner to accept ownership role.
215    * @dev NOTE: Added method to support ownership transfer flow
216    */
217   function acceptOwnership() public {
218     OwnershipTransferred(owner, pendingOwner);
219     owner = pendingOwner;
220   }
221 }
222 
223 
224 /**
225  * @title Mintable token
226  * @dev Simple ERC20 Token example, with mintable token creation
227  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
228  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
229  */
230 contract MintableToken is StandardToken, Ownable {
231   event Mint(address indexed to, uint256 amount);
232 
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will receive the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
241     totalSupply_ = totalSupply_.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     Transfer(address(0), _to, _amount);
245     return true;
246   }
247 }
248 
249 
250 /**
251  * @title Burnable Token
252  * @dev Token that can be irreversibly burned (destroyed).
253  */
254 contract BurnableToken is StandardToken {
255 
256   event Burn(address indexed burner, uint256 value);
257 
258   /**
259    * @dev Burns a specific amount of tokens.
260    * @param _value The amount of token to be burned.
261    */
262   function burn(uint256 _value) public {
263     require(_value <= balances[msg.sender]);
264     // no need to require value <= totalSupply, since that would imply the
265     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
266 
267     address burner = msg.sender;
268     balances[burner] = balances[burner].sub(_value);
269     totalSupply_ = totalSupply_.sub(_value);
270     Burn(burner, _value);
271   }
272 }
273 
274 
275 /**
276  * @title DappDev Token
277  * @dev DappDevs Membership Token
278  * @dev Mint more tokens when 
279  * Based on OpenZeppelin Mintable Token (infinite minting)
280  */
281 contract DappDevToken is MintableToken, BurnableToken {
282 
283   string public name = 'DappDevs Membership Token';
284   string public symbol = 'DDV';
285   uint8 public decimals = 0;
286 
287 }