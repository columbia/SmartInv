1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 pragma solidity ^0.4.18;
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 pragma solidity ^0.4.18;
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 pragma solidity ^0.4.18;
223 
224 
225 /**
226  * @title Ownable
227  * @dev The Ownable contract has an owner address, and provides basic authorization control
228  * functions, this simplifies the implementation of "user permissions".
229  */
230 contract Ownable {
231   address public owner;
232 
233 
234   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236 
237   /**
238    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
239    * account.
240    */
241   function Ownable() public {
242     owner = msg.sender;
243   }
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 
266 
267 /**
268  * @title Mintable token
269  * @dev Simple ERC20 Token example, with mintable token creation
270  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
271  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
272  */
273 contract MintableToken is StandardToken, Ownable {
274   event Mint(address indexed to, uint256 amount);
275   event MintFinished();
276 
277   bool public mintingFinished = false;
278 
279 
280   modifier canMint() {
281     require(!mintingFinished);
282     _;
283   }
284 
285   /**
286    * @dev Function to mint tokens
287    * @param _to The address that will receive the minted tokens.
288    * @param _amount The amount of tokens to mint.
289    * @return A boolean that indicates if the operation was successful.
290    */
291   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292     totalSupply_ = totalSupply_.add(_amount);
293     balances[_to] = balances[_to].add(_amount);
294     Mint(_to, _amount);
295     Transfer(address(0), _to, _amount);
296     return true;
297   }
298 
299   /**
300    * @dev Function to stop minting new tokens.
301    * @return True if the operation was successful.
302    */
303   function finishMinting() onlyOwner canMint public returns (bool) {
304     mintingFinished = true;
305     MintFinished();
306     return true;
307   }
308 }
309 
310 
311 
312 /**
313  * @title Capped token
314  * @dev Mintable token with a token cap.
315  */
316 contract CappedToken is MintableToken {
317 
318   uint256 public cap;
319 
320   function CappedToken(uint256 _cap) public {
321     require(_cap > 0);
322     cap = _cap;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
332     require(totalSupply_.add(_amount) <= cap);
333 
334     return super.mint(_to, _amount);
335   }
336 
337 }
338 
339 /**
340  * Merit token
341  */
342 contract MeritToken is CappedToken {
343 	event NewCap(uint256 value);
344 
345 	string public constant name = "Merit Token"; // solium-disable-line uppercase
346 	string public constant symbol = "MERIT"; // solium-disable-line uppercase
347 	uint8 public constant decimals = 18; // solium-disable-line uppercase
348 	bool public tokensReleased;
349 
350 	function MeritToken(uint256 _cap) public CappedToken(_cap * 10**uint256(decimals)) { }
351 
352     modifier released {
353         require(mintingFinished);
354         _;
355     }
356     
357     modifier notReleased {
358         require(!mintingFinished);
359         _;
360     }
361     
362     // only allow these functions once the token is released (minting is done)
363     // basically the zeppelin 'Pausable' token but using my token release flag
364     // Only allow our token to be usable once the minting phase is over
365     function transfer(address _to, uint256 _value) public released returns (bool) {
366         return super.transfer(_to, _value);
367     }
368     
369     function transferFrom(address _from, address _to, uint256 _value) public released returns (bool) {
370         return super.transferFrom(_from, _to, _value);
371     }
372     
373     function approve(address _spender, uint256 _value) public released returns (bool) {
374         return super.approve(_spender, _value);
375     }
376     
377     function increaseApproval(address _spender, uint _addedValue) public released returns (bool success) {
378         return super.increaseApproval(_spender, _addedValue);
379     }
380     
381     function decreaseApproval(address _spender, uint _subtractedValue) public released returns (bool success) {
382         return super.decreaseApproval(_spender, _subtractedValue);
383     }
384     
385     // for our token, the balance will always be zero if we're still minting them
386 	// once we're done minting, the tokens will be effectively released to their owners
387     function balanceOf(address _owner) public view released returns (uint256 balance) {
388         return super.balanceOf(_owner);
389     }
390 
391     // lets us see the pre-allocated balance, since we're just letting the token keep track of all of the allocations
392     // instead of going through another complete allocation step for all users
393     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
394         return super.balanceOf(_owner);
395     }
396     
397     // revoke a user's tokens if they have been banned for violating the TOS.
398     // Note, this can only be called during the ICO phase and not once the tokens are released.
399     function revoke(address _owner) public onlyOwner notReleased returns (uint256 balance) {
400         // the balance should never ben greater than our total supply, so don't worry about checking
401         balance = balances[_owner];
402         balances[_owner] = 0;
403         totalSupply_ = totalSupply_.sub(balance);
404     }
405   }