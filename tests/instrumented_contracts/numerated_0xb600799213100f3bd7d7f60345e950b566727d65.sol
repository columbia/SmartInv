1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'PROQYR'  token contract
5 //
6 // Symbol      : PROQYR
7 // Name        : PROQYR
8 // Total supply: 5 000 000 000
9 // Decimals    : 18
10 // (c) by Team @ PROQYR 2019.
11 // ----------------------------------------------------------------------------
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) onlyOwner public {
80     require(newOwner != address(0));
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 }
85 
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92   uint256 public totalSupply;
93   function balanceOf(address who) public constant returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic, Ownable {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107   // allowedAddresses will be able to transfer even when locked
108   // lockedAddresses will *not* be able to transfer even when *not locked*
109   mapping(address => bool) public allowedAddresses;
110   mapping(address => bool) public lockedAddresses;
111   bool public locked = true;
112 
113   function allowAddress(address _addr, bool _allowed) public onlyOwner {
114     require(_addr != owner);
115     allowedAddresses[_addr] = _allowed;
116   }
117 
118   function lockAddress(address _addr, bool _locked) public onlyOwner {
119     require(_addr != owner);
120     lockedAddresses[_addr] = _locked;
121   }
122 
123   function setLocked(bool _locked) public onlyOwner {
124     locked = _locked;
125   }
126 
127   function canTransfer(address _addr) public constant returns (bool) {
128     if(locked){
129       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
130     }else if(lockedAddresses[_addr]) return false;
131 
132     return true;
133   }
134 
135 
136 
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(canTransfer(msg.sender));
146     
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public constant returns (uint256 balance) {
161     return balances[_owner];
162   }
163 }
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public constant returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(canTransfer(msg.sender));
198 
199     uint256 _allowance = allowed[_from][msg.sender];
200 
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    */
243   function increaseApproval (address _spender, uint _addedValue)
244     returns (bool success) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   function decreaseApproval (address _spender, uint _subtractedValue)
251     returns (bool success) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 }
262 
263 
264 /**
265  * @title Burnable Token
266  * @dev Token that can be irreversibly burned (destroyed).
267  */
268 contract BurnableToken is StandardToken {
269 
270     event Burn(address indexed burner, uint256 value);
271 
272     /**
273      * @dev Burns a specific amount of tokens.
274      * @param _value The amount of token to be burned.
275      */
276     function burn(uint256 _value) public {
277         require(_value > 0);
278         require(_value <= balances[msg.sender]);
279         // no need to require value <= totalSupply, since that would imply the
280         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282         address burner = msg.sender;
283         balances[burner] = balances[burner].sub(_value);
284         totalSupply = totalSupply.sub(_value);
285         Burn(burner, _value);
286         Transfer(burner, address(0), _value);
287     }
288 }
289 
290 contract PROQYR is BurnableToken {
291 
292     string public constant name = "PROQYR";
293     string public constant symbol = "PROQYR";
294     uint public constant decimals = 18;
295     // there is no problem in using * here instead of .mul()
296     uint256 public constant initialSupply = 5000000000 * (10 ** uint256(decimals));
297 
298     // Constructors
299     function PROQYR () {
300         totalSupply = initialSupply;
301         balances[msg.sender] = initialSupply; // Send all tokens to owner
302         allowedAddresses[owner] = true;
303     }
304 
305 }