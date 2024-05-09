1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: contracts/token/ERC20/Storage.sol
146 
147 /**
148  * MIT License
149  *
150  * Copyright (c) 2019 eToroX Labs
151  *
152  * Permission is hereby granted, free of charge, to any person obtaining a copy
153  * of this software and associated documentation files (the "Software"), to deal
154  * in the Software without restriction, including without limitation the rights
155  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
156  * copies of the Software, and to permit persons to whom the Software is
157  * furnished to do so, subject to the following conditions:
158  *
159  * The above copyright notice and this permission notice shall be included in all
160  * copies or substantial portions of the Software.
161  *
162  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
163  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
164  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
165  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
166  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
167  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
168  * SOFTWARE.
169  */
170 
171 pragma solidity 0.4.24;
172 
173 
174 
175 /**
176  * @title External ERC20 Storage
177  *
178  * @dev The storage contract used in ExternalERC20 token. This contract can
179  * provide storage for exactly one contract, referred to as the implementor,
180  * inheriting from the ExternalERC20 contract. Only the current implementor or
181  * the owner can transfer the implementorship. Change of state is only allowed
182  * by the implementor.
183  */
184 contract Storage is Ownable {
185     using SafeMath for uint256;
186 
187     mapping (address => uint256) private balances;
188     mapping (address => mapping (address => uint256)) private allowed;
189     uint256 private totalSupply;
190 
191     address private _implementor;
192 
193     event StorageImplementorTransferred(address indexed from,
194                                         address indexed to);
195 
196     /**
197      * @dev Contructor.
198      * @param owner The address of the owner of the contract.
199      * Must not be the zero address.
200      * @param implementor The address of the contract that is
201      * allowed to change state. Must not be the zero address.
202      */
203     constructor(address owner, address implementor) public {
204 
205         require(
206             owner != address(0),
207             "Owner should not be the zero address"
208         );
209 
210         require(
211             implementor != address(0),
212             "Implementor should not be the zero address"
213         );
214 
215         transferOwnership(owner);
216         _implementor = implementor;
217     }
218 
219     /**
220      * @dev Return whether the sender is an implementor.
221      */
222     function isImplementor() public view returns(bool) {
223         return msg.sender == _implementor;
224     }
225 
226     /**
227      * @dev Sets new balance.
228      * Can only be done by owner or implementor contract.
229      */
230     function setBalance(address owner,
231                         uint256 value)
232         public
233         onlyImplementor
234     {
235         balances[owner] = value;
236     }
237 
238     /**
239      * @dev Increases the balances relatively
240      * @param owner the address for which to increase balance
241      * @param addedValue the value to increase with
242      */
243     function increaseBalance(address owner, uint256 addedValue)
244         public
245         onlyImplementor
246     {
247         balances[owner] = balances[owner].add(addedValue);
248     }
249 
250     /**
251      * @dev Decreases the balances relatively
252      * @param owner the address for which to decrease balance
253      * @param subtractedValue the value to decrease with
254      */
255     function decreaseBalance(address owner, uint256 subtractedValue)
256         public
257         onlyImplementor
258     {
259         balances[owner] = balances[owner].sub(subtractedValue);
260     }
261 
262     /**
263      * @dev Can only be done by owner or implementor contract.
264      * @return The current balance of owner
265      */
266     function getBalance(address owner)
267         public
268         view
269         returns (uint256)
270     {
271         return balances[owner];
272     }
273 
274     /**
275      * @dev Sets new allowance.
276      * Can only be called by implementor contract.
277      */
278     function setAllowed(address owner,
279                         address spender,
280                         uint256 value)
281         public
282         onlyImplementor
283     {
284         allowed[owner][spender] = value;
285     }
286 
287     /**
288      * @dev Increases the allowance relatively
289      * @param owner the address for which to allow from
290      * @param spender the addres for which the allowance increase is granted
291      * @param addedValue the value to increase with
292      */
293     function increaseAllowed(
294         address owner,
295         address spender,
296         uint256 addedValue
297     )
298         public
299         onlyImplementor
300     {
301         allowed[owner][spender] = allowed[owner][spender].add(addedValue);
302     }
303 
304     /**
305      * @dev Decreases the allowance relatively
306      * @param owner the address for which to allow from
307      * @param spender the addres for which the allowance decrease is granted
308      * @param subtractedValue the value to decrease with
309      */
310     function decreaseAllowed(
311         address owner,
312         address spender,
313         uint256 subtractedValue
314     )
315         public
316         onlyImplementor
317     {
318         allowed[owner][spender] = allowed[owner][spender].sub(subtractedValue);
319     }
320 
321     /**
322      * @dev Can only be called by implementor contract.
323      * @return The current allowance for spender from owner
324      */
325     function getAllowed(address owner,
326                         address spender)
327         public
328         view
329         returns (uint256)
330     {
331         return allowed[owner][spender];
332     }
333 
334     /**
335      * @dev Change totalSupply.
336      * Can only be called by implementor contract.
337      */
338     function setTotalSupply(uint256 value)
339         public
340         onlyImplementor
341     {
342         totalSupply = value;
343     }
344 
345     /**
346      * @dev Can only be called by implementor contract.
347      * @return Current supply
348      */
349     function getTotalSupply()
350         public
351         view
352         returns (uint256)
353     {
354         return totalSupply;
355     }
356 
357     /**
358      * @dev Transfer implementor to new contract
359      * Can only be called by owner or implementor contract.
360      */
361     function transferImplementor(address newImplementor)
362         public
363         requireNonZero(newImplementor)
364         onlyImplementorOrOwner
365     {
366         require(newImplementor != _implementor,
367                 "Cannot transfer to same implementor as existing");
368         address curImplementor = _implementor;
369         _implementor = newImplementor;
370         emit StorageImplementorTransferred(curImplementor, newImplementor);
371     }
372 
373     /**
374      * @dev Asserts that sender is either owner or implementor.
375      */
376     modifier onlyImplementorOrOwner() {
377         require(isImplementor() || isOwner(), "Is not implementor or owner");
378         _;
379     }
380 
381     /**
382      * @dev Asserts that sender is the implementor.
383      */
384     modifier onlyImplementor() {
385         require(isImplementor(), "Is not implementor");
386         _;
387     }
388 
389     /**
390      * @dev Asserts that the given address is not the null-address
391      */
392     modifier requireNonZero(address addr) {
393         require(addr != address(0), "Expected a non-zero address");
394         _;
395     }
396 }