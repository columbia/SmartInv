1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't h4old
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53  
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    */
83 //   function renounceOwnership() public onlyOwner {
84 //     emit OwnershipRenounced(owner);
85 //     owner = address(0);
86 //   }
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address _newOwner) public onlyOwner {
93     _transferOwnership(_newOwner);
94   }
95 
96   /**
97    * @dev Transfers control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function _transferOwnership(address _newOwner) internal {
101     require(_newOwner != address(0));
102     emit OwnershipTransferred(owner, _newOwner);
103     owner = _newOwner;
104   }
105 }
106 
107 contract Freezing is Ownable {
108   event Freeze();
109   event Unfreeze();
110   event Freeze(address to);
111   event UnfreezeOf(address to);
112   event TransferAccessOn();
113   event TransferAccessOff();
114 
115   bool public freezed = false;
116   
117   mapping (address => bool) public freezeOf;
118   mapping (address => bool) public transferAccess;
119 
120   modifier whenNotFreeze() {
121     require(!freezed);
122     _;
123   }
124 
125   modifier whenFreeze() {
126     require(freezed);
127     _;
128   }
129 
130   modifier whenNotFreezeOf(address _account) {
131     require(!freezeOf[_account]);
132     _;
133   }
134 
135   modifier whenFreezeOf(address _account) {
136     require(freezeOf[_account]);
137     _;
138   }
139   
140   modifier onTransferAccess(address _account) {
141       require(transferAccess[_account]);
142       _;
143   }
144   
145   modifier offTransferAccess(address _account) {
146       require(!transferAccess[_account]);
147       _;
148   }
149 
150   function freeze() onlyOwner whenNotFreeze public {
151     freezed = true;
152     emit Freeze();
153   }
154 
155   function unfreeze() onlyOwner whenFreeze public {
156     freezed = false;
157     emit Unfreeze();
158   }
159   
160   function freezeOf(address _account) onlyOwner whenNotFreeze public {
161     freezeOf[_account] = true;
162     emit Freeze(_account);
163   }
164 
165   function unfreezeOf(address _account) onlyOwner whenFreeze public  {
166     freezeOf[_account] = false;
167     emit UnfreezeOf(_account);
168   }
169   
170   function transferAccessOn(address _account) onlyOwner offTransferAccess(_account) public {
171       transferAccess[_account] = true;
172       emit TransferAccessOn();
173   }
174   
175   function transferAccessOff(address _account) onlyOwner onTransferAccess(_account) public {
176       transferAccess[_account] = false;
177       emit TransferAccessOff();
178   }
179   
180 }
181 
182 
183 /**
184  * @title ERC20Basic 
185  * @dev Simpler version of ERC20 interface 
186  * @dev see https://github.com/ethereum/EIPs/issues/20 
187  */ 
188 contract ERC20Basic {
189      uint public totalSupply;
190      function balanceOf(address who) public constant returns (uint); 
191      function transfer(address to, uint value) public ; 
192      event Transfer(address indexed from, address indexed to, uint value); 
193     
194 } 
195 
196 /** 
197  * @title ERC20 interface 
198  * @dev see https://github.com/ethereum/EIPs/issues/20 
199  */
200 
201 contract BasicToken is ERC20Basic, Freezing {
202   using SafeMath for uint;
203 
204   mapping(address => uint) balances;
205 
206   /**
207    * @dev Fix for the ERC20 short address attack.
208    */
209   modifier onlyPayloadSize(uint size) {
210      require(msg.data.length >= size + 4);
211      _;
212   }
213   
214   function transfer(address _to, uint _value) 
215     public 
216     onlyPayloadSize(2 * 32)
217     whenNotFreeze
218     whenNotFreezeOf(msg.sender)
219     whenNotFreezeOf(_to)
220   {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226   }
227   
228   function accsessAccountTransfer(address _to, uint _value) 
229     public 
230     onlyPayloadSize(2 * 32)
231     onTransferAccess(msg.sender)
232   {
233     require(_to != address(0));
234     require(_value <= balances[msg.sender]);
235     balances[msg.sender] = balances[msg.sender].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     emit Transfer(msg.sender, _to, _value);
238   }
239 
240   function balanceOf(address _owner) public constant returns (uint balance) {
241     return balances[_owner];
242   }
243 
244 }
245 
246 contract ERC20 is ERC20Basic {
247   function allowance(address owner, address spender)
248     public view returns (uint256);
249 
250   function transferFrom(address from, address to, uint256 value)
251     public returns (bool);
252 
253   function approve(address spender, uint256 value) public returns (bool);
254   event Approval(
255     address indexed owner,
256     address indexed spender,
257     uint256 value
258   );
259 }
260 
261 contract StandardToken is ERC20, BasicToken {
262 
263   mapping (address => mapping (address => uint256)) internal allowed;
264 
265   /**
266    * @dev Transfer tokens from one address to another
267    * @param _from address The address which you want to send tokens from
268    * @param _to address The address which you want to transfer to
269    * @param _value uint256 the amount of tokens to be transferred
270    */
271   function transferFrom(
272     address _from,
273     address _to,
274     uint256 _value
275   )
276     public
277     onlyPayloadSize(3 * 32)
278     whenNotFreeze
279     whenNotFreezeOf(_from)
280     whenNotFreezeOf(_to)
281     returns (bool)
282   {
283     require(_to != address(0));
284     require(_value <= balances[_from]);
285     require(_value <= allowed[_from][msg.sender]);
286 
287     balances[_from] = balances[_from].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290     emit Transfer(_from, _to, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296    *
297    * Beware that changing an allowance with this method brings the risk that someone may use both the old
298    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
299    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
300    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301    * @param _spender The address which will spend the funds.
302    * @param _value The amount of tokens to be spent.
303    */
304   function approve(address _spender, uint256 _value) public returns (bool) {
305     allowed[msg.sender][_spender] = _value;
306     emit Approval(msg.sender, _spender, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Function to check the amount of tokens that an owner allowed to a spender.
312    * @param _owner address The address which owns the funds.
313    * @param _spender address The address which will spend the funds.
314    * @return A uint256 specifying the amount of tokens still available for the spender.
315    */
316   function allowance(
317     address _owner,
318     address _spender
319    )
320     public
321     view
322     returns (uint256)
323   {
324     return allowed[_owner][_spender];
325   }
326 
327   /**
328    * @dev Increase the amount of tokens that an owner allowed to a spender.
329    *
330    * approve should be called when allowed[_spender] == 0. To increment
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _addedValue The amount of tokens to increase the allowance by.
336    */
337   function increaseApproval(
338     address _spender,
339     uint _addedValue
340   )
341     public
342     returns (bool)
343   {
344     allowed[msg.sender][_spender] = (
345       allowed[msg.sender][_spender].add(_addedValue));
346     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
347     return true;
348   }
349 
350   /**
351    * @dev Decrease the amount of tokens that an owner allowed to a spender.
352    *
353    * approve should be called when allowed[_spender] == 0. To decrement
354    * allowed value is better to use this function to avoid 2 calls (and wait until
355    * the first transaction is mined)
356    * From MonolithDAO Token.sol
357    * @param _spender The address which will spend the funds.
358    * @param _subtractedValue The amount of tokens to decrease the allowance by.
359    */
360   function decreaseApproval(
361     address _spender,
362     uint _subtractedValue
363   )
364     public
365     returns (bool)
366   {
367     uint oldValue = allowed[msg.sender][_spender];
368     if (_subtractedValue > oldValue) {
369       allowed[msg.sender][_spender] = 0;
370     } else {
371       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
372     }
373     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376 
377 }
378 
379 /**
380  * @title Mintable token
381  * @dev Simple ERC20 Token example, with mintable token creation
382  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
383  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
384  */
385 contract MintableToken is StandardToken {
386   event Mint(address indexed to, uint256 amount);
387   event MintFinished();
388 
389   bool public mintingFinished = false;
390 
391 
392   modifier canMint() {
393     require(!mintingFinished);
394     _;
395   }
396 
397   modifier hasMintPermission() {
398     require(msg.sender == owner);
399     _;
400   }
401 
402   /**
403    * @dev Function to mint tokens
404    * @param _to The address that will receive the minted tokens.
405    * @param _amount The amount of tokens to mint.
406    * @return A boolean that indicates if the operation was successful.
407    */
408   function mint(
409     address _to,
410     uint256 _amount
411   )
412     hasMintPermission
413     canMint
414     public
415     returns (bool)
416   {
417     totalSupply = totalSupply.add(_amount);
418     balances[_to] = balances[_to].add(_amount);
419     emit Mint(_to, _amount);
420     emit Transfer(address(0), _to, _amount);
421     return true;
422   }
423 
424   /**
425    * @dev Function to stop minting new tokens.
426    * @return True if the operation was successful.
427    */
428   function finishMinting() onlyOwner canMint public returns (bool) {
429     mintingFinished = true;
430     emit MintFinished();
431     return true;
432   }
433   
434 }
435 
436 contract ElacToken is MintableToken {
437     using SafeMath for uint256;
438     
439     string public name = 'ElacToken';
440     string public symbol = 'ELAC';
441     uint8 public decimals = 18;
442     
443 }