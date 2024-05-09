1 pragma solidity 0.6.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'XTAKE' token contract
5 //
6 // Symbol      : XTK
7 // Name        : XTAKE
8 // Total supply: 10 000 000 000
9 // Decimals    : 6
10 // ----------------------------------------------------------------------------
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath{
18       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
19     {
20         if (a == 0) {
21         return 0;}
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) 
28     {
29         uint256 c = a / b;
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
34     {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) 
40     {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 
46 }
47  
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
66   constructor () internal {
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
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */ 
96 interface ERC20Basic {
97   
98   function balanceOf(address who) external view returns (uint256 balance);
99   function transfer(address to, uint256 value) external returns (bool trans1);
100   function allowance(address owner, address spender) external view returns (uint256 remaining);
101   function transferFrom(address from, address to, uint256 value) external returns (bool trans);
102   function approve(address spender, uint256 value) external returns (bool hello);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is  ERC20Basic, Ownable {
123 
124 
125 
126 uint256 public totalSupply;
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130   // allowedAddresses will be able to transfer even when locked
131   // lockedAddresses will *not* be able to transfer even when *not locked*
132   mapping(address => bool) public allowedAddresses;
133   mapping(address => bool) public lockedAddresses;
134   bool public locked = true;
135 
136   function allowAddress(address _addr, bool _allowed) public onlyOwner {
137     require(_addr != owner);
138     allowedAddresses[_addr] = _allowed;
139   }
140 
141   function lockAddress(address _addr, bool _locked) public onlyOwner {
142     require(_addr != owner);
143     lockedAddresses[_addr] = _locked;
144   }
145 
146   function setLocked(bool _locked) public onlyOwner {
147     locked = _locked;
148   }
149 
150   function canTransfer(address _addr) public view returns (bool can1) {
151     if(locked){
152       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
153     }else if(lockedAddresses[_addr]) return false;
154 
155     return true;
156   }
157 
158 
159 
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public override returns (bool trans1) {
167     require(_to != address(0));
168     require(canTransfer(msg.sender));
169     
170 
171     // SafeMath.sub will throw if there is not enough balance.
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   
182   */
183   function balanceOf(address _owner) public view override returns (uint256 balance) {
184     return balances[_owner];
185   }
186 
187 
188   mapping (address => mapping (address => uint256)) allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public override returns (bool trans) {
198     require(_to != address(0));
199     require(canTransfer(msg.sender));
200 
201     uint256 _allowance = allowed[_from][msg.sender];
202 
203     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
204     // require (_value <= _allowance);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = _allowance.sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public override returns (bool hello) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    
234    */
235   function allowance(address _owner, address _spender) public view override  returns (uint256 remaining) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    */
245   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   function decreaseApproval (address _spender, uint _subtractedValue) public  returns (bool success) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
285         emit Burn(burner, _value);
286         emit Transfer(burner, address(0), _value);
287     }
288 }
289 
290 contract XTAKE is BurnableToken {
291 
292     string public constant name = "XTAKE";
293     string public constant symbol = "XTK";
294     uint public constant decimals = 6;
295     // there is no problem in using * here instead of .mul()
296     uint256 public constant initialSupply = 10000000000 * (10 ** uint256(decimals));
297 
298     // Constructors
299     constructor () public{
300         totalSupply = initialSupply;
301         balances[msg.sender] = initialSupply; // Send all tokens to owner
302         allowedAddresses[owner] = true;
303     }
304 
305 }