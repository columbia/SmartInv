1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'PIXBYTOKEN'  token contract
5 //
6 // Symbol      : PXB
7 // Name        : PIXBYTOKEN
8 // Total supply: 150 000 000 
9 // Decimals    : 8
10 // ----------------------------------------------------------------------------
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 }
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   uint256 public totalSupply;
92   function balanceOf(address who) public constant returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic, Ownable {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106   // allowedAddresses will be able to transfer even when locked
107   // lockedAddresses will *not* be able to transfer even when *not locked*
108   mapping(address => bool) public allowedAddresses;
109   mapping(address => bool) public lockedAddresses;
110   bool public locked = true;
111 
112   function allowAddress(address _addr, bool _allowed) public onlyOwner {
113     require(_addr != owner);
114     allowedAddresses[_addr] = _allowed;
115   }
116 
117   function lockAddress(address _addr, bool _locked) public onlyOwner {
118     require(_addr != owner);
119     lockedAddresses[_addr] = _locked;
120   }
121 
122   function setLocked(bool _locked) public onlyOwner {
123     locked = _locked;
124   }
125 
126   function canTransfer(address _addr) public constant returns (bool) {
127     if(locked){
128       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
129     }else if(lockedAddresses[_addr]) return false;
130 
131     return true;
132   }
133 
134 
135 
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(canTransfer(msg.sender));
145     
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public constant returns (uint256 balance) {
160     return balances[_owner];
161   }
162 }
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) public constant returns (uint256);
170   function transferFrom(address from, address to, uint256 value) public returns (bool);
171   function approve(address spender, uint256 value) public returns (bool);
172   event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(canTransfer(msg.sender));
197 
198     uint256 _allowance = allowed[_from][msg.sender];
199 
200     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
201     // require (_value <= _allowance);
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = _allowance.sub(_value);
206     Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param _spender The address which will spend the funds.
218    * @param _value The amount of tokens to be spent.
219    */
220   function approve(address _spender, uint256 _value) public returns (bool) {
221     allowed[msg.sender][_spender] = _value;
222     Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
233     return allowed[_owner][_spender];
234   }
235 
236   /**
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    */
242   function increaseApproval (address _spender, uint _addedValue)
243     returns (bool success) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   function decreaseApproval (address _spender, uint _subtractedValue)
250     returns (bool success) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 }
261 
262 
263 /**
264  * @title Burnable Token
265  * @dev Token that can be irreversibly burned (destroyed).
266  */
267 contract BurnableToken is StandardToken {
268 
269     event Burn(address indexed burner, uint256 value);
270 
271     /**
272      * @dev Burns a specific amount of tokens.
273      * @param _value The amount of token to be burned.
274      */
275     function burn(uint256 _value) public {
276         require(_value > 0);
277         require(_value <= balances[msg.sender]);
278         // no need to require value <= totalSupply, since that would imply the
279         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
280 
281         address burner = msg.sender;
282         balances[burner] = balances[burner].sub(_value);
283         totalSupply = totalSupply.sub(_value);
284         Burn(burner, _value);
285         Transfer(burner, address(0), _value);
286     }
287 }
288 
289 contract PIXBYTOKEN is BurnableToken {
290 
291     string public constant name = "PIXBYTOKEN";
292     string public constant symbol = "PXB";
293     uint public constant decimals = 8;
294     // there is no problem in using * here instead of .mul()
295     uint256 public constant initialSupply = 150000000 * (10 ** uint256(decimals));
296 
297     // Constructors
298     function PIXBYTOKEN () {
299         totalSupply = initialSupply;
300         balances[msg.sender] = initialSupply; // Send all tokens to owner
301         allowedAddresses[owner] = true;
302     }
303 
304 }