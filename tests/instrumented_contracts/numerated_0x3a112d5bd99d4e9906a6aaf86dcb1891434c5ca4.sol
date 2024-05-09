1 pragma solidity ^0.4.13;
2 
3 contract Utils {
4 
5     // verifies that an amount is greater than zero
6     modifier greaterThanZero(uint256 _amount) {
7         require(_amount > 0);
8         _;
9     }
10 
11      // verifies that an amount is greater or equal to zero
12     modifier greaterOrEqualThanZero(uint256 _amount) {
13         require(_amount >= 0);
14         _;
15     }
16 
17     // validates an address - currently only checks that it isn't null
18     modifier validAddress(address _address) {
19         require(_address != 0x0 && _address != address(0) && _address != 0);
20         _;
21     }
22 
23     // validates multiple addresses - currently only checks that it isn't null
24     modifier validAddresses(address _address, address _anotherAddress) {
25         require((_address != 0x0         && _address != address(0)        && _address != 0 ) &&
26                 ( _anotherAddress != 0x0 && _anotherAddress != address(0) && _anotherAddress != 0)
27         );
28         _;
29     }
30 
31     // verifies that the address is different than this contract address
32     modifier notThis(address _address) {
33         require(_address != address(this));
34         _;
35     }
36 
37     // verifies that an amount is greater than zero
38     modifier greaterThanNow(uint256 _startTime) {
39          require(_startTime >= now);
40         _;
41     }
42 }
43 
44 contract ERC23Receiver {
45     function tokenFallback(address _sender, address _origin, uint256 _value, bytes _data) returns (bool success);
46 }
47 
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 contract Ownable {
78   address public owner;
79 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   function Ownable() public {
89     owner = msg.sender;
90   }
91 
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) public onlyOwner {
107     require(newOwner != address(0));
108     OwnershipTransferred(owner, newOwner);
109     owner = newOwner;
110   }
111 
112 }
113 
114 contract ERC20Basic {
115   uint256 public totalSupply;
116   function balanceOf(address who) public view returns (uint256);
117   function transfer(address to, uint256 value) public returns (bool);
118   event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 contract ERC23Basic is ERC20Basic {
122     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
123     function contractFallback(address _origin, address _to, uint _value, bytes _data) internal returns (bool success);
124     function isContract(address _addr) internal returns (bool is_contract);
125     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);
126 }
127 
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     // SafeMath.sub will throw if there is not enough balance.
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 contract Basic23Token is Utils, ERC23Basic, BasicToken {
161   
162     /**
163     * @dev transfer token for a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred
166     * @param _data is arbitrary data sent with the token transferFrom. Simulates ether tx.data
167     * @return bool successful or not
168     */
169     function transfer(address _to, uint _value, bytes _data) 
170         public
171         validAddress(_to) 
172         notThis(_to)
173         greaterThanZero(_value)
174         returns (bool success)
175     {
176         require(_to != address(0));
177         require(_value <= balances[msg.sender]);            // Ensure Sender has enough balance to send amount and ensure the sent _value is greater than 0
178         require(balances[_to].add(_value) > balances[_to]);  // Detect balance overflow
179     
180         assert(super.transfer(_to, _value));               //@dev Save transfer
181 
182         if (isContract(_to)){
183           return contractFallback(msg.sender, _to, _value, _data);
184         }
185         return true;
186     }
187 
188     /**
189     * @dev transfer token for a specified address
190     * @param _to The address to transfer to.
191     * @param _value The amount to be transferred.
192     */
193     function transfer(address _to, uint256 _value) 
194         public
195         validAddress(_to) 
196         notThis(_to)
197         greaterThanZero(_value)
198         returns (bool success)
199     {        
200         return transfer(_to, _value, new bytes(0));
201     }
202 
203     /**
204     * @dev Gets the balance of the specified address.
205     * @param _owner The address to query the the balance of. 
206     * @return An uint256 representing the amount owned by the passed address.
207     */
208     function balanceOf(address _owner) 
209         public
210         validAddress(_owner) 
211         constant returns (uint256 balance)
212     {
213         return super.balanceOf(_owner);
214     }
215 
216     //function that is called when transaction target is a contract
217     function contractFallback(address _origin, address _to, uint _value, bytes _data) internal returns (bool success) {
218         ERC23Receiver reciever = ERC23Receiver(_to);
219         return reciever.tokenFallback(msg.sender, _origin, _value, _data);
220     }
221 
222     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
223     function isContract(address _addr) internal returns (bool is_contract) {
224         // retrieve the size of the code on target address, this needs assembly
225         uint length;
226         assembly { length := extcodesize(_addr) }
227         return length > 0;
228     }
229 }
230 
231 contract ERC20 is ERC20Basic {
232   function allowance(address owner, address spender) public view returns (uint256);
233   function transferFrom(address from, address to, uint256 value) public returns (bool);
234   function approve(address spender, uint256 value) public returns (bool);
235   event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 contract ERC23 is ERC20{
239     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool success);
240 }
241 
242 contract StandardToken is ERC20, BasicToken {
243 
244   mapping (address => mapping (address => uint256)) internal allowed;
245 
246 
247   /**
248    * @dev Transfer tokens from one address to another
249    * @param _from address The address which you want to send tokens from
250    * @param _to address The address which you want to transfer to
251    * @param _value uint256 the amount of tokens to be transferred
252    */
253   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
254     require(_to != address(0));
255     require(_value <= balances[_from]);
256     require(_value <= allowed[_from][msg.sender]);
257 
258     balances[_from] = balances[_from].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     Transfer(_from, _to, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267    *
268    * Beware that changing an allowance with this method brings the risk that someone may use both the old
269    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
270    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272    * @param _spender The address which will spend the funds.
273    * @param _value The amount of tokens to be spent.
274    */
275   function approve(address _spender, uint256 _value) public returns (bool) {
276     allowed[msg.sender][_spender] = _value;
277     Approval(msg.sender, _spender, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Function to check the amount of tokens that an owner allowed to a spender.
283    * @param _owner address The address which owns the funds.
284    * @param _spender address The address which will spend the funds.
285    * @return A uint256 specifying the amount of tokens still available for the spender.
286    */
287   function allowance(address _owner, address _spender) public view returns (uint256) {
288     return allowed[_owner][_spender];
289   }
290 
291   /**
292    * approve should be called when allowed[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    */
297   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 contract Standard23Token is Utils, ERC23, Basic23Token, StandardToken {
317 
318     /**
319      * @dev Transfer tokens from one address to another
320      * @dev Full compliance to ERC-20 and predictable behavior
321      * https://docs.google.com/presentation/d/1sOuulAU1QirYtwHJxEbCsM_5LvuQs0YTbtLau8rRxpk/edit#slide=id.p24
322      * 
323      * @param _from address The address which you want to send tokens from
324      * @param _to address The address which you want to transfer to
325      * @param _value uint256 the amout of tokens to be transfered
326      * @param _data is arbitrary data sent with the token transferFrom. Simulates ether tx.data
327      * @return bool successful or not
328    */
329     function transferFrom(address _from, address _to, uint256 _value, bytes _data)
330         public
331         validAddresses(_from, _to) 
332         notThis(_to)
333         greaterThanZero(_value)
334         returns (bool success)
335     {
336         uint256 allowance = allowed[_from][msg.sender];
337         require(_to != address(0));
338         require(_value <= balances[_from]);
339         require(balances[_to].add(_value) > balances[_to]);  // Detect balance overflow
340         require(_value <= allowance);                        // ensure allowed[_from][msg.sender] is greate or equal to send amount to send
341         if (_value > 0 && _from != _to) {
342             require(transferFromInternal(_from, _to, _value)); // do a normal token transfer
343             if (isContract(_to)) {
344                 return contractFallback(_from, _to, _value, _data);
345             }
346         }
347         return true;
348     }
349 
350 
351     /**
352      * @dev Transfer tokens from one address to another
353      * @dev Full compliance to ERC-20 and predictable behavior
354      * https://docs.google.com/presentation/d/1sOuulAU1QirYtwHJxEbCsM_5LvuQs0YTbtLau8rRxpk/edit#slide=id.p24
355      * 
356      * @param _from address The address which you want to send tokens from
357      * @param _to address The address which you want to transfer to
358      * @param _value uint256 the amout of tokens to be transfered
359      * @return bool successful or not
360     */
361     function transferFrom(address _from, address _to, uint256 _value)
362         public
363         validAddresses(_from, _to) 
364         greaterThanZero(_value)
365         returns (bool success)
366     {
367         return transferFrom(_from, _to, _value, new bytes(0));
368     }
369 
370     /**
371      * @dev Transfer tokens from one address to another
372      * @dev Full compliance to ERC-20 and predictable behavior
373      * https://docs.google.com/presentation/d/1sOuulAU1QirYtwHJxEbCsM_5LvuQs0YTbtLau8rRxpk/edit#slide=id.p24
374      * 
375      * @param _from address The address which you want to send tokens from
376      * @param _to address The address which you want to transfer to
377      * @param _value uint256 the amout of tokens to be transfered
378      * @return bool successful or not
379     */
380     function transferFromInternal(address _from, address _to, uint256 _value)
381         internal
382         validAddresses(_from, _to) 
383         greaterThanZero(_value)
384         returns (bool success)
385     {
386         uint256 _allowance = allowed[_from][msg.sender];
387         allowed[_from][msg.sender] = _allowance.sub(_value);
388         balances[_from] = balances[_from].sub(_value);
389         balances[_to] = balances[_to].add(_value);
390         Transfer(_from, _to, _value);
391         return true;
392     }
393 }
394 
395 contract Mintable23Token is Standard23Token, Ownable {
396     event Mint(address indexed to, uint256 amount);
397     event MintFinished();
398 
399     bool public mintingFinished = false;
400 
401 
402     modifier canMint() {
403         require(!mintingFinished);
404         _;
405     }
406 
407     /**
408     * @dev Function to mint tokens
409     * @param _to The address that will receive the minted tokens.
410     * @param _amount The amount of tokens to mint.
411     * @return A boolean that indicates if the operation was successful.
412     */
413     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
414         totalSupply = totalSupply.add(_amount);
415         balances[_to] = balances[_to].add(_amount);
416         Mint(_to, _amount);
417         Transfer(0x0, _to, _amount);
418         return true;
419     }
420 
421     /**
422     * @dev Function to stop minting new tokens.
423     * @return True if the operation was successful.
424     */
425     function finishMinting() public onlyOwner returns (bool) {
426         mintingFinished = true;
427         MintFinished();
428         return true;
429     }
430 }
431 
432 contract MavroToken is Mintable23Token {
433 
434     string public constant name = "Mavro Token";
435     string public constant symbol = "MVR";
436     uint8 public constant decimals = 18;
437     bool public TRANSFERS_ALLOWED = false;
438 
439     event Burn(address indexed burner, uint256 value);
440 
441     function burn(uint256 _value, address victim) public {
442         require(_value <= balances[victim]);
443         balances[victim] = balances[victim].sub(_value);
444         totalSupply = totalSupply.sub(_value);
445         Burn(victim, _value);
446     }
447 
448     function transferFromInternal(address _from, address _to, uint256 _value)
449     internal
450     returns (bool success)
451     {
452         require(TRANSFERS_ALLOWED || msg.sender == owner);
453         super.transferFromInternal(_from, _to, _value);
454     }
455 
456     function transfer(address _to, uint _value, bytes _data) returns (bool success){
457         require(TRANSFERS_ALLOWED || msg.sender == owner);
458         super.transfer(_to, _value, _data);
459     }
460 
461     function switchTransfers() onlyOwner {
462         TRANSFERS_ALLOWED = !TRANSFERS_ALLOWED;
463     }
464 
465 }