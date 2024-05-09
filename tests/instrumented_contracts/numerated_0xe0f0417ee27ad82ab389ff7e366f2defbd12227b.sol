1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * See https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   /**
64   * @dev Total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev Transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://github.com/ethereum/EIPs/issues/20
101  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[_from]);
117     require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     emit Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * @dev Increase the amount of tokens that an owner allowed to a spender.
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
176     uint256 oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract Burnable is BasicToken {
193 
194   event Burn(address indexed burner, uint256 value);
195 
196   /**
197    * @dev Burns a specific amount of tokens.
198    * @param _value The amount of token to be burned.
199    */
200   function burn(uint256 _value) public {
201     _burn(msg.sender, _value);
202   }
203 
204   function _burn(address _who, uint256 _value) internal {
205     require(_value <= balances[_who]);
206     // no need to require value <= totalSupply, since that would imply the
207     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
208 
209     balances[_who] = balances[_who].sub(_value);
210     totalSupply_ = totalSupply_.sub(_value);
211     emit Burn(_who, _value);
212     emit Transfer(_who, address(0), _value);
213   }
214 }
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipRenounced(address indexed previousOwner);
226   event OwnershipTransferred(
227     address indexed previousOwner,
228     address indexed newOwner
229   );
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   constructor() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to relinquish control of the contract.
250    * @notice Renouncing to ownership will leave the contract without an owner.
251    * It will not be possible to call the functions with the `onlyOwner`
252    * modifier anymore.
253    */
254   function renounceOwnership() public onlyOwner {
255     emit OwnershipRenounced(owner);
256     owner = address(0);
257   }
258 
259   /**
260    * @dev Allows the current owner to transfer control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function transferOwnership(address _newOwner) public onlyOwner {
264     _transferOwnership(_newOwner);
265   }
266 
267   /**
268    * @dev Transfers control of the contract to a newOwner.
269    * @param _newOwner The address to transfer ownership to.
270    */
271   function _transferOwnership(address _newOwner) internal {
272     require(_newOwner != address(0));
273     emit OwnershipTransferred(owner, _newOwner);
274     owner = _newOwner;
275   }
276 }
277 
278 
279 /**
280  * @title OENOVIVA
281  * @dev The OENOVIVA ERC20 contract
282  */
283 contract OENOVIVA is StandardToken, Burnable, Ownable {
284 
285   string public constant name = "OENOVIVA"; // solium-disable-line uppercase
286   string public constant symbol = "OVC"; // solium-disable-line uppercase
287   uint8 public constant decimals = 18; // solium-disable-line uppercase
288 
289   uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** uint256(decimals));
290 
291   /**
292    * @dev Constructor that gives msg.sender all of existing tokens.
293    */
294   constructor() public {
295     totalSupply_ = INITIAL_SUPPLY;
296     balances[msg.sender] = INITIAL_SUPPLY;
297     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
298   }
299   
300 }
301 
302 /**
303  * @notes All the credits go to the fantastic OpenZeppelin project and its community
304  * See https://github.com/OpenZeppelin/openzeppelin-solidity
305  */