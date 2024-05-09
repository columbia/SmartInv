1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
7  * Copyright (c) 2016 Smart Contract Solutions, Inc.
8  * Permission is hereby granted, free of charge, to any person obtaining
9  * a copy of this software and associated documentation files (the
10  * "Software"), to deal in the Software without restriction, including
11  * without limitation the rights to use, copy, modify, merge, publish,
12  * distribute, sublicense, and/or sell copies of the Software, and to
13  * permit persons to whom the Software is furnished to do so, subject to
14  * the following conditions:
15  *
16  * The above copyright notice and this permission notice shall be included
17  * in all copies or substantial portions of the Software.
18 
19  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
20  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
21  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
22  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
23  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
24  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
25  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, reverts on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     uint256 c = a * b;
41     require(c / a == b);
42 
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     require(b > 0); // Solidity only automatically asserts when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54     return c;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b <= a);
62     uint256 c = a - b;
63 
64     return c;
65   }
66 
67   /**
68   * @dev Adds two numbers, reverts on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     require(c >= a);
73 
74     return c;
75   }
76 
77   /**
78   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
79   * reverts when dividing by zero.
80   */
81   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b != 0);
83     return a % b;
84   }
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
91  * Copyright (c) 2016 Smart Contract Solutions, Inc.
92  * Permission is hereby granted, free of charge, to any person obtaining
93  * a copy of this software and associated documentation files (the
94  * "Software"), to deal in the Software without restriction, including
95  * without limitation the rights to use, copy, modify, merge, publish,
96  * distribute, sublicense, and/or sell copies of the Software, and to
97  * permit persons to whom the Software is furnished to do so, subject to
98  * the following conditions:
99  *
100  * The above copyright notice and this permission notice shall be included
101  * in all copies or substantial portions of the Software.
102 
103  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
104  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
105  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
106  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
107  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
108  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
109  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
110  */
111 interface IERC20 {
112   function totalSupply() external view returns (uint256);
113 
114   function balanceOf(address who) external view returns (uint256);
115 
116   function allowance(address owner, address spender)
117     external view returns (uint256);
118 
119   function transfer(address to, uint256 value) external returns (bool);
120 
121   function approve(address spender, uint256 value)
122     external returns (bool);
123 
124   function transferFrom(address from, address to, uint256 value)
125     external returns (bool);
126 
127   event Transfer(
128     address indexed from,
129     address indexed to,
130     uint256 value
131   );
132 
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
146  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
148  * Copyright (c) 2016 Smart Contract Solutions, Inc.
149  * Permission is hereby granted, free of charge, to any person obtaining
150  * a copy of this software and associated documentation files (the
151  * "Software"), to deal in the Software without restriction, including
152  * without limitation the rights to use, copy, modify, merge, publish,
153  * distribute, sublicense, and/or sell copies of the Software, and to
154  * permit persons to whom the Software is furnished to do so, subject to
155  * the following conditions:
156  *
157  * The above copyright notice and this permission notice shall be included
158  * in all copies or substantial portions of the Software.
159 
160  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
161  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
162  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
163  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
164  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
165  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
166  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
167  */
168 contract ERC20 is IERC20 {
169   using SafeMath for uint256;
170 
171   mapping (address => uint256) private _balances;
172 
173   mapping (address => mapping (address => uint256)) private _allowed;
174 
175   uint256 private _totalSupply;
176 
177   /**
178   * @dev Total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return _totalSupply;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address owner) public view returns (uint256) {
190     return _balances[owner];
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param owner address The address which owns the funds.
196    * @param spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address owner,
201     address spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return _allowed[owner][spender];
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param to The address to transfer to.
213   * @param value The amount to be transferred.
214   */
215   function transfer(address to, uint256 value) public returns (bool) {
216     _transfer(msg.sender, to, value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param spender The address which will spend the funds.
227    * @param value The amount of tokens to be spent.
228    */
229   function approve(address spender, uint256 value) public returns (bool) {
230     require(spender != address(0));
231 
232     _allowed[msg.sender][spender] = value;
233     emit Approval(msg.sender, spender, value);
234     return true;
235   }
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param from address The address which you want to send tokens from
240    * @param to address The address which you want to transfer to
241    * @param value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom(
244     address from,
245     address to,
246     uint256 value
247   )
248     public
249     returns (bool)
250   {
251     require(value <= _allowed[from][msg.sender]);
252 
253     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
254     _transfer(from, to, value);
255     return true;
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    * approve should be called when allowed_[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param spender The address which will spend the funds.
265    * @param addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseAllowance(
268     address spender,
269     uint256 addedValue
270   )
271     public
272     returns (bool)
273   {
274     require(spender != address(0));
275 
276     _allowed[msg.sender][spender] = (
277       _allowed[msg.sender][spender].add(addedValue));
278     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed_[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param spender The address which will spend the funds.
289    * @param subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseAllowance(
292     address spender,
293     uint256 subtractedValue
294   )
295     public
296     returns (bool)
297   {
298     require(spender != address(0));
299 
300     _allowed[msg.sender][spender] = (
301       _allowed[msg.sender][spender].sub(subtractedValue));
302     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
303     return true;
304   }
305 
306   /**
307   * @dev Transfer token for a specified addresses
308   * @param from The address to transfer from.
309   * @param to The address to transfer to.
310   * @param value The amount to be transferred.
311   */
312   function _transfer(address from, address to, uint256 value) internal {
313     require(value <= _balances[from]);
314     require(to != address(0));
315 
316     _balances[from] = _balances[from].sub(value);
317     _balances[to] = _balances[to].add(value);
318     emit Transfer(from, to, value);
319   }
320 
321   /**
322    * @dev Internal function that mints an amount of the token and assigns it to
323    * an account. This encapsulates the modification of balances such that the
324    * proper events are emitted.
325    * @param account The account that will receive the created tokens.
326    * @param amount The amount that will be created.
327    */
328   function _mint(address account, uint256 amount) internal {
329     require(account != 0);
330     _totalSupply = _totalSupply.add(amount);
331     _balances[account] = _balances[account].add(amount);
332     emit Transfer(address(0), account, amount);
333   }
334 
335   /**
336    * @dev Internal function that burns an amount of the token of a given
337    * account.
338    * @param account The account whose tokens will be burnt.
339    * @param amount The amount that will be burnt.
340    */
341   function _burn(address account, uint256 amount) internal {
342     require(account != 0);
343     require(amount <= _balances[account]);
344 
345     _totalSupply = _totalSupply.sub(amount);
346     _balances[account] = _balances[account].sub(amount);
347     emit Transfer(account, address(0), amount);
348   }
349 
350   /**
351    * @dev Internal function that burns an amount of the token of a given
352    * account, deducting from the sender's allowance for said account. Uses the
353    * internal burn function.
354    * @param account The account whose tokens will be burnt.
355    * @param amount The amount that will be burnt.
356    */
357   function _burnFrom(address account, uint256 amount) internal {
358     require(amount <= _allowed[account][msg.sender]);
359 
360     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
361     // this function needs to emit an event with the updated approval.
362     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
363       amount);
364     _burn(account, amount);
365   }
366 }
367 
368 
369 /**
370  * @title ERC20Detailed token
371  * @dev The decimals are only for visualization purposes.
372  * All the operations are done using the smallest and indivisible token unit,
373  * just as on Ethereum all the operations are done in wei.
374  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
375  * Copyright (c) 2016 Smart Contract Solutions, Inc.
376  * Permission is hereby granted, free of charge, to any person obtaining
377  * a copy of this software and associated documentation files (the
378  * "Software"), to deal in the Software without restriction, including
379  * without limitation the rights to use, copy, modify, merge, publish,
380  * distribute, sublicense, and/or sell copies of the Software, and to
381  * permit persons to whom the Software is furnished to do so, subject to
382  * the following conditions:
383  *
384  * The above copyright notice and this permission notice shall be included
385  * in all copies or substantial portions of the Software.
386 
387  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
388  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
389  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
390  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
391  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
392  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
393  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
394  */
395 contract ERC20Detailed is IERC20 {
396   string private _name;
397   string private _symbol;
398   uint8 private _decimals;
399 
400   constructor(string name, string symbol, uint8 decimals) public {
401     _name = name;
402     _symbol = symbol;
403     _decimals = decimals;
404   }
405 
406   /**
407    * @return the name of the token.
408    */
409   function name() public view returns(string) {
410     return _name;
411   }
412 
413   /**
414    * @return the symbol of the token.
415    */
416   function symbol() public view returns(string) {
417     return _symbol;
418   }
419 
420   /**
421    * @return the number of decimals of the token.
422    */
423   function decimals() public view returns(uint8) {
424     return _decimals;
425   }
426 }
427 
428 /**
429  * @title Liquidity.Network Fungible Token Contract
430  * Built on OpenZeppelin-Solidity Contracts https://github.com/OpenZeppelin/openzeppelin-solidity
431  */
432 contract LQD is ERC20, ERC20Detailed {
433   constructor()
434   ERC20Detailed("Liquidity.Network Token", "LQD", 18)
435   public {
436     _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
437   }
438 }