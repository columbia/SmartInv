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
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
145  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
147  * Copyright (c) 2016 Smart Contract Solutions, Inc.
148  * Permission is hereby granted, free of charge, to any person obtaining
149  * a copy of this software and associated documentation files (the
150  * "Software"), to deal in the Software without restriction, including
151  * without limitation the rights to use, copy, modify, merge, publish,
152  * distribute, sublicense, and/or sell copies of the Software, and to
153  * permit persons to whom the Software is furnished to do so, subject to
154  * the following conditions:
155  *
156  * The above copyright notice and this permission notice shall be included
157  * in all copies or substantial portions of the Software.
158 
159  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
160  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
161  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
162  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
163  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
164  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
165  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
166  */
167 contract ERC20 is IERC20 {
168   using SafeMath for uint256;
169 
170   mapping (address => uint256) private _balances;
171 
172   mapping (address => mapping (address => uint256)) private _allowed;
173 
174   uint256 private _totalSupply;
175 
176   /**
177   * @dev Total number of tokens in existence
178   */
179   function totalSupply() public view returns (uint256) {
180     return _totalSupply;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address owner) public view returns (uint256) {
189     return _balances[owner];
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param owner address The address which owns the funds.
195    * @param spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(
199     address owner,
200     address spender
201    )
202     public
203     view
204     returns (uint256)
205   {
206     return _allowed[owner][spender];
207   }
208 
209   /**
210   * @dev Transfer token for a specified address
211   * @param to The address to transfer to.
212   * @param value The amount to be transferred.
213   */
214   function transfer(address to, uint256 value) public returns (bool) {
215     _transfer(msg.sender, to, value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param spender The address which will spend the funds.
226    * @param value The amount of tokens to be spent.
227    */
228   function approve(address spender, uint256 value) public returns (bool) {
229     require(spender != address(0));
230 
231     _allowed[msg.sender][spender] = value;
232     emit Approval(msg.sender, spender, value);
233     return true;
234   }
235 
236   /**
237    * @dev Transfer tokens from one address to another
238    * @param from address The address which you want to send tokens from
239    * @param to address The address which you want to transfer to
240    * @param value uint256 the amount of tokens to be transferred
241    */
242   function transferFrom(
243     address from,
244     address to,
245     uint256 value
246   )
247     public
248     returns (bool)
249   {
250     require(value <= _allowed[from][msg.sender]);
251 
252     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
253     _transfer(from, to, value);
254     return true;
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed_[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param spender The address which will spend the funds.
264    * @param addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseAllowance(
267     address spender,
268     uint256 addedValue
269   )
270     public
271     returns (bool)
272   {
273     require(spender != address(0));
274 
275     _allowed[msg.sender][spender] = (
276       _allowed[msg.sender][spender].add(addedValue));
277     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed_[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param spender The address which will spend the funds.
288    * @param subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseAllowance(
291     address spender,
292     uint256 subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     require(spender != address(0));
298 
299     _allowed[msg.sender][spender] = (
300       _allowed[msg.sender][spender].sub(subtractedValue));
301     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302     return true;
303   }
304 
305   /**
306   * @dev Transfer token for a specified addresses
307   * @param from The address to transfer from.
308   * @param to The address to transfer to.
309   * @param value The amount to be transferred.
310   */
311   function _transfer(address from, address to, uint256 value) internal {
312     require(value <= _balances[from]);
313     require(to != address(0));
314 
315     _balances[from] = _balances[from].sub(value);
316     _balances[to] = _balances[to].add(value);
317     emit Transfer(from, to, value);
318   }
319 
320   /**
321    * @dev Internal function that mints an amount of the token and assigns it to
322    * an account. This encapsulates the modification of balances such that the
323    * proper events are emitted.
324    * @param account The account that will receive the created tokens.
325    * @param amount The amount that will be created.
326    */
327   function _mint(address account, uint256 amount) internal {
328     require(account != 0);
329     _totalSupply = _totalSupply.add(amount);
330     _balances[account] = _balances[account].add(amount);
331     emit Transfer(address(0), account, amount);
332   }
333 
334   /**
335    * @dev Internal function that burns an amount of the token of a given
336    * account.
337    * @param account The account whose tokens will be burnt.
338    * @param amount The amount that will be burnt.
339    */
340   function _burn(address account, uint256 amount) internal {
341     require(account != 0);
342     require(amount <= _balances[account]);
343 
344     _totalSupply = _totalSupply.sub(amount);
345     _balances[account] = _balances[account].sub(amount);
346     emit Transfer(account, address(0), amount);
347   }
348 
349   /**
350    * @dev Internal function that burns an amount of the token of a given
351    * account, deducting from the sender's allowance for said account. Uses the
352    * internal burn function.
353    * @param account The account whose tokens will be burnt.
354    * @param amount The amount that will be burnt.
355    */
356   function _burnFrom(address account, uint256 amount) internal {
357     require(amount <= _allowed[account][msg.sender]);
358 
359     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
360     // this function needs to emit an event with the updated approval.
361     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
362       amount);
363     _burn(account, amount);
364   }
365 }
366 
367 /**
368  * @title SafeERC20
369  * @dev Wrappers around ERC20 operations that throw on failure.
370  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
371  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
372  * Source: https://github.com/OpenZeppelin/openzeppelin-solidity
373  * Copyright (c) 2016 Smart Contract Solutions, Inc.
374  * Permission is hereby granted, free of charge, to any person obtaining
375  * a copy of this software and associated documentation files (the
376  * "Software"), to deal in the Software without restriction, including
377  * without limitation the rights to use, copy, modify, merge, publish,
378  * distribute, sublicense, and/or sell copies of the Software, and to
379  * permit persons to whom the Software is furnished to do so, subject to
380  * the following conditions:
381  *
382  * The above copyright notice and this permission notice shall be included
383  * in all copies or substantial portions of the Software.
384 
385  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
386  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
387  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
388  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
389  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
390  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
391  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
392  */
393 library SafeERC20 {
394   function safeTransfer(
395     IERC20 token,
396     address to,
397     uint256 value
398   )
399     internal
400   {
401     require(token.transfer(to, value));
402   }
403 
404   function safeTransferFrom(
405     IERC20 token,
406     address from,
407     address to,
408     uint256 value
409   )
410     internal
411   {
412     require(token.transferFrom(from, to, value));
413   }
414 
415   function safeApprove(
416     IERC20 token,
417     address spender,
418     uint256 value
419   )
420     internal
421   {
422     require(token.approve(spender, value));
423   }
424 }
425 
426 contract Distributor {
427   using SafeERC20 for ERC20;
428 
429   function distribute(ERC20 token, address[] recipients, uint256[] amounts) public {
430     assert(recipients.length == amounts.length);
431 
432     for (uint8 i = 0; i < recipients.length; i++) {
433       token.safeTransferFrom(msg.sender, recipients[i], amounts[i]);
434     }
435   }
436 }