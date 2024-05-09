1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-10
3 */
4 
5 pragma solidity ^ 0.4.26;
6 
7 
8 library SafeMath {
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 contract Context {
68     constructor() internal {}
69 
70     function _msgSender() internal view returns(address) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view returns(bytes memory) {
75         this;
76         return msg.data;
77     }
78 }
79 
80 contract Ownable is Context {
81     address internal _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /**
86      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87      * account.
88      */
89     constructor () internal {
90         _owner = msg.sender;
91         emit OwnershipTransferred(address(0), _owner);
92     }
93 
94     /**
95      * @return the address of the owner.
96      */
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(isOwner());
106         _;
107     }
108 
109     /**
110      * @return true if `msg.sender` is the owner of the contract.
111      */
112     function isOwner() public view returns (bool) {
113         return msg.sender == _owner;
114     }
115 
116     /**
117      * @dev Allows the current owner to relinquish control of the contract.
118      * @notice Renouncing to ownership will leave the contract without an owner.
119      * It will not be possible to call the functions with the `onlyOwner`
120      * modifier anymore.
121      */
122     function renounceOwnership() public onlyOwner {
123         emit OwnershipTransferred(_owner, address(0));
124         _owner = address(0);
125     }
126 
127     /**
128      * @dev Allows the current owner to transfer control of the contract to a newOwner.
129      * @param newOwner The address to transfer ownership to.
130      */
131     function transferOwnership(address newOwner) public onlyOwner {
132         _transferOwnership(newOwner);
133     }
134 
135     /**
136      * @dev Transfers control of the contract to a newOwner.
137      * @param newOwner The address to transfer ownership to.
138      */
139     function _transferOwnership(address newOwner) internal {
140         require(newOwner != address(0));
141         emit OwnershipTransferred(_owner, newOwner);
142         _owner = newOwner;
143     }
144 }
145 
146 library Roles {
147     struct Role {
148         mapping (address => bool) bearer;
149     }
150 
151     /**
152      * @dev give an account access to this role
153      */
154     function add(Role storage role, address account) internal {
155         require(account != address(0));
156         require(!has(role, account));
157 
158         role.bearer[account] = true;
159     }
160 
161     /**
162      * @dev remove an account's access to this role
163      */
164     function remove(Role storage role, address account) internal {
165         require(account != address(0));
166         require(has(role, account));
167 
168         role.bearer[account] = false;
169     }
170 
171     /**
172      * @dev check if an account has this role
173      * @return bool
174      */
175     function has(Role storage role, address account) internal view returns (bool) {
176         require(account != address(0));
177         return role.bearer[account];
178     }
179 }
180 
181 contract MinterRole is Context,Ownable {
182     using Roles for Roles.Role;
183 
184     event MinterAdded(address indexed account);
185     event MinterRemoved(address indexed account);
186 
187     Roles.Role private _minters;
188 
189     constructor () internal {
190         _addMinter(msg.sender);
191     }
192 
193     modifier onlyMinter() {
194         require(isMinter(msg.sender));
195         _;
196     }
197 
198     function isMinter(address account) public view returns (bool) {
199         return _minters.has(account);
200     }
201 
202     function addMinter(address account) public onlyOwner {
203         _addMinter(account);
204     }
205 
206     function renounceMinter() public {
207         _removeMinter(msg.sender);
208     }
209 
210     function _addMinter(address account) internal {
211         _minters.add(account);
212         emit MinterAdded(account);
213     }
214 
215     function _removeMinter(address account) internal {
216         _minters.remove(account);
217         emit MinterRemoved(account);
218     }
219 }
220 
221 interface IERC20 {
222     function totalSupply() external view returns (uint256);
223 
224     function balanceOf(address who) external view returns (uint256);
225 
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     function transfer(address to, uint256 value) external returns (bool);
229 
230     function approve(address spender, uint256 value) external returns (bool);
231 
232     function transferFrom(address from, address to, uint256 value) external returns (bool);
233 
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 
240 contract RVXToken is MinterRole, IERC20 {
241 
242     using SafeMath for uint256;
243     string private _name;
244     string private _symbol;
245     uint8 private _decimals;
246     mapping(address => uint256) private _balances;
247     mapping(address => mapping(address => uint256)) private _allowances;
248     uint256 private _totalSupply;
249     uint256 private _maxAmount;
250     modifier onlyPayloadSize(uint size) {
251         require(msg.data.length >= size + 4);
252         _;
253     }
254 
255     //constructor
256     constructor(address newOwner) public {
257         _owner = newOwner;
258         _addMinter(newOwner);
259         _removeMinter(msg.sender);
260         _name = "RiveX Token";
261         _symbol = "RVX";
262         _decimals = 18;
263         _totalSupply = 25000000 ether;
264         _maxAmount = 25000000 ether;
265         _balances[newOwner] = 25000000 ether;
266     }
267 
268 
269 
270     function drainToken(address _token) onlyOwner public { //owner can withdraw tokens from contract in case of wrong sending
271         IERC20 token =  IERC20(_token);
272         uint256 tokenBalance = token.balanceOf(this);
273         token.transfer(_owner, tokenBalance);
274     }
275 
276     function mint(address account, uint256 amount) public onlyMinter returns(bool) {
277         require(amount>0);
278         require(_totalSupply.add(amount)<=_maxAmount);
279         _mint(account, amount);
280         return true;
281     }
282     
283     function burn(uint256 amount) public onlyMinter returns(bool) {
284         _burn(msg.sender, amount);
285         return true;
286     }
287 
288     function name() public view returns(string memory) {
289         return _name;
290     }
291 
292     function symbol() public view returns(string memory) {
293         return _symbol;
294     }
295 
296     function decimals() public view returns(uint8) {
297         return _decimals;
298     }
299 
300     function totalSupply() public view returns(uint256) {
301         return _totalSupply;
302     }
303 
304     function balanceOf(address account) public view returns(uint256) {
305         return _balances[account];
306     }
307 
308     function transfer(address recipient, uint256 amount) public returns(bool) {
309         _transfer(msg.sender, recipient, amount);
310         return true;
311     }
312 
313     function allowance(address owner, address spender) public view returns(uint256) {
314         return _allowances[owner][spender];
315     }
316 
317     function approve(address spender, uint256 amount) public returns(bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     function transferFrom(address from, address to, uint256 value) public onlyPayloadSize( 2*32) returns (bool) {
323         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
324         _transfer(from, to, value);
325         emit Approval(from, msg.sender, _allowances[from][msg.sender]);
326         return true;
327     }
328     function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
329         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
330         return true;
331     }
332 
333    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
334         require(spender != address(0));
335 
336         _allowances[msg.sender][spender] = _allowances[msg.sender][spender].sub(subtractedValue);
337         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
338         return true;
339     }
340 
341   function _transfer(address from, address to, uint256 value) internal onlyPayloadSize( 2*32) {
342         require(to != address(0));
343 
344         _balances[from] = _balances[from].sub(value);
345         _balances[to] = _balances[to].add(value);
346         emit Transfer(from, to, value);
347     }
348 
349     function _mint(address account, uint256 amount) internal {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _totalSupply = _totalSupply.add(amount);
353         _balances[account] = _balances[account].add(amount);
354         emit Transfer(address(0), account, amount);
355     }
356 
357     function _burn(address account, uint256 value) internal {
358         require(account != address(0));
359 
360         _totalSupply = _totalSupply.sub(value);
361         _balances[account] = _balances[account].sub(value);
362         emit Transfer(account, address(0), value);
363     }
364 
365     function _approve(address owner, address spender, uint256 amount) internal {
366         require(owner != address(0), "ERC20: approve from the zero address");
367         require(spender != address(0), "ERC20: approve to the zero address");
368 
369         _allowances[owner][spender] = amount;
370         emit Approval(owner, spender, amount);
371     }
372 
373 }