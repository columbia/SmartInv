1 // @website https://www.yidaibi.me/
2 // @English https://en.yidaibi.me/
3 // @SendTokens https://www.qunfaba.com/
4 // @exchange https://www.yunjiami.com/
5 
6 pragma solidity ^0.4.18;
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[msg.sender]);
83 
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public view returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[_from]);
123     require(_value <= allowed[_from][msg.sender]);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128     Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    *
135    * Beware that changing an allowance with this method brings the risk that someone may use both the old
136    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139    * @param _spender The address which will spend the funds.
140    * @param _value The amount of tokens to be spent.
141    */
142   function approve(address _spender, uint256 _value) public returns (bool) {
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public view returns (uint256) {
155     return allowed[_owner][_spender];
156   }
157 
158   /**
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181 }
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control
186  * functions, this simplifies the implementation of "user permissions".
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner) public onlyOwner {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 /**
226  * @title Pausable
227  * @dev Base contract which allows children to implement an emergency stop mechanism.
228  */
229 contract Pausable is Ownable {
230   event PausePublic(bool newState);
231   event PauseOwnerAdmin(bool newState);
232 
233   bool public pausedPublic = false;
234   bool public pausedOwnerAdmin = false;
235 
236   address public admin;
237 
238   /**
239    * @dev Modifier to make a function callable based on pause states.
240    */
241   modifier whenNotPaused() {
242     if(pausedPublic) {
243       if(!pausedOwnerAdmin) {
244         require(msg.sender == admin || msg.sender == owner);
245       } else {
246         revert();
247       }
248     }
249     _;
250   }
251 
252   /**
253    * @dev called by the owner to set new pause flags
254    * pausedPublic can't be false while pausedOwnerAdmin is true
255    */
256   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
257     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
258 
259     pausedPublic = newPausedPublic;
260     pausedOwnerAdmin = newPausedOwnerAdmin;
261 
262     PausePublic(newPausedPublic);
263     PauseOwnerAdmin(newPausedOwnerAdmin);
264   }
265 }
266 
267 contract PausableToken is StandardToken, Pausable {
268 
269   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
270     return super.transfer(_to, _value);
271   }
272 
273   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
274     return super.transferFrom(_from, _to, _value);
275   }
276 
277   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
278     return super.approve(_spender, _value);
279   }
280 
281   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
282     return super.increaseApproval(_spender, _addedValue);
283   }
284 
285   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
286     return super.decreaseApproval(_spender, _subtractedValue);
287   }
288 }
289 
290 
291 contract YiDaiBiToken is PausableToken {
292     string  public  constant name = "https://www.yidaibi.me/ 最佳一键发币解决方案 Create tokens easily";
293     string  public  constant symbol = "www.yidaibi.me一键发币CreateTokens";
294     uint8   public  constant decimals = 18;
295 
296     modifier validDestination( address to )
297     {
298         require(to != address(0x0));
299         require(to != address(this));
300         _;
301     }
302 
303     function YiDaiBiToken( address _admin, uint _totalTokenAmount ) 
304     {
305         // assign the admin account
306         admin = _admin;
307 
308         // assign the total tokens to YiDaiBi
309         totalSupply = _totalTokenAmount;
310         balances[msg.sender] = _totalTokenAmount;
311         Transfer(address(0x0), msg.sender, _totalTokenAmount);
312     }
313 
314     function transfer(address _to, uint _value) validDestination(_to) returns (bool) 
315     {
316         return super.transfer(_to, _value);
317     }
318 
319     function transferFrom(address _from, address _to, uint _value) validDestination(_to) returns (bool) 
320     {
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324     event Burn(address indexed _burner, uint _value);
325 
326     function burn(uint _value) returns (bool)
327     {
328         balances[msg.sender] = balances[msg.sender].sub(_value);
329         totalSupply = totalSupply.sub(_value);
330         Burn(msg.sender, _value);
331         Transfer(msg.sender, address(0x0), _value);
332         return true;
333     }
334 
335     // save some gas by making only one contract call
336     function burnFrom(address _from, uint256 _value) returns (bool) 
337     {
338         assert( transferFrom( _from, msg.sender, _value ) );
339         return burn(_value);
340     }
341 
342     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
343         // owner can drain tokens that are sent here by mistake
344         token.transfer( owner, amount );
345     }
346 
347     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
348 
349     function changeAdmin(address newAdmin) onlyOwner {
350         // owner can re-assign the admin
351         AdminTransferred(admin, newAdmin);
352         admin = newAdmin;
353     }
354 }