1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'buckycoin' CROWDSALE token contract
5 //
6 // Deployed to : 0xF86C2C4c7Dd79Ba0480eBbEbd096F51311Cfb952
7 // Symbol      : BUC
8 // Name        : buckycoin Token
9 // Total supply: 940000000
10 // Decimals    : 18
11 //
12 // POWERED BY BUCKY HOUSE.
13 //
14 // (c) by Team @ BUCKYHOUSE  2018.
15 // ----------------------------------------------------------------------------
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() {
66     owner = msg.sender;
67   }
68 
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) onlyOwner public {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public constant returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic, Ownable {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111   // allowedAddresses will be able to transfer even when locked
112   // lockedAddresses will *not* be able to transfer even when *not locked*
113   mapping(address => bool) public allowedAddresses;
114   mapping(address => bool) public lockedAddresses;
115   bool public locked = true;
116 
117   function allowAddress(address _addr, bool _allowed) public onlyOwner {
118     require(_addr != owner);
119     allowedAddresses[_addr] = _allowed;
120   }
121 
122   function lockAddress(address _addr, bool _locked) public onlyOwner {
123     require(_addr != owner);
124     lockedAddresses[_addr] = _locked;
125   }
126 
127   function setLocked(bool _locked) public onlyOwner {
128     locked = _locked;
129   }
130 
131   function canTransfer(address _addr) public constant returns (bool) {
132     if(locked){
133       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
134     }else if(lockedAddresses[_addr]) return false;
135 
136     return true;
137   }
138 
139 
140 
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(canTransfer(msg.sender));
150     
151 
152     // SafeMath.sub will throw if there is not enough balance.
153     balances[msg.sender] = balances[msg.sender].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     Transfer(msg.sender, _to, _value);
156     return true;
157   }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163   */
164   function balanceOf(address _owner) public constant returns (uint256 balance) {
165     return balances[_owner];
166   }
167 }
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) public constant returns (uint256);
175   function transferFrom(address from, address to, uint256 value) public returns (bool);
176   function approve(address spender, uint256 value) public returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190   mapping (address => mapping (address => uint256)) allowed;
191 
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(canTransfer(msg.sender));
202 
203     uint256 _allowance = allowed[_from][msg.sender];
204 
205     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
206     // require (_value <= _allowance);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = _allowance.sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval (address _spender, uint _addedValue)
248     returns (bool success) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   function decreaseApproval (address _spender, uint _subtractedValue)
255     returns (bool success) {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 }
266 
267 
268 /**
269  * @title Burnable Token
270  * @dev Token that can be irreversibly burned (destroyed).
271  */
272 contract BurnableToken is StandardToken {
273 
274     event Burn(address indexed burner, uint256 value);
275 
276     /**
277      * @dev Burns a specific amount of tokens.
278      * @param _value The amount of token to be burned.
279      */
280     function burn(uint256 _value) public {
281         require(_value > 0);
282         require(_value <= balances[msg.sender]);
283         // no need to require value <= totalSupply, since that would imply the
284         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
285 
286         address burner = msg.sender;
287         balances[burner] = balances[burner].sub(_value);
288         totalSupply = totalSupply.sub(_value);
289         Burn(burner, _value);
290         Transfer(burner, address(0), _value);
291     }
292 }
293 
294 contract BuckyCoin  is BurnableToken {
295 
296     string public constant name = "BUCKY COIN";
297     string public constant symbol = "BUC";
298     uint public constant decimals = 18;
299     // there is no problem in using * here instead of .mul()
300     uint256 public constant initialSupply = 940000000 * (10 ** uint256(decimals));
301 
302     // Constructors
303     function BuckyCoin () {
304         totalSupply = initialSupply;
305         balances[msg.sender] = initialSupply; // Send all tokens to owner
306         allowedAddresses[owner] = true;
307     }
308 
309 }