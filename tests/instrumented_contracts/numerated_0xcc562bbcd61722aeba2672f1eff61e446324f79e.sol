1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event PausePublic(bool newState);
83   event PauseOwnerAdmin(bool newState);
84 
85   bool public pausedPublic = true;
86   bool public pausedOwnerAdmin = false;
87 
88   address public admin;
89 
90   /**
91    * @dev Modifier to make a function callable based on pause states.
92    */
93   modifier whenNotPaused() {
94     if(pausedPublic) {
95       if(!pausedOwnerAdmin) {
96         require(msg.sender == admin || msg.sender == owner);
97       } else {
98         revert();
99       }
100     }
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to set new pause flags
106    * pausedPublic can't be false while pausedOwnerAdmin is true
107    */
108   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
109     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
110 
111     pausedPublic = newPausedPublic;
112     pausedOwnerAdmin = newPausedOwnerAdmin;
113 
114     emit PausePublic(newPausedPublic);
115     emit PauseOwnerAdmin(newPausedOwnerAdmin);
116   }
117 }
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   uint256 public totalSupply;
126   function balanceOf(address who) public view returns (uint256);
127   function transfer(address to, uint256 value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public view returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
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
185   mapping (address => mapping (address => uint256)) internal allowed;
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
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     emit Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     emit Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    */
238   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
239     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract PausableToken is StandardToken, Pausable {
258 
259   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
260     return super.transfer(_to, _value);
261   }
262 
263   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
264     return super.transferFrom(_from, _to, _value);
265   }
266 
267   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
268     return super.approve(_spender, _value);
269   }
270 
271   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
272     return super.increaseApproval(_spender, _addedValue);
273   }
274 
275   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
276     return super.decreaseApproval(_spender, _subtractedValue);
277   }
278 }
279 contract Swachhcoin is PausableToken {
280     string  public  constant name = "Swachhcoin";
281     string  public  constant symbol = "SWACH";
282     uint8   public  constant decimals = 18;
283     uint256 public constant INITIAL_SUPPLY = 400000000 * 10**18;
284     modifier validDestination( address to )
285     {
286         require(to != address(0x0));
287         require(to != address(this));
288         _;
289     }
290 
291     constructor( address _admin ) public
292     {
293         // assign the admin account
294         admin = _admin;
295 
296        
297         totalSupply = INITIAL_SUPPLY;
298         balances[msg.sender] = INITIAL_SUPPLY;
299         emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
300     }
301 
302     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
303     {
304         return super.transfer(_to, _value);
305     }
306 
307     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
308     {
309         return super.transferFrom(_from, _to, _value);
310     }
311 
312     event Burn(address indexed _burner, uint _value);
313 
314     function burn(uint _value) onlyOwner returns (bool)
315     {
316         balances[msg.sender] = balances[msg.sender].sub(_value);
317         totalSupply = totalSupply.sub(_value);
318         emit Burn(msg.sender, _value);
319         emit Transfer(msg.sender, address(0x0), _value);
320         return true;
321     }
322 
323     // save some gas by making only one contract call
324     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool) 
325     {
326         assert( transferFrom( _from, msg.sender, _value ) );
327         return burn(_value);
328     }
329 
330     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
331         // owner can drain tokens that are sent here by mistake
332         token.transfer( owner, amount );
333     }
334 
335     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
336 
337     function changeAdmin(address newAdmin) public onlyOwner {
338         // owner can re-assign the admin
339         emit AdminTransferred(admin, newAdmin);
340         admin = newAdmin;
341     }
342 }