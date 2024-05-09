1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/ContractReceiver.sol
4 
5 contract ContractReceiver {
6     function receiveApproval(address _from, uint256 _value, address _token, bytes _data) public;
7 }
8 
9 // File: contracts/token/CustomToken.sol
10 
11 contract CustomToken {
12     function approveAndCall(address _to, uint256 _value, bytes _data) public returns (bool);
13     event ApproveAndCall(address indexed _from, address indexed _to, uint256 _value, bytes _data);
14 }
15 
16 // File: contracts/utils/ExtendsOwnable.sol
17 
18 contract ExtendsOwnable {
19 
20     mapping(address => bool) public owners;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23     event OwnershipRevoked(address indexed revokedOwner);
24     event OwnershipExtended(address indexed host, address indexed guest);
25 
26     modifier onlyOwner() {
27         require(owners[msg.sender]);
28         _;
29     }
30 
31     constructor() public {
32         owners[msg.sender] = true;
33     }
34 
35     function addOwner(address guest) public onlyOwner {
36         require(guest != address(0));
37         owners[guest] = true;
38         emit OwnershipExtended(msg.sender, guest);
39     }
40 
41     function removeOwner(address owner) public onlyOwner {
42         require(owner != address(0));
43         require(msg.sender != owner);
44         owners[owner] = false;
45         emit OwnershipRevoked(owner);
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         owners[newOwner] = true;
51         delete owners[msg.sender];
52         emit OwnershipTransferred(msg.sender, newOwner);
53     }
54 }
55 
56 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that revert on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, reverts on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69     // benefit is lost if 'b' is also tested.
70     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71     if (a == 0) {
72       return 0;
73     }
74 
75     uint256 c = a * b;
76     require(c / a == b);
77 
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     require(b > 0); // Solidity only automatically asserts when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b <= a);
97     uint256 c = a - b;
98 
99     return c;
100   }
101 
102   /**
103   * @dev Adds two numbers, reverts on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     require(c >= a);
108 
109     return c;
110   }
111 
112   /**
113   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
114   * reverts when dividing by zero.
115   */
116   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117     require(b != 0);
118     return a % b;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 interface IERC20 {
129   function totalSupply() external view returns (uint256);
130 
131   function balanceOf(address who) external view returns (uint256);
132 
133   function allowance(address owner, address spender)
134     external view returns (uint256);
135 
136   function transfer(address to, uint256 value) external returns (bool);
137 
138   function approve(address spender, uint256 value)
139     external returns (bool);
140 
141   function transferFrom(address from, address to, uint256 value)
142     external returns (bool);
143 
144   event Transfer(
145     address indexed from,
146     address indexed to,
147     uint256 value
148   );
149 
150   event Approval(
151     address indexed owner,
152     address indexed spender,
153     uint256 value
154   );
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
164  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract ERC20 is IERC20 {
167   using SafeMath for uint256;
168 
169   mapping (address => uint256) private _balances;
170 
171   mapping (address => mapping (address => uint256)) private _allowed;
172 
173   uint256 private _totalSupply;
174 
175   /**
176   * @dev Total number of tokens in existence
177   */
178   function totalSupply() public view returns (uint256) {
179     return _totalSupply;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param owner The address to query the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address owner) public view returns (uint256) {
188     return _balances[owner];
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param owner address The address which owns the funds.
194    * @param spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address owner,
199     address spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return _allowed[owner][spender];
206   }
207 
208   /**
209   * @dev Transfer token for a specified address
210   * @param to The address to transfer to.
211   * @param value The amount to be transferred.
212   */
213   function transfer(address to, uint256 value) public returns (bool) {
214     _transfer(msg.sender, to, value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param spender The address which will spend the funds.
225    * @param value The amount of tokens to be spent.
226    */
227   function approve(address spender, uint256 value) public returns (bool) {
228     require(spender != address(0));
229 
230     _allowed[msg.sender][spender] = value;
231     emit Approval(msg.sender, spender, value);
232     return true;
233   }
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param from address The address which you want to send tokens from
238    * @param to address The address which you want to transfer to
239    * @param value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(
242     address from,
243     address to,
244     uint256 value
245   )
246     public
247     returns (bool)
248   {
249     require(value <= _allowed[from][msg.sender]);
250 
251     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
252     _transfer(from, to, value);
253     return true;
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed_[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param spender The address which will spend the funds.
263    * @param addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseAllowance(
266     address spender,
267     uint256 addedValue
268   )
269     public
270     returns (bool)
271   {
272     require(spender != address(0));
273 
274     _allowed[msg.sender][spender] = (
275       _allowed[msg.sender][spender].add(addedValue));
276     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed_[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param spender The address which will spend the funds.
287    * @param subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseAllowance(
290     address spender,
291     uint256 subtractedValue
292   )
293     public
294     returns (bool)
295   {
296     require(spender != address(0));
297 
298     _allowed[msg.sender][spender] = (
299       _allowed[msg.sender][spender].sub(subtractedValue));
300     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
301     return true;
302   }
303 
304   /**
305   * @dev Transfer token for a specified addresses
306   * @param from The address to transfer from.
307   * @param to The address to transfer to.
308   * @param value The amount to be transferred.
309   */
310   function _transfer(address from, address to, uint256 value) internal {
311     require(value <= _balances[from]);
312     require(to != address(0));
313 
314     _balances[from] = _balances[from].sub(value);
315     _balances[to] = _balances[to].add(value);
316     emit Transfer(from, to, value);
317   }
318 
319   /**
320    * @dev Internal function that mints an amount of the token and assigns it to
321    * an account. This encapsulates the modification of balances such that the
322    * proper events are emitted.
323    * @param account The account that will receive the created tokens.
324    * @param value The amount that will be created.
325    */
326   function _mint(address account, uint256 value) internal {
327     require(account != 0);
328     _totalSupply = _totalSupply.add(value);
329     _balances[account] = _balances[account].add(value);
330     emit Transfer(address(0), account, value);
331   }
332 
333   /**
334    * @dev Internal function that burns an amount of the token of a given
335    * account.
336    * @param account The account whose tokens will be burnt.
337    * @param value The amount that will be burnt.
338    */
339   function _burn(address account, uint256 value) internal {
340     require(account != 0);
341     require(value <= _balances[account]);
342 
343     _totalSupply = _totalSupply.sub(value);
344     _balances[account] = _balances[account].sub(value);
345     emit Transfer(account, address(0), value);
346   }
347 
348   /**
349    * @dev Internal function that burns an amount of the token of a given
350    * account, deducting from the sender's allowance for said account. Uses the
351    * internal burn function.
352    * @param account The account whose tokens will be burnt.
353    * @param value The amount that will be burnt.
354    */
355   function _burnFrom(address account, uint256 value) internal {
356     require(value <= _allowed[account][msg.sender]);
357 
358     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
359     // this function needs to emit an event with the updated approval.
360     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
361       value);
362     _burn(account, value);
363   }
364 }
365 
366 
367 //   Toonium Token @Toonmania Ent
368 //   Dev Team  
369 
370 contract TNI is ERC20, CustomToken, ExtendsOwnable {
371     using SafeMath for uint256;
372 
373   
374     string public constant name = "Toonium";
375     string public constant symbol = "TNI";
376     uint256 public constant decimals = 18;
377 
378  
379     function() public payable {
380         revert();
381     }
382 
383   
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
385         return super.transferFrom(_from, _to, _value);
386     }
387 
388   
389     function transfer(address _to, uint256 _value) public returns (bool) {
390         return super.transfer(_to, _value);
391     }
392 
393   
394     function approveAndCall(address _to, uint256 _value, bytes _data) public returns (bool) {
395         require(_to != address(0) && _to != address(this));
396         require(balanceOf(msg.sender) >= _value);
397 
398         if(approve(_to, _value) && isContract(_to)) {
399             ContractReceiver receiver = ContractReceiver(_to);
400             receiver.receiveApproval(msg.sender, _value, address(this), _data);
401             emit ApproveAndCall(msg.sender, _to, _value, _data);
402 
403             return true;
404         }
405     }
406 
407  
408     function mint(uint256 _amount) onlyOwner external {
409         super._mint(msg.sender, _amount);
410 
411         emit Mint(msg.sender, _amount);
412     }
413 
414 
415     function burn(uint256 _amount) onlyOwner external {
416         super._burn(msg.sender, _amount);
417 
418         emit Burn(msg.sender, _amount);
419     }
420 
421    
422     function isContract(address _addr) private view returns (bool) {
423         uint256 length;
424         assembly {
425             //retrieve the size of the code on target address, this needs assembly
426             length := extcodesize(_addr)
427         }
428         return (length > 0);
429     }
430 
431     event Mint(address indexed _to, uint256 _amount);
432     event Burn(address indexed _from, uint256 _amount);
433 }