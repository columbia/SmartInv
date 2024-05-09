1 pragma solidity ^0.4.18;
2 
3 // @website sunpower.io
4 // @Partner ixx.com
5 // @Partner yunjiami.com
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[msg.sender]);
82 
83     // SafeMath.sub will throw if there is not enough balance.
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 }
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180 }
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188   address public owner;
189 
190 
191   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193 
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198   function Ownable() public {
199     owner = msg.sender;
200   }
201 
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.
215    */
216   function transferOwnership(address newOwner) public onlyOwner {
217     require(newOwner != address(0));
218     OwnershipTransferred(owner, newOwner);
219     owner = newOwner;
220   }
221 
222 }
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is Ownable {
229   event PausePublic(bool newState);
230   event PauseOwnerAdmin(bool newState);
231 
232   bool public pausedPublic = true;
233   bool public pausedOwnerAdmin = false;
234 
235   address public admin;
236 
237   /**
238    * @dev Modifier to make a function callable based on pause states.
239    */
240   modifier whenNotPaused() {
241     if(pausedPublic) {
242       if(!pausedOwnerAdmin) {
243         require(msg.sender == admin || msg.sender == owner);
244       } else {
245         revert();
246       }
247     }
248     _;
249   }
250 
251   /**
252    * @dev called by the owner to set new pause flags
253    * pausedPublic can't be false while pausedOwnerAdmin is true
254    */
255   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
256     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
257 
258     pausedPublic = newPausedPublic;
259     pausedOwnerAdmin = newPausedOwnerAdmin;
260 
261     PausePublic(newPausedPublic);
262     PauseOwnerAdmin(newPausedOwnerAdmin);
263   }
264 }
265 
266 contract PausableToken is StandardToken, Pausable {
267 
268   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
269     return super.transfer(_to, _value);
270   }
271 
272   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transferFrom(_from, _to, _value);
274   }
275 
276   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
277     return super.approve(_spender, _value);
278   }
279 
280   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
281     return super.increaseApproval(_spender, _addedValue);
282   }
283 
284   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
285     return super.decreaseApproval(_spender, _subtractedValue);
286   }
287 }
288 
289 
290 contract EveryBodyToken is PausableToken {
291     string  public  constant name = "EveryBody";
292     string  public  constant symbol = "EB";
293     uint8   public  constant decimals = 18;
294 
295     modifier validDestination( address to )
296     {
297         require(to != address(0x0));
298         require(to != address(this));
299         _;
300     }
301 
302     function EveryBodyToken( address _admin, uint _totalTokenAmount ) 
303     {
304         // assign the admin account
305         admin = _admin;
306 
307         // assign the total tokens to EveryBody
308         totalSupply = _totalTokenAmount;
309         balances[msg.sender] = _totalTokenAmount;
310         Transfer(address(0x0), msg.sender, _totalTokenAmount);
311     }
312 
313     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
314     {
315         return super.transfer(_to, _value);
316     }
317 
318     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
319     {
320         return super.transferFrom(_from, _to, _value);
321     }
322 
323     event Burn(address indexed _burner, uint _value);
324 
325     function burn(uint _value) returns (bool)
326     {
327         balances[msg.sender] = balances[msg.sender].sub(_value);
328         totalSupply = totalSupply.sub(_value);
329         Burn(msg.sender, _value);
330         Transfer(msg.sender, address(0x0), _value);
331         return true;
332     }
333 
334     // save some gas by making only one contract call
335     function burnFrom(address _from, uint256 _value) returns (bool) 
336     {
337         assert( transferFrom( _from, msg.sender, _value ) );
338         return burn(_value);
339     }
340 
341     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
342         // owner can drain tokens that are sent here by mistake
343         token.transfer( owner, amount );
344     }
345 
346     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
347 
348     function changeAdmin(address newAdmin) onlyOwner {
349         // owner can re-assign the admin
350         AdminTransferred(admin, newAdmin);
351         admin = newAdmin;
352     }
353 }