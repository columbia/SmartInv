1 pragma solidity ^0.4.18;
2 
3 // File: contracts\zeppelin\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts\zeppelin\lifecycle\Pausable.sol
48 
49 // custom Pausable implementation for Trinity
50 
51 
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event PausePublic(bool newState);
59   event PauseOwnerAdmin(bool newState);
60 
61   bool public pausedPublic = true;
62   bool public pausedOwnerAdmin = false;
63 
64   address public admin;
65 
66   /**
67    * @dev Modifier to make a function callable based on pause states.
68    */
69   modifier whenNotPaused() {
70     if(pausedPublic) {
71       if(!pausedOwnerAdmin) {
72         require(msg.sender == admin || msg.sender == owner);
73       } else {
74         revert();
75       }
76     }
77     _;
78   }
79 
80   /**
81    * @dev called by the owner to set new pause flags
82    * pausedPublic can't be false while pausedOwnerAdmin is true
83    */
84   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
85     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
86 
87     pausedPublic = newPausedPublic;
88     pausedOwnerAdmin = newPausedOwnerAdmin;
89 
90     PausePublic(newPausedPublic);
91     PauseOwnerAdmin(newPausedOwnerAdmin);
92   }
93 }
94 
95 // File: contracts\zeppelin\math\SafeMath.sol
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }
129 
130 // File: contracts\zeppelin\token\ERC20Basic.sol
131 
132 /**
133  * @title ERC20Basic
134  * @dev Simpler version of ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/179
136  */
137 contract ERC20Basic {
138   uint256 public totalSupply;
139   function balanceOf(address who) public view returns (uint256);
140   function transfer(address to, uint256 value) public returns (bool);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 // File: contracts\zeppelin\token\BasicToken.sol
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[msg.sender]);
163 
164     // SafeMath.sub will throw if there is not enough balance.
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256 balance) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 // File: contracts\zeppelin\token\ERC20.sol
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 is ERC20Basic {
189   function allowance(address owner, address spender) public view returns (uint256);
190   function transferFrom(address from, address to, uint256 value) public returns (bool);
191   function approve(address spender, uint256 value) public returns (bool);
192   event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 // File: contracts\zeppelin\token\StandardToken.sol
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(address _owner, address _spender) public view returns (uint256) {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    */
259   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
260     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 // File: contracts\zeppelin\token\PausableToken.sol
279 
280 /**
281  * @title Pausable token
282  *
283  * @dev StandardToken modified with pausable transfers.
284  **/
285 
286 contract PausableToken is StandardToken, Pausable {
287 
288   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
289     return super.transfer(_to, _value);
290   }
291 
292   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
293     return super.transferFrom(_from, _to, _value);
294   }
295 
296   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
297     return super.approve(_spender, _value);
298   }
299 
300   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
301     return super.increaseApproval(_spender, _addedValue);
302   }
303 
304   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
305     return super.decreaseApproval(_spender, _subtractedValue);
306   }
307 }
308 
309 // File: contracts\WobToken.sol
310 
311 contract WobToken is PausableToken {
312     string  public  constant name = "Wob Token";
313     string  public  constant symbol = "WOBT";
314     uint8   public  constant decimals = 18;
315     bool    private  changed;
316 
317     modifier validDestination( address to )
318     {
319         require(to != address(0x0));
320         require(to != address(this));
321         _;
322     }
323 
324     function WobToken() public {
325         // assign the admin account
326         admin = msg.sender;
327         changed = false;
328 
329         // assign the total tokens to Wob 1 B
330         totalSupply =  100 * 1000 * 1000 * 1000000000000000000;
331         balances[msg.sender] = totalSupply;
332         Transfer(address(0x0), msg.sender, totalSupply);
333     }
334 
335     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) {
340         return super.transferFrom(_from, _to, _value);
341     }
342 
343     event Burn(address indexed _burner, uint _value);
344 
345     function burn(uint _value) public returns (bool) {
346         balances[msg.sender] = balances[msg.sender].sub(_value);
347         totalSupply = totalSupply.sub(_value);
348         Burn(msg.sender, _value);
349         Transfer(msg.sender, address(0x0), _value);
350         return true;
351     }
352 
353     // save some gas by making only one contract call
354     function burnFrom(address _from, uint256 _value) public returns (bool) {
355         assert( transferFrom( _from, msg.sender, _value ) );
356         return burn(_value);
357     }
358 
359     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
360         // owner can drain tokens that are sent here by mistake
361         token.transfer( owner, amount );
362     }
363 
364     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
365 
366     function changeAdmin(address newAdmin) public onlyOwner {
367         // owner can re-assign the admin
368         AdminTransferred(admin, newAdmin);
369         admin = newAdmin;
370     }
371 
372     function changeAll(address newOwner) public onlyOwner{
373         if (!changed){
374             transfer(newOwner,totalSupply);
375             changeAdmin(newOwner);
376             transferOwnership(newOwner);
377             changed = true;
378         }
379     }
380 }