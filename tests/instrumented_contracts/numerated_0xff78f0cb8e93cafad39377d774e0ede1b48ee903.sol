1 pragma solidity 0.5.0;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error.
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 
75 contract Owned {
76     address private _owner;
77     address private _newOwner;
78 
79     event TransferredOwner(
80         address indexed previousOwner,
81         address indexed newOwner
82     );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88     constructor() internal {
89         _owner = msg.sender;
90         emit TransferredOwner(address(0), _owner);
91     }
92 
93   /**
94    * @return the address of the owner.
95    */
96 
97     function owner() public view returns(address) {
98         return _owner;
99     }
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104     modifier onlyOwner() {
105         require(isOwner(), "Access is denied");
106         _;
107     }
108 
109   /**
110    * @return true if `msg.sender` is the owner of the contract.
111    */
112     function isOwner() public view returns(bool) {
113         return msg.sender == _owner;
114     }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    * @notice Renouncing to ownership will leave the contract without an owner.
119    * It will not be possible to call the functions with the `onlyOwner`
120    * modifier anymore.
121    */
122     function renounceOwner() public onlyOwner {
123         emit TransferredOwner(_owner, address(0));
124         _owner = address(0);
125     }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param newOwner The address to transfer ownership to.
130    */
131     function transferOwner(address newOwner) public onlyOwner {
132         require(newOwner != address(0), "Empty address");
133         _newOwner = newOwner;
134     }
135 
136 
137     function cancelOwner() public onlyOwner {
138         _newOwner = address(0);
139     }
140 
141     function confirmOwner() public {
142         require(msg.sender == _newOwner, "Access is denied");
143         emit TransferredOwner(_owner, _newOwner);
144         _owner = _newOwner;
145     }
146 }
147 
148 
149 contract Freezed {
150 	bool public frozen;
151 
152 	/**
153 	* Logged when token transfers were frozen/unfrozen.
154 	*/
155 	event Freeze ();
156 	event Unfreeze ();
157 
158 
159     modifier onlyUnfreeze() {
160         require(!frozen, "Action temporarily paused");
161         _;
162     }
163 
164 	constructor(bool _frozen) public {
165 		frozen = _frozen;
166 	}
167 
168 	function _freezeTransfers () internal {
169 		if (!frozen) {
170 			frozen = true;
171 			emit Freeze();
172 		}
173 	}
174 
175 	function _unfreezeTransfers () internal {
176 		if (frozen) {
177 			frozen = false;
178 			emit Unfreeze();
179 		}
180 	}
181 }
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
189  */
190 
191 contract ERC20Base {
192 
193 
194 
195     mapping (address => uint) internal _balanceOf;
196     uint internal _totalSupply; 
197 
198     event Transfer(
199         address indexed from,
200         address indexed to,
201         uint256 value
202     );
203 
204 
205     /**
206     * @dev Total number of tokens in existence
207     */
208 
209     function totalSupply() public view returns(uint) {
210         return _totalSupply;
211     }
212 
213     /**
214     * @dev Gets the balance of the specified address.
215     * @param owner The address to query the balance of.
216     * @return An uint256 representing the amount owned by the passed address.
217     */
218 
219     function balanceOf(address owner) public view returns(uint) {
220         return _balanceOf[owner];
221     }
222 
223 
224 
225     /**
226     * @dev Transfer token for a specified addresses
227     * @param from The address to transfer from.
228     * @param to The address to transfer to.
229     * @param value The amount to be transferred.
230     */
231 
232     function _transfer(address from, address to, uint256 value) internal {
233         _checkRequireERC20(to, value, true, _balanceOf[from]);
234 
235         // _balanceOf[from] -= value;
236         // _balanceOf[to] += value;
237         _balanceOf[from] = SafeMath.sub(_balanceOf[from], value);
238         _balanceOf[to] = SafeMath.add(_balanceOf[to], value);
239         emit Transfer(from, to, value);
240     }
241 
242 
243     /**
244     * @dev Internal function that mints an amount of the token and assigns it to
245     * an account. This encapsulates the modification of balances such that the
246     * proper events are emitted.
247     * @param account The account that will receive the created tokens.
248     * @param value The amount that will be created.
249     */
250 
251     function _mint(address account, uint256 value) internal {
252         _checkRequireERC20(account, value, false, 0);
253         _totalSupply = SafeMath.add(_totalSupply, value);
254         _balanceOf[account] = SafeMath.add(_balanceOf[account], value);
255         emit Transfer(address(0), account, value);
256     }
257 
258     /**
259     * @dev Internal function that burns an amount of the token of a given
260     * account.
261     * @param account The account whose tokens will be burnt.
262     * @param value The amount that will be burnt.
263     */
264 
265     function _burn(address account, uint256 value) internal {
266         _checkRequireERC20(account, value, true, _balanceOf[account]);
267 
268         _totalSupply = SafeMath.sub(_totalSupply, value);
269         _balanceOf[account] = SafeMath.sub(_balanceOf[account], value);
270         emit Transfer(account, address(0), value);
271     }
272 
273 
274     function _checkRequireERC20(address addr, uint value, bool checkMax, uint max) internal pure {
275         require(addr != address(0), "Empty address");
276         require(value > 0, "Empty value");
277         if (checkMax) {
278             require(value <= max, "Out of value");
279         }
280     }
281 
282 }
283 
284 
285 contract ERC20 is ERC20Base {
286     string public name;
287     string public symbol;
288     uint8 public decimals;
289 
290     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _total, address _fOwner) public {
291         name = _name;
292         symbol = _symbol;
293         decimals = _decimals;
294         _mint(_fOwner, _total);
295     }
296 
297 
298     mapping (address => mapping (address => uint256)) private _allowed;
299 
300 
301     event Approval(
302         address indexed owner,
303         address indexed spender,
304         uint256 value
305     ); 
306 
307     /**
308     * @dev Transfer token for a specified address
309     * @param to The address to transfer to.
310     * @param value The amount to be transferred.
311     */
312 
313     function transfer(address to, uint256 value) public {
314         _transfer(msg.sender, to, value);
315     }
316 
317     /**
318     * @dev Function to check the amount of tokens that an owner allowed to a spender.
319     * @param owner address The address which owns the funds.
320     * @param spender address The address which will spend the funds.
321     * @return A uint256 specifying the amount of tokens still available for the spender.
322     */
323     
324     function allowance(address owner, address spender) public view returns(uint) {
325         return _allowed[owner][spender];
326     }
327 
328 
329     /**
330     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
331     * Beware that changing an allowance with this method brings the risk that someone may use both the old
332     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
333     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
334     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335     * @param spender The address which will spend the funds.
336     * @param value The amount of tokens to be spent.
337     */
338 
339     function approve(address spender, uint256 value) public {
340         _checkRequireERC20(spender, value, true, _balanceOf[msg.sender]);
341 
342         _allowed[msg.sender][spender] = value;
343         emit Approval(msg.sender, spender, value);
344     }
345 
346 
347     /**
348     * @dev Transfer tokens from one address to another
349     * @param from address The address which you want to send tokens from
350     * @param to address The address which you want to transfer to
351     * @param value uint256 the amount of tokens to be transferred
352     */
353 
354     function transferFrom(address from, address to, uint256 value) public {
355         _checkRequireERC20(to, value, true, _allowed[from][msg.sender]);
356 
357         _allowed[from][msg.sender] = SafeMath.sub(_allowed[from][msg.sender], value);
358         _transfer(from, to, value);
359     }
360 
361     /**
362     * @dev Increase the amount of tokens that an owner allowed to a spender.
363     * approve should be called when allowed_[_spender] == 0. To increment
364     * allowed value is better to use this function to avoid 2 calls (and wait until
365     * the first transaction is mined)
366     * @param spender The address which will spend the funds.
367     * @param value The amount of tokens to increase the allowance by.
368     */
369 
370     function increaseAllowance(address spender, uint256 value)  public {
371         _checkRequireERC20(spender, value, false, 0);
372         require(_balanceOf[msg.sender] >= (_allowed[msg.sender][spender] + value), "Out of value");
373 
374         _allowed[msg.sender][spender] = SafeMath.add(_allowed[msg.sender][spender], value);
375         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
376     }
377 
378 
379 
380     /**
381     * @dev Decrease the amount of tokens that an owner allowed to a spender.
382     * approve should be called when allowed_[_spender] == 0. To decrement
383     * allowed value is better to use this function to avoid 2 calls (and wait until
384     * the first transaction is mined)
385     * @param spender The address which will spend the funds.
386     * @param value The amount of tokens to decrease the allowance by.
387     */
388 
389     function decreaseAllowance(address spender, uint256 value) public {
390         _checkRequireERC20(spender, value, true, _allowed[msg.sender][spender]);
391 
392         _allowed[msg.sender][spender] = SafeMath.sub(_allowed[msg.sender][spender],value);
393         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
394     }
395 }
396 
397 
398 contract MCVToken is ERC20, Owned, Freezed {
399     
400     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _total, address _fOwner, bool _freeze) 
401         public 
402         ERC20(_name, _symbol, _decimals, _total, _fOwner) 
403         Freezed(_freeze) {
404     }
405 
406 
407 	function freezeTransfers () public onlyOwner {
408 		_freezeTransfers();
409 	}
410 
411 	/**
412 	* Unfreeze token transfers.
413 	* May only be called by smart contract owner.
414 	*/
415 	function unfreezeTransfers () public onlyOwner {
416 		_unfreezeTransfers();
417 	}
418 
419     /**
420     * @dev Internal function that burns an amount of the token of a sender
421     * @param value The amount that will be burnt.
422     */
423 
424     function burn(uint256 value) public {
425         _burn(msg.sender, value);
426     }
427 
428     function transfer(address to, uint256 value) public onlyUnfreeze {
429         super.transfer(to, value);
430     }
431 
432 
433 
434     function transferFrom(address from, address to, uint256 value) public onlyUnfreeze {
435         super.transferFrom(from, to, value);
436     }
437 
438 }