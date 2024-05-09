1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Certifier {
46     event Confirmed(address indexed who);
47     event Revoked(address indexed who);
48     function certified(address) public constant returns (bool);
49     function get(address, string) public constant returns (bytes32);
50     function getAddress(address, string) public constant returns (address);
51     function getUint(address, string) public constant returns (uint);
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract Certifiable is Ownable {
90     Certifier public certifier;
91     event CertifierChanged(address indexed newCertifier);
92 
93     constructor(address _certifier) public {
94         certifier = Certifier(_certifier);
95     }
96 
97     function updateCertifier(address _address) public onlyOwner returns (bool success) {
98         require(_address != address(0));
99         emit CertifierChanged(_address);
100         certifier = Certifier(_address);
101         return true;
102     }
103 }
104 
105 contract KYCToken is Certifiable {
106     mapping(address => bool) public kycPending;
107     mapping(address => bool) public managers;
108 
109     event ManagerAdded(address indexed newManager);
110     event ManagerRemoved(address indexed removedManager);
111 
112     modifier onlyManager() {
113         require(managers[msg.sender] == true);
114         _;
115     }
116 
117     modifier isKnownCustomer(address _address) {
118         require(!kycPending[_address] || certifier.certified(_address));
119         if (kycPending[_address]) {
120             kycPending[_address] = false;
121         }
122         _;
123     }
124 
125     constructor(address _certifier) public Certifiable(_certifier)
126     {
127 
128     }
129 
130     function addManager(address _address) external onlyOwner {
131         managers[_address] = true;
132         emit ManagerAdded(_address);
133     }
134 
135     function removeManager(address _address) external onlyOwner {
136         managers[_address] = false;
137         emit ManagerRemoved(_address);
138     }
139 
140 }
141 
142 contract ERC20Basic {
143   function totalSupply() public view returns (uint256);
144   function balanceOf(address who) public view returns (uint256);
145   function transfer(address to, uint256 value) public returns (bool);
146   event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 contract BurnableToken is BasicToken {
190 
191   event Burn(address indexed burner, uint256 value);
192 
193   /**
194    * @dev Burns a specific amount of tokens.
195    * @param _value The amount of token to be burned.
196    */
197   function burn(uint256 _value) public {
198     _burn(msg.sender, _value);
199   }
200 
201   function _burn(address _who, uint256 _value) internal {
202     require(_value <= balances[_who]);
203     // no need to require value <= totalSupply, since that would imply the
204     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206     balances[_who] = balances[_who].sub(_value);
207     totalSupply_ = totalSupply_.sub(_value);
208     emit Burn(_who, _value);
209     emit Transfer(_who, address(0), _value);
210   }
211 }
212 
213 contract ERC20 is ERC20Basic {
214   function allowance(address owner, address spender) public view returns (uint256);
215   function transferFrom(address from, address to, uint256 value) public returns (bool);
216   function approve(address spender, uint256 value) public returns (bool);
217   event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 contract ERC827 is ERC20 {
221   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
222   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
223   function transferFromAndCall(
224     address _from,
225     address _to,
226     uint256 _value,
227     bytes _data
228   )
229     public
230     payable
231     returns (bool);
232 }
233 
234 contract StandardToken is ERC20, BasicToken {
235 
236   mapping (address => mapping (address => uint256)) internal allowed;
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
247     require(_value <= balances[_from]);
248     require(_value <= allowed[_from][msg.sender]);
249 
250     balances[_from] = balances[_from].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     emit Transfer(_from, _to, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    *
260    * Beware that changing an allowance with this method brings the risk that someone may use both the old
261    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   function approve(address _spender, uint256 _value) public returns (bool) {
268     allowed[msg.sender][_spender] = _value;
269     emit Approval(msg.sender, _spender, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Function to check the amount of tokens that an owner allowed to a spender.
275    * @param _owner address The address which owns the funds.
276    * @param _spender address The address which will spend the funds.
277    * @return A uint256 specifying the amount of tokens still available for the spender.
278    */
279   function allowance(address _owner, address _spender) public view returns (uint256) {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
294     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299   /**
300    * @dev Decrease the amount of tokens that an owner allowed to a spender.
301    *
302    * approve should be called when allowed[_spender] == 0. To decrement
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _subtractedValue The amount of tokens to decrease the allowance by.
308    */
309   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
310     uint oldValue = allowed[msg.sender][_spender];
311     if (_subtractedValue > oldValue) {
312       allowed[msg.sender][_spender] = 0;
313     } else {
314       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315     }
316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317     return true;
318   }
319 
320 }
321 
322 contract ERC827Token is ERC827, StandardToken {
323 
324   /**
325    * @dev Addition to ERC20 token methods. It allows to
326    * @dev approve the transfer of value and execute a call with the sent data.
327    *
328    * @dev Beware that changing an allowance with this method brings the risk that
329    * @dev someone may use both the old and the new allowance by unfortunate
330    * @dev transaction ordering. One possible solution to mitigate this race condition
331    * @dev is to first reduce the spender's allowance to 0 and set the desired value
332    * @dev afterwards:
333    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
334    *
335    * @param _spender The address that will spend the funds.
336    * @param _value The amount of tokens to be spent.
337    * @param _data ABI-encoded contract call to call `_to` address.
338    *
339    * @return true if the call function was executed successfully
340    */
341   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
342     require(_spender != address(this));
343 
344     super.approve(_spender, _value);
345 
346     // solium-disable-next-line security/no-call-value
347     require(_spender.call.value(msg.value)(_data));
348 
349     return true;
350   }
351 
352   /**
353    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
354    * @dev address and execute a call with the sent data on the same transaction
355    *
356    * @param _to address The address which you want to transfer to
357    * @param _value uint256 the amout of tokens to be transfered
358    * @param _data ABI-encoded contract call to call `_to` address.
359    *
360    * @return true if the call function was executed successfully
361    */
362   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
363     require(_to != address(this));
364 
365     super.transfer(_to, _value);
366 
367     // solium-disable-next-line security/no-call-value
368     require(_to.call.value(msg.value)(_data));
369     return true;
370   }
371 
372   /**
373    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
374    * @dev another and make a contract call on the same transaction
375    *
376    * @param _from The address which you want to send tokens from
377    * @param _to The address which you want to transfer to
378    * @param _value The amout of tokens to be transferred
379    * @param _data ABI-encoded contract call to call `_to` address.
380    *
381    * @return true if the call function was executed successfully
382    */
383   function transferFromAndCall(
384     address _from,
385     address _to,
386     uint256 _value,
387     bytes _data
388   )
389     public payable returns (bool)
390   {
391     require(_to != address(this));
392 
393     super.transferFrom(_from, _to, _value);
394 
395     // solium-disable-next-line security/no-call-value
396     require(_to.call.value(msg.value)(_data));
397     return true;
398   }
399 
400   /**
401    * @dev Addition to StandardToken methods. Increase the amount of tokens that
402    * @dev an owner allowed to a spender and execute a call with the sent data.
403    *
404    * @dev approve should be called when allowed[_spender] == 0. To increment
405    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
406    * @dev the first transaction is mined)
407    * @dev From MonolithDAO Token.sol
408    *
409    * @param _spender The address which will spend the funds.
410    * @param _addedValue The amount of tokens to increase the allowance by.
411    * @param _data ABI-encoded contract call to call `_spender` address.
412    */
413   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
414     require(_spender != address(this));
415 
416     super.increaseApproval(_spender, _addedValue);
417 
418     // solium-disable-next-line security/no-call-value
419     require(_spender.call.value(msg.value)(_data));
420 
421     return true;
422   }
423 
424   /**
425    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
426    * @dev an owner allowed to a spender and execute a call with the sent data.
427    *
428    * @dev approve should be called when allowed[_spender] == 0. To decrement
429    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
430    * @dev the first transaction is mined)
431    * @dev From MonolithDAO Token.sol
432    *
433    * @param _spender The address which will spend the funds.
434    * @param _subtractedValue The amount of tokens to decrease the allowance by.
435    * @param _data ABI-encoded contract call to call `_spender` address.
436    */
437   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
438     require(_spender != address(this));
439 
440     super.decreaseApproval(_spender, _subtractedValue);
441 
442     // solium-disable-next-line security/no-call-value
443     require(_spender.call.value(msg.value)(_data));
444 
445     return true;
446   }
447 
448 }
449 
450 contract EDUToken is BurnableToken, KYCToken, ERC827Token {
451     using SafeMath for uint256;
452 
453     string public constant name = "EDU Token";
454     string public constant symbol = "EDU";
455     uint8 public constant decimals = 18;
456 
457     uint256 public constant INITIAL_SUPPLY = 48000000 * (10 ** uint256(decimals));
458 
459     constructor(address _certifier) public KYCToken(_certifier) {
460         totalSupply_ = INITIAL_SUPPLY;
461         balances[msg.sender] = INITIAL_SUPPLY;
462         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
463     }
464 
465     function transfer(address _to, uint256 _value) public isKnownCustomer(msg.sender) returns (bool) {
466         return super.transfer(_to, _value);
467     }
468 
469     function transferFrom(address _from, address _to, uint256 _value) public isKnownCustomer(_from) returns (bool) {
470         return super.transferFrom(_from, _to, _value);
471     }
472 
473     function approve(address _spender, uint256 _value) public isKnownCustomer(_spender) returns (bool) {
474         return super.approve(_spender, _value);
475     }
476 
477     function increaseApproval(address _spender, uint _addedValue) public isKnownCustomer(_spender) returns (bool success) {
478         return super.increaseApproval(_spender, _addedValue);
479     }
480 
481     function decreaseApproval(address _spender, uint _subtractedValue) public isKnownCustomer(_spender) returns (bool success) {
482         return super.decreaseApproval(_spender, _subtractedValue);
483     }
484 
485     function delayedTransferFrom(address _tokenWallet, address _to, uint256 _value) public onlyManager returns (bool) {
486         transferFrom(_tokenWallet, _to, _value);
487         kycPending[_to] = true;
488     }
489 
490 }