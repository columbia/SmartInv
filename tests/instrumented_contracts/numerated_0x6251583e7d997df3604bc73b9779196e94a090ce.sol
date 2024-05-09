1 pragma solidity ^0.4.25;
2 
3 /*
4 Copyright (c) 2018 Hercules SEZC
5 
6 Licensed under the Apache License, Version 2.0 (the "License");
7 you may not use this file except in compliance with the License.
8 You may obtain a copy of the License at
9 
10     http://www.apache.org/licenses/LICENSE-2.0
11 
12 Unless required by applicable law or agreed to in writing, software
13 distributed under the License is distributed on an "AS IS" BASIS,
14 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15 See the License for the specific language governing permissions and
16 limitations under the License.
17 */
18 
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, reverts on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     uint256 c = a * b;
33     require(c / a == b);
34 
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b > 0); // Solidity only automatically asserts when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46     return c;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     require(b <= a);
54     uint256 c = a - b;
55 
56     return c;
57   }
58 
59   /**
60   * @dev Adds two numbers, reverts on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     require(c >= a);
65 
66     return c;
67   }
68 
69   /**
70   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
71   * reverts when dividing by zero.
72   */
73   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b != 0);
75     return a % b;
76   }
77 }
78 
79 
80 interface Int20 {
81   function totalSupply() external view returns (uint256);
82 
83   function balanceOf(address who) external view returns (uint256);
84 
85   function allowance(address owner, address spender)
86     external view returns (uint256);
87 
88   function transfer(address to, uint256 value) external returns (bool);
89 
90   function approve(address spender, uint256 value)
91     external returns (bool);
92 
93   function transferFrom(address from, address to, uint256 value)
94     external returns (bool);
95 
96   event Transfer(
97     address indexed from,
98     address indexed to,
99     uint256 value
100   );
101 
102   event Approval(
103     address indexed owner,
104     address indexed spender,
105     uint256 value
106   );
107 }
108 
109 contract Ownable {
110   address private _owner;
111 
112   event OwnershipTransferred(
113     address indexed previousOwner,
114     address indexed newOwner
115   );
116 
117   /**
118    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119    * account.
120    */
121   constructor() internal {
122     _owner = msg.sender;
123     emit OwnershipTransferred(address(0), _owner);
124   }
125 
126   /**
127    * @return the address of the owner.
128    */
129   function owner() public view returns(address) {
130     return _owner;
131   }
132 
133   /**
134    * @dev Throws if called by any account other than the owner.
135    */
136   modifier onlyOwner() {
137     require(isOwner());
138     _;
139   }
140 
141   /**
142    * @return true if `msg.sender` is the owner of the contract.
143    */
144   function isOwner() public view returns(bool) {
145     return msg.sender == _owner;
146   }
147 
148   /**
149    * @dev Allows the current owner to relinquish control of the contract.
150    * @notice Renouncing to ownership will leave the contract without an owner.
151    * It will not be possible to call the functions with the `onlyOwner`
152    * modifier anymore.
153    */
154   function renounceOwnership() public onlyOwner {
155     emit OwnershipTransferred(_owner, address(0));
156     _owner = address(0);
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param newOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address newOwner) public onlyOwner {
164     _transferOwnership(newOwner);
165   }
166 
167   /**
168    * @dev Transfers control of the contract to a newOwner.
169    * @param newOwner The address to transfer ownership to.
170    */
171   function _transferOwnership(address newOwner) internal {
172     require(newOwner != address(0));
173     emit OwnershipTransferred(_owner, newOwner);
174     _owner = newOwner;
175   }
176 }
177 /**
178  * @title HERC Token 
179 **/
180 
181 contract HERCToken is Int20 , Ownable {
182   using SafeMath for uint256;
183 
184     event Transfer(
185         address indexed _from,
186         address indexed _to,
187         uint256 _value
188     );
189 
190     event Approval(
191         address indexed _owner,
192         address indexed _spender,
193         uint256 _value
194     );
195 
196     
197 
198     mapping(address => uint) balances;
199     mapping(address => mapping(address => uint)) allowed;
200 
201    string public constant name = "Hercules";
202   string public constant symbol = "HERC";
203   uint8 public constant decimals = 18;
204 
205   uint256 public constant INITIAL_SUPPLY = 234259085 * (10 ** uint256(decimals));
206 
207   /**
208    * @dev Constructor that gives msg.sender all of existing tokens.
209    */
210   constructor() public {
211     mint(msg.sender, INITIAL_SUPPLY);
212   }
213     /**
214      * @dev Fallback function
215      */
216     function() public payable { revert(); }
217 
218   mapping (address => uint256) private _balances;
219 
220   mapping (address => mapping (address => uint256)) private _allowed;
221 
222   uint256 private _totalSupply;
223 
224   /**
225   * @dev Total number of tokens in existence
226   */
227   function totalSupply() public view returns (uint256) {
228     return _totalSupply;
229   }
230 
231   /**
232   * @dev Gets the balance of the specified address.
233   * @param owner The address to query the balance of.
234   * @return An uint256 representing the amount owned by the passed address.
235   */
236   function balanceOf(address owner) public view returns (uint256) {
237     return _balances[owner];
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param owner address The address which owns the funds.
243    * @param spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address owner,
248     address spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return _allowed[owner][spender];
255   }
256 
257   /**
258   * @dev Transfer token for a specified address
259   * @param to The address to transfer to.
260   * @param value The amount to be transferred.
261   */
262   function transfer(address to, uint256 value) public returns (bool) {
263     _transfer(msg.sender, to, value);
264     return true;
265   }
266 
267   /**
268    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param spender The address which will spend the funds.
274    * @param value The amount of tokens to be spent.
275    */
276   function approve(address spender, uint256 value) public returns (bool) {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = value;
280     emit Approval(msg.sender, spender, value);
281     return true;
282   }
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param from address The address which you want to send tokens from
287    * @param to address The address which you want to transfer to
288    * @param value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(
291     address from,
292     address to,
293     uint256 value
294   )
295     public
296     returns (bool)
297   {
298     require(value <= _allowed[from][msg.sender]);
299 
300     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
301     _transfer(from, to, value);
302     return true;
303   }
304 
305   /**
306    * @dev Increase the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed_[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param spender The address which will spend the funds.
312    * @param addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseAllowance(
315     address spender,
316     uint256 addedValue
317   )
318     public
319     returns (bool)
320   {
321     require(spender != address(0));
322 
323     _allowed[msg.sender][spender] = (
324       _allowed[msg.sender][spender].add(addedValue));
325     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
326     return true;
327   }
328 
329   /**
330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
331    * approve should be called when allowed_[_spender] == 0. To decrement
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param spender The address which will spend the funds.
336    * @param subtractedValue The amount of tokens to decrease the allowance by.
337    */
338   function decreaseAllowance(
339     address spender,
340     uint256 subtractedValue
341   )
342     public
343     returns (bool)
344   {
345     require(spender != address(0));
346 
347     _allowed[msg.sender][spender] = (
348       _allowed[msg.sender][spender].sub(subtractedValue));
349     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
350     return true;
351   }
352 
353   /**
354   * @dev Transfer token for a specified addresses
355   * @param from The address to transfer from.
356   * @param to The address to transfer to.
357   * @param value The amount to be transferred.
358   */
359   function _transfer(address from, address to, uint256 value) internal {
360     require(value <= _balances[from]);
361     require(to != address(0));
362 
363     _balances[from] = _balances[from].sub(value);
364     _balances[to] = _balances[to].add(value);
365     emit Transfer(from, to, value);
366   }
367 
368   /**
369    * @dev Internal function that mints an amount of the token and assigns it to
370    * an account. This encapsulates the modification of balances such that the
371    * proper events are emitted.
372    * @param account The account that will receive the created tokens.
373    * @param value The amount that will be created.
374    */
375   function mint(address account, uint256 value) onlyOwner public {
376     require(account != 0);
377     _totalSupply = _totalSupply.add(value);
378     _balances[account] = _balances[account].add(value);
379     emit Transfer(address(0), account, value);
380   }
381 
382   /**
383    * @dev Internal function that burns an amount of the token of a given
384    * account.
385    * @param account The account whose tokens will be burnt.
386    * @param value The amount that will be burnt.
387    */
388   function burn(address account, uint256 value) onlyOwner public {
389     require(account != 0);
390     require(value <= _balances[account]);
391 
392     _totalSupply = _totalSupply.sub(value);
393     _balances[account] = _balances[account].sub(value);
394     emit Transfer(account, address(0), value);
395   }
396 
397   /**
398    * @dev Internal function that burns an amount of the token of a given
399    * account, deducting from the sender's allowance for said account. Uses the
400    * internal burn function.
401    * @param account The account whose tokens will be burnt.
402    * @param value The amount that will be burnt.
403    */
404   function _burnFrom(address account, uint256 value) internal {
405     require(value <= _allowed[account][msg.sender]);
406 
407 
408     // this function needs to emit an event with the updated approval.
409     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
410       value);
411     burn(account, value);
412   }
413 }