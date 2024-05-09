1 pragma solidity ^0.4.18;
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
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 
218 /**
219  * @title Burnable Token
220  * @dev Token that can be irreversibly burned (destroyed).
221  */
222 contract BurnableToken is BasicToken {
223 
224   event Burn(address indexed burner, uint256 value);
225 
226   /**
227    * @dev Burns a specific amount of tokens.
228    * @param _value The amount of token to be burned.
229    */
230   function burn(uint256 _value) public {
231     require(_value <= balances[msg.sender]);
232     // no need to require value <= totalSupply, since that would imply the
233     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
234 
235     address burner = msg.sender;
236     balances[burner] = balances[burner].sub(_value);
237     totalSupply_ = totalSupply_.sub(_value);
238     Burn(burner, _value);
239     Transfer(burner, address(0), _value);
240   }
241 }
242 
243 
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255 
256   /**
257    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
258    * account.
259    */
260   function Ownable() public {
261     owner = msg.sender;
262   }
263 
264   /**
265    * @dev Throws if called by any account other than the owner.
266    */
267   modifier onlyOwner() {
268     require(msg.sender == owner);
269     _;
270   }
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address newOwner) public onlyOwner {
277     require(newOwner != address(0));
278     OwnershipTransferred(owner, newOwner);
279     owner = newOwner;
280   }
281 
282 }
283 
284 
285 /**
286  * @title TileToken
287  */
288 contract TileToken is StandardToken, BurnableToken, Ownable {
289 
290   string public constant NAME = "Tile"; // solium-disable-line uppercase
291   string public constant SYMBOL = "TILE"; // solium-disable-line uppercase
292   uint8 public constant DECIMALS = 18; // solium-disable-line uppercase
293 
294   uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(DECIMALS));
295 
296   /**
297    * @dev Constructor that gives msg.sender all of existing tokens.
298    */
299   function Tile() public {
300     totalSupply_ = INITIAL_SUPPLY;
301     balances[msg.sender] = INITIAL_SUPPLY;
302     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
303   }
304 
305 }