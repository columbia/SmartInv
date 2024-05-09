1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address who) public view returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 contract DetailedERC20 is ERC20 {
93   string public name;
94   string public symbol;
95   uint8 public decimals;
96 
97   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
98     name = _name;
99     symbol = _symbol;
100     decimals = _decimals;
101   }
102 }
103 
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     emit Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract BurnableToken is BasicToken {
146 
147   event Burn(address indexed burner, uint256 value);
148 
149   /**
150    * @dev Burns a specific amount of tokens.
151    * @param _value The amount of token to be burned.
152    */
153   function burn(uint256 _value) public {
154     _burn(msg.sender, _value);
155   }
156 
157   function _burn(address _who, uint256 _value) internal {
158     require(_value <= balances[_who]);
159     // no need to require value <= totalSupply, since that would imply the
160     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
161 
162     balances[_who] = balances[_who].sub(_value);
163     totalSupply_ = totalSupply_.sub(_value);
164     emit Burn(_who, _value);
165     emit Transfer(_who, address(0), _value);
166   }
167 }
168 
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract ERC827 is ERC20 {
258   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
259   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
260   function transferFromAndCall(
261     address _from,
262     address _to,
263     uint256 _value,
264     bytes _data
265   )
266     public
267     payable
268     returns (bool);
269 }
270 
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 contract CappedToken is MintableToken {
309 
310   uint256 public cap;
311 
312   function CappedToken(uint256 _cap) public {
313     require(_cap > 0);
314     cap = _cap;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     require(totalSupply_.add(_amount) <= cap);
325 
326     return super.mint(_to, _amount);
327   }
328 
329 }
330 
331 contract ERC827Token is ERC827, StandardToken {
332 
333   /**
334    * @dev Addition to ERC20 token methods. It allows to
335    * @dev approve the transfer of value and execute a call with the sent data.
336    *
337    * @dev Beware that changing an allowance with this method brings the risk that
338    * @dev someone may use both the old and the new allowance by unfortunate
339    * @dev transaction ordering. One possible solution to mitigate this race condition
340    * @dev is to first reduce the spender's allowance to 0 and set the desired value
341    * @dev afterwards:
342    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343    *
344    * @param _spender The address that will spend the funds.
345    * @param _value The amount of tokens to be spent.
346    * @param _data ABI-encoded contract call to call `_to` address.
347    *
348    * @return true if the call function was executed successfully
349    */
350   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
351     require(_spender != address(this));
352 
353     super.approve(_spender, _value);
354 
355     // solium-disable-next-line security/no-call-value
356     require(_spender.call.value(msg.value)(_data));
357 
358     return true;
359   }
360 
361   /**
362    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
363    * @dev address and execute a call with the sent data on the same transaction
364    *
365    * @param _to address The address which you want to transfer to
366    * @param _value uint256 the amout of tokens to be transfered
367    * @param _data ABI-encoded contract call to call `_to` address.
368    *
369    * @return true if the call function was executed successfully
370    */
371   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
372     require(_to != address(this));
373 
374     super.transfer(_to, _value);
375 
376     // solium-disable-next-line security/no-call-value
377     require(_to.call.value(msg.value)(_data));
378     return true;
379   }
380 
381   /**
382    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
383    * @dev another and make a contract call on the same transaction
384    *
385    * @param _from The address which you want to send tokens from
386    * @param _to The address which you want to transfer to
387    * @param _value The amout of tokens to be transferred
388    * @param _data ABI-encoded contract call to call `_to` address.
389    *
390    * @return true if the call function was executed successfully
391    */
392   function transferFromAndCall(
393     address _from,
394     address _to,
395     uint256 _value,
396     bytes _data
397   )
398     public payable returns (bool)
399   {
400     require(_to != address(this));
401 
402     super.transferFrom(_from, _to, _value);
403 
404     // solium-disable-next-line security/no-call-value
405     require(_to.call.value(msg.value)(_data));
406     return true;
407   }
408 
409   /**
410    * @dev Addition to StandardToken methods. Increase the amount of tokens that
411    * @dev an owner allowed to a spender and execute a call with the sent data.
412    *
413    * @dev approve should be called when allowed[_spender] == 0. To increment
414    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
415    * @dev the first transaction is mined)
416    * @dev From MonolithDAO Token.sol
417    *
418    * @param _spender The address which will spend the funds.
419    * @param _addedValue The amount of tokens to increase the allowance by.
420    * @param _data ABI-encoded contract call to call `_spender` address.
421    */
422   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
423     require(_spender != address(this));
424 
425     super.increaseApproval(_spender, _addedValue);
426 
427     // solium-disable-next-line security/no-call-value
428     require(_spender.call.value(msg.value)(_data));
429 
430     return true;
431   }
432 
433   /**
434    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
435    * @dev an owner allowed to a spender and execute a call with the sent data.
436    *
437    * @dev approve should be called when allowed[_spender] == 0. To decrement
438    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
439    * @dev the first transaction is mined)
440    * @dev From MonolithDAO Token.sol
441    *
442    * @param _spender The address which will spend the funds.
443    * @param _subtractedValue The amount of tokens to decrease the allowance by.
444    * @param _data ABI-encoded contract call to call `_spender` address.
445    */
446   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
447     require(_spender != address(this));
448 
449     super.decreaseApproval(_spender, _subtractedValue);
450 
451     // solium-disable-next-line security/no-call-value
452     require(_spender.call.value(msg.value)(_data));
453 
454     return true;
455   }
456 
457 }
458 
459 contract SUNToken is ERC827Token, DetailedERC20, BurnableToken, CappedToken {
460     using SafeMath for uint256;
461 
462     function SUNToken() public
463         CappedToken(5000000000 * (10**18))
464         DetailedERC20("BitSun", "SUN", 18) {
465     }
466 
467     /**
468     * @dev Function to mass mint tokens
469     * @param _recipients The addresses that will receive the minted tokens.
470     * @param _amounts The list of the amounts of tokens to mint.
471     * @return A boolean that indicates if the operation was successful.
472     */
473     function massMint(address [] _recipients, uint256 [] _amounts) onlyOwner canMint public returns (bool) {
474         require(_recipients.length == _amounts.length);
475 
476         for (uint i = 0; i < _recipients.length; i++) {
477             if (!mint(_recipients[i], _amounts[i])) {
478                 revert();
479             }
480         }
481 
482         return true;
483     }
484 }