1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * @dev this version copied from zeppelin-solidity, constant changed to pure
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /**
38  * @title Read-only ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/20
40  */
41 contract ReadOnlyToken {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function allowance(address owner, address spender) public constant returns (uint256);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract Token is ReadOnlyToken {
52   function transfer(address to, uint256 value) public returns (bool);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract ReadOnlyTokenImpl is ReadOnlyToken {
60     mapping(address => uint256) balances;
61     mapping(address => mapping(address => uint256)) internal allowed;
62 
63     /**
64     * @dev Gets the balance of the specified address.
65     * @param _owner The address to query the the balance of.
66     * @return An uint256 representing the amount owned by the passed address.
67     */
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     /**
73      * @dev Function to check the amount of tokens that an owner allowed to a spender.
74      * @param _owner address The address which owns the funds.
75      * @param _spender address The address which will spend the funds.
76      * @return A uint256 specifying the amount of tokens still available for the spender.
77      */
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 }
82 
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract TokenImpl is Token, ReadOnlyTokenImpl {
91   using SafeMath for uint256;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emitTransfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   function emitTransfer(address _from, address _to, uint256 _value) internal {
110     Transfer(_from, _to, _value);
111   }
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
127     emitTransfer(_from, _to, _value);
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
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    */
153   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
160     uint oldValue = allowed[msg.sender][_spender];
161     if (_subtractedValue > oldValue) {
162       allowed[msg.sender][_spender] = 0;
163     } else {
164       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165     }
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170 }
171 
172 contract BurnableToken is Token {
173 	event Burn(address indexed burner, uint256 value);
174 	function burn(uint256 _value) public;
175 }
176 
177 contract BurnableTokenImpl is TokenImpl, BurnableToken {
178 	/**
179 	 * @dev Burns a specific amount of tokens.
180 	 * @param _value The amount of token to be burned.
181 	 */
182 	function burn(uint256 _value) public {
183 		require(_value <= balances[msg.sender]);
184 		// no need to require value <= totalSupply, since that would imply the
185 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
186 
187 		address burner = msg.sender;
188 		balances[burner] = balances[burner].sub(_value);
189 		totalSupply = totalSupply.sub(_value);
190 		Burn(burner, _value);
191 	}
192 }
193 
194 /**
195  * @title Ownable
196  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
197  */
198 contract Ownable {
199     modifier onlyOwner() {
200         checkOwner();
201         _;
202     }
203 
204     function checkOwner() internal;
205 }
206 
207 contract MintableToken is Token {
208     event Mint(address indexed to, uint256 amount);
209 
210     function mint(address _to, uint256 _amount) public returns (bool);
211 }
212 
213 contract MintableTokenImpl is Ownable, TokenImpl, MintableToken {
214     /**
215      * @dev Function to mint tokens
216      * @param _to The address that will receive the minted tokens.
217      * @param _amount The amount of tokens to mint.
218      * @return A boolean that indicates if the operation was successful.
219      */
220     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
221         totalSupply = totalSupply.add(_amount);
222         balances[_to] = balances[_to].add(_amount);
223         emitMint(_to, _amount);
224         emitTransfer(address(0), _to, _amount);
225         return true;
226     }
227 
228     function emitMint(address _to, uint256 _value) internal {
229         Mint(_to, _value);
230     }
231 }
232 
233 /**
234  * @title Pausable
235  * @dev Base contract which allows children to implement an emergency stop mechanism.
236  */
237 contract Pausable is Ownable {
238     event Pause();
239     event Unpause();
240 
241     bool public paused = false;
242 
243 
244     /**
245      * @dev Modifier to make a function callable only when the contract is not paused.
246      */
247     modifier whenNotPaused() {
248         require(!paused);
249         _;
250     }
251 
252     /**
253      * @dev Modifier to make a function callable only when the contract is paused.
254      */
255     modifier whenPaused() {
256         require(paused);
257         _;
258     }
259 
260     /**
261      * @dev called by the owner to pause, triggers stopped state
262      */
263     function pause() onlyOwner whenNotPaused public {
264         paused = true;
265         Pause();
266     }
267 
268     /**
269      * @dev called by the owner to unpause, returns to normal state
270      */
271     function unpause() onlyOwner whenPaused public {
272         paused = false;
273         Unpause();
274     }
275 }
276 
277 contract PausableToken is Pausable, TokenImpl {
278 
279 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
280 		return super.transfer(_to, _value);
281 	}
282 
283 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
284 		return super.transferFrom(_from, _to, _value);
285 	}
286 
287 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
288 		return super.approve(_spender, _value);
289 	}
290 
291 	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
292 		return super.increaseApproval(_spender, _addedValue);
293 	}
294 
295 	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
296 		return super.decreaseApproval(_spender, _subtractedValue);
297 	}
298 }
299 
300 /**
301  * @title OwnableImpl
302  * @dev The Ownable contract has an owner address, and provides basic authorization control
303  * functions, this simplifies the implementation of "user permissions".
304  */
305 contract OwnableImpl is Ownable {
306     address public owner;
307 
308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
309 
310     /**
311      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
312      * account.
313      */
314     function OwnableImpl() public {
315         owner = msg.sender;
316     }
317 
318     /**
319      * @dev Throws if called by any account other than the owner.
320      */
321     function checkOwner() internal {
322         require(msg.sender == owner);
323     }
324 
325     /**
326      * @dev Allows the current owner to transfer control of the contract to a newOwner.
327      * @param newOwner The address to transfer ownership to.
328      */
329     function transferOwnership(address newOwner) onlyOwner public {
330         require(newOwner != address(0));
331         OwnershipTransferred(owner, newOwner);
332         owner = newOwner;
333     }
334 }
335 
336 contract ZenomeToken is OwnableImpl, PausableToken, MintableTokenImpl, BurnableTokenImpl {
337 	string public constant name = "Zenome";
338 	string public constant symbol = "sZNA";
339 	uint8 public constant decimals = 18;
340 
341 	function burn(uint256 _value) public whenNotPaused {
342 		super.burn(_value);
343 	}
344 }