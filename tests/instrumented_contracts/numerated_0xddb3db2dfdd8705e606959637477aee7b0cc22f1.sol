1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    * From MonolithDAO Token.sol
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() public {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) public onlyOwner {
214     require(newOwner != address(0));
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 /**
222  * @title Pausable
223  * @dev Base contract which allows children to implement an emergency stop mechanism.
224  */
225 contract Pausable is Ownable {
226   event PausePublic(bool newState);
227   event PauseOwnerAdmin(bool newState);
228 
229   bool public pausedPublic = false;
230   bool public pausedOwnerAdmin = false;
231 
232   address public admin;
233 
234   /**
235    * @dev Modifier to make a function callable based on pause states.
236    */
237   modifier whenNotPaused() {
238     if(pausedPublic) {
239       if(!pausedOwnerAdmin) {
240         require(msg.sender == admin || msg.sender == owner);
241       } else {
242         revert();
243       }
244     }
245     _;
246   }
247 
248   /**
249    * @dev called by the owner to set new pause flags
250    * pausedPublic can't be false while pausedOwnerAdmin is true
251    */
252   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
253     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
254 
255     pausedPublic = newPausedPublic;
256     pausedOwnerAdmin = newPausedOwnerAdmin;
257 
258     PausePublic(newPausedPublic);
259     PauseOwnerAdmin(newPausedOwnerAdmin);
260   }
261 }
262 
263 contract PausableToken is StandardToken, Pausable {
264 
265   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
266     return super.transfer(_to, _value);
267   }
268 
269   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
270     return super.transferFrom(_from, _to, _value);
271   }
272 
273   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
274     return super.approve(_spender, _value);
275   }
276 
277   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
278     return super.increaseApproval(_spender, _addedValue);
279   }
280 
281   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
282     return super.decreaseApproval(_spender, _subtractedValue);
283   }
284 }
285 
286 
287 contract TyercoinToken is PausableToken {
288     string  public  constant name = "Tyercoin";
289     string  public  constant symbol = "TRC";
290     uint8   public  constant decimals = 18;
291 
292     modifier validDestination( address to )
293     {
294         require(to != address(0x0));
295         require(to != address(this));
296         _;
297     }
298 
299     function TyercoinToken( address _admin, uint _totalTokenAmount ) 
300     {
301         // assign the admin account
302         admin = _admin;
303 
304         // assign the total tokens to Tyercoin
305         totalSupply = _totalTokenAmount;
306         balances[msg.sender] = _totalTokenAmount;
307         Transfer(address(0x0), msg.sender, _totalTokenAmount);
308     }
309 
310     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
311     {
312         return super.transfer(_to, _value);
313     }
314 
315     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
316     {
317         return super.transferFrom(_from, _to, _value);
318     }
319 
320     event Burn(address indexed _burner, uint _value);
321 
322     function burn(uint _value) returns (bool)
323     {
324         balances[msg.sender] = balances[msg.sender].sub(_value);
325         totalSupply = totalSupply.sub(_value);
326         Burn(msg.sender, _value);
327         Transfer(msg.sender, address(0x0), _value);
328         return true;
329     }
330 
331     // save some gas by making only one contract call
332     function burnFrom(address _from, uint256 _value) returns (bool) 
333     {
334         assert( transferFrom( _from, msg.sender, _value ) );
335         return burn(_value);
336     }
337 
338     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
339         // owner can drain tokens that are sent here by mistake
340         token.transfer( owner, amount );
341     }
342 
343     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
344 
345     function changeAdmin(address newAdmin) onlyOwner {
346         // owner can re-assign the admin
347         AdminTransferred(admin, newAdmin);
348         admin = newAdmin;
349     }
350 }