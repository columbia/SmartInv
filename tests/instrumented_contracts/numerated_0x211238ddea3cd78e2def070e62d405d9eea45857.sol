1 pragma solidity ^0.4.24;
2 
3 // ——————————————————————————————————————
4 // 'PX' token contract
5 //
6 // Symbol      : PX
7 // Name        : PlatformX Token
8 // Total supply: 5000000000
9 // Decimals    : 18
10 //
11 // CEO: Yeo Myeong Kim
12 // CTO: In Hyuk Seo
13 // COO: Boo Yoon Hwang
14 //
15 // InBloc Co., Ltd. (https://www.inbloc.kr)
16 // ——————————————————————————————————————
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (_a == 0) {
32       return 0;
33     }
34 
35     c = _a * _b;
36     assert(c / _a == _b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     // assert(_b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = _a / _b;
46     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
47     return _a / _b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     assert(_b <= _a);
55     return _a - _b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
62     c = _a + _b;
63     assert(c >= _a);
64     return c;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) onlyOwner public {
104     require(newOwner != address(0));
105     emit OwnershipTransferred(owner, newOwner);
106     owner = newOwner;
107   }
108 
109 }
110 
111 
112 
113 
114 /**
115  * @title Pausable
116  * @dev Base contract which allows children to implement an emergency stop mechanism.
117  */
118 contract Pausable is Ownable {
119   event Pause();
120   event Unpause();
121 
122   bool public paused = false;
123 
124 
125   /**
126    * @dev Modifier to make a function callable only when the contract is not paused.
127    */
128   modifier whenNotPaused() {
129     require(!paused);
130     _;
131   }
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is paused.
135    */
136   modifier whenPaused() {
137     require(paused);
138     _;
139   }
140 
141   /**
142    * @dev called by the owner to pause, triggers stopped state
143    */
144   function pause() onlyOwner whenNotPaused public {
145     paused = true;
146     emit Pause();
147   }
148 
149   /**
150    * @dev called by the owner to unpause, returns to normal state
151    */
152   function unpause() onlyOwner whenPaused public {
153     paused = false;
154     emit Unpause();
155   }
156 }
157 
158 
159 /**
160  * @title ERC20Basic
161  * @dev Simpler version of ERC20 interface
162  * @dev see https://github.com/ethereum/EIPs/issues/179
163  */
164 contract ERC20Basic {
165   uint256 public totalSupply;
166   function balanceOf(address who) public constant returns (uint256);
167   function transfer(address to, uint256 value) public returns (bool);
168   event Transfer(address indexed from, address indexed to, uint256 value);
169 }
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public constant returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances.
189  */
190 contract BasicToken is ERC20Basic {
191   using SafeMath for uint256;
192 
193   mapping(address => uint256) balances;
194 
195 
196 
197   /**
198   * @dev transfer token for a specified address
199   * @param _to The address to transfer to.
200   * @param _value The amount to be transferred.
201   */
202   function transfer(address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204 
205     // SafeMath.sub will throw if there is not enough balance.
206     balances[msg.sender] = balances[msg.sender].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     emit Transfer(msg.sender, _to, _value);
209     return true;
210   }
211 
212   /**
213   * @dev Gets the balance of the specified address.
214   * @param _owner The address to query the the balance of.
215   * @return An uint256 representing the amount owned by the passed address.
216   */
217   function balanceOf(address _owner) public constant returns (uint256 balance) {
218     return balances[_owner];
219   }
220 
221 }
222 
223 
224 
225 
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * @dev https://github.com/ethereum/EIPs/issues/20
232  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is ERC20, BasicToken {
235 
236   mapping (address => mapping (address => uint256)) allowed;
237 
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246     require(_to != address(0));
247 
248     uint256 _allowance = allowed[_from][msg.sender];
249 
250     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
251     // require (_value <= _allowance);
252 
253     balances[_from] = balances[_from].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     allowed[_from][msg.sender] = _allowance.sub(_value);
256     emit Transfer(_from, _to, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    *
263    * Beware that changing an allowance with this method brings the risk that someone may use both the old
264    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    * @param _spender The address which will spend the funds.
268    * @param _value The amount of tokens to be spent.
269    */
270   function approve(address _spender, uint256 _value) public returns (bool) {
271     allowed[msg.sender][_spender] = _value;
272     emit Approval(msg.sender, _spender, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Function to check the amount of tokens that an owner allowed to a spender.
278    * @param _owner address The address which owns the funds.
279    * @param _spender address The address which will spend the funds.
280    * @return A uint256 specifying the amount of tokens still available for the spender.
281    */
282   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
283     return allowed[_owner][_spender];
284   }
285 
286   function increaseApproval (address _spender, uint _addedValue) public
287     returns (bool success) {
288     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   function decreaseApproval (address _spender, uint _subtractedValue) public
294     returns (bool success) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 
308 
309 /**
310  * @title Burnable Token
311  * @dev Token that can be irreversibly burned (destroyed).
312  */
313 contract BurnableToken is StandardToken {
314 
315     event Burn(address indexed burner, uint256 value);
316 
317     /**
318      * @dev Burns a specific amount of tokens.
319      * @param _value The amount of token to be burned.
320      */
321     function burn(uint256 _value) public {
322         require(_value > 0);
323 
324         address burner = msg.sender;
325         balances[burner] = balances[burner].sub(_value);
326         totalSupply = totalSupply.sub(_value);
327         emit Burn(burner, _value);
328     }
329 }
330 
331 // InBloc Co., Ltd. (info@inbloc.kr)
332 
333 
334 
335 /**
336  * The PlatformX Token (PX) has a fixed supply and is not mintable.
337  */
338 contract PXToken is StandardToken, BurnableToken, Ownable {
339 
340     // Constants
341     string  public constant name = "PlatformX Token";
342     string  public constant symbol = "PX";
343     uint8   public constant decimals = 18;
344     uint256 public constant INITIAL_SUPPLY      = 5000000000 * (10 ** uint256(decimals));
345 
346 
347     constructor() public {
348 
349         totalSupply = INITIAL_SUPPLY;
350         balances[msg.sender] = totalSupply;
351         emit Transfer(address(0x0), msg.sender, totalSupply);
352 
353     }
354 
355     function transfer(address _to, uint256 _value) public returns (bool) {
356         return super.transfer(_to, _value);
357     }
358 
359     function burn(uint256 _value) public {
360         require(msg.sender == owner);
361         require(balances[msg.sender] >= _value);
362         super.burn(_value);
363         emit Transfer(msg.sender, address(0x0), _value);
364     }
365 }