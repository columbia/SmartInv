1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 }
107 
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   /**
188    * @dev Decrease the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
198     uint oldValue = allowed[msg.sender][_spender];
199     if (_subtractedValue > oldValue) {
200       allowed[msg.sender][_spender] = 0;
201     } else {
202       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203     }
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 }
208 
209 /////
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   function Ownable() public {
228     owner = msg.sender;
229   }
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     require(newOwner != address(0));
245     OwnershipTransferred(owner, newOwner);
246     owner = newOwner;
247   }
248 
249 }
250 
251 /**
252  * @title Pausable
253  * @dev Base contract which allows children to implement an emergency stop mechanism.
254  */
255 contract Pausable is Ownable {
256   event Pause();
257   event Unpause();
258 
259   bool public paused = false;
260 
261 
262   /**
263    * @dev modifier to allow actions only when the contract IS paused
264    */
265   modifier whenNotPaused() {
266     require(!paused);
267     _;
268   }
269 
270   /**
271    * @dev modifier to allow actions only when the contract IS NOT paused
272    */
273   modifier whenPaused {
274     require(paused);
275     _;
276   }
277 
278   /**
279    * @dev called by the owner to pause, triggers stopped state
280    */
281   function pause() onlyOwner whenNotPaused public returns (bool) {
282     paused = true;
283     Pause();
284     return true;
285   }
286 
287   /**
288    * @dev called by the owner to unpause, returns to normal state
289    */
290   function unpause() onlyOwner whenPaused public returns (bool) {
291     paused = false;
292     Unpause();
293     return true;
294   }
295 }
296 
297 contract PausableToken is StandardToken, Pausable {
298 	function transferFrom(address from, address to, uint256 value) whenNotPaused public returns (bool) {
299 		return super.transferFrom(from,to,value);
300 	}
301 
302 	function approve(address spender, uint256 value) whenNotPaused public returns (bool) {
303 		return super.approve(spender,value);
304 	}
305 
306 	function transfer(address to, uint256 value) whenNotPaused public returns (bool) {
307 		return super.transfer(to,value);
308 	}
309 
310 	function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
311 		return super.increaseApproval(_spender,_addedValue);
312 	}
313 
314 	function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
315 		return super.decreaseApproval(_spender,_subtractedValue);
316 	}
317 }
318 
319 /**
320  * @title WCME Token for WCMC(World Chinese Merchant Chain)
321  * 
322  */
323 contract WCME is PausableToken {
324     string public name = "WCME Token for WCMC";
325     string public symbol = "WCME";
326     uint public decimals = 8;
327     string public version = "1.0";
328 
329     event Burn(address indexed from, uint256 value);
330   
331     function WCME() public {
332         totalSupply_ = 960000000 * 10 ** 8;
333         balances[owner] = totalSupply_;
334     }
335 
336    function burn(uint256 _value) onlyOwner public returns (bool success) {
337         require(balances[msg.sender] >= _value);                   // Check if the sender has enough
338 		    require(_value > 0); 
339         balances[msg.sender] = balances[msg.sender].sub(_value);  // Subtract from the sender
340         totalSupply_ = totalSupply_.sub(_value);                  // Updates totalSupply
341         Burn(msg.sender, _value);
342         return true;
343     }
344 
345     function () public {
346         revert();
347     }
348 }