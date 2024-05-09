1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'Pro Life'  token contract
5 //
6 // Symbol      : MICE
7 // Name        : MicroCents
8 // Total supply: 999 000 000 000 000 000
9 // Decimals    : 18
10 // Website     : www.visionbrokers.org
11 // (c) by Team @ Vision Brokers 2019.
12 // ----------------------------------------------------------------------------
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) onlyOwner public {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   uint256 public totalSupply;
94   function balanceOf(address who) public constant returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is ERC20Basic, Ownable {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108   // allowedAddresses will be able to transfer even when locked
109   // lockedAddresses will *not* be able to transfer even when *not locked*
110   mapping(address => bool) public allowedAddresses;
111   mapping(address => bool) public lockedAddresses;
112   bool public locked = true;
113 
114   function allowAddress(address _addr, bool _allowed) public onlyOwner {
115     require(_addr != owner);
116     allowedAddresses[_addr] = _allowed;
117   }
118 
119   function lockAddress(address _addr, bool _locked) public onlyOwner {
120     require(_addr != owner);
121     lockedAddresses[_addr] = _locked;
122   }
123 
124   function setLocked(bool _locked) public onlyOwner {
125     locked = _locked;
126   }
127 
128   function canTransfer(address _addr) public constant returns (bool) {
129     if(locked){
130       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
131     }else if(lockedAddresses[_addr]) return false;
132 
133     return true;
134   }
135 
136 
137 
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(canTransfer(msg.sender));
147     
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public constant returns (uint256 balance) {
162     return balances[_owner];
163   }
164 }
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(canTransfer(msg.sender));
199 
200     uint256 _allowance = allowed[_from][msg.sender];
201 
202     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
203     // require (_value <= _allowance);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = _allowance.sub(_value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    */
244   function increaseApproval (address _spender, uint _addedValue)
245     returns (bool success) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   function decreaseApproval (address _spender, uint _subtractedValue)
252     returns (bool success) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 }
263 
264 
265 /**
266  * @title Burnable Token
267  * @dev Token that can be irreversibly burned (destroyed).
268  */
269 contract BurnableToken is StandardToken {
270 
271     event Burn(address indexed burner, uint256 value);
272 
273     /**
274      * @dev Burns a specific amount of tokens.
275      * @param _value The amount of token to be burned.
276      */
277     function burn(uint256 _value) public {
278         require(_value > 0);
279         require(_value <= balances[msg.sender]);
280         // no need to require value <= totalSupply, since that would imply the
281         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283         address burner = msg.sender;
284         balances[burner] = balances[burner].sub(_value);
285         totalSupply = totalSupply.sub(_value);
286         Burn(burner, _value);
287         Transfer(burner, address(0), _value);
288     }
289 }
290 
291 contract MICE is BurnableToken {
292 
293     string public constant name = "MicroCents";
294     string public constant symbol = "MICE";
295     uint public constant decimals = 18;
296     // there is no problem in using * here instead of .mul()
297     uint256 public constant initialSupply = 999000000000000000 * (10 ** uint256(decimals));
298 
299     // Constructors
300     function MICE () {
301         totalSupply = initialSupply;
302         balances[msg.sender] = initialSupply; // Send all tokens to owner
303         allowedAddresses[owner] = true;
304     }
305 
306 }