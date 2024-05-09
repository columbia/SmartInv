1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() public {
195     owner = msg.sender;
196   }
197 
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) public onlyOwner {
213     require(newOwner != address(0));
214     OwnershipTransferred(owner, newOwner);
215     owner = newOwner;
216   }
217 
218 }
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225   event PausePublic(bool newState);
226   event PauseOwnerAdmin(bool newState);
227 
228   bool public pausedPublic = false;
229   bool public pausedOwnerAdmin = false;
230 
231   address public admin;
232 
233   /**
234    * @dev Modifier to make a function callable based on pause states.
235    */
236   modifier whenNotPaused() {
237     if(pausedPublic) {
238       if(!pausedOwnerAdmin) {
239         require(msg.sender == admin || msg.sender == owner);
240       } else {
241         revert();
242       }
243     }
244     _;
245   }
246 
247   /**
248    * @dev called by the owner to set new pause flags
249    * pausedPublic can't be false while pausedOwnerAdmin is true
250    */
251   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
252     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
253 
254     pausedPublic = newPausedPublic;
255     pausedOwnerAdmin = newPausedOwnerAdmin;
256 
257     PausePublic(newPausedPublic);
258     PauseOwnerAdmin(newPausedOwnerAdmin);
259   }
260 }
261 
262 contract PausableToken is StandardToken, Pausable {
263 
264   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
265     return super.transfer(_to, _value);
266   }
267 
268   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
269     return super.transferFrom(_from, _to, _value);
270   }
271 
272   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
273     return super.approve(_spender, _value);
274   }
275 
276   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
277     return super.increaseApproval(_spender, _addedValue);
278   }
279 
280   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
281     return super.decreaseApproval(_spender, _subtractedValue);
282   }
283 }
284 
285 
286 contract TXTToken is PausableToken {
287     string  public  constant name = "旅链";
288     string  public  constant symbol = "TXT";
289     uint8   public  constant decimals = 18;
290 
291     modifier validDestination( address to )
292     {
293         require(to != address(0x0));
294         require(to != address(this));
295         _;
296     }
297 
298     function TXTToken( address _admin, uint _totalTokenAmount ) 
299     {
300         // assign the admin account
301         admin = _admin;
302 
303         // assign the total tokens to TXT
304         totalSupply = _totalTokenAmount;
305         balances[msg.sender] = _totalTokenAmount;
306         Transfer(address(0x0), msg.sender, _totalTokenAmount);
307     }
308 
309     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
310     {
311         return super.transfer(_to, _value);
312     }
313 
314     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
315     {
316         return super.transferFrom(_from, _to, _value);
317     }
318 
319     event Burn(address indexed _burner, uint _value);
320 
321     function burn(uint _value) returns (bool)
322     {
323         balances[msg.sender] = balances[msg.sender].sub(_value);
324         totalSupply = totalSupply.sub(_value);
325         Burn(msg.sender, _value);
326         Transfer(msg.sender, address(0x0), _value);
327         return true;
328     }
329 
330     // save some gas by making only one contract call
331     function burnFrom(address _from, uint256 _value) returns (bool) 
332     {
333         assert( transferFrom( _from, msg.sender, _value ) );
334         return burn(_value);
335     }
336 
337     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
338         // owner can drain tokens that are sent here by mistake
339         token.transfer( owner, amount );
340     }
341 
342     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
343 
344     function changeAdmin(address newAdmin) onlyOwner {
345         // owner can re-assign the admin
346         AdminTransferred(admin, newAdmin);
347         admin = newAdmin;
348     }
349 }