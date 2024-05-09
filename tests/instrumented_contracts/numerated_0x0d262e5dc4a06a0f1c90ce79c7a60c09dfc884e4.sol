1 pragma solidity ^0.4.17;
2 
3 contract J8TTokenConfig {
4     // The J8T decimals
5     uint8 public constant TOKEN_DECIMALS = 8;
6 
7     // The J8T decimal factor to obtain luckys
8     uint256 public constant J8T_DECIMALS_FACTOR = 10**uint256(TOKEN_DECIMALS);
9 }
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal constant returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   uint256 public totalSupply;
90   function balanceOf(address who) public constant returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
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
127 
128 }
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public constant returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161 
162     uint256 _allowance = allowed[_from][msg.sender];
163 
164     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
165     // require (_value <= _allowance);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = _allowance.sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval (address _spender, uint _addedValue)
207     returns (bool success) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   function decreaseApproval (address _spender, uint _subtractedValue)
214     returns (bool success) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 /**
228  * @title Burnable Token
229  * @dev Token that can be irreversibly burned (destroyed).
230  */
231 contract BurnableToken is StandardToken {
232 
233     event Burn(address indexed burner, uint256 value);
234 
235     /**
236      * @dev Burns a specific amount of tokens.
237      * @param _value The amount of token to be burned.
238      */
239     function burn(uint256 _value) public {
240         require(_value > 0);
241 
242         address burner = msg.sender;
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         Burn(burner, _value);
246     }
247 }
248 
249 //////////////////////////////////////////////////////////////////////
250 // @title J8T Token 									   			//
251 // @dev ERC20 J8T Token 								   			//
252 //														   			//
253 // J8T Tokens are divisible by 1e8 (100,000,000) base      			//
254 //														   			//
255 // J8T are displayed using 8 decimal places of precision.  			//
256 //														   			//
257 // 1 J8T is equivalent to 100000000 luckys:				   			//
258 //   100000000 == 1 * 10**8 == 1e8 == One Hundred Million luckys 	//
259 //														   			//
260 // 1,5 Billion J8T (total supply) is equivalent to:        			//
261 //   150000000000000000 == 1500000000 * 10**8 == 1,5e17 luckys   	//
262 // 														   			//
263 //////////////////////////////////////////////////////////////////////
264 
265 contract J8TToken is J8TTokenConfig, BurnableToken, Ownable {
266 	string public constant name            = "J8T Token";
267 	string public constant symbol          = "J8T";
268 	uint256 public constant decimals       = TOKEN_DECIMALS;
269 	uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(decimals));
270 
271     event Transfer(address indexed _from, address indexed _to, uint256 _value);
272 
273     function J8TToken() {
274 	    totalSupply = INITIAL_SUPPLY;
275 	    balances[msg.sender] = INITIAL_SUPPLY;
276 
277         //https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
278         //EIP 20: A token contract which creates new tokens SHOULD trigger a
279         //Transfer event with the _from address set to 0x0
280         //when tokens are created.
281         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
282 	 }
283 }