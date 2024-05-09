1 pragma solidity ^ 0.4.26;
2 
3 
4 library SafeMath {
5     /**
6     * @dev Multiplies two numbers, reverts on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Solidity only automatically asserts when dividing by 0
27         require(b > 0);
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two numbers, reverts on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56     * reverts when dividing by zero.
57     */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 contract Context {
64     constructor() internal {}
65 
66     function _msgSender() internal view returns(address) {
67         return msg.sender;
68     }
69 
70     function _msgData() internal view returns(bytes memory) {
71         this;
72         return msg.data;
73     }
74 }
75 
76 contract Ownable is Context {
77     address internal _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 library Roles {
143     struct Role {
144         mapping (address => bool) bearer;
145     }
146 
147     /**
148      * @dev give an account access to this role
149      */
150     function add(Role storage role, address account) internal {
151         require(account != address(0));
152         require(!has(role, account));
153 
154         role.bearer[account] = true;
155     }
156 
157     /**
158      * @dev remove an account's access to this role
159      */
160     function remove(Role storage role, address account) internal {
161         require(account != address(0));
162         require(has(role, account));
163 
164         role.bearer[account] = false;
165     }
166 
167     /**
168      * @dev check if an account has this role
169      * @return bool
170      */
171     function has(Role storage role, address account) internal view returns (bool) {
172         require(account != address(0));
173         return role.bearer[account];
174     }
175 }
176 
177 contract MinterRole is Context,Ownable {
178     using Roles for Roles.Role;
179 
180     event MinterAdded(address indexed account);
181     event MinterRemoved(address indexed account);
182 
183     Roles.Role private _minters;
184 
185     constructor () internal {
186         _addMinter(msg.sender);
187     }
188 
189     modifier onlyMinter() {
190         require(isMinter(msg.sender));
191         _;
192     }
193 
194     function isMinter(address account) public view returns (bool) {
195         return _minters.has(account);
196     }
197 
198     function addMinter(address account) public onlyOwner {
199         _addMinter(account);
200     }
201 
202     function renounceMinter() public {
203         _removeMinter(msg.sender);
204     }
205 
206     function _addMinter(address account) internal {
207         _minters.add(account);
208         emit MinterAdded(account);
209     }
210 
211     function _removeMinter(address account) internal {
212         _minters.remove(account);
213         emit MinterRemoved(account);
214     }
215 }
216 
217 interface IERC20 {
218     function totalSupply() external view returns (uint256);
219 
220     function balanceOf(address who) external view returns (uint256);
221 
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     function transfer(address to, uint256 value) external returns (bool);
225 
226     function approve(address spender, uint256 value) external returns (bool);
227 
228     function transferFrom(address from, address to, uint256 value) external returns (bool);
229 
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 
236 contract rRVXToken is MinterRole, IERC20 {
237 
238     using SafeMath for uint256;
239     string private _name;
240     string private _symbol;
241     uint8 private _decimals;
242     mapping(address => uint256) private _balances;
243     mapping(address => mapping(address => uint256)) private _allowances;
244     uint256 private _totalSupply;
245     uint256 private _maxAmount;
246     modifier onlyPayloadSize(uint size) {
247         require(msg.data.length >= size + 4);
248         _;
249     }
250 
251     //constructor
252     constructor() public {
253         _owner = msg.sender;
254         _name = "Yield Bearing RVX";
255         _symbol = "rRVX";
256         _decimals = 18;
257     }
258 
259 
260 
261     function drainToken(address _token) onlyOwner public { //owner can withdraw tokens from contract in case of wrong sending
262         IERC20 token =  IERC20(_token);
263         uint256 tokenBalance = token.balanceOf(this);
264         token.transfer(_owner, tokenBalance);
265     }
266 
267     function mint(address account, uint256 amount) public onlyMinter returns(bool) {
268         require(amount>0);
269         _mint(account, amount);
270         return true;
271     }
272     
273     function burn(address _address,uint256 amount) public onlyMinter returns(bool) {
274         require(amount > 0);
275         _burn(_address, amount);
276         return true;
277     }
278 
279     function name() public view returns(string memory) {
280         return _name;
281     }
282 
283     function symbol() public view returns(string memory) {
284         return _symbol;
285     }
286 
287     function decimals() public view returns(uint8) {
288         return _decimals;
289     }
290 
291     function totalSupply() public view returns(uint256) {
292         return _totalSupply;
293     }
294 
295     function balanceOf(address account) public view returns(uint256) {
296         return _balances[account];
297     }
298 
299     function transfer(address recipient, uint256 amount) public returns(bool) {
300         _transfer(msg.sender, recipient, amount);
301         return true;
302     }
303 
304     function allowance(address owner, address spender) public view returns(uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     function approve(address spender, uint256 amount) public returns(bool) {
309         _approve(_msgSender(), spender, amount);
310         return true;
311     }
312 
313     function transferFrom(address from, address to, uint256 value) public onlyPayloadSize( 2*32) returns (bool) {
314         _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
315         _transfer(from, to, value);
316         emit Approval(from, msg.sender, _allowances[from][msg.sender]);
317         return true;
318     }
319     function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
321         return true;
322     }
323 
324    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
325         require(spender != address(0));
326 
327         _allowances[msg.sender][spender] = _allowances[msg.sender][spender].sub(subtractedValue);
328         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
329         return true;
330     }
331 
332   function _transfer(address from, address to, uint256 value) internal onlyPayloadSize( 2*32) {
333         require(to != address(0));
334 
335         _balances[from] = _balances[from].sub(value);
336         _balances[to] = _balances[to].add(value);
337         emit Transfer(from, to, value);
338     }
339 
340     function _mint(address account, uint256 amount) internal {
341         require(account != address(0), "ERC20: mint to the zero address");
342 
343         _totalSupply = _totalSupply.add(amount);
344         _balances[account] = _balances[account].add(amount);
345         emit Transfer(address(0), account, amount);
346     }
347 
348     function _burn(address account, uint256 value) internal {
349         require(account != address(0));
350 
351         _totalSupply = _totalSupply.sub(value);
352         _balances[account] = _balances[account].sub(value);
353         emit Transfer(account, address(0), value);
354     }
355 
356     function _approve(address owner, address spender, uint256 amount) internal {
357         require(owner != address(0), "ERC20: approve from the zero address");
358         require(spender != address(0), "ERC20: approve to the zero address");
359 
360         _allowances[owner][spender] = amount;
361         emit Approval(owner, spender, amount);
362     }
363 
364 }