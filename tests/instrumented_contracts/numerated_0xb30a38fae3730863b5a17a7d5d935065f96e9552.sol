1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
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
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     Transfer(address(0), _to, _amount);
281     return true;
282   }
283 
284   /**
285    * @dev Function to stop minting new tokens.
286    * @return True if the operation was successful.
287    */
288   function finishMinting() onlyOwner canMint public returns (bool) {
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 }
294 
295 // TEAM Token is an index token of TokenStars platform
296 // Copyright (c) 2017 TokenStars
297 // Made by Aler Denisov
298 // Permission is hereby granted, free of charge, to any person obtaining a copy
299 // of this software and associated documentation files (the "Software"), to deal
300 // in the Software without restriction, including without limitation the rights
301 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
302 // copies of the Software, and to permit persons to whom the Software is
303 // furnished to do so, subject to the following conditions:
304 
305 // The above copyright notice and this permission notice shall be included in all
306 // copies or substantial portions of the Software.
307 
308 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
309 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
310 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
311 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
312 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
313 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
314 // SOFTWARE.
315 
316 
317 
318 
319 
320 
321 contract StarTokenInterface is MintableToken {
322     // Cheatsheet of inherit methods and events
323     // function transferOwnership(address newOwner);
324     // function allowance(address owner, address spender) constant returns (uint256);
325     // function transfer(address _to, uint256 _value) returns (bool);
326     // function transferFrom(address from, address to, uint256 value) returns (bool);
327     // function approve(address spender, uint256 value) returns (bool);
328     // function increaseApproval (address _spender, uint _addedValue) returns (bool success);
329     // function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
330     // function finishMinting() returns (bool);
331     // function mint(address _to, uint256 _amount) returns (bool);
332     // event Approval(address indexed owner, address indexed spender, uint256 value);
333     // event Mint(address indexed to, uint256 amount);
334     // event MintFinished();
335 
336     // Custom methods and events
337     function openTransfer() public returns (bool);
338     function toggleTransferFor(address _for) public returns (bool);
339     function extraMint() public returns (bool);
340 
341     event TransferAllowed();
342     event TransferAllowanceFor(address indexed who, bool indexed state);
343 
344 
345 }
346 
347 // TEAM Token is an index token of TokenStars platform
348 // Copyright (c) 2017 TokenStars
349 // Made by Aler Denisov
350 // Permission is hereby granted, free of charge, to any person obtaining a copy
351 // of this software and associated documentation files (the "Software"), to deal
352 // in the Software without restriction, including without limitation the rights
353 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
354 // copies of the Software, and to permit persons to whom the Software is
355 // furnished to do so, subject to the following conditions:
356 
357 // The above copyright notice and this permission notice shall be included in all
358 // copies or substantial portions of the Software.
359 
360 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
361 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
362 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
363 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
364 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
365 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
366 // SOFTWARE.
367 
368 
369 
370 
371 
372 
373 
374 contract TeamTokenDistribution is Ownable {
375   using SafeMath for uint256;
376   StarTokenInterface public token;
377 
378   event DistributionMint(address indexed to, uint256 amount);
379   event ExtraMint();
380 
381   function TeamTokenDistribution (address _tokenAddress) public {
382     require(_tokenAddress != 0);
383     token = StarTokenInterface(_tokenAddress);
384   }
385 
386   /**
387   * @dev Minting required amount of tokens in a loop
388   * @param _investors The array of addresses of investors
389   * @param _amounts The array of token amounts corresponding to investors
390   */
391   function bulkMint(address[] _investors, uint256[] _amounts) onlyOwner public returns (bool) {
392     // require(_investors.length < 50);
393     require(_investors.length == _amounts.length);
394 
395     for (uint index = 0; index < _investors.length; index++) {
396       assert(token.mint(_investors[index], _amounts[index]));
397       DistributionMint(_investors[index], _amounts[index]);
398     }
399   }
400 
401   /**
402   * @dev Minting extra (team and community) tokens
403   */
404   function extraMint() onlyOwner public returns (bool) {
405     assert(token.extraMint());
406     ExtraMint();
407   }
408 
409   /**
410   * @dev Return ownership to previous owner
411   */
412   function returnOwnership() onlyOwner public returns (bool) {
413     token.transferOwnership(owner);
414   }
415 }