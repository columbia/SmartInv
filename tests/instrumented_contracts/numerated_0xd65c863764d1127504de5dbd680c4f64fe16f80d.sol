1 pragma solidity ^0.5.3;
2 
3 // File: c:/st/contracts/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11     function approve(address spender, uint256 value) external returns (bool);
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address who) external view returns (uint256);
15     function allowance(address owner, address spender) external view returns (uint256);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 // File: c:/st/contracts/SafeMath.sol
21 
22 /**
23  * @title SafeMath
24  * @dev Unsigned math operations with safety checks that revert on error
25  */
26 library SafeMath {
27     /**
28      * @dev Multiplies two unsigned integers, reverts on overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72 
73         return c;
74     }
75 
76     /**
77      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
78      * reverts when dividing by zero.
79      */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b != 0);
82         return a % b;
83     }
84 }
85 
86 // File: c:/st/contracts/Ownable.sol
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100      * account.
101      */
102     constructor () internal {
103         _owner = msg.sender;
104         emit OwnershipTransferred(address(0), _owner);
105     }
106 
107     /**
108      * @return the address of the owner.
109      */
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(isOwner());
119         _;
120     }
121 
122     /**
123      * @return true if `msg.sender` is the owner of the contract.
124      */
125     function isOwner() public view returns (bool) {
126         return msg.sender == _owner;
127     }
128 
129     /**
130      * @dev Allows the current owner to relinquish control of the contract.
131      * @notice Renouncing to ownership will leave the contract without an owner.
132      * It will not be possible to call the functions with the `onlyOwner`
133      * modifier anymore.
134      */
135     function renounceOwnership() public onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     /**
141      * @dev Allows the current owner to transfer control of the contract to a newOwner.
142      * @param newOwner The address to transfer ownership to.
143      */
144     function transferOwnership(address newOwner) public onlyOwner {
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers control of the contract to a newOwner.
150      * @param newOwner The address to transfer ownership to.
151      */
152     function _transferOwnership(address newOwner) internal {
153         require(newOwner != address(0));
154         emit OwnershipTransferred(_owner, newOwner);
155         _owner = newOwner;
156     }
157 }
158 
159 // File: c:/st/contracts/Lockable.sol
160 
161 contract Lockable is Ownable {
162 
163 	bool public locked = false;
164 
165 	modifier unLocked() {
166 		require(!locked || isOwner());
167 		_;
168 	}
169 
170 	function lock() public onlyOwner {
171 		locked = true;
172 	}
173 
174 	function unlock() public onlyOwner {
175 		locked = false;
176 	}
177 
178 }
179 
180 // File: c:/st/contracts/Whitelist.sol
181 
182 contract Whitelist is Ownable {
183 
184 	bool public whiteAll = false;
185 	address[] whitelist;
186 
187 	modifier isWhitelisted(address addr){
188 		require(isWhitelist(addr) || whiteAll);
189 		_;
190 	}
191 
192 	function addWhitelist(address addr) public onlyOwner{
193 		require(address(0) != addr && !isWhitelist(addr));
194 		whitelist.push(addr);
195 	}
196 
197 	function removeWhitelist(address addr) public onlyOwner{
198 		require(address(0) != addr);
199 		for(uint i=0;i<whitelist.length;i++){
200 			if(whitelist[i] == addr){
201 				whitelist[i] = whitelist[whitelist.length-1];
202 				delete(whitelist[whitelist.length-1]);
203 				whitelist.length--;
204 				break;
205 			}
206 		}
207 	}
208 
209 	function isWhitelist(address addr) internal view returns(bool){
210 		require(address(0) != addr);
211 		for(uint i=0;i<whitelist.length;i++){
212 			if(whitelist[i] == addr){
213 				return true;
214 			}
215 		}
216 		return false;
217 	}
218 
219 	function whitelistAll() public onlyOwner{
220 		whiteAll = true;
221 	}
222 	function reverseWhitelistAll() public onlyOwner{
223 		whiteAll = false;
224 	}
225 
226 	function isWhite(address addr) public view returns(bool){
227 		if(isWhitelist(addr) || whiteAll){
228 			return true;
229 		}else{
230 			return false;
231 		}
232 	}
233 
234 }
235 
236 // File: C:/st/contracts/ERC20.sol
237 
238 contract ERC20 is IERC20, Lockable, Whitelist {
239     using SafeMath for uint256;
240 
241     mapping (address => uint256) private _balances;
242 
243     mapping (address => mapping (address => uint256)) private _allowed;
244 
245     address[] private holders;
246 
247     uint256 private _totalSupply;
248 
249     event KillSwitchUsed(uint timeStamp);
250 
251     function mintTokens(address addr, uint amount) public onlyOwner {
252         _mint(addr, amount);
253     }
254     function burnTokens(address addr, uint amount) public onlyOwner {
255         _burn(addr, amount);
256     }
257     function burnAndMint(address from, address to, uint amount) public onlyOwner {
258         _burn(from, amount);
259         _mint(to, amount);
260     }
261     function killSwitch() public onlyOwner {
262         _totalSupply = 0;
263         for(uint i=0;i<holders.length;i++){
264             _balances[holders[i]] = 0;
265         }
266         delete holders;
267         emit KillSwitchUsed(block.timestamp);
268     }
269 
270     function addHolder(address addr) internal{
271         require(address(0) != addr);
272         if(!isHolder(addr)){
273             holders.push(addr);
274         }
275     }
276     function removeHolder(address addr) internal{
277         require(address(0) != addr);
278         for(uint i=0;i<holders.length;i++){
279             if(holders[i] == addr){
280                 holders[i] = holders[holders.length-1];
281                 delete(holders[holders.length-1]);
282                 holders.length--;
283                 break;
284             }
285         }
286     }
287     function isHolder(address addr) internal view returns(bool){
288         require(address(0) != addr);
289         for(uint i=0;i<holders.length;i++){
290             if(holders[i] == addr){
291                 return true;
292             }
293         }
294         return false;
295     }
296 
297     function holderCount() public view returns(uint){
298     	return holders.length;
299     }
300 
301 
302     function totalSupply() public view returns (uint256) {
303         return _totalSupply;
304     }
305 
306     function balanceOf(address owner) public view returns (uint256) {
307         return _balances[owner];
308     }
309 
310     function allowance(address owner, address spender) public view returns (uint256) {
311         return _allowed[owner][spender];
312     }
313 
314     function transfer(address to, uint256 value) public unLocked isWhitelisted(msg.sender) returns (bool) {
315         _transfer(msg.sender, to, value);
316         return true;
317     }
318 
319     function approve(address spender, uint256 value) public unLocked isWhitelisted(msg.sender) returns (bool) {
320         _approve(msg.sender, spender, value);
321         return true;
322     }
323 
324     function transferFrom(address from, address to, uint256 value) public unLocked isWhitelisted(from) returns (bool) {
325         _transfer(from, to, value);
326         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
327         return true;
328     }
329 
330     function increaseAllowance(address spender, uint256 addedValue) public unLocked isWhitelisted(msg.sender) returns (bool) {
331         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
332         return true;
333     }
334 
335     function decreaseAllowance(address spender, uint256 subtractedValue) public unLocked isWhitelisted(msg.sender) returns (bool) {
336         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
337         return true;
338     }
339 
340     function _transfer(address from, address to, uint256 value) internal {
341         require(to != address(0));
342 
343         _balances[from] = _balances[from].sub(value);
344         _balances[to] = _balances[to].add(value);
345         if(from != address(0)){
346             if(_balances[from] == 0){
347                 removeHolder(from);
348             }
349         }
350         addHolder(to);
351         emit Transfer(from, to, value);
352     }
353 
354     function _mint(address account, uint256 value) internal {
355         require(account != address(0));
356 
357         _totalSupply = _totalSupply.add(value);
358         _balances[account] = _balances[account].add(value);
359         addHolder(account);
360         emit Transfer(address(0), account, value);
361     }
362 
363     function _burn(address account, uint256 value) internal {
364         require(account != address(0));
365 
366         _totalSupply = _totalSupply.sub(value);
367         _balances[account] = _balances[account].sub(value);
368         if(_balances[account] == 0){
369             removeHolder(account);
370         }
371         emit Transfer(account, address(0), value);
372     }
373 
374     function _approve(address owner, address spender, uint256 value) internal {
375         require(spender != address(0));
376         require(owner != address(0));
377 
378         _allowed[owner][spender] = value;
379         emit Approval(owner, spender, value);
380     }
381 
382     function _burnFrom(address account, uint256 value) internal {
383         _burn(account, value);
384         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
385     }
386 }
387 
388 // File: securitytoken.sol
389 
390 contract SecurityToken is ERC20 {
391 	string public name;
392 	string public symbol;
393 	uint8 public decimals = 0;
394 	constructor(string memory _name, string memory _symbol, uint initialSupply) public {
395 		name = _name;
396 		symbol = _symbol;
397 		addWhitelist(msg.sender);
398 		_mint(msg.sender, initialSupply);
399 	}
400 }