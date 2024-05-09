1 /**************************************************************************
2  *            ____        _                              
3  *           / ___|      | |     __ _  _   _   ___  _ __ 
4  *          | |    _____ | |    / _` || | | | / _ \| '__|
5  *          | |___|_____|| |___| (_| || |_| ||  __/| |   
6  *           \____|      |_____|\__,_| \__, | \___||_|   
7  *                                     |___/             
8  * 
9  **************************************************************************
10  *
11  *  The MIT License (MIT)
12  * SPDX-License-Identifier: MIT
13  *
14  * Copyright (c) 2016-2020 Cyril Lapinte
15  *
16  * Permission is hereby granted, free of charge, to any person obtaining
17  * a copy of this software and associated documentation files (the
18  * "Software"), to deal in the Software without restriction, including
19  * without limitation the rights to use, copy, modify, merge, publish,
20  * distribute, sublicense, and/or sell copies of the Software, and to
21  * permit persons to whom the Software is furnished to do so, subject to
22  * the following conditions:
23  *
24  * The above copyright notice and this permission notice shall be included
25  * in all copies or substantial portions of the Software.
26  *
27  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
28  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
29  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
30  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
31  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
32  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
33  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
34  *
35  **************************************************************************
36  *
37  * Flatten Contract: WrappedERC20
38  *
39  * Git Commit:
40  * https://github.com/c-layer/contracts/commit/9993912325afde36151b04d0247ac9ea9ffa2a93
41  *
42  **************************************************************************/
43 
44 
45 // File: @c-layer/common/contracts/interface/IERC20.sol
46 
47 pragma solidity ^0.6.0;
48 
49 
50 /**
51  * @title IERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  *
55  */
56 interface IERC20 {
57 
58   event Transfer(address indexed from, address indexed to, uint256 value);
59   event Approval(
60     address indexed owner,
61     address indexed spender,
62     uint256 value
63   );
64 
65   function name() external view returns (string memory);
66   function symbol() external view returns (string memory);
67   function decimals() external view returns (uint256);
68   function totalSupply() external view returns (uint256);
69   function balanceOf(address _owner) external view returns (uint256);
70 
71   function transfer(address _to, uint256 _value) external returns (bool);
72 
73   function allowance(address _owner, address _spender)
74     external view returns (uint256);
75 
76   function transferFrom(address _from, address _to, uint256 _value)
77     external returns (bool);
78 
79   function approve(address _spender, uint256 _value) external returns (bool);
80 
81   function increaseApproval(address _spender, uint256 _addedValue)
82     external returns (bool);
83 
84   function decreaseApproval(address _spender, uint256 _subtractedValue)
85     external returns (bool);
86 }
87 
88 // File: @c-layer/common/contracts/math/SafeMath.sol
89 
90 pragma solidity ^0.6.0;
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 // File: @c-layer/common/contracts/token/TokenERC20.sol
144 
145 pragma solidity ^0.6.0;
146 
147 
148 
149 
150 /**
151  * @title Token ERC20
152  * @dev Token ERC20 default implementation
153  *
154  * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
155  *
156  * Error messages
157  *   TE01: Address is invalid
158  *   TE02: Not enougth tokens
159  *   TE03: Approval too low
160  */
161 contract TokenERC20 is IERC20 {
162   using SafeMath for uint256;
163 
164   string internal name_;
165   string internal symbol_;
166   uint256 internal decimals_;
167 
168   uint256 internal totalSupply_;
169   mapping(address => uint256) internal balances;
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172   constructor(
173     string memory _name,
174     string memory _symbol,
175     uint256 _decimals,
176     address _initialAccount,
177     uint256 _initialSupply
178   ) public {
179     name_ = _name;
180     symbol_ = _symbol;
181     decimals_ = _decimals;
182     totalSupply_ = _initialSupply;
183     balances[_initialAccount] = _initialSupply;
184 
185     emit Transfer(address(0), _initialAccount, _initialSupply);
186   }
187 
188   function name() external override view returns (string memory) {
189     return name_;
190   }
191 
192   function symbol() external override view returns (string memory) {
193     return symbol_;
194   }
195 
196   function decimals() external override view returns (uint256) {
197     return decimals_;
198   }
199 
200   function totalSupply() external override view returns (uint256) {
201     return totalSupply_;
202   }
203 
204   function balanceOf(address _owner) external override view returns (uint256) {
205     return balances[_owner];
206   }
207 
208   function allowance(address _owner, address _spender)
209     external override view returns (uint256)
210   {
211     return allowed[_owner][_spender];
212   }
213 
214   function transfer(address _to, uint256 _value) external override returns (bool) {
215     require(_to != address(0), "TE01");
216     require(_value <= balances[msg.sender], "TE02");
217 
218     balances[msg.sender] = balances[msg.sender].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     emit Transfer(msg.sender, _to, _value);
221     return true;
222   }
223 
224   function transferFrom(address _from, address _to, uint256 _value)
225     external override returns (bool)
226   {
227     require(_to != address(0), "TE01");
228     require(_value <= balances[_from], "TE02");
229     require(_value <= allowed[_from][msg.sender], "TE03");
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   function approve(address _spender, uint256 _value) external override returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   function increaseApproval(address _spender, uint _addedValue)
245     external override returns (bool)
246   {
247     allowed[msg.sender][_spender] = (
248       allowed[msg.sender][_spender].add(_addedValue));
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval(address _spender, uint _subtractedValue)
254     external override returns (bool)
255   {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 }
266 
267 // File: contracts/interface/IWrappedERC20.sol
268 
269 pragma solidity ^0.6.0;
270 
271 
272 
273 /**
274  * @title WrappedERC20
275  * @dev WrappedERC20
276  * @author Cyril Lapinte - <cyril@openfiz.com>
277  *
278  * Error messages
279  */
280 abstract contract IWrappedERC20 is IERC20 {
281 
282   function base() public view virtual returns (IERC20);
283 
284   function deposit(uint256 _value) public virtual returns (bool);
285   function depositTo(address _to, uint256 _value) public virtual returns (bool);
286 
287   function withdraw(uint256 _value) public virtual returns (bool);
288   function withdrawFrom(address _from, address _to, uint256 _value) public virtual returns (bool);
289 
290   event Deposit(address indexed _address, uint256 value);
291   event Withdrawal(address indexed _address, uint256 value);
292 }
293 
294 // File: contracts/WrappedERC20.sol
295 
296 pragma solidity ^0.6.0;
297 
298 
299 
300 
301 /**
302  * @title WrappedERC20
303  * @dev WrappedERC20
304  * @author Cyril Lapinte - <cyril@openfiz.com>
305  *
306  * Error messages
307  *   WE01: Unable to transfer tokens to address 0
308  *   WE02: Unable to deposit the base token
309  *   WE03: Not enougth tokens
310  *   WE04: Approval too low
311  *   WE05: Unable to withdraw the base token
312  */
313 contract WrappedERC20 is TokenERC20, IWrappedERC20 {
314 
315   IERC20 internal base_;
316   uint256 internal ratio_;
317 
318   /**
319    * @dev constructor
320    */
321   constructor(
322     string memory _name,
323     string memory _symbol,
324     uint256 _decimals,
325     IERC20 _base
326   ) public
327     TokenERC20(_name, _symbol, _decimals, address(0), 0)
328   {
329     ratio_ = 10 ** _decimals.sub(_base.decimals());
330     base_ = _base;
331   }
332 
333   /**
334    * @dev base token
335    */
336   function base() public view override returns (IERC20) {
337     return base_;
338   }
339 
340   /**
341    * @dev deposit
342    */
343   function deposit(uint256 _value) public override returns (bool) {
344     return depositTo(msg.sender, _value);
345   }
346 
347   /**
348    * @dev depositTo
349    */
350   function depositTo(address _to, uint256 _value) public override returns (bool) {
351     require(_to != address(0), "WE01");
352     require(base_.transferFrom(msg.sender, address(this), _value), "WE02");
353 
354     uint256 wrappedValue = _value.mul(ratio_);
355     balances[_to] = balances[_to].add(wrappedValue);
356     totalSupply_ = totalSupply_.add(wrappedValue);
357     emit Transfer(address(0), _to, wrappedValue);
358     return true;
359   }
360 
361   /**
362    * @dev withdraw
363    */
364   function withdraw(uint256 _value) public override returns (bool) {
365     return withdrawFrom(msg.sender, msg.sender, _value);
366   }
367 
368   /**
369    * @dev withdrawFrom
370    */
371   function withdrawFrom(address _from, address _to, uint256 _value) public override returns (bool) {
372     require(_to != address(0), "WE01");
373     uint256 wrappedValue = _value.mul(ratio_);
374     require(wrappedValue <= balances[_from], "WE03");
375 
376     if (_from != msg.sender) {
377       require(wrappedValue <= allowed[_from][msg.sender], "WE04");
378       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(wrappedValue);
379     }
380 
381     balances[_from] = balances[_from].sub(wrappedValue);
382     totalSupply_ = totalSupply_.sub(wrappedValue);
383     emit Transfer(_from, address(0), wrappedValue);
384 
385     require(base_.transfer(_to, _value), "WE05");
386     return true;
387   }
388 }