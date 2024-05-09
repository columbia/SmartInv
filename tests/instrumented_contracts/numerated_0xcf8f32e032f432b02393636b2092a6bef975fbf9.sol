1 pragma solidity ^0.6.12;
2 
3 // SPDX-License-Identifier: GPL-3.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner, "Not authorized operation");
31         _;
32     }
33 
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0), "Address shouldn't be zero");
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 
48 /**
49  * @dev Wrappers over Solidity's arithmetic operations with added overflow
50  * checks.
51  *
52  * Arithmetic operations in Solidity wrap on overflow. This can easily result
53  * in bugs, because programmers usually assume that an overflow raises an
54  * error, which is the standard behavior in high level programming languages.
55  * `SafeMath` restores this intuition by reverting the transaction when an
56  * operation overflows.
57  *
58  * Using this library instead of the unchecked operations eliminates an entire
59  * class of bugs, so it's recommended to use it always.
60  */
61 library SafeMath {
62     /**
63      * @dev Returns the addition of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `+` operator.
67      *
68      * Requirements:
69      * - Addition cannot overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a, "SafeMath: subtraction overflow");
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0, "SafeMath: division by zero");
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         require(b != 0, "SafeMath: modulo by zero");
150         return a % b;
151     }
152 }
153 
154 interface IERC20 {
155     /**
156      * @dev Returns the amount of tokens in existence.
157      */
158     function totalSupply() external view returns (uint256);
159 
160     /**
161      * @dev Returns the amount of tokens owned by `account`.
162      */
163     function balanceOf(address _owner) external view returns (uint256);
164 
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to `approve`. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 
176 /**
177  * @dev Simple ERC20 Token example, with mintable token creation only during the deployement of the token contract */
178 
179 contract TokenContract is Ownable{
180   using SafeMath for uint256;
181 
182   string public name;
183   string public symbol;
184   uint8 public decimals;
185   uint256 public totalSupply;
186   address public tokenOwner;
187   address private ico;
188 
189   mapping(address => uint256) balances;
190   mapping (address => mapping (address => uint256)) internal allowed;
191   mapping(address => bool) public vestedlist;
192 
193   event SetICO(address indexed _ico);
194   event Mint(address indexed to, uint256 amount);
195   event MintFinished();
196   event UnlockToken();
197   event LockToken();
198   event Burn();
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200   event Transfer(address indexed from, address indexed to, uint256 value);
201   event addedToVestedlist(address indexed _vestedAddress);
202   event removedFromVestedlist(address indexed _vestedAddress);
203 
204   
205   bool public mintingFinished = false;
206   bool public locked = true;
207 
208   modifier canMint() {
209     require(!mintingFinished);
210     _;
211   }
212   
213   modifier canTransfer() {
214     require(!locked || msg.sender == owner || msg.sender == ico);
215     _;
216   }
217   
218   modifier onlyAuthorized() {
219     require(msg.sender == owner || msg.sender == ico);
220     _;
221   }
222 
223 
224   constructor(string memory _name, string memory  _symbol, uint8 _decimals) public {
225     require (_decimals != 0);
226     name = _name;
227     symbol = _symbol;
228     decimals = _decimals;
229     totalSupply = 0;
230     balances[msg.sender] = totalSupply;
231     emit Transfer(address(0), msg.sender, totalSupply);
232 
233 
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) public onlyAuthorized canMint returns (bool) {
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     emit Mint(_to, _amount);
246     emit Transfer(address(this), _to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() public onlyAuthorized canMint returns (bool) {
255     mintingFinished = true;
256     emit MintFinished();
257     return true;
258   }
259 
260   /**
261   * @dev transfer token for a specified address
262   * @param _to The address to transfer to.
263   * @param _value The amount to be transferred.
264   */
265   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
266     require(_to != address(0));
267 	require (!isVestedlisted(msg.sender));
268     require(_value <= balances[msg.sender]);
269     require (msg.sender != address(this));
270 
271     // SafeMath.sub will throw if there is not enough balance.
272     balances[msg.sender] = balances[msg.sender].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     emit Transfer(msg.sender, _to, _value);
275     return true;
276   }
277 
278 
279   function burn(address _who, uint256 _value) onlyAuthorized public returns (bool){
280     require(_who != address(0));
281     
282     totalSupply = totalSupply.sub(_value);
283     balances[_who] = balances[_who].sub(_value);
284     emit Burn();
285     emit Transfer(_who, address(0), _value);
286     return true;
287   }
288   
289 
290   function balanceOf(address _owner) public view returns (uint256 balance) {
291     return balances[_owner];
292   }
293   
294   /**
295    * @dev Transfer tokens from one address to another
296    * @param _from address The address which you want to send tokens from
297    * @param _to address The address which you want to transfer to
298    * @param _value uint256 the amount of tokens to be transferred
299    */
300   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
301     require(_to != address(0));
302     require(_value <= balances[_from]);
303     require(_value <= allowed[_from][msg.sender]);
304 
305     balances[_from] = balances[_from].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     emit Transfer(_from, _to, _value);
309     return true;
310   }
311 
312   function transferFromERC20Contract(address _to, uint256 _value) public onlyOwner returns (bool) {
313     require(_to != address(0));
314     require(_value <= balances[address(this)]);
315     balances[address(this)] = balances[address(this)].sub(_value);
316     balances[_to] = balances[_to].add(_value);
317     emit Transfer(address(this), _to, _value);
318     return true;
319   }
320 
321 
322   /**
323    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
324    *
325    * Beware that changing an allowance with this method brings the risk that someone may use both the old
326    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329    * @param _spender The address which will spend the funds.
330    * @param _value The amount of tokens to be spent.
331    */
332   function approve(address _spender, uint256 _value) public returns (bool) {
333     allowed[msg.sender][_spender] = _value;
334     emit Approval(msg.sender, _spender, _value);
335     return true;
336   }
337 
338   /**
339    * @dev Function to check the amount of tokens that an owner allowed to a spender.
340    * @param _owner address The address which owns the funds.
341    * @param _spender address The address which will spend the funds.
342    * @return A uint256 specifying the amount of tokens still available for the spender.
343    */
344   function allowance(address _owner, address _spender) public view returns (uint256) {
345     return allowed[_owner][_spender];
346   }
347 
348   /**
349    * @dev Increase the amount of tokens that an owner allowed to a spender.
350    *
351    * approve should be called when allowed[_spender] == 0. To increment
352    * allowed value is better to use this function to avoid 2 calls (and wait until
353    * the first transaction is mined)
354    * @param _spender The address which will spend the funds.
355    * @param _addedValue The amount of tokens to increase the allowance by.
356    */
357   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
358     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363   /**
364    * @dev Decrease the amount of tokens that an owner allowed to a spender.
365    *
366    * approve should be called when allowed[_spender] == 0. To decrement
367    * allowed value is better to use this function to avoid 2 calls (and wait until
368    * the first transaction is mined)
369    * @param _spender The address which will spend the funds.
370    * @param _subtractedValue The amount of tokens to decrease the allowance by.
371    */
372   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
373     uint oldValue = allowed[msg.sender][_spender];
374     if (_subtractedValue > oldValue) {
375       allowed[msg.sender][_spender] = 0;
376     } else {
377       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
378     }
379     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380     return true;
381   }
382 
383   function unlockToken() public onlyAuthorized returns (bool) {
384     locked = false;
385     emit UnlockToken();
386     return true;
387   }
388 
389   function lockToken() public onlyAuthorized returns (bool) {
390     locked = true;
391     emit LockToken();
392     return true;
393   }
394   
395   function setICO(address _icocontract) public onlyOwner returns (bool) {
396     require(_icocontract != address(0));
397     ico = _icocontract;
398     emit SetICO(_icocontract);
399     return true;
400   }
401 
402     /**
403      * @dev Adds list of addresses to Vestedlist. Not overloaded due to limitations with truffle testing.
404      * @param _vestedAddress Addresses to be added to the Vestedlist
405      */
406     function addToVestedlist(address[] memory _vestedAddress) public onlyOwner {
407         for (uint256 i = 0; i < _vestedAddress.length; i++) {
408             if (vestedlist[_vestedAddress[i]]) continue;
409             vestedlist[_vestedAddress[i]] = true;
410         }
411     }
412 
413 
414     /**
415      * @dev Removes single address from Vestedlist.
416      * @param _vestedAddress Address to be removed to the Vestedlist
417      */
418     function removeFromVestedlist(address[] memory _vestedAddress) public onlyOwner {
419         for (uint256 i = 0; i < _vestedAddress.length; i++) {
420             if (!vestedlist[_vestedAddress[i]]) continue;
421             vestedlist[_vestedAddress[i]] = false;
422         }
423     }
424 
425 
426     function isVestedlisted(address _vestedAddress) internal view returns (bool) {
427       return (vestedlist[_vestedAddress]);
428     }
429 
430 }