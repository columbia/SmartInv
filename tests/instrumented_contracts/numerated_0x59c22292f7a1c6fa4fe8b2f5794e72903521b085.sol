1 /**
2  *
3  * MIT License
4  *
5  * Copyright (c) 2018, MEXC Program Developers & OpenZeppelin Project.
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
26 pragma solidity ^0.4.17;
27 
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 library SafeERC20 {
58   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
59     assert(token.transfer(to, value));
60   }
61 
62   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
63     assert(token.transferFrom(from, to, value));
64   }
65 
66   function safeApprove(ERC20 token, address spender, uint256 value) internal {
67     assert(token.approve(spender, value));
68   }
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 }
106 
107 contract Destructible is Ownable {
108 
109   function Destructible() public payable { }
110 
111   /**
112    * @dev Transfers the current balance to the owner and terminates the contract.
113    */
114   function destroy() onlyOwner public {
115     selfdestruct(owner);
116   }
117 
118   function destroyAndSend(address _recipient) onlyOwner public {
119     selfdestruct(_recipient);
120   }
121 }
122 
123 contract ERC20Basic {
124   uint256 public totalSupply;
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     // SafeMath.sub will throw if there is not enough balance.
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256 balance) {
164     return balances[_owner];
165   }
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 }
254 
255 contract MintableToken is StandardToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261 
262   modifier canMint() {
263     require(!mintingFinished);
264     _;
265   }
266 
267   /**
268    * @dev Function to mint tokens
269    * @param _to The address that will receive the minted tokens.
270    * @param _amount The amount of tokens to mint.
271    * @return A boolean that indicates if the operation was successful.
272    */
273   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
274     totalSupply = totalSupply.add(_amount);
275     balances[_to] = balances[_to].add(_amount);
276     Mint(_to, _amount);
277     Transfer(address(0), _to, _amount);
278     return true;
279   }
280 
281   /**
282    * @dev Function to stop minting new tokens.
283    * @return True if the operation was successful.
284    */
285   function finishMinting() onlyOwner canMint public returns (bool) {
286     mintingFinished = true;
287     MintFinished();
288     return true;
289   }
290 }
291 
292 contract MEXCToken is MintableToken, Destructible  {
293 
294   string  public name = 'MEX Care Token';
295   string  public symbol = 'MEXC';
296   uint8   public decimals = 18;
297   uint256 public maxSupply = 1714285714 ether;    // max allowable minting.
298   bool    public transferDisabled = true;         // disable transfer init.
299 
300   event Confiscate(address indexed offender, uint256 value);
301 
302   // empty constructor
303   function MEXCToken() public {}
304 
305   /*
306    * the real reason for quarantined addresses are for those who are
307    * mistakenly sent the MEXC tokens to the wrong address. We can disable
308    * the usage of the MEXC tokens here.
309    */
310   mapping(address => bool) quarantined;           // quarantined addresses
311   mapping(address => bool) gratuity;              // locked addresses for owners
312 
313   modifier canTransfer() {
314     if (msg.sender == owner) {
315       _;
316     } else {
317       require(!transferDisabled);
318       require(quarantined[msg.sender] == false);  // default bool is false
319       require(gratuity[msg.sender] == false);     // default bool is false
320       _;
321     }
322   }
323 
324   /*
325    * Allow the transfer of token to happen once listed on exchangers
326    */
327   function allowTransfers() onlyOwner public returns (bool) {
328     transferDisabled = false;
329     return true;
330   }
331 
332   function disallowTransfers() onlyOwner public returns (bool) {
333     transferDisabled = true;
334     return true;
335   }
336 
337   function quarantineAddress(address _addr) onlyOwner public returns (bool) {
338     quarantined[_addr] = true;
339     return true;
340   }
341 
342   function unQuarantineAddress(address _addr) onlyOwner public returns (bool) {
343     quarantined[_addr] = false;
344     return true;
345   }
346 
347   function lockAddress(address _addr) onlyOwner public returns (bool) {
348     gratuity[_addr] = true;
349     return true;
350   }
351 
352   function unlockAddress(address _addr) onlyOwner public returns (bool) {
353     gratuity[_addr] = false;
354     return true;
355   }
356 
357   /**
358    * This is confiscate the money that is sent to the wrong address accidentally.
359    * the confiscated value can then be transferred to the righful owner. This is
360    * especially important during ICO where some are *still* using Exchanger wallet
361    * address, instead of their personal address.
362    */
363   function confiscate(address _offender) onlyOwner public returns (bool) {
364     uint256 all = balances[_offender];
365     require(all > 0);
366     
367     balances[_offender] = balances[_offender].sub(all);
368     balances[msg.sender] = balances[msg.sender].add(all);
369     Confiscate(_offender, all);
370     return true;
371   }
372 
373   /*
374    * @dev Function to mint tokens
375    * @param _to The address that will receive the minted tokens.
376    * @param _amount The amount of tokens to mint.
377    * @return A boolean that indicates if the operation was successful.
378    */
379   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
380     require(totalSupply <= maxSupply);
381     return super.mint(_to, _amount);
382   }
383 
384   /**
385   * @dev transfer token for a specified address
386   * @param _to The address to transfer to.
387   * @param _value The amount to be transferred.
388   */
389   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
390     return super.transfer(_to, _value);
391   }
392 
393   /**
394    * @dev Transfer tokens from one address to another
395    * @param _from address The address which you want to send tokens from
396    * @param _to address The address which you want to transfer to
397    * @param _value uint256 the amount of tokens to be transferred
398    */
399   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
400     return super.transferFrom(_from, _to, _value);
401   }
402 
403   /**
404    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
405    *
406    * Beware that changing an allowance with this method brings the risk that someone may use both the old
407    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
408    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
409    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
410    * @param _spender The address which will spend the funds.
411    * @param _value The amount of tokens to be spent.
412    */
413   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
414     return super.approve(_spender, _value);
415   }
416 }