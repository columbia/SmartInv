1 /**
2  * Copyright 2019 Vanta Network.
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License");
5  * you may not use this file except in compliance with the License.
6  * You may obtain a copy of the License at
7  *
8  *     http://www.apache.org/licenses/LICENSE-2.0
9  *
10  * Unless required by applicable law or agreed to in writing, software
11  * distributed under the License is distributed on an "AS IS" BASIS,
12  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13  * See the License for the specific language governing permissions and
14  * limitations under the License.
15  */
16 
17 pragma solidity ^0.5.2;
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://eips.ethereum.org/EIPS/eip-20
22  */
23 interface IERC20 {
24     function transfer(address to, uint256 value) external returns (bool);
25 
26     function approve(address spender, uint256 value) external returns (bool);
27 
28     function transferFrom(address from, address to, uint256 value) external returns (bool);
29 
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address who) external view returns (uint256);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Unsigned math operations with safety checks that revert on error
44  */
45 library SafeMath {
46     /**
47      * @dev Multiplies two unsigned integers, reverts on overflow.
48      */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b);
59 
60         return c;
61     }
62 
63     /**
64      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
65      */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Solidity only automatically asserts when dividing by 0
68         require(b > 0);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     /**
76      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77      */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Adds two unsigned integers, reverts on overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a);
91 
92         return c;
93     }
94 
95     /**
96      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
97      * reverts when dividing by zero.
98      */
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0);
101         return a % b;
102     }
103 }
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * https://eips.ethereum.org/EIPS/eip-20
110  * Originally based on code by FirstBlood:
111  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  *
113  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
114  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
115  * compliant implementations may not do it.
116  */
117 contract ERC20 is IERC20 {
118     using SafeMath for uint256;
119 
120     mapping (address => uint256) private _balances;
121 
122     mapping (address => mapping (address => uint256)) private _allowed;
123 
124     uint256 private _totalSupply;
125 
126     /**
127      * @dev Total number of tokens in existence
128      */
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134      * @dev Gets the balance of the specified address.
135      * @param owner The address to query the balance of.
136      * @return A uint256 representing the amount owned by the passed address.
137      */
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param owner address The address which owns the funds.
145      * @param spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address owner, address spender) public view returns (uint256) {
149         return _allowed[owner][spender];
150     }
151 
152     /**
153      * @dev Transfer token to a specified address
154      * @param to The address to transfer to.
155      * @param value The amount to be transferred.
156      */
157     function transfer(address to, uint256 value) public returns (bool) {
158         _transfer(msg.sender, to, value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param spender The address which will spend the funds.
169      * @param value The amount of tokens to be spent.
170      */
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another.
178      * Note that while this function emits an Approval event, this is not required as per the specification,
179      * and other compliant implementations may not emit the event.
180      * @param from address The address which you want to send tokens from
181      * @param to address The address which you want to transfer to
182      * @param value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _transfer(from, to, value);
186         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
202         return true;
203     }
204 
205     /**
206      * @dev Decrease the amount of tokens that an owner allowed to a spender.
207      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * Emits an Approval event.
212      * @param spender The address which will spend the funds.
213      * @param subtractedValue The amount of tokens to decrease the allowance by.
214      */
215     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
216         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
217         return true;
218     }
219 
220     /**
221      * @dev Transfer token for a specified addresses
222      * @param from The address to transfer from.
223      * @param to The address to transfer to.
224      * @param value The amount to be transferred.
225      */
226     function _transfer(address from, address to, uint256 value) internal {
227 
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         emit Transfer(from, to, value);
231     }
232 
233     /**
234      * @dev Internal function that mints an amount of the token and assigns it to
235      * an account. This encapsulates the modification of balances such that the
236      * proper events are emitted.
237      * @param account The account that will receive the created tokens.
238      * @param value The amount that will be created.
239      */
240     function _mint(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.add(value);
244         _balances[account] = _balances[account].add(value);
245         emit Transfer(address(0), account, value);
246     }
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account.
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burn(address account, uint256 value) internal {
255         require(account != address(0));
256 
257         _totalSupply = _totalSupply.sub(value);
258         _balances[account] = _balances[account].sub(value);
259         emit Transfer(account, address(0), value);
260     }
261 
262     /**
263      * @dev Approve an address to spend another addresses' tokens.
264      * @param owner The address that owns the tokens.
265      * @param spender The address that will spend the tokens.
266      * @param value The number of tokens that can be spent.
267      */
268     function _approve(address owner, address spender, uint256 value) internal {
269         require(spender != address(0));
270         require(owner != address(0));
271 
272         _allowed[owner][spender] = value;
273         emit Approval(owner, spender, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account, deducting from the sender's allowance for said account. Uses the
279      * internal burn function.
280      * Emits an Approval event (reflecting the reduced allowance).
281      * @param account The account whose tokens will be burnt.
282      * @param value The amount that will be burnt.
283      */
284     function _burnFrom(address account, uint256 value) internal {
285         _burn(account, value);
286         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
287     }
288 }
289 
290 /**
291  * @title ERC20Detailed token
292  * @dev The decimals are only for visualization purposes.
293  * All the operations are done using the smallest and indivisible token unit,
294  * just as on Ethereum all the operations are done in wei.
295  */
296 contract ERC20Detailed is IERC20 {
297     string private _name;
298     string private _symbol;
299     uint8 private _decimals;
300 
301     constructor (string memory name, string memory symbol, uint8 decimals) public {
302         _name = name;
303         _symbol = symbol;
304         _decimals = decimals;
305     }
306 
307     /**
308      * @return the name of the token.
309      */
310     function name() public view returns (string memory) {
311         return _name;
312     }
313 
314     /**
315      * @return the symbol of the token.
316      */
317     function symbol() public view returns (string memory) {
318         return _symbol;
319     }
320 
321     /**
322      * @return the number of decimals of the token.
323      */
324     function decimals() public view returns (uint8) {
325         return _decimals;
326     }
327 }
328 
329 /**
330  * @title Ownable
331  * @dev The Ownable contract has an owner address, and provides basic authorization control
332  * functions, this simplifies the implementation of "user permissions".
333  */
334 contract Ownable {
335     address private _owner;
336 
337     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
338 
339     /**
340      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
341      * account.
342      */
343     constructor () internal {
344         _owner = msg.sender;
345         emit OwnershipTransferred(address(0), _owner);
346     }
347 
348     /**
349      * @return the address of the owner.
350      */
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     /**
356      * @dev Throws if called by any account other than the owner.
357      */
358     modifier onlyOwner() {
359         require(isOwner());
360         _;
361     }
362 
363     /**
364      * @return true if `msg.sender` is the owner of the contract.
365      */
366     function isOwner() public view returns (bool) {
367         return msg.sender == _owner;
368     }
369 
370     /**
371      * @dev Allows the current owner to relinquish control of the contract.
372      * It will not be possible to call the functions with the `onlyOwner`
373      * modifier anymore.
374      * @notice Renouncing ownership will leave the contract without an owner,
375      * thereby removing any functionality that is only available to the owner.
376      */
377     function renounceOwnership() public onlyOwner {
378         emit OwnershipTransferred(_owner, address(0));
379         _owner = address(0);
380     }
381 
382     /**
383      * @dev Allows the current owner to transfer control of the contract to a newOwner.
384      * @param newOwner The address to transfer ownership to.
385      */
386     function transferOwnership(address newOwner) public onlyOwner {
387         _transferOwnership(newOwner);
388     }
389 
390     /**
391      * @dev Transfers control of the contract to a newOwner.
392      * @param newOwner The address to transfer ownership to.
393      */
394     function _transferOwnership(address newOwner) internal {
395         require(newOwner != address(0));
396         emit OwnershipTransferred(_owner, newOwner);
397         _owner = newOwner;
398     }
399 }
400 
401 /**
402  * @title   Interface for ERC20 token transfer
403  * @dev     This interface contains function for ERC20 token transfer.
404  */
405 interface ITransferable {
406     function transfer(address _to, uint _amount) external returns (bool success);
407 }
408 
409 contract VantaToken is ERC20, ERC20Detailed, Ownable {
410     string _name = "VANTA Token";
411     string _symbol = "VANTA";
412     uint8 _decimals = 18;
413     uint256 _totalSupply  = 5620000000000000000000000000;
414     
415     constructor() ERC20Detailed(_name, _symbol, _decimals) Ownable() public {
416         ERC20._mint(msg.sender, _totalSupply);
417     }
418 
419     /**
420      * @dev Withdraw the ERC20 Token in the VANTAToken contract.
421      * @param erc20 ERC20 Token address.
422      * @param to To receive tokens.
423      * @param amount Tokens amount.
424      */
425     function withdrawERC20Token(address erc20, address to, uint256 amount) external onlyOwner {
426         require(to != address(0x0));
427         require(ITransferable(erc20).transfer(to, amount));
428     }
429 }