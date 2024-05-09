1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/access/Roles.sol
28 
29 /**
30  * @title Roles
31  * @dev Library for managing addresses assigned to a Role.
32  */
33 library Roles {
34     struct Role {
35         mapping (address => bool) bearer;
36     }
37 
38     /**
39      * @dev give an account access to this role
40      */
41     function add(Role storage role, address account) internal {
42         require(account != address(0));
43         require(!has(role, account));
44 
45         role.bearer[account] = true;
46     }
47 
48     /**
49      * @dev remove an account's access to this role
50      */
51     function remove(Role storage role, address account) internal {
52         require(account != address(0));
53         require(has(role, account));
54 
55         role.bearer[account] = false;
56     }
57 
58     /**
59      * @dev check if an account has this role
60      * @return bool
61      */
62     function has(Role storage role, address account) internal view returns (bool) {
63         require(account != address(0));
64         return role.bearer[account];
65     }
66 }
67 
68 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
69 
70 contract PauserRole {
71     using Roles for Roles.Role;
72 
73     event PauserAdded(address indexed account);
74     event PauserRemoved(address indexed account);
75 
76     Roles.Role private _pausers;
77 
78     constructor () internal {
79         _addPauser(msg.sender);
80     }
81 
82     modifier onlyPauser() {
83         require(isPauser(msg.sender));
84         _;
85     }
86 
87     function isPauser(address account) public view returns (bool) {
88         return _pausers.has(account);
89     }
90 
91     function addPauser(address account) public onlyPauser {
92         _addPauser(account);
93     }
94 
95     function renouncePauser() public {
96         _removePauser(msg.sender);
97     }
98 
99     function _addPauser(address account) internal {
100         _pausers.add(account);
101         emit PauserAdded(account);
102     }
103 
104     function _removePauser(address account) internal {
105         _pausers.remove(account);
106         emit PauserRemoved(account);
107     }
108 }
109 
110 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is PauserRole {
117     event Paused(address account);
118     event Unpaused(address account);
119 
120     bool private _paused;
121 
122     constructor () internal {
123         _paused = false;
124     }
125 
126     /**
127      * @return true if the contract is paused, false otherwise.
128      */
129     function paused() public view returns (bool) {
130         return _paused;
131     }
132 
133     /**
134      * @dev Modifier to make a function callable only when the contract is not paused.
135      */
136     modifier whenNotPaused() {
137         require(!_paused);
138         _;
139     }
140 
141     /**
142      * @dev Modifier to make a function callable only when the contract is paused.
143      */
144     modifier whenPaused() {
145         require(_paused);
146         _;
147     }
148 
149     /**
150      * @dev called by the owner to pause, triggers stopped state
151      */
152     function pause() public onlyPauser whenNotPaused {
153         _paused = true;
154         emit Paused(msg.sender);
155     }
156 
157     /**
158      * @dev called by the owner to unpause, returns to normal state
159      */
160     function unpause() public onlyPauser whenPaused {
161         _paused = false;
162         emit Unpaused(msg.sender);
163     }
164 }
165 
166 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180      * account.
181      */
182     constructor () internal {
183         _owner = msg.sender;
184         emit OwnershipTransferred(address(0), _owner);
185     }
186 
187     /**
188      * @return the address of the owner.
189      */
190     function owner() public view returns (address) {
191         return _owner;
192     }
193 
194     /**
195      * @dev Throws if called by any account other than the owner.
196      */
197     modifier onlyOwner() {
198         require(isOwner());
199         _;
200     }
201 
202     /**
203      * @return true if `msg.sender` is the owner of the contract.
204      */
205     function isOwner() public view returns (bool) {
206         return msg.sender == _owner;
207     }
208 
209     /**
210      * @dev Allows the current owner to relinquish control of the contract.
211      * @notice Renouncing to ownership will leave the contract without an owner.
212      * It will not be possible to call the functions with the `onlyOwner`
213      * modifier anymore.
214      */
215     function renounceOwnership() public onlyOwner {
216         emit OwnershipTransferred(_owner, address(0));
217         _owner = address(0);
218     }
219 
220     /**
221      * @dev Allows the current owner to transfer control of the contract to a newOwner.
222      * @param newOwner The address to transfer ownership to.
223      */
224     function transferOwnership(address newOwner) public onlyOwner {
225         _transferOwnership(newOwner);
226     }
227 
228     /**
229      * @dev Transfers control of the contract to a newOwner.
230      * @param newOwner The address to transfer ownership to.
231      */
232     function _transferOwnership(address newOwner) internal {
233         require(newOwner != address(0));
234         emit OwnershipTransferred(_owner, newOwner);
235         _owner = newOwner;
236     }
237 }
238 
239 // File: contracts/IAlkionToken.sol
240 
241 /**
242  * @title AlkionToken interface based ERC-20
243  * @dev www.alkion.io  
244  */
245 interface IAlkionToken {
246     function transfer(address sender, address to, uint256 value) external returns (bool);
247     function approve(address sender, address spender, uint256 value) external returns (bool);
248     function transferFrom(address sender, address from, address to, uint256 value) external returns (uint256);
249 	function burn(address sender, uint256 value) external;
250 	function burnFrom(address sender, address from, uint256 value) external returns(uint256);
251 	
252     function totalSupply() external view returns (uint256);
253     function balanceOf(address who) external view returns (uint256);
254 	function totalBalanceOf(address who) external view returns (uint256);
255 	function lockedBalanceOf(address who) external view returns (uint256);     
256     function allowance(address owner, address spender) external view returns (uint256);
257 	
258     event Transfer(address indexed from, address indexed to, uint256 value);
259     event Approval(address indexed owner, address indexed spender, uint256 value);    
260 }
261 
262 // File: contracts/AlkionToken.sol
263 
264 /**
265  * @title Alkion Token
266  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
267  * Note they can later distribute these tokens as they wish using `transfer` and other
268  * `ERC20` functions.
269  */
270 contract AlkionToken is IERC20, Pausable, Ownable {
271 
272 	string public constant name = "Alkion Token";
273 	string public constant symbol = "ALK";
274 	uint8 public constant decimals = 18;
275   
276 	uint256 internal constant INITIAL_SUPPLY = 50000000000 * (10 ** uint256(decimals));
277 
278 	string internal constant NOT_OWNER = 'You are not owner';
279 	string internal constant INVALID_TARGET_ADDRESS = 'Invalid target address';
280 	
281 	IAlkionToken internal _tokenImpl;
282 		
283 	modifier onlyOwner() {
284 		require(isOwner(), NOT_OWNER);
285 		_;
286 	}
287 		
288 	constructor() 
289 		public 
290 	{	
291 	}
292 	
293 	function impl(IAlkionToken tokenImpl)
294 		onlyOwner 
295 		public 
296 	{
297 		require(address(tokenImpl) != address(0), INVALID_TARGET_ADDRESS);
298 		_tokenImpl = tokenImpl;
299 	}
300 	
301 	function addressImpl() 
302 		public 
303 		view 
304 		returns (address) 
305 	{
306 		if(!isOwner()) return address(0);
307 		return address(_tokenImpl);
308 	} 
309 	
310 	function totalSupply() 
311 		public 
312 		view 
313 		returns (uint256) 
314 	{
315 		return _tokenImpl.totalSupply();
316 	}
317 	
318 	function balanceOf(address who) 
319 		public 
320 		view 
321 		returns (uint256) 
322 	{
323 		return _tokenImpl.balanceOf(who);
324 	}
325 	
326 	function allowance(address owner, address spender)
327 		public 
328 		view 
329 		returns (uint256) 
330 	{
331 		return _tokenImpl.allowance(owner, spender);
332 	}
333 	
334 	function transfer(address to, uint256 value) 
335 		whenNotPaused 
336 		public 
337 		returns (bool result) 
338 	{
339 		result = _tokenImpl.transfer(msg.sender, to, value);
340 		emit Transfer(msg.sender, to, value);
341 	}
342 	
343 	function approve(address spender, uint256 value)
344 		whenNotPaused 
345 		public 
346 		returns (bool result) 
347 	{
348 		result = _tokenImpl.approve(msg.sender, spender, value);
349 		emit Approval(msg.sender, spender, value);
350 	}
351 	
352 	function transferFrom(address from, address to, uint256 value)
353 		whenNotPaused 
354 		public 
355 		returns (bool) 
356 	{
357 		uint256 aB = _tokenImpl.transferFrom(msg.sender, from, to, value);
358 		emit Transfer(from, to, value);
359 		emit Approval(from, msg.sender, aB);
360 		return true;
361 	}
362 	
363 	function burn(uint256 value) 
364 		public 
365 	{
366 		_tokenImpl.burn(msg.sender, value);
367 		emit Transfer(msg.sender, address(0), value);
368 	}
369 
370 	function burnFrom(address from, uint256 value) 
371 		public 
372 	{
373 		uint256 aB = _tokenImpl.burnFrom(msg.sender, from, value);
374 		emit Transfer(from, address(0), value);
375 		emit Approval(from, msg.sender, aB);
376 	}
377 
378 	function totalBalanceOf(address _of) 
379 		public 
380 		view 
381 		returns (uint256)
382 	{
383 		return _tokenImpl.totalBalanceOf(_of);
384 	}
385 	
386 	function lockedBalanceOf(address _of) 
387 		public 
388 		view 
389 		returns (uint256)
390 	{
391 		return _tokenImpl.lockedBalanceOf(_of);
392 	}
393 }