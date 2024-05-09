1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/zeppelin/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 // File: contracts/zeppelin/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: contracts/zeppelin/token/ERC20.sol
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: contracts/zeppelin/token/StandardToken.sol
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184 }
185 
186 // File: contracts/zeppelin/ownership/Ownable.sol
187 
188 /**
189  * @title Ownable
190  * @dev The Ownable contract has an owner address, and provides basic authorization control
191  * functions, this simplifies the implementation of "user permissions".
192  */
193 contract Ownable {
194   address public owner;
195 
196 
197   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   function Ownable() public {
205     owner = msg.sender;
206   }
207 
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) public onlyOwner {
223     require(newOwner != address(0));
224     OwnershipTransferred(owner, newOwner);
225     owner = newOwner;
226   }
227 
228 }
229 
230 // File: contracts/zeppelin/lifecycle/Pausable.sol
231 
232 // custom Pausable implementation for Quanta
233 
234 
235 
236 /**
237  * @title Pausable
238  * @dev Base contract which allows children to implement an emergency stop mechanism.
239  */
240 contract Pausable is Ownable {
241   event PausePublic(bool newState);
242   event PauseOwnerAdmin(bool newState);
243 
244   bool public pausedPublic = true;
245   bool public pausedOwnerAdmin = false;
246 
247   address public admin;
248 
249   /**
250    * @dev Modifier to make a function callable based on pause states.
251    */
252   modifier whenNotPaused() {
253     if(pausedPublic) {
254       if(!pausedOwnerAdmin) {
255         require(msg.sender == admin || msg.sender == owner);
256       } else {
257         revert();
258       }
259     }
260     _;
261   }
262 
263   /**
264    * @dev called by the owner to set new pause flags
265    * pausedPublic can't be false while pausedOwnerAdmin is true
266    */
267   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
268     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
269 
270     pausedPublic = newPausedPublic;
271     pausedOwnerAdmin = newPausedOwnerAdmin;
272 
273     PausePublic(newPausedPublic);
274     PauseOwnerAdmin(newPausedOwnerAdmin);
275   }
276 }
277 
278 // File: contracts/zeppelin/token/PausableToken.sol
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
309 // File: contracts/QuantaToken.sol
310 
311 contract QuantaToken is PausableToken {
312     string  public  constant name = "QUANTA";
313     string  public  constant symbol = "QDEX";
314     uint8   public  constant decimals = 9;
315     uint256 public INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));
316 
317     function QuantaToken() 
318     {
319         admin = owner;
320         totalSupply = INITIAL_SUPPLY;
321         balances[msg.sender] = INITIAL_SUPPLY;
322         Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
323     }
324 
325     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
326 
327     function changeAdmin(address newAdmin) onlyOwner {
328         // owner can re-assign the admin
329         AdminTransferred(admin, newAdmin);
330         admin = newAdmin;
331     }
332 }