1 pragma solidity ^0.4.18;
2 
3 /**
4  * Stefan Corporation develops world-class decentralized applications for you.
5  *
6  * By making payment to this contract, you can retain Stefan Corporation's
7  * Services and will also receive Stefan Tokens as a thank you.
8  *
9  * For more information on ERC827 tokens, see the following blog post from Augusto Lemble:
10  * https://blog.windingtree.com/erc827-erc20-extension-a-new-simple-powerful-token-standard-254bbe1a37a5
11  *
12  * Copyright (c) 2018 Stefan Corporation
13  * https://stefan.co.jp
14  */
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 /**
29  * @title ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/20
31  */
32 contract ERC20 is ERC20Basic {
33   function allowance(address owner, address spender) public view returns (uint256);
34   function transferFrom(address from, address to, uint256 value) public returns (bool);
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 /**
40    @title ERC827 interface, an extension of ERC20 token standard
41 
42    Interface of a ERC827 token, following the ERC20 standard with extra
43    methods to transfer value and data and execute calls in transfers and
44    approvals.
45  */
46 contract ERC827 is ERC20 {
47 
48   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
49   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
50   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
51 
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   /**
83   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is ERC20Basic {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   uint256 totalSupply_;
110 
111   /**
112   * @dev total number of tokens in existence
113   */
114   function totalSupply() public view returns (uint256) {
115     return totalSupply_;
116   }
117 
118   /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 /**
241    @title ERC827, an extension of ERC20 token standard
242 
243    Implementation the ERC827, following the ERC20 standard with extra
244    methods to transfer value and data and execute calls in transfers and
245    approvals.
246    Uses OpenZeppelin StandardToken.
247  */
248 contract ERC827Token is ERC827, StandardToken {
249 
250   /**
251      @dev Addition to ERC20 token methods. It allows to
252      approve the transfer of value and execute a call with the sent data.
253 
254      Beware that changing an allowance with this method brings the risk that
255      someone may use both the old and the new allowance by unfortunate
256      transaction ordering. One possible solution to mitigate this race condition
257      is to first reduce the spender's allowance to 0 and set the desired value
258      afterwards:
259      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260 
261      @param _spender The address that will spend the funds.
262      @param _value The amount of tokens to be spent.
263      @param _data ABI-encoded contract call to call `_to` address.
264 
265      @return true if the call function was executed successfully
266    */
267   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
268     require(_spender != address(this));
269 
270     super.approve(_spender, _value);
271 
272     require(_spender.call(_data));
273 
274     return true;
275   }
276 
277   /**
278      @dev Addition to ERC20 token methods. Transfer tokens to a specified
279      address and execute a call with the sent data on the same transaction
280 
281      @param _to address The address which you want to transfer to
282      @param _value uint256 the amout of tokens to be transfered
283      @param _data ABI-encoded contract call to call `_to` address.
284 
285      @return true if the call function was executed successfully
286    */
287   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
288     require(_to != address(this));
289 
290     super.transfer(_to, _value);
291 
292     require(_to.call(_data));
293     return true;
294   }
295 
296   /**
297      @dev Addition to ERC20 token methods. Transfer tokens from one address to
298      another and make a contract call on the same transaction
299 
300      @param _from The address which you want to send tokens from
301      @param _to The address which you want to transfer to
302      @param _value The amout of tokens to be transferred
303      @param _data ABI-encoded contract call to call `_to` address.
304 
305      @return true if the call function was executed successfully
306    */
307   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
308     require(_to != address(this));
309 
310     super.transferFrom(_from, _to, _value);
311 
312     require(_to.call(_data));
313     return true;
314   }
315 
316   /**
317    * @dev Addition to StandardToken methods. Increase the amount of tokens that
318    * an owner allowed to a spender and execute a call with the sent data.
319    *
320    * approve should be called when allowed[_spender] == 0. To increment
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _addedValue The amount of tokens to increase the allowance by.
326    * @param _data ABI-encoded contract call to call `_spender` address.
327    */
328   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
329     require(_spender != address(this));
330 
331     super.increaseApproval(_spender, _addedValue);
332 
333     require(_spender.call(_data));
334 
335     return true;
336   }
337 
338   /**
339    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
340    * an owner allowed to a spender and execute a call with the sent data.
341    *
342    * approve should be called when allowed[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _subtractedValue The amount of tokens to decrease the allowance by.
348    * @param _data ABI-encoded contract call to call `_spender` address.
349    */
350   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
351     require(_spender != address(this));
352 
353     super.decreaseApproval(_spender, _subtractedValue);
354 
355     require(_spender.call(_data));
356 
357     return true;
358   }
359 
360 }
361 
362 /**
363  * @title Ownable
364  * @dev The Ownable contract has an owner address, and provides basic authorization control
365  * functions, this simplifies the implementation of "user permissions".
366  */
367 contract Ownable {
368   address public owner;
369 
370 
371   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
372 
373 
374   /**
375    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
376    * account.
377    */
378   function Ownable() public {
379     owner = msg.sender;
380   }
381 
382   /**
383    * @dev Throws if called by any account other than the owner.
384    */
385   modifier onlyOwner() {
386     require(msg.sender == owner);
387     _;
388   }
389 
390   /**
391    * @dev Allows the current owner to transfer control of the contract to a newOwner.
392    * @param newOwner The address to transfer ownership to.
393    */
394   function transferOwnership(address newOwner) public onlyOwner {
395     require(newOwner != address(0));
396     OwnershipTransferred(owner, newOwner);
397     owner = newOwner;
398   }
399 
400 }
401 
402 
403 
404 contract Stefan is ERC827Token, Ownable {
405 
406   // Token Name
407   string public constant NAME = "Stefan";
408 
409   // Token Symbol
410   string public constant SYMBOL = "STF";
411 
412   // Token Decimals
413   uint public constant DECIMALS = 18;
414 
415   bool public available = false;
416   uint256 public yearlyFee = 500 ether;
417   mapping(address => Retainer) public retainers;
418 
419   event Retained(address);
420 
421   struct Retainer {
422     uint256 startDate;
423     uint256 paidFee;
424   }
425 
426   function setAvailable(bool _available) public onlyOwner {
427     available = _available;
428   }
429 
430   function changeFee(uint256 _newFee) public onlyOwner {
431     yearlyFee = _newFee;
432   }
433 
434   function createRetainer() public payable {
435     // Make sure we are not at capacity
436     require(available);
437 
438     // Don't accept anything less than the yearly fee
439     require(msg.value >= yearlyFee);
440 
441     // Make sure the sender does not already have a retainment
442     require(retainers[msg.sender].startDate < now - 1 years);
443 
444     // Save the retainer for the client
445     retainers[msg.sender] = Retainer(now, msg.value);
446 
447     // Store an event in the blockchain
448     Retained(msg.sender);
449 
450     // Give Stefan Tokens to the client
451     totalSupply_ = totalSupply_.add(msg.value);
452     balances[msg.sender] = balances[msg.sender].add(msg.value);
453     Transfer(0x0, msg.sender, msg.value);
454 
455     // Send the fee to the owner wallet
456     owner.transfer(msg.value);
457   }
458 
459   function() public payable {
460     createRetainer();
461   }
462 
463 }