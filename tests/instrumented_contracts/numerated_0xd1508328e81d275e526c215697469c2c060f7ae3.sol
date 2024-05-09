1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor () public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic, Ownable {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96   // allowedAddresses will be able to transfer even when locked
97   // lockedAddresses will *not* be able to transfer even when *not locked*
98   mapping(address => bool) public allowedAddresses;
99   mapping(address => bool) public lockedAddresses;
100   bool public locked = true;
101 
102   function allowAddress(address _addr, bool _allowed) public onlyOwner {
103     require(_addr != owner);
104     allowedAddresses[_addr] = _allowed;
105   }
106 
107   function lockAddress(address _addr, bool _locked) public onlyOwner {
108     require(_addr != owner);
109     lockedAddresses[_addr] = _locked;
110   }
111 
112   function setLocked(bool _locked) public onlyOwner {
113     locked = _locked;
114   }
115 
116   function canTransfer(address _addr) public view returns (bool) {
117     if (locked) {
118       if(!allowedAddresses[_addr] &&_addr !=owner) return false;
119     } else if (lockedAddresses[_addr]) return false;
120 
121     return true;
122   }
123 
124 
125 
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(canTransfer(msg.sender));
135     
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public constant returns (uint256 balance) {
150     return balances[_owner];
151   }
152 }
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender) public constant returns (uint256);
160   function transferFrom(address from, address to, uint256 value) public returns (bool);
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(canTransfer(msg.sender));
187 
188     uint256 _allowance = allowed[_from][msg.sender];
189 
190     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191     // require (_value <= _allowance);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = _allowance.sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    */
232   function increaseApproval (address _spender, uint _addedValue)
233     public
234     returns (bool success) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   function decreaseApproval (address _spender, uint _subtractedValue)
241     public
242     returns (bool success) {
243     uint oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue > oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 }
253 
254 
255 /**
256  * @title Burnable Token
257  * @dev Token that can be irreversibly burned (destroyed).
258  */
259 contract BurnableToken is StandardToken {
260 
261     event Burn(address indexed burner, uint256 value);
262 
263     /**
264      * @dev Burns a specific amount of tokens.
265      * @param _value The amount of token to be burned.
266      */
267     function burn(uint256 _value) public {
268         require(_value > 0);
269         require(_value <= balances[msg.sender]);
270         // no need to require value <= totalSupply, since that would imply the
271         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273         address burner = msg.sender;
274         balances[burner] = balances[burner].sub(_value);
275         totalSupply = totalSupply.sub(_value);
276         emit Burn(burner, _value);
277         emit Transfer(burner, address(0), _value);
278     }
279 }
280 
281 contract ReliableIndex  is BurnableToken {
282 
283     string public constant name = "RIN";
284     string public constant symbol = "RIN";
285     uint public constant decimals = 18;
286     // there is no problem in using * here instead of .mul()
287     uint256 public constant initialSupply = 1000000000 * (10 ** uint256(decimals));
288 
289     // Constructors
290     constructor () public {
291         totalSupply = initialSupply;
292         balances[msg.sender] = initialSupply; // Send all tokens to owner
293         // owner is allowed to send tokens even when locked
294         allowedAddresses[owner] = true;
295         emit Transfer(address(0), owner, initialSupply);
296     }
297 
298 }