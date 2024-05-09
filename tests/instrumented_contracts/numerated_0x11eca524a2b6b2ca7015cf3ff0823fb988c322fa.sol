1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12 
13         uint256 c = a * b;
14         require(c / a == b);
15 
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Solidity only automatically asserts when dividing by 0
21         require(b > 0);
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b != 0);
44         return a % b;
45     }
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
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() internal {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
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
92   function balanceOf(address who) public view returns (uint256);
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
105   mapping(address => uint256) internal balances;
106   // allowedAddresses will be able to transfer even when locked
107   // lockedAddresses will *not* be able to transfer even when *not locked*
108   mapping(address => bool) internal allowedAddresses;
109   mapping(address => bool) internal lockedAddresses;
110   bool public locked = true;
111   
112   mapping(address => uint256) internal lockedBalances;
113   event LockBalance(address indexed _addr, uint256 _lockAmount);
114 
115   function allowAddress(address _addr, bool _allowed) public onlyOwner {
116     require(_addr != owner);
117     allowedAddresses[_addr] = _allowed;
118   }
119 
120   function lockAddress(address _addr, bool _locked) public onlyOwner {
121     require(_addr != owner);
122     lockedAddresses[_addr] = _locked;
123   }
124 
125   function setLocked(bool _locked) public onlyOwner {
126     locked = _locked;
127   }
128 
129   function canTransfer(address _addr) public view returns (bool) {
130     if(locked) {
131       if(!allowedAddresses[_addr] && _addr != owner) {
132           return false;
133       }
134     } else if(lockedAddresses[_addr]) {
135         return false;
136     }
137 
138     return true;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(canTransfer(msg.sender));
149     require(checkHolderBalance(msg.sender, _value));
150     
151     // SafeMath.sub will throw if there is not enough balance.
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     
155     emit Transfer(msg.sender, _to, _value);
156     return true;
157   }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163   */
164   function balanceOf(address _owner) public view returns (uint256 balance) {
165     return balances[_owner];
166   }
167   
168   function lockBalance(address _addr, uint256 _lockAmount) onlyOwner public {
169       require(_addr != address(0));
170       //require(_lockAmount != 0);
171       
172       lockedBalances[_addr] = _lockAmount;
173       emit LockBalance(_addr, _lockAmount);
174   }
175   
176   function lockedBalanceOf(address _addr) public view returns (uint256) {
177       return lockedBalances[_addr];
178   }
179   
180   function checkHolderBalance(address _addr, uint256 _sendAmount) internal view returns (bool) {
181       if (balances[_addr] >= lockedBalances[_addr]
182         && balances[_addr].sub(lockedBalances[_addr]) >= _sendAmount) {
183           return true;
184       } else {
185           return false;
186       }
187   }
188 }
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(canTransfer(msg.sender));
220     require(checkHolderBalance(_from, _value));
221 
222     uint256 _allowance = allowed[_from][msg.sender];
223 
224     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
225     // require (_value <= _allowance);
226 
227     balances[_from] = balances[_from].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = _allowance.sub(_value);
230     
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
269     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270     
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
276     uint oldValue = allowed[msg.sender][_spender];
277     
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 }
288 
289 /**
290  * @title Burnable Token
291  * @dev Token that can be irreversibly burned (destroyed).
292  */
293 contract BurnableToken is StandardToken {
294     event Burn(address indexed burner, uint256 value);
295 
296     /**
297      * @dev Burns a specific amount of tokens.
298      * @param _value The amount of token to be burned.
299      */
300     function burn(uint256 _value) public {
301         require(_value > 0);
302         require(_value <= balances[msg.sender]);
303         // no need to require value <= totalSupply, since that would imply the
304         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
305 
306         address burner = msg.sender;
307         balances[burner] = balances[burner].sub(_value);
308         totalSupply = totalSupply.sub(_value);
309         emit Burn(burner, _value);
310         emit Transfer(burner, address(0), _value);
311     }
312 }
313 
314 contract Token  is BurnableToken {
315     string public constant name = "NiX-M";
316     string public constant symbol = "NiXM";
317     uint256 public constant decimals = 18;
318     // there is no problem in using * here instead of .mul()
319     uint256 public constant initialSupply = 10_000_000_000 * (10 ** decimals);
320 
321     // Constructors
322     constructor() public {
323         totalSupply = initialSupply;
324         balances[msg.sender] = initialSupply; // Send all tokens to owner
325         allowedAddresses[owner] = true;
326     }
327 }