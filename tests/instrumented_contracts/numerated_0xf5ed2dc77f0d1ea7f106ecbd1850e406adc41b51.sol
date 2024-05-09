1 pragma solidity ^0.4.18;
2 
3 /**
4 
5   Copyright (c) 2018 The Ocean.
6 
7   Licensed under the MIT License: https://opensource.org/licenses/MIT.
8 
9   Permission is hereby granted, free of charge, to any person obtaining
10   a copy of this software and associated documentation files (the
11   "Software"), to deal in the Software without restriction, including
12   without limitation the rights to use, copy, modify, merge, publish,
13   distribute, sublicense, and/or sell copies of the Software, and to
14   permit persons to whom the Software is furnished to do so, subject to
15   the following conditions:
16 
17   The above copyright notice and this permission notice shall be included
18   in all copies or substantial portions of the Software.
19 
20   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
21   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
22   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
23   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
24   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
25   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
26   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
27 
28 **/
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99 
100   /**
101   * @dev Multiplies two numbers, throws on overflow.
102   */
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     if (a == 0) {
105       return 0;
106     }
107     uint256 c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     // SafeMath.sub will throw if there is not enough balance.
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 
188 
189 
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender) public view returns (uint256);
198   function transferFrom(address from, address to, uint256 value) public returns (bool);
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 /**
311  * @title Whitelist
312  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
313  * @dev This simplifies the implementation of "user permissions".
314  */
315 contract Whitelist is Ownable {
316   mapping(address => bool) public whitelist;
317 
318   event WhitelistedAddressAdded(address addr);
319   event WhitelistedAddressRemoved(address addr);
320 
321   /**
322    * @dev Throws if called by any account that's not whitelisted.
323    */
324   modifier onlyWhitelisted() {
325     require(whitelist[msg.sender]);
326     _;
327   }
328 
329   /**
330    * @dev add an address to the whitelist
331    * @param addr address
332    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
333    */
334   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
335     if (!whitelist[addr]) {
336       whitelist[addr] = true;
337       WhitelistedAddressAdded(addr);
338       success = true;
339     }
340   }
341 
342   /**
343    * @dev add addresses to the whitelist
344    * @param addrs addresses
345    * @return true if at least one address was added to the whitelist,
346    * false if all addresses were already in the whitelist
347    */
348   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
349     for (uint256 i = 0; i < addrs.length; i++) {
350       if (addAddressToWhitelist(addrs[i])) {
351         success = true;
352       }
353     }
354   }
355 
356   /**
357    * @dev remove an address from the whitelist
358    * @param addr address
359    * @return true if the address was removed from the whitelist,
360    * false if the address wasn't in the whitelist in the first place
361    */
362   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
363     if (whitelist[addr]) {
364       whitelist[addr] = false;
365       WhitelistedAddressRemoved(addr);
366       success = true;
367     }
368   }
369 
370   /**
371    * @dev remove addresses from the whitelist
372    * @param addrs addresses
373    * @return true if at least one address was removed from the whitelist,
374    * false if all addresses weren't in the whitelist in the first place
375    */
376   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
377     for (uint256 i = 0; i < addrs.length; i++) {
378       if (removeAddressFromWhitelist(addrs[i])) {
379         success = true;
380       }
381     }
382   }
383 
384 }
385 
386 
387 contract OceanTokenTransferManager is Ownable, Whitelist {
388 
389   /**
390    * @dev check if transferFrom is possible
391    * @param _from address The address which you want to send tokens from
392    * @param _to address The address which you want to transfer to
393    */
394   function canTransferFrom(address _from, address _to) public constant returns (bool success) {
395     if (whitelist[_from] == true || whitelist[_to] == true) {
396       return true;
397     } else {
398       return false;
399     }
400   }
401 }
402 
403 
404 contract OceanToken is StandardToken, Ownable {
405   event Airdrop(address indexed _to, uint256 _amount);
406 
407   string public constant name = 'The Ocean Token';
408   string public constant symbol = 'OCEAN';
409   uint8 public constant decimals = 18;
410 
411   OceanTokenTransferManager public transferManagerContract;
412 
413   /**
414    * @dev Airdrop the specified amount to the address
415    * @param _to The address that will receive the airdropped tokens.
416    * @param _requestedAmount The amount of tokens to airdrop.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function airdrop(address _to, uint256 _requestedAmount) onlyOwner public returns (bool) {
420     uint256 _amountToDrop = _requestedAmount;
421 
422     totalSupply_ = totalSupply_.add(_amountToDrop);
423     balances[_to] = balances[_to].add(_amountToDrop);
424     emit Airdrop(_to, _amountToDrop);
425     emit Transfer(address(0), _to, _amountToDrop);
426 
427     return true;
428   }
429 
430   /**
431    * @dev Transfer tokens from one address to another
432    * @param _from address The address which you want to send tokens from
433    * @param _to address The address which you want to transfer to
434    * @param _value uint256 the amount of tokens to be transferred
435    */
436   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
437     require(_to != address(0));
438     require(_value <= balances[_from]);
439     require(_value <= allowed[_from][msg.sender]);
440 
441     // trading possible when at least one from list [_from, _to] is whitelisted
442     require(transferManagerContract.canTransferFrom(_from, _to));
443 
444     balances[_from] = balances[_from].sub(_value);
445     balances[_to] = balances[_to].add(_value);
446     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
447     emit Transfer(_from, _to, _value);
448     return true;
449   }
450 
451   function setTransferManagerContract(OceanTokenTransferManager _transferManagerContract) onlyOwner public {
452     transferManagerContract = _transferManagerContract;
453   }
454 }