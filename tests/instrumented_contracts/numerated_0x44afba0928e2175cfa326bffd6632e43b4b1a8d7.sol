1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title Read-only ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ReadOnlyToken {
21     uint256 public totalSupply;
22     function balanceOf(address who) public constant returns (uint256);
23     function allowance(address owner, address spender) public constant returns (uint256);
24 }
25 
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract Token is ReadOnlyToken {
31   function transfer(address to, uint256 value) public returns (bool);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract MintableToken is Token {
39     event Mint(address indexed to, uint256 amount);
40 
41     function mint(address _to, uint256 _amount) public returns (bool);
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  * @dev this version copied from zeppelin-solidity, constant changed to pure
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 contract ReadOnlyTokenImpl is ReadOnlyToken {
79     mapping(address => uint256) balances;
80     mapping(address => mapping(address => uint256)) internal allowed;
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     /**
92      * @dev Function to check the amount of tokens that an owner allowed to a spender.
93      * @param _owner address The address which owns the funds.
94      * @param _spender address The address which will spend the funds.
95      * @return A uint256 specifying the amount of tokens still available for the spender.
96      */
97     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract TokenImpl is Token, ReadOnlyTokenImpl {
110   using SafeMath for uint256;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emitTransfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   function emitTransfer(address _from, address _to, uint256 _value) internal {
129     Transfer(_from, _to, _value);
130   }
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     emitTransfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    */
172   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
173     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 contract MintableTokenImpl is Ownable, TokenImpl, MintableToken {
192     /**
193      * @dev Function to mint tokens
194      * @param _to The address that will receive the minted tokens.
195      * @param _amount The amount of tokens to mint.
196      * @return A boolean that indicates if the operation was successful.
197      */
198     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
199         totalSupply = totalSupply.add(_amount);
200         balances[_to] = balances[_to].add(_amount);
201         emitMint(_to, _amount);
202         emitTransfer(address(0), _to, _amount);
203         return true;
204     }
205 
206     function emitMint(address _to, uint256 _value) internal {
207         Mint(_to, _value);
208     }
209 }
210 
211 /**
212  * @title OwnableImpl
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract OwnableImpl is Ownable {
217     address public owner;
218 
219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221     /**
222      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223      * account.
224      */
225     function OwnableImpl() public {
226         owner = msg.sender;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     function checkOwner() internal {
233         require(msg.sender == owner);
234     }
235 
236     /**
237      * @dev Allows the current owner to transfer control of the contract to a newOwner.
238      * @param newOwner The address to transfer ownership to.
239      */
240     function transferOwnership(address newOwner) onlyOwner public {
241         require(newOwner != address(0));
242         OwnershipTransferred(owner, newOwner);
243         owner = newOwner;
244     }
245 }
246 
247 /**
248  * @title Pausable
249  * @dev Base contract which allows children to implement an emergency stop mechanism.
250  */
251 contract Pausable is Ownable {
252     event Pause();
253     event Unpause();
254 
255     bool public paused = false;
256 
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      */
261     modifier whenNotPaused() {
262         require(!paused);
263         _;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is paused.
268      */
269     modifier whenPaused() {
270         require(paused);
271         _;
272     }
273 
274     /**
275      * @dev called by the owner to pause, triggers stopped state
276      */
277     function pause() onlyOwner whenNotPaused public {
278         paused = true;
279         Pause();
280     }
281 
282     /**
283      * @dev called by the owner to unpause, returns to normal state
284      */
285     function unpause() onlyOwner whenPaused public {
286         paused = false;
287         Unpause();
288     }
289 }
290 
291 contract PausableToken is Pausable, TokenImpl {
292 
293 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
294 		return super.transfer(_to, _value);
295 	}
296 
297 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
298 		return super.transferFrom(_from, _to, _value);
299 	}
300 
301 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
302 		return super.approve(_spender, _value);
303 	}
304 
305 	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
306 		return super.increaseApproval(_spender, _addedValue);
307 	}
308 
309 	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
310 		return super.decreaseApproval(_spender, _subtractedValue);
311 	}
312 }
313 
314 contract BurnableToken is Token {
315 	event Burn(address indexed burner, uint256 value);
316 	function burn(uint256 _value) public;
317 }
318 
319 contract BurnableTokenImpl is TokenImpl, BurnableToken {
320 	/**
321 	 * @dev Burns a specific amount of tokens.
322 	 * @param _value The amount of token to be burned.
323 	 */
324 	function burn(uint256 _value) public {
325 		require(_value <= balances[msg.sender]);
326 		// no need to require value <= totalSupply, since that would imply the
327 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
328 
329 		address burner = msg.sender;
330 		balances[burner] = balances[burner].sub(_value);
331 		totalSupply = totalSupply.sub(_value);
332 		Burn(burner, _value);
333 	}
334 }
335 
336 contract HcftToken is OwnableImpl, PausableToken, MintableTokenImpl, BurnableTokenImpl {
337 	string public constant name = "HARITONOV CAPITAL FUND TOKEN";
338 	string public constant symbol = "HCFT";
339 	uint8 public constant decimals = 18;
340 
341 	function burn(uint256 _value) public whenNotPaused {
342 		super.burn(_value);
343 	}
344 }