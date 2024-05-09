1 pragma solidity ^0.4.25;
2 
3 /** For more info visit www.MettaCreative.world
4  * 
5  * Need a custom token for your own event? Interested in using smart contracts?
6  * Contact the developer! Email: 2eny6208k1af@opayq.com
7  */
8 
9 /** The MIT License (MIT)
10  *
11  * Copyright (c) 2018 Metta Creative
12  *
13  * Permission is hereby granted, free of charge, to any person obtaining
14  * a copy of this software and associated documentation files (the
15  * "Software"), to deal in the Software without restriction, including
16  * without limitation the rights to use, copy, modify, merge, publish,
17  * distribute, sublicense, and/or sell copies of the Software, and to
18  * permit persons to whom the Software is furnished to do so, subject to
19  * the following conditions:
20  * 
21  * The above copyright notice and this permission notice shall be included
22  * in all copies or substantial portions of the Software.
23  *
24  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
25  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
26  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
27  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
28  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
29  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
30  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
31  */
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that revert on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, reverts on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (a == 0) {
47       return 0;
48     }
49 
50     uint256 c = a * b;
51     require(c / a == b);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b > 0); // Solidity only automatically asserts when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64     return c;
65   }
66 
67   /**
68   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b <= a);
72     uint256 c = a - b;
73 
74     return c;
75   }
76 
77   /**
78   * @dev Adds two numbers, reverts on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     require(c >= a);
83 
84     return c;
85   }
86 
87   /**
88   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
89   * reverts when dividing by zero.
90   */
91   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b != 0);
93     return a % b;
94   }
95 }
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 interface IERC20 {
103   function totalSupply() external view returns (uint256);
104 
105   function balanceOf(address who) external view returns (uint256);
106 
107   function allowance(address owner, address spender)
108     external view returns (uint256);
109 
110   function transfer(address to, uint256 value) external returns (bool);
111 
112   function approve(address spender, uint256 value)
113     external returns (bool);
114 
115   function transferFrom(address from, address to, uint256 value)
116     external returns (bool);
117 
118   event Transfer(
119     address indexed from,
120     address indexed to,
121     uint256 value
122   );
123 
124   event Approval(
125     address indexed owner,
126     address indexed spender,
127     uint256 value
128   );
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
136  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract ERC20 is IERC20 {
139   using SafeMath for uint256;
140 
141   mapping (address => uint256) private _balances;
142 
143   mapping (address => mapping (address => uint256)) private _allowed;
144 
145   uint256 private _totalSupply;
146 
147   /**
148   * @dev Total number of tokens in existence
149   */
150   function totalSupply() public view returns (uint256) {
151     return _totalSupply;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param owner The address to query the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address owner) public view returns (uint256) {
160     return _balances[owner];
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param owner address The address which owns the funds.
166    * @param spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(
170     address owner,
171     address spender
172    )
173     public
174     view
175     returns (uint256)
176   {
177     return _allowed[owner][spender];
178   }
179 
180   /**
181   * @dev Transfer token for a specified address
182   * @param to The address to transfer to.
183   * @param value The amount to be transferred.
184   */
185   function transfer(address to, uint256 value) public returns (bool) {
186     _transfer(msg.sender, to, value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param spender The address which will spend the funds.
197    * @param value The amount of tokens to be spent.
198    */
199   function approve(address spender, uint256 value) public returns (bool) {
200     require(spender != address(0));
201 
202     _allowed[msg.sender][spender] = value;
203     emit Approval(msg.sender, spender, value);
204     return true;
205   }
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param from address The address which you want to send tokens from
210    * @param to address The address which you want to transfer to
211    * @param value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(
214     address from,
215     address to,
216     uint256 value
217   )
218     public
219     returns (bool)
220   {
221     require(value <= _allowed[from][msg.sender]);
222 
223     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
224     _transfer(from, to, value);
225     return true;
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed_[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param spender The address which will spend the funds.
235    * @param addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseAllowance(
238     address spender,
239     uint256 addedValue
240   )
241     public
242     returns (bool)
243   {
244     require(spender != address(0));
245 
246     _allowed[msg.sender][spender] = (
247       _allowed[msg.sender][spender].add(addedValue));
248     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed_[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param spender The address which will spend the funds.
259    * @param subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseAllowance(
262     address spender,
263     uint256 subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     require(spender != address(0));
269 
270     _allowed[msg.sender][spender] = (
271       _allowed[msg.sender][spender].sub(subtractedValue));
272     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
273     return true;
274   }
275 
276   /**
277   * @dev Transfer token for a specified addresses
278   * @param from The address to transfer from.
279   * @param to The address to transfer to.
280   * @param value The amount to be transferred.
281   */
282   function _transfer(address from, address to, uint256 value) internal {
283     require(value <= _balances[from]);
284     require(to != address(0));
285 
286     _balances[from] = _balances[from].sub(value);
287     _balances[to] = _balances[to].add(value);
288     emit Transfer(from, to, value);
289   }
290 
291   /**
292    * @dev Internal function that mints an amount of the token and assigns it to
293    * an account. This encapsulates the modification of balances such that the
294    * proper events are emitted.
295    * @param account The account that will receive the created tokens.
296    * @param value The amount that will be created.
297    */
298   function _mint(address account, uint256 value) internal {
299     require(account != 0);
300     _totalSupply = _totalSupply.add(value);
301     _balances[account] = _balances[account].add(value);
302     emit Transfer(address(0), account, value);
303   }
304 
305   /**
306    * @dev Internal function that burns an amount of the token of a given
307    * account.
308    * @param account The account whose tokens will be burnt.
309    * @param value The amount that will be burnt.
310    */
311   function _burn(address account, uint256 value) internal {
312     require(account != 0);
313     require(value <= _balances[account]);
314 
315     _totalSupply = _totalSupply.sub(value);
316     _balances[account] = _balances[account].sub(value);
317     emit Transfer(account, address(0), value);
318   }
319 
320   /**
321    * @dev Internal function that burns an amount of the token of a given
322    * account, deducting from the sender's allowance for said account. Uses the
323    * internal burn function.
324    * @param account The account whose tokens will be burnt.
325    * @param value The amount that will be burnt.
326    */
327   function _burnFrom(address account, uint256 value) internal {
328     require(value <= _allowed[account][msg.sender]);
329 
330     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
331     // this function needs to emit an event with the updated approval.
332     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
333       value);
334     _burn(account, value);
335   }
336 }
337 
338 
339 contract MettaToken is ERC20 {
340   string public name = "Metta Token";
341   string public symbol = "MTTA";
342   uint8 public decimals = 2;
343   uint public INITIAL_SUPPLY = 5000000000;
344   constructor() public {
345  
346     _mint(msg.sender, INITIAL_SUPPLY);
347    }
348 
349 }