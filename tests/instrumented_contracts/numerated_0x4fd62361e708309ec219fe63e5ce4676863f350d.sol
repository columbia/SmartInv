1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 
10 contract Owned {
11     address private _owner;
12     address private _newOwner;
13 
14     event TransferredOwner(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 	/**
20 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
21 	* account.
22 	*/
23     constructor() internal {
24         _owner = msg.sender;
25         emit TransferredOwner(address(0), _owner);
26     }
27 
28 	/**
29 	* @return the address of the owner.
30 	*/
31 
32     function owner() public view returns(address) {
33         return _owner;
34     }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39     modifier onlyOwner() {
40         require(isOwner(), "Access is denied");
41         _;
42     }
43 
44   /**
45    * @return true if `msg.sender` is the owner of the contract.
46    */
47     function isOwner() public view returns(bool) {
48         return msg.sender == _owner;
49     }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57     function renounceOwner() public onlyOwner {
58         emit TransferredOwner(_owner, address(0));
59         _owner = address(0);
60     }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66     function transferOwner(address newOwner) public onlyOwner {
67         require(newOwner != address(0), "Empty address");
68         _newOwner = newOwner;
69     }
70 
71 
72     function cancelOwner() public onlyOwner {
73         _newOwner = address(0);
74     }
75 
76     function confirmOwner() public {
77         require(msg.sender == _newOwner, "Access is denied");
78         emit TransferredOwner(_owner, _newOwner);
79         _owner = _newOwner;
80     }
81 }
82 
83 
84 /**
85  * @title Standard ERC20 token
86  *
87  * @dev Implementation of the basic standard token.
88  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
89  */
90 
91 contract ERC20CoreBase {
92 
93     // string public name;
94     // string public symbol;
95     // uint8 public decimals;
96 
97 
98     mapping (address => uint) internal _balanceOf;
99     uint internal _totalSupply; 
100 
101     event Transfer(
102         address indexed from,
103         address indexed to,
104         uint256 value
105     );
106 
107 
108     /**
109     * @dev Total number of tokens in existence
110     */
111 
112     function totalSupply() public view returns(uint) {
113         return _totalSupply;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param owner The address to query the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121 
122     function balanceOf(address owner) public view returns(uint) {
123         return _balanceOf[owner];
124     }
125 
126 
127 
128     /**
129     * @dev Transfer token for a specified addresses
130     * @param from The address to transfer from.
131     * @param to The address to transfer to.
132     * @param value The amount to be transferred.
133     */
134 
135     function _transfer(address from, address to, uint256 value) internal {
136         _checkRequireERC20(to, value, true, _balanceOf[from]);
137 
138         _balanceOf[from] -= value;
139         _balanceOf[to] += value;
140         emit Transfer(from, to, value);
141     }
142 
143 
144     /**
145     * @dev Internal function that mints an amount of the token and assigns it to
146     * an account. This encapsulates the modification of balances such that the
147     * proper events are emitted.
148     * @param account The account that will receive the created tokens.
149     * @param value The amount that will be created.
150     */
151 
152     function _mint(address account, uint256 value) internal {
153         _checkRequireERC20(account, value, false, 0);
154         _totalSupply += value;
155         _balanceOf[account] += value;
156         emit Transfer(address(0), account, value);
157     }
158 
159     /**
160     * @dev Internal function that burns an amount of the token of a given
161     * account.
162     * @param account The account whose tokens will be burnt.
163     * @param value The amount that will be burnt.
164     */
165 
166     function _burn(address account, uint256 value) internal {
167         _checkRequireERC20(account, value, true, _balanceOf[account]);
168 
169         _totalSupply -= value;
170         _balanceOf[account] -= value;
171         emit Transfer(account, address(0), value);
172     }
173 
174 
175     function _checkRequireERC20(address addr, uint value, bool checkMax, uint max) internal pure {
176         require(addr != address(0), "Empty address");
177         require(value > 0, "Empty value");
178         if (checkMax) {
179             require(value <= max, "Out of value");
180         }
181     }
182 
183 }
184 
185 
186 contract ERC20Core is ERC20CoreBase {
187     /**
188     * @dev Transfer token for a specified address
189     * @param to The address to transfer to.
190     * @param value The amount to be transferred.
191     */
192 
193     function transfer(address to, uint256 value) public returns (bool) {
194         _transfer(msg.sender, to, value);
195         return true;
196     }
197 }
198 
199 
200 contract ERC20WithApproveBase is ERC20CoreBase {
201     mapping (address => mapping (address => uint256)) private _allowed;
202 
203 
204     event Approval(
205         address indexed owner,
206         address indexed spender,
207         uint256 value
208     ); 
209 
210     /**
211     * @dev Function to check the amount of tokens that an owner allowed to a spender.
212     * @param owner address The address which owns the funds.
213     * @param spender address The address which will spend the funds.
214     * @return A uint256 specifying the amount of tokens still available for the spender.
215     */
216     
217     function allowance(address owner, address spender) public view returns(uint) {
218         return _allowed[owner][spender];
219     }
220 
221     /**
222     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223     * Beware that changing an allowance with this method brings the risk that someone may use both the old
224     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227     * @param spender The address which will spend the funds.
228     * @param value The amount of tokens to be spent.
229     */
230 
231     function _approve(address spender, uint256 value) internal {
232         _checkRequireERC20(spender, value, true, _balanceOf[msg.sender]);
233 
234         _allowed[msg.sender][spender] = value;
235         emit Approval(msg.sender, spender, value);
236     }
237 
238     /**
239     * @dev Transfer tokens from one address to another
240     * @param from address The address which you want to send tokens from
241     * @param to address The address which you want to transfer to
242     * @param value uint256 the amount of tokens to be transferred
243     */
244 
245     function _transferFrom(address from, address to, uint256 value) internal {
246         _checkRequireERC20(to, value, true, _allowed[from][msg.sender]);
247 
248         _allowed[from][msg.sender] -= value;
249         _transfer(from, to, value);
250     }
251 
252     /**
253     * @dev Increase the amount of tokens that an owner allowed to a spender.
254     * approve should be called when allowed_[_spender] == 0. To increment
255     * allowed value is better to use this function to avoid 2 calls (and wait until
256     * the first transaction is mined)
257     * @param spender The address which will spend the funds.
258     * @param value The amount of tokens to increase the allowance by.
259     */
260 
261     function _increaseAllowance(address spender, uint256 value)  internal {
262         _checkRequireERC20(spender, value, false, 0);
263         require(_balanceOf[msg.sender] >= (_allowed[msg.sender][spender] + value), "Out of value");
264 
265         _allowed[msg.sender][spender] += value;
266         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
267     }
268 
269 
270 
271     /**
272     * @dev Decrease the amount of tokens that an owner allowed to a spender.
273     * approve should be called when allowed_[_spender] == 0. To decrement
274     * allowed value is better to use this function to avoid 2 calls (and wait until
275     * the first transaction is mined)
276     * @param spender The address which will spend the funds.
277     * @param value The amount of tokens to decrease the allowance by.
278     */
279 
280     function _decreaseAllowance(address spender, uint256 value) internal {
281         _checkRequireERC20(spender, value, true, _allowed[msg.sender][spender]);
282 
283         _allowed[msg.sender][spender] -= value;
284         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
285     }
286 
287 }
288 
289 
290 contract ERC20WithApprove is ERC20WithApproveBase {
291     /**
292     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293     * Beware that changing an allowance with this method brings the risk that someone may use both the old
294     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297     * @param spender The address which will spend the funds.
298     * @param value The amount of tokens to be spent.
299     */
300 
301     function approve(address spender, uint256 value) public {
302         _approve(spender, value);
303     }
304 
305     /**
306     * @dev Transfer tokens from one address to another
307     * @param from address The address which you want to send tokens from
308     * @param to address The address which you want to transfer to
309     * @param value uint256 the amount of tokens to be transferred
310     */
311 
312     function transferFrom(address from, address to, uint256 value) public {
313         _transferFrom(from, to, value);
314     }
315 
316     /**
317     * @dev Increase the amount of tokens that an owner allowed to a spender.
318     * approve should be called when allowed_[_spender] == 0. To increment
319     * allowed value is better to use this function to avoid 2 calls (and wait until
320     * the first transaction is mined)
321     * @param spender The address which will spend the funds.
322     * @param value The amount of tokens to increase the allowance by.
323     */
324 
325     function increaseAllowance(address spender, uint256 value)  public {
326         _increaseAllowance(spender, value);
327     }
328 
329 
330 
331     /**
332     * @dev Decrease the amount of tokens that an owner allowed to a spender.
333     * approve should be called when allowed_[_spender] == 0. To decrement
334     * allowed value is better to use this function to avoid 2 calls (and wait until
335     * the first transaction is mined)
336     * @param spender The address which will spend the funds.
337     * @param value The amount of tokens to decrease the allowance by.
338     */
339 
340     function decreaseAllowance(address spender, uint256 value) public {
341         _decreaseAllowance(spender, value);
342     }
343 }
344 
345 
346 contract VendiCoins is ERC20WithApprove, Owned {
347 	string public name;
348 	string public symbol;
349 	uint public decimals;
350 	bool public frozen;
351 
352 
353 	/**
354 	* Logged when token transfers were frozen/unfrozen.
355 	*/
356 	event Freeze ();
357 	event Unfreeze ();
358 
359 
360     modifier onlyUnfreeze() {
361         require(!frozen, "Action temporarily paused");
362         _;
363     }
364 
365 
366 
367 	constructor(string _name, string _symbol, uint _decimals, uint total, bool _frozen) public {
368 		name = _name;
369 		symbol = _symbol;
370 		decimals = _decimals;
371 		frozen = _frozen;
372 
373 		_mint(msg.sender, total);
374 	} 
375 
376 	function mint(address account, uint value) public onlyOwner {
377 		_mint(account, value);
378 	}
379 
380 	function burn(uint value) public {
381 		_burn(msg.sender, value);
382 	} 
383 
384 
385 	function transfer(address to, uint value) public onlyUnfreeze {
386 		_transfer(msg.sender, to, value);
387 	}
388 
389 	function transferFrom(address from, address to, uint value) public onlyUnfreeze {
390 		_transferFrom(from, to, value);
391 	}
392 
393 
394 	function freezeTransfers () public onlyOwner {
395 		if (!frozen) {
396 			frozen = true;
397 			emit Freeze();
398 		}
399 	}
400 
401 	/**
402 	* Unfreeze token transfers.
403 	* May only be called by smart contract owner.
404 	*/
405 	function unfreezeTransfers () public onlyOwner {
406 		if (frozen) {
407 			frozen = false;
408 			emit Unfreeze();
409 		}
410 	}
411 }