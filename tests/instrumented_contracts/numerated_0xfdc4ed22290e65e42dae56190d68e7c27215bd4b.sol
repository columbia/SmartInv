1 /**
2     Copyright (c) 2018 Taylor OÜ
3 
4     Permission is hereby granted, free of charge, to any person obtaining a copy
5     of this software and associated documentation files (the "Software"), to deal
6     in the Software without restriction, including without limitation the rights
7     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8     copies of the Software, and to permit persons to whom the Software is
9     furnished to do so, subject to the following conditions:
10 
11     The above copyright notice and this permission notice shall be included in
12     all copies or substantial portions of the Software.
13 
14     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
20     THE SOFTWARE.
21 
22     based on the contracts of OpenZeppelin:
23     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
24 
25 **/
26 
27 pragma solidity ^0.4.18;
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 
72 /**
73   @title TaylorToken
74 **/
75 contract TaylorToken is Ownable{
76 
77     using SafeMath for uint256;
78 
79     /**
80         EVENTS
81     **/
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     event Burn(address indexed _owner, uint256 _amount);
85     /**
86         CONTRACT VARIABLES
87     **/
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 
91     //this address can transfer even when transfer is disabled.
92     mapping (address => bool) public whitelistedTransfer;
93     mapping (address => bool) public whitelistedBurn;
94 
95     string public name = "Taylor";
96     string public symbol = "TAY";
97     uint8 public decimals = 18;
98     uint256 constant internal DECIMAL_CASES = 10**18;
99     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
100     bool public transferable = false;
101 
102     /**
103         MODIFIERS
104     **/
105     modifier onlyWhenTransferable(){
106       if(!whitelistedTransfer[msg.sender]){
107         require(transferable);
108       }
109       _;
110     }
111 
112     /**
113         CONSTRUCTOR
114     **/
115 
116     /**
117       @dev Constructor function executed on contract creation
118     **/
119     function TaylorToken()
120       Ownable()
121       public
122     {
123       balances[owner] = balances[owner].add(totalSupply);
124       whitelistedTransfer[msg.sender] = true;
125       whitelistedBurn[msg.sender] = true;
126       Transfer(address(0),owner, totalSupply);
127     }
128 
129     /**
130         OWNER ONLY FUNCTIONS
131     **/
132 
133     /**
134       @dev Activates the trasfer for all users
135     **/
136     function activateTransfers()
137       public
138       onlyOwner
139     {
140       transferable = true;
141     }
142 
143     /**
144       @dev Allows the owner to add addresse that can bypass the
145       transfer lock. Eg: ICO contract, TGE contract.
146       @param _address address Address to be added
147     **/
148     function addWhitelistedTransfer(address _address)
149       public
150       onlyOwner
151     {
152       whitelistedTransfer[_address] = true;
153     }
154 
155     /**
156       @dev Sends all avaible TAY to the TGE contract to be properly
157       distribute
158       @param _tgeAddress address Address of the token distribution
159       contract
160     **/
161     function distribute(address _tgeAddress)
162       public
163       onlyOwner
164     {
165       whitelistedTransfer[_tgeAddress] = true;
166       transfer(_tgeAddress, balances[owner]);
167     }
168 
169 
170     /**
171       @dev Allows the owner to add addresse that can burn tokens
172       Eg: ICO contract, TGE contract.
173       @param _address address Address to be added
174     **/
175     function addWhitelistedBurn(address _address)
176       public
177       onlyOwner
178     {
179       whitelistedBurn[_address] = true;
180     }
181 
182     /**
183         PUBLIC FUNCTIONS
184     **/
185 
186     /**
187     * @dev transfer token for a specified address
188     * @param _to The address to transfer to.
189     * @param _value The amount to be transferred.
190     */
191     function transfer(address _to, uint256 _value)
192       public
193       onlyWhenTransferable
194       returns (bool success)
195     {
196       require(_to != address(0));
197       require(_value <= balances[msg.sender]);
198 
199       balances[msg.sender] = balances[msg.sender].sub(_value);
200       balances[_to] = balances[_to].add(_value);
201       Transfer(msg.sender, _to, _value);
202       return true;
203     }
204 
205     /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211     function transferFrom
212       (address _from,
213         address _to,
214         uint256 _value)
215         public
216         onlyWhenTransferable
217         returns (bool success) {
218       require(_to != address(0));
219       require(_value <= balances[_from]);
220       require(_value <= allowed[_from][msg.sender]);
221 
222       balances[_from] = balances[_from].sub(_value);
223       balances[_to] = balances[_to].add(_value);
224       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225       Transfer(_from, _to, _value);
226       return true;
227     }
228 
229     /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231     For security reasons, if one need to change the value from a existing allowance, it must furst sets
232     it to zero and then sets the new value
233 
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237     function approve(address _spender, uint256 _value)
238       public
239       onlyWhenTransferable
240       returns (bool success)
241     {
242       allowed[msg.sender][_spender] = _value;
243       Approval(msg.sender, _spender, _value);
244       return true;
245     }
246 
247       /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      *
250      * approve should be called when allowed[_spender] == 0. To increment
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * @param _spender The address which will spend the funds.
255      * @param _addedValue The amount of tokens to increase the allowance by.
256      */
257     function increaseApproval(address _spender, uint _addedValue)
258       public
259       returns (bool)
260     {
261       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
262       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263       return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      *
269      * approve should be called when allowed[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * @param _spender The address which will spend the funds.
274      * @param _subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseApproval(address _spender, uint _subtractedValue)
277       public
278       returns (bool)
279     {
280       uint oldValue = allowed[msg.sender][_spender];
281       if (_subtractedValue > oldValue) {
282         allowed[msg.sender][_spender] = 0;
283       } else {
284         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285       }
286       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287       return true;
288     }
289 
290     /**
291       @dev Allows for msg.sender to burn his on tokens
292       @param _amount uint256 The amount of tokens to be burned
293     **/
294     function burn(uint256 _amount)
295       public
296       returns (bool success)
297     {
298       require(whitelistedBurn[msg.sender]);
299       require(_amount <= balances[msg.sender]);
300       balances[msg.sender] = balances[msg.sender].sub(_amount);
301       totalSupply =  totalSupply.sub(_amount);
302       Burn(msg.sender, _amount);
303       return true;
304     }
305 
306 
307     /**
308         CONSTANT FUNCTIONS
309     **/
310 
311     /**
312     * @dev Gets the balance of the specified address.
313     * @param _owner The address to query the the balance of.
314     * @return An uint256 representing the amount owned by the passed address.
315     */
316     function balanceOf(address _owner) view public returns (uint256 balance) {
317         return balances[_owner];
318     }
319 
320     /**
321    * @dev Function to check the amount of tokens that an owner allowed to a spender.
322    * @param _owner address The address which owns the funds.
323    * @param _spender address The address which will spend the funds.
324    * @return A uint256 specifying the amount of tokens still available for the spender.
325    */
326     function allowance(address _owner, address _spender)
327       view
328       public
329       returns (uint256 remaining)
330     {
331       return allowed[_owner][_spender];
332     }
333 
334 }
335 
336 
337 
338 
339 
340 /**
341  * @title SafeMath
342  * @dev Math operations with safety checks that throw on error
343  */
344 library SafeMath {
345   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
346     if (a == 0) {
347       return 0;
348     }
349     uint256 c = a * b;
350     assert(c / a == b);
351     return c;
352   }
353 
354   function div(uint256 a, uint256 b) internal pure returns (uint256) {
355     // assert(b > 0); // Solidity automatically throws when dividing by 0
356     uint256 c = a / b;
357     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
358     return c;
359   }
360 
361   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
362     assert(b <= a);
363     return a - b;
364   }
365 
366   function add(uint256 a, uint256 b) internal pure returns (uint256) {
367     uint256 c = a + b;
368     assert(c >= a);
369     return c;
370   }
371 }
372 
373 
374 /**
375  * @title TokenVesting
376  * @dev A token holder contract that can release its token balance gradually like a
377  * typical vesting scheme, with a cliff and vesting period.
378  */
379 contract TokenVesting is Ownable {
380   using SafeMath for uint256;
381 
382   event Released(uint256 amount);
383 
384   // beneficiary of tokens after they are released
385   address public beneficiary;
386 
387   TaylorToken public token;
388 
389   uint256 public cliff;
390   uint256 public start;
391   uint256 public duration;
392 
393   uint256 public released;
394 
395   /**
396    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
397    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
398    * of the balance will have vested.
399    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
400    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
401    * @param _duration duration in seconds of the period in which the tokens will vest
402    * @param _token The token to be vested
403    */
404   function TokenVesting(address _beneficiary,address _token, uint256 _start, uint256 _cliff, uint256 _duration) public {
405     require(_beneficiary != address(0));
406     require(_cliff <= _duration);
407 
408     beneficiary = _beneficiary;
409     duration = _duration;
410     token = TaylorToken(_token);
411     cliff = _start.add(_cliff);
412     start = _start;
413   }
414 
415   /**
416    * @notice Transfers vested tokens to beneficiary.
417    */
418   function release() public {
419     uint256 unreleased = releasableAmount();
420     require(unreleased > 0);
421 
422     released = released.add(unreleased);
423 
424     token.transfer(beneficiary, unreleased);
425 
426     Released(unreleased);
427   }
428 
429   /**
430    * @dev Calculates the amount that has already vested but hasn't been released yet.
431    */
432   function releasableAmount() public view returns (uint256) {
433     return vestedAmount().sub(released);
434   }
435 
436   /**
437    * @dev Calculates the amount that has already vested.
438    */
439   function vestedAmount() public view returns (uint256) {
440     uint256 currentBalance = token.balanceOf(this);
441     uint256 totalBalance = currentBalance.add(released);
442 
443     if (now < cliff) {
444       return 0;
445     } else if (now >= cliff && now < start.add(duration)) {
446       return totalBalance / 2;
447     } else {
448       return totalBalance;
449     }
450   }
451 }