1 pragma solidity >=0.4.21 <0.6.0;
2 
3 contract AdminRole {
4     using Roles for Roles.Role;
5 
6     event AdminAdded(address indexed account);
7     event AdminRemoved(address indexed account);
8 
9     Roles.Role private _Admins;
10     address private _owner;
11 
12     constructor () internal {
13         _addAdmin(msg.sender);
14         _owner = msg.sender;
15     }
16 
17     modifier onlyAdmin() {
18         require(isAdmin(msg.sender));
19         _;
20     }
21 
22     modifier onlyOwner() {
23         require(msg.sender == _owner);
24         _;
25     }
26 
27     function addAdmin(address account) public onlyOwner {
28         _addAdmin(account);
29     }
30 
31     function removeAdmin(address account) public onlyOwner {
32         _removeAdmin(account);
33     }
34 
35     function transferOwnership(address account) public onlyOwner returns (bool) {
36         _Admins.add(account);
37         _owner = account;
38         return true;
39     }
40 
41     function isAdmin(address account) public view returns (bool) {
42         return _Admins.has(account);
43     }
44 
45     function _addAdmin(address account) internal {
46         _Admins.add(account);
47         emit AdminAdded(account);
48     }
49 
50     function _removeAdmin(address account) internal {
51         _Admins.remove(account);
52         emit AdminRemoved(account);
53     }
54 }
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address who) external view returns (uint256);
60 
61     function transfer(address to, uint256 value) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract Equity is IERC20, AdminRole {
67 
68     using SafeMath for uint256;
69 
70     mapping (address => uint256) private _balances;
71 
72     string private _name;
73     string private _symbol;
74     uint8  private _decimals;
75     uint256 private _totalSupply;
76     string private _contractHash;
77     string private _contractUrl;
78 
79     constructor (
80         string memory name, 
81         string memory symbol, 
82         uint8 decimals,
83         string memory contractHash, 
84         string memory contractUrl) public {
85 
86         _name = name;
87         _symbol = symbol;
88         _decimals = decimals;
89         _totalSupply = 0;
90         _contractHash = contractHash;
91         _contractUrl = contractUrl;
92     }
93 
94     /**
95      * @return the name of the token.
96      */
97     function name() public view returns (string memory) {
98         return _name;
99     }
100 
101     /**
102      * @return the symbol of the token.
103      */
104     function symbol() public view returns (string memory) {
105         return _symbol;
106     }
107 
108     /**
109      * @return the number of decimals of the token.
110      */
111     function decimals() public view returns (uint8) {
112         return _decimals;
113     }
114 
115     /**
116     * @dev Total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121             
122     /**
123      * @return the contractHash
124      */
125     function contractHash() public view returns (string memory) {
126         return _contractHash;
127     }
128 
129      /**
130      * @return the contractUrl
131      */
132     function contractUrl() public view returns (string memory) {
133         return _contractUrl;
134     }
135 
136     /**
137     * @dev Gets the balance of the specified address.
138     * @param owner The address to query the balance of.
139     * @return An uint256 representing the amount owned by the passed address.
140     */
141     function balanceOf(address owner) public view returns (uint256) {
142         return _balances[owner];
143     }
144 
145     /**
146     * @dev Destroy the contract
147     */
148     function Destroy() public onlyAdmin returns (bool) {
149         selfdestruct(msg.sender);
150         return true;
151     }
152 
153     /**
154     * @dev Transfer token for a specified address
155     * @param to The address to transfer to.
156     * @param value The amount to be transferred.
157     */
158     function transfer(address to, uint256 value) public returns (bool) {
159         _transfer(msg.sender, to, value);
160         return true;
161     }
162 
163     /**
164     * @dev sudo Transfer tokens
165     * @param from The address to transfer from.
166     * @param to The address to transfer to.1
167     * @param value The amount to be transferred.
168     */
169     function sudoTransfer(address from, address to, uint256 value) public onlyAdmin returns (bool) {
170         _transfer(from, to, value);
171         return true;
172     }
173 
174     /**
175     * @dev Mint tokens
176     * @param to The address to mint in.
177     * @param value The amount to be minted.
178     */
179     function Mint(address to, uint256 value) public onlyAdmin returns (bool) {
180         _mint(to, value);
181         return true;
182     }
183 
184     /**
185     * @dev Burn tokens
186     * @param from The address to burn in.
187     * @param value The amount to be burned.
188     */
189     function Burn(address from, uint256 value) public onlyAdmin returns (bool) {
190         _burn(from, value);
191         return true;
192     }
193 
194     /**
195      * @dev set the contract URL
196      * @param newContractUrl The new contract URL.
197      */
198     function setContractUrl(string memory newContractUrl) public onlyAdmin returns (bool) {
199         _contractUrl = newContractUrl;
200         return true;
201     }
202 
203     /**
204     * @dev Transfer token for a specified addresses
205     * @param from The address to transfer from.
206     * @param to The address to transfer to.
207     * @param value The amount to be transferred.
208     */
209     function _transfer(address from, address to, uint256 value) internal {
210         require(to != address(0),"0x0 Address");
211 
212         _balances[from] = _balances[from].sub(value);
213         _balances[to] = _balances[to].add(value);
214         emit Transfer(from, to, value);
215     }
216 
217     /**
218      * @dev Internal function that mints an amount of the token and assigns it to
219      * an account. This encapsulates the modification of balances such that the
220      * proper events are emitted.
221      * @param account The account that will receive the created tokens.
222      * @param value The amount that will be created.
223      */
224     function _mint(address account, uint256 value) internal {
225         require(account != address(0),"0x0 Address");
226 
227         _totalSupply = _totalSupply.add(value);
228         _balances[account] = _balances[account].add(value);
229         emit Transfer(address(0), account, value);
230     }
231 
232     /**
233      * @dev Internal function that burns an amount of the token of a given
234      * account.
235      * @param account The account whose tokens will be burnt.
236      * @param value The amount that will be burnt.
237      */
238     function _burn(address account, uint256 value) internal {
239         require(account != address(0),"0x0 Address");
240 
241         _totalSupply = _totalSupply.sub(value);
242         _balances[account] = _balances[account].sub(value);
243         emit Transfer(account, address(0), value);
244     }
245 }
246 
247 library Roles {
248     struct Role {
249         mapping (address => bool) bearer;
250     }
251 
252     /**
253      * @dev give an account access to this role
254      */
255     function add(Role storage role, address account) internal {
256         require(account != address(0));
257         require(!has(role, account));
258 
259         role.bearer[account] = true;
260     }
261 
262     /**
263      * @dev remove an account's access to this role
264      */
265     function remove(Role storage role, address account) internal {
266         require(account != address(0));
267         require(has(role, account));
268 
269         role.bearer[account] = false;
270     }
271 
272     /**
273      * @dev check if an account has this role
274      * @return bool
275      */
276     function has(Role storage role, address account) internal view returns (bool) {
277         require(account != address(0));
278         return role.bearer[account];
279     }
280 }
281 
282 library SafeMath {
283     /**
284     * @dev Multiplies two unsigned integers, reverts on overflow.
285     */
286     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
288         // benefit is lost if 'b' is also tested.
289         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
290         if (a == 0) {
291             return 0;
292         }
293 
294         uint256 c = a * b;
295         require(c / a == b);
296 
297         return c;
298     }
299 
300     /**
301     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
302     */
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         // Solidity only automatically asserts when dividing by 0
305         require(b > 0);
306         uint256 c = a / b;
307         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308 
309         return c;
310     }
311 
312     /**
313     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
314     */
315     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
316         require(b <= a);
317         uint256 c = a - b;
318 
319         return c;
320     }
321 
322     /**
323     * @dev Adds two unsigned integers, reverts on overflow.
324     */
325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
326         uint256 c = a + b;
327         require(c >= a);
328 
329         return c;
330     }
331 
332     /**
333     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
334     * reverts when dividing by zero.
335     */
336     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337         require(b != 0);
338         return a % b;
339     }
340 }