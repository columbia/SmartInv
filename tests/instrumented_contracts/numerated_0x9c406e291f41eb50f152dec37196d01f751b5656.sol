1 /**
2  *
3  * MIT License
4  *
5  * Copyright (c) 2018, TOPEX Developers & OpenZeppelin Project.
6  *
7  * Permission is hereby granted, free of charge, to any person obtaining a copy
8  * of this software and associated documentation files (the "Software"), to deal
9  * in the Software without restriction, including without limitation the rights
10  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11  * copies of the Software, and to permit persons to whom the Software is
12  * furnished to do so, subject to the following conditions:
13  *
14  * The above copyright notice and this permission notice shall be included in all
15  * copies or substantial portions of the Software.
16  *
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23  * SOFTWARE.
24  *
25  */
26 
27 pragma solidity ^0.4.24;
28 
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 library SafeERC20 {
59   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
60     assert(token.transfer(to, value));
61   }
62 
63   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
64     assert(token.transferFrom(from, to, value));
65   }
66 
67   function safeApprove(ERC20 token, address spender, uint256 value) internal {
68     assert(token.approve(spender, value));
69   }
70 }
71 
72 contract Ownable {
73   address public owner;
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     emit OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 }
104 
105 contract Destructible is Ownable {
106 
107   constructor() public payable { }
108 
109   /**
110    * @dev Transfers the current balance to the owner and terminates the contract.
111    */
112   function destroy() onlyOwner public {
113     selfdestruct(owner);
114   }
115 
116   function destroyAndSend(address _recipient) onlyOwner public {
117     selfdestruct(_recipient);
118   }
119 }
120 
121 contract ERC20Basic {
122   uint256 public totalSupply;
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256 balance) {
162     return balances[_owner];
163   }
164 }
165 
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 }
251 
252 contract MintableToken is StandardToken, Ownable {
253   event Mint(address indexed to, uint256 amount);
254   event MintFinished();
255 
256   bool public mintingFinished = false;
257 
258   modifier canMint() {
259     require(!mintingFinished);
260     _;
261   }
262 
263   /**
264    * @dev Function to mint tokens
265    * @param _to The address that will receive the minted tokens.
266    * @param _amount The amount of tokens to mint.
267    * @return A boolean that indicates if the operation was successful.
268    */
269   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
270     totalSupply = totalSupply.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     emit Mint(_to, _amount);
273     emit Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     emit MintFinished();
284     return true;
285   }
286 }
287 
288 contract TPXToken is MintableToken, Destructible {
289 
290   string  public name = 'TOPEX Token';
291   string  public symbol = 'TPX';
292   uint8   public decimals = 18;
293   uint256 public maxSupply = 200000000 ether;    // max allowable minting.
294   bool    public transferDisabled = true;         // disable transfer init.
295 
296   event Confiscate(address indexed offender, uint256 value);
297 
298   // empty constructor
299   constructor() public {}
300 
301   /*
302    * the real reason for quarantined addresses are for those who are
303    * mistakenly sent the TPX tokens to the wrong address. We can disable
304    * the usage of the TPX tokens here.
305    */
306   mapping(address => bool) quarantined;           // quarantined addresses
307   mapping(address => bool) gratuity;              // locked addresses for owners
308 
309   modifier canTransfer() {
310     if (msg.sender == owner) {
311       _;
312     } else {
313       require(!transferDisabled);
314       require(quarantined[msg.sender] == false);  // default bool is false
315       require(gratuity[msg.sender] == false);     // default bool is false
316       _;
317     }
318   }
319 
320   /*
321    * Allow the transfer of tokens to happen once ICO finished
322    */
323   function allowTransfers() onlyOwner public returns (bool) {
324     transferDisabled = false;
325     return true;
326   }
327 
328   function disallowTransfers() onlyOwner public returns (bool) {
329     transferDisabled = true;
330     return true;
331   }
332 
333   function quarantineAddress(address _addr) onlyOwner public returns (bool) {
334     quarantined[_addr] = true;
335     return true;
336   }
337 
338   function unQuarantineAddress(address _addr) onlyOwner public returns (bool) {
339     quarantined[_addr] = false;
340     return true;
341   }
342 
343   function lockAddress(address _addr) onlyOwner public returns (bool) {
344     gratuity[_addr] = true;
345     return true;
346   }
347 
348   function unlockAddress(address _addr) onlyOwner public returns (bool) {
349     gratuity[_addr] = false;
350     return true;
351   }
352 
353   /**
354    * This is confiscate the money that is sent to the wrong address accidentally.
355    * the confiscated value can then be transferred to the righful owner. This is
356    * especially important during ICO where some are *still* using Exchanger wallet
357    * address, instead of their personal address.
358    */
359   function confiscate(address _offender) onlyOwner public returns (bool) {
360     uint256 all = balances[_offender];
361     require(all > 0);
362     
363     balances[_offender] = balances[_offender].sub(all);
364     balances[msg.sender] = balances[msg.sender].add(all);
365     emit Confiscate(_offender, all);
366     return true;
367   }
368 
369   /*
370    * @dev Function to mint tokens
371    * @param _to The address that will receive the minted tokens.
372    * @param _amount The amount of tokens to mint.
373    * @return A boolean that indicates if the operation was successful.
374    */
375   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
376     require(totalSupply <= maxSupply);
377     return super.mint(_to, _amount);
378   }
379 
380   /**
381   * @dev transfer token for a specified address
382   * @param _to The address to transfer to.
383   * @param _value The amount to be transferred.
384   */
385   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
386     return super.transfer(_to, _value);
387   }
388 
389   /**
390    * @dev Transfer tokens from one address to another
391    * @param _from address The address which you want to send tokens from
392    * @param _to address The address which you want to transfer to
393    * @param _value uint256 the amount of tokens to be transferred
394    */
395   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
396     return super.transferFrom(_from, _to, _value);
397   }
398 
399   /**
400    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
401    *
402    * Beware that changing an allowance with this method brings the risk that someone may use both the old
403    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
404    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
405    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
406    * @param _spender The address which will spend the funds.
407    * @param _value The amount of tokens to be spent.
408    */
409   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
410     return super.approve(_spender, _value);
411   }
412   
413    /**
414   * @dev transfer Bounty tokens for a specified addresses
415   * @param _toRecipients The addresses to transfer to.
416   * @param _toValues The amounts to be transferred.
417   */
418   
419   function transferBountyTokens(address[] _toRecipients, uint256[] _toValues) onlyOwner canTransfer public returns (bool) {
420     
421     /* Ensures _toRecipients array length is equal to _toValues array length */
422     assert(_toRecipients.length == _toValues.length);
423     for (uint i = 0; i < _toRecipients.length; i++) 
424         transfer(_toRecipients[i], _toValues[i]);  
425     }
426 }