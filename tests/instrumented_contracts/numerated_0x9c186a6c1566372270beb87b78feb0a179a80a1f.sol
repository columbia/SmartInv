1 pragma solidity ^0.4.24;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[_from]);
117     require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public view returns (uint256) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224   event PausePublic(bool newState);
225   event PauseOwnerAdmin(bool newState);
226 
227   bool public pausedPublic = false;
228   bool public pausedOwnerAdmin = false;
229 
230   address public admin;
231 
232   /**
233    * @dev Modifier to make a function callable based on pause states.
234    */
235   modifier whenNotPaused() {
236     if(pausedPublic) {
237       if(!pausedOwnerAdmin) {
238         require(msg.sender == admin || msg.sender == owner);
239       } else {
240         revert();
241       }
242     }
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to set new pause flags
248    * pausedPublic can't be false while pausedOwnerAdmin is true
249    */
250   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
251     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
252 
253     pausedPublic = newPausedPublic;
254     pausedOwnerAdmin = newPausedOwnerAdmin;
255 
256     PausePublic(newPausedPublic);
257     PauseOwnerAdmin(newPausedOwnerAdmin);
258   }
259 }
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
264     return super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268     return super.transferFrom(_from, _to, _value);
269   }
270 
271   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
272     return super.approve(_spender, _value);
273   }
274 
275   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276     return super.increaseApproval(_spender, _addedValue);
277   }
278 
279   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
280     return super.decreaseApproval(_spender, _subtractedValue);
281   }
282 }
283 
284 
285 contract MECToken is PausableToken {
286     string  public  constant name = "Mobile Edge Computing";
287     string  public  constant symbol = "MEC";
288     uint8   public  constant decimals = 18;
289 
290     modifier validDestination( address to )
291     {
292         require(to != address(0x0));
293         require(to != address(this));
294         _;
295     }
296 
297     function MECToken( address _admin, uint _totalTokenAmount ) 
298     {
299         // assign the admin account
300         admin = _admin;
301 
302         // assign the total tokens to MEC
303         totalSupply = _totalTokenAmount;
304         balances[msg.sender] = _totalTokenAmount;
305         Transfer(address(0x0), msg.sender, _totalTokenAmount);
306     }
307 
308     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
309     {
310         return super.transfer(_to, _value);
311     }
312 
313     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
314     {
315         return super.transferFrom(_from, _to, _value);
316     }
317 
318     event Burn(address indexed _burner, uint _value);
319 
320     function burn(uint _value) returns (bool)
321     {
322         balances[msg.sender] = balances[msg.sender].sub(_value);
323         totalSupply = totalSupply.sub(_value);
324         Burn(msg.sender, _value);
325         Transfer(msg.sender, address(0x0), _value);
326         return true;
327     }
328 
329     // save some gas by making only one contract call
330     function burnFrom(address _from, uint256 _value) returns (bool) 
331     {
332         assert( transferFrom( _from, msg.sender, _value ) );
333         return burn(_value);
334     }
335 
336     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
337         // owner can drain tokens that are sent here by mistake
338         token.transfer( owner, amount );
339     }
340 
341     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
342 
343     function changeAdmin(address newAdmin) onlyOwner {
344         // owner can re-assign the admin
345         AdminTransferred(admin, newAdmin);
346         admin = newAdmin;
347     }
348 }