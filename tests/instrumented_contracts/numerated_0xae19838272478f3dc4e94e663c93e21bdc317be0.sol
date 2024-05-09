1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/MidasPooling.sol
322 
323 contract MidasPooling is Ownable {
324     function safeMul(uint a, uint b) internal pure returns (uint) {
325         uint c = a * b;
326         assert(a == 0 || c / a == b);
327         return c;
328     }
329 
330     function safeSub(uint a, uint b) internal pure returns (uint) {
331         assert(b <= a);
332         return a - b;
333     }
334 
335     function safeAdd(uint a, uint b) internal pure returns (uint) {
336         uint c = a + b;
337         assert(c >= a && c >= b);
338         return c;
339     }
340 
341     string public name = "MidasPooling";
342     address public owner;
343     address public admin;
344     address public feeAccount;
345     address public tokenAddress;
346 
347     uint256 public withdrawStartTime;
348     uint256 public withdrawEndTime;
349 
350     mapping(address => uint256) public balances; // mapping of addresses to account balances
351 
352     event SetOwner(address indexed previousOwner, address indexed newOwner);
353     event SetAdmin(address indexed previousAdmin, address indexed newAdmin);
354     event SetFeeAcount(address indexed previousFeeAccount, address indexed newFeeAccount);
355     event Deposit(address user, uint256 amount, uint256 balance);
356     event Withdraw(address user, uint256 amount, uint256 balance);
357     event TransferERC20Token(address token, address owner, uint256 amount);
358     event SetBalance(address user, uint256 balance);
359     event ChangeWithdrawTimeRange(uint256 withdrawStartTime, uint256 withdrawEndTime);
360 
361     modifier onlyAdminOrOwner {
362         require(msg.sender == owner);
363         require(msg.sender == admin);
364         _;
365     }
366 
367     function setOwner(address newOwner) onlyOwner public {
368         owner = newOwner;
369         emit SetOwner(owner, newOwner);
370     }
371 
372     function setAdmin(address newAdmin) onlyOwner public {
373         admin = newAdmin;
374         emit SetAdmin(admin, newAdmin);
375     }
376 
377     function setFeeAccount(address newFeeAccount) onlyOwner public {
378         feeAccount = newFeeAccount;
379         emit SetFeeAcount(feeAccount, newFeeAccount);
380     }
381 
382     constructor (
383         string _name,
384         address _admin,
385         address _feeAccount,
386         address _tokenAddress,
387         uint _withdrawStartTime,
388         uint _withdrawEndTime) public {
389         owner = msg.sender;
390         name = _name;
391         admin = _admin;
392         feeAccount = _feeAccount;
393         tokenAddress = _tokenAddress;
394         withdrawStartTime = _withdrawStartTime;
395         withdrawEndTime = _withdrawEndTime;
396     }
397 
398     function changeWithdrawTimeRange(uint _withdrawStartTime, uint _withdrawEndTime) onlyAdminOrOwner public {
399         require(_withdrawStartTime <= _withdrawEndTime);
400         withdrawStartTime = _withdrawStartTime;
401         withdrawEndTime = _withdrawEndTime;
402         emit ChangeWithdrawTimeRange(_withdrawStartTime, _withdrawEndTime);
403     }
404 
405     function depositToken(uint256 amount) public returns (bool success) {
406         require(amount > 0);
407         require(StandardToken(tokenAddress).balanceOf(msg.sender) >= amount);
408         require(StandardToken(tokenAddress).transferFrom(msg.sender, this, amount));
409         balances[msg.sender] = safeAdd(balances[msg.sender], amount);
410         emit Deposit(msg.sender, amount, balances[msg.sender]);
411         return true;
412     }
413 
414     function withdraw(uint256 amount) public returns (bool success) {
415         require(amount > 0);
416         require(balances[msg.sender] >= amount);
417         require(now >= withdrawStartTime);
418         require(now <= withdrawEndTime);
419         require(StandardToken(tokenAddress).transfer(msg.sender, amount));
420         balances[msg.sender] = safeSub(balances[msg.sender], amount);
421         emit Withdraw(msg.sender, amount, balances[msg.sender]);
422         return true;
423     }
424 
425     function adminWithdraw(address user, uint256 amount, uint256 feeWithdrawal) onlyAdminOrOwner public returns (bool success) {
426         require(balances[user] > amount);
427         require(amount > feeWithdrawal);
428         uint256 transferAmt = safeSub(amount, feeWithdrawal);
429         require(StandardToken(tokenAddress).transfer(user, transferAmt));
430         balances[user] = safeSub(balances[user], amount);
431         balances[feeAccount] = safeAdd(balances[feeAccount], feeWithdrawal);
432         emit Withdraw(user, amount, balances[user]);
433         return true;
434     }
435 
436     function transferERC20Token(address token, uint256 amount) public onlyOwner returns (bool success) {
437         emit TransferERC20Token(token, owner, amount);
438         return StandardToken(token).transfer(owner, amount);
439     }
440 
441     function balanceOf(address user) constant public returns (uint256) {
442         return balances[user];
443     }
444 
445     function setBalance(address user, uint256 amount) onlyAdminOrOwner public {
446         require(amount >= 0);
447         balances[user] = amount;
448         emit SetBalance(user, balances[user]);
449     }
450 
451     function setBalances(address[] users, uint256[] amounts) onlyAdminOrOwner public {
452         for (uint i = 0; i < users.length; i++) {
453             setBalance(users[i], amounts[i]);
454         }
455     }
456 }