1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'buckycoin'  token contract
5 //
6 // Deployed to : 0x0d6b7184fe73365cB21Bf044B5d415446C26D904
7 // Symbol      : BUCKY
8 // Name        : buckycoin Token
9 // Total supply: 940000000
10 // Decimals    : 18
11 // Website     : https://www.buckycoin.io 
12 // Email       : tokens@buckycoin.io
13 // POWERED BY BUCKY HOUSE.
14 
15 // (c) by Team @ BUCKYHOUSE  2018.
16 // ----------------------------------------------------------------------------
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() {
67     owner = msg.sender;
68   }
69 
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) onlyOwner public {
85     require(newOwner != address(0));
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   uint256 public totalSupply;
98   function balanceOf(address who) public constant returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic, Ownable {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112   // allowedAddresses will be able to transfer even when locked
113   // lockedAddresses will *not* be able to transfer even when *not locked*
114   mapping(address => bool) public allowedAddresses;
115   mapping(address => bool) public lockedAddresses;
116   bool public locked = true;
117 
118   function allowAddress(address _addr, bool _allowed) public onlyOwner {
119     require(_addr != owner);
120     allowedAddresses[_addr] = _allowed;
121   }
122 
123   function lockAddress(address _addr, bool _locked) public onlyOwner {
124     require(_addr != owner);
125     lockedAddresses[_addr] = _locked;
126   }
127 
128   function setLocked(bool _locked) public onlyOwner {
129     locked = _locked;
130   }
131 
132   function canTransfer(address _addr) public constant returns (bool) {
133     if(locked){
134       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
135     }else if(lockedAddresses[_addr]) return false;
136 
137     return true;
138   }
139 
140 
141 
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(canTransfer(msg.sender));
151     
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public constant returns (uint256 balance) {
166     return balances[_owner];
167   }
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) public constant returns (uint256);
176   function transferFrom(address from, address to, uint256 value) public returns (bool);
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(canTransfer(msg.sender));
203 
204     uint256 _allowance = allowed[_from][msg.sender];
205 
206     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
207     // require (_value <= _allowance);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = _allowance.sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    */
248   function increaseApproval (address _spender, uint _addedValue)
249     returns (bool success) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   function decreaseApproval (address _spender, uint _subtractedValue)
256     returns (bool success) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 }
267 
268 
269 /**
270  * @title Burnable Token
271  * @dev Token that can be irreversibly burned (destroyed).
272  */
273 contract BurnableToken is StandardToken {
274 
275     event Burn(address indexed burner, uint256 value);
276 
277     /**
278      * @dev Burns a specific amount of tokens.
279      * @param _value The amount of token to be burned.
280      */
281     function burn(uint256 _value) public {
282         require(_value > 0);
283         require(_value <= balances[msg.sender]);
284         // no need to require value <= totalSupply, since that would imply the
285         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
286 
287         address burner = msg.sender;
288         balances[burner] = balances[burner].sub(_value);
289         totalSupply = totalSupply.sub(_value);
290         Burn(burner, _value);
291         Transfer(burner, address(0), _value);
292     }
293 }
294 
295 contract BuckyCoin  is BurnableToken {
296 
297     string public constant name = "BUCKY COIN";
298     string public constant symbol = "BUCKY";
299     uint public constant decimals = 18;
300     // there is no problem in using * here instead of .mul()
301     uint256 public constant initialSupply = 940000000 * (10 ** uint256(decimals));
302 
303     // Constructors
304     function BuckyCoin () {
305         totalSupply = initialSupply;
306         balances[msg.sender] = initialSupply; // Send all tokens to owner
307         allowedAddresses[owner] = true;
308     }
309 
310 }