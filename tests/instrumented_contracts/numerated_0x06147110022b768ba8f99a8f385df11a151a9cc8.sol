1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances. 
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) returns (bool) {
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of. 
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) returns (bool);
84   function approve(address spender, uint256 value) returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 
195 contract MintableToken is StandardToken, Ownable {
196   event Mint(address indexed to, uint256 amount);
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 // ACE Token is a first token of TokenStars platform
232 // Copyright (c) 2017 TokenStars
233 // Made by Aler Denisov
234 // Permission is hereby granted, free of charge, to any person obtaining a copy
235 // of this software and associated documentation files (the "Software"), to deal
236 // in the Software without restriction, including without limitation the rights
237 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
238 // copies of the Software, and to permit persons to whom the Software is
239 // furnished to do so, subject to the following conditions:
240 
241 // The above copyright notice and this permission notice shall be included in all
242 // copies or substantial portions of the Software.
243 
244 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
245 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
246 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
247 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
248 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
249 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
250 // SOFTWARE.
251 
252 
253 
254 
255 
256 
257 contract StarTokenInterface is MintableToken {
258     // Cheatsheet of inherit methods and events
259     // function transferOwnership(address newOwner);
260     // function allowance(address owner, address spender) constant returns (uint256);
261     // function transfer(address _to, uint256 _value) returns (bool);
262     // function transferFrom(address from, address to, uint256 value) returns (bool);
263     // function approve(address spender, uint256 value) returns (bool);
264     // function increaseApproval (address _spender, uint _addedValue) returns (bool success);
265     // function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
266     // function finishMinting() returns (bool);
267     // function mint(address _to, uint256 _amount) returns (bool);
268     // event Approval(address indexed owner, address indexed spender, uint256 value);
269     // event Mint(address indexed to, uint256 amount);
270     // event MintFinished();
271 
272     // Custom methods and events
273     function openTransfer() public returns (bool);
274     function toggleTransferFor(address _for) public returns (bool);
275     function extraMint() public returns (bool);
276 
277     event TransferAllowed();
278     event TransferAllowanceFor(address indexed who, bool indexed state);
279 
280 
281 }
282 
283 // ACE Token is a first token of TokenStars platform
284 // Copyright (c) 2017 TokenStars
285 // Made by Aler Denisov
286 // Permission is hereby granted, free of charge, to any person obtaining a copy
287 // of this software and associated documentation files (the "Software"), to deal
288 // in the Software without restriction, including without limitation the rights
289 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
290 // copies of the Software, and to permit persons to whom the Software is
291 // furnished to do so, subject to the following conditions:
292 
293 // The above copyright notice and this permission notice shall be included in all
294 // copies or substantial portions of the Software.
295 
296 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
297 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
298 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
299 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
300 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
301 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
302 // SOFTWARE.
303 
304 
305 
306 
307 
308 
309 
310 contract AceToken is StarTokenInterface {
311     using SafeMath for uint256;
312     
313     // ERC20 constants
314     string public constant name = "ACE Token";
315     string public constant symbol = "ACE";
316     uint public constant decimals = 0;
317 
318     // Minting constants
319     uint256 public constant MAXSOLD_SUPPLY = 99000000;
320     uint256 public constant HARDCAPPED_SUPPLY = 165000000;
321 
322     uint256 public investorSupply = 0;
323     uint256 public extraSupply = 0;
324     uint256 public freeToExtraMinting = 0;
325 
326     uint256 public constant DISTRIBUTION_INVESTORS = 60;
327     uint256 public constant DISTRIBUTION_TEAM      = 20;
328     uint256 public constant DISTRIBUTION_COMMUNITY = 20;
329 
330     address public teamTokensHolder;
331     address public communityTokensHolder;
332 
333     // Transfer rules
334     bool public transferAllowed = false;
335     mapping (address=>bool) public specialAllowed;
336 
337     // Transfer rules events
338     // event TransferAllowed();
339     // event TransferAllowanceFor(address indexed who, bool indexed state);
340 
341     // Holders events
342     event ChangeCommunityHolder(address indexed from, address indexed to);
343     event ChangeTeamHolder(address indexed from, address indexed to);
344 
345     /**
346     * @dev check transfer is allowed
347     */
348     modifier allowTransfer() {
349         require(transferAllowed || specialAllowed[msg.sender]);
350         _;
351     }
352 
353     function AceToken() public {
354       teamTokensHolder = msg.sender;
355       communityTokensHolder = msg.sender;
356 
357       ChangeTeamHolder(0x0, teamTokensHolder);
358       ChangeCommunityHolder(0x0, communityTokensHolder);
359     }
360 
361     /**
362     * @dev change team tokens holder
363     * @param _tokenHolder The address of next team tokens holder
364     */
365     function setTeamTokensHolder(address _tokenHolder) onlyOwner public returns (bool) {
366       require(_tokenHolder != 0);
367       address temporaryEventAddress = teamTokensHolder;
368       teamTokensHolder = _tokenHolder;
369       ChangeTeamHolder(temporaryEventAddress, teamTokensHolder);
370       return true;
371     }
372 
373     /**
374     * @dev change community tokens holder
375     * @param _tokenHolder The address of next community tokens holder
376     */
377     function setCommunityTokensHolder(address _tokenHolder) onlyOwner public returns (bool) {
378       require(_tokenHolder != 0);
379       address temporaryEventAddress = communityTokensHolder;
380       communityTokensHolder = _tokenHolder;
381       ChangeCommunityHolder(temporaryEventAddress, communityTokensHolder);
382       return true;
383     }
384 
385     /**
386     * @dev Doesn't allow to send funds on contract!
387     */
388     function () payable public {
389         require(false);
390     }
391 
392     /**
393     * @dev transfer token for a specified address if transfer is open
394     * @param _to The address to transfer to.
395     * @param _value The amount to be transferred.
396     */
397     function transfer(address _to, uint256 _value) allowTransfer public returns (bool) {
398         return super.transfer(_to, _value);
399     }
400 
401     
402     /**
403     * @dev Transfer tokens from one address to another if transfer is open
404     * @param _from address The address which you want to send tokens from
405     * @param _to address The address which you want to transfer to
406     * @param _value uint256 the amount of tokens to be transferred
407      */
408     function transferFrom(address _from, address _to, uint256 _value) allowTransfer public returns (bool) {
409         return super.transferFrom(_from, _to, _value);
410     }
411 
412     /**
413     * @dev Open transfer for everyone or throws
414      */
415     function openTransfer() onlyOwner public returns (bool) {
416         require(!transferAllowed);
417         transferAllowed = true;
418         TransferAllowed();
419         return true;
420     }
421 
422     /**
423     * @dev allow transfer for the given address against global rules
424     * @param _for addres The address of special allowed transfer (required for smart contracts)
425      */
426     function toggleTransferFor(address _for) onlyOwner public returns (bool) {
427         specialAllowed[_for] = !specialAllowed[_for];
428         TransferAllowanceFor(_for, specialAllowed[_for]);
429         return specialAllowed[_for];
430     }
431 
432     /**
433     * @dev Function to mint tokens for investor
434     * @param _to The address that will receive the minted tokens.
435     * @param _amount The amount of tokens to emit.
436     * @return A boolean that indicates if the operation was successful.
437     */
438     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
439         require(_amount > 0);
440         totalSupply = totalSupply.add(_amount);
441         investorSupply = investorSupply.add(_amount);
442         freeToExtraMinting = freeToExtraMinting.add(_amount);
443 
444         // Prevent to emit more than sale hardcap!
445         assert(investorSupply <= MAXSOLD_SUPPLY);
446         assert(totalSupply <= HARDCAPPED_SUPPLY);
447 
448         balances[_to] = balances[_to].add(_amount);
449         Mint(_to, _amount);
450         Transfer(address(this), _to, _amount);
451         return true;
452     }
453 
454 
455     /**
456     * @dev Mint extra token to corresponding token and community holders
457     */
458     function extraMint() onlyOwner canMint public returns (bool) {
459       require(freeToExtraMinting > 0);
460 
461       uint256 onePercent = freeToExtraMinting / DISTRIBUTION_INVESTORS;
462       uint256 teamPart = onePercent * DISTRIBUTION_TEAM;
463       uint256 communityPart = onePercent * DISTRIBUTION_COMMUNITY;
464       uint256 extraTokens = teamPart.add(communityPart);
465 
466       totalSupply = totalSupply.add(extraTokens);
467       extraSupply = extraSupply.add(extraTokens);
468 
469       uint256 leftToNextMinting = freeToExtraMinting % DISTRIBUTION_INVESTORS;
470       freeToExtraMinting = leftToNextMinting;
471 
472       assert(totalSupply <= HARDCAPPED_SUPPLY);
473       assert(extraSupply <= HARDCAPPED_SUPPLY.sub(MAXSOLD_SUPPLY));
474 
475       balances[teamTokensHolder] = balances[teamTokensHolder].add(teamPart);
476       balances[communityTokensHolder] = balances[communityTokensHolder].add(communityPart);
477 
478       Mint(teamTokensHolder, teamPart);
479       Transfer(address(this), teamTokensHolder, teamPart);
480       Mint(communityTokensHolder, communityPart);
481       Transfer(address(this), communityTokensHolder, communityPart);
482 
483       return true;
484     }
485 
486     /**
487     * @dev Increase approved amount to spend 
488     * @param _spender The address which will spend the funds.
489     * @param _addedValue The amount of tokens to increase already approved amount. 
490      */
491     function increaseApproval (address _spender, uint _addedValue)  public returns (bool success) {
492         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
493         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
494         return true;
495     }
496 
497     /**
498     * @dev Decrease approved amount to spend 
499     * @param _spender The address which will spend the funds.
500     * @param _subtractedValue The amount of tokens to decrease already approved amount. 
501      */
502     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
503         uint oldValue = allowed[msg.sender][_spender];
504         if (_subtractedValue > oldValue) {
505             allowed[msg.sender][_spender] = 0;
506         } else {
507             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
508         }
509         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
510         return true;
511     }
512 
513 
514     function finilize() onlyOwner public returns (bool) {
515         require(mintingFinished);
516         require(transferAllowed);
517 
518         owner = 0x0;
519         return true;
520     }
521 }