1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         require(b <= a);
11         uint256 c = a - b;
12 
13         return c;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a);
19 
20         return c;
21     }
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor () internal {
35         _owner = msg.sender;
36         emit OwnershipTransferred(address(0), _owner);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(isOwner(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     function isOwner() public view returns (bool) {
49         return msg.sender == _owner;
50     }
51 
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://eips.ethereum.org/EIPS/eip-20
67  */
68 interface IERC20 {
69     function transfer(address to, uint256 value) external returns (bool);
70     function approve(address spender, uint256 value) external returns (bool);
71     function transferFrom(address from, address to, uint256 value) external returns (bool);
72     function totalSupply() external view returns (uint256);
73     function balanceOf(address who) external view returns (uint256);
74     function allowance(address owner, address spender) external view returns (uint256);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @title Standard ERC20 token
81  *
82  * @dev Implementation of the basic standard token.
83  * See https://eips.ethereum.org/EIPS/eip-20
84  */
85 contract ERC20 is IERC20 {
86     using SafeMath for uint256;
87 
88     mapping (address => uint256) private _balances;
89 
90     mapping (address => mapping (address => uint256)) private _allowed;
91 
92     uint256 private _totalSupply;
93 
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     function balanceOf(address owner) public view returns (uint256) {
99         return _balances[owner];
100     }
101 
102     function allowance(address owner, address spender) public view returns (uint256) {
103         return _allowed[owner][spender];
104     }
105 
106     function transfer(address to, uint256 value) public returns (bool) {
107         _transfer(msg.sender, to, value);
108         return true;
109     }
110 
111     function approve(address spender, uint256 value) public returns (bool) {
112         _approve(msg.sender, spender, value);
113         return true;
114     }
115 
116     function transferFrom(address from, address to, uint256 value) public returns (bool) {
117         _transfer(from, to, value);
118         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
119         return true;
120     }
121 
122     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
123         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
124         return true;
125     }
126 
127     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
128         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
129         return true;
130     }
131 
132     function _transfer(address from, address to, uint256 value) internal {
133         require(to != address(0));
134 
135         _balances[from] = _balances[from].sub(value);
136         _balances[to] = _balances[to].add(value);
137         emit Transfer(from, to, value);
138     }
139 
140     function _mint(address account, uint256 value) internal {
141         require(account != address(0));
142 
143         _totalSupply = _totalSupply.add(value);
144         _balances[account] = _balances[account].add(value);
145         emit Transfer(address(0), account, value);
146     }
147 
148     function _burn(address account, uint256 value) internal {
149         require(account != address(0));
150 
151         _totalSupply = _totalSupply.sub(value);
152         _balances[account] = _balances[account].sub(value);
153         emit Transfer(account, address(0), value);
154     }
155 
156     function _approve(address owner, address spender, uint256 value) internal {
157         require(spender != address(0));
158         require(owner != address(0));
159 
160         _allowed[owner][spender] = value;
161         emit Approval(owner, spender, value);
162     }
163 
164 }
165 
166 /**
167  * @title ApproveAndCall Interface.
168  * @dev ApproveAndCall system allows to communicate with smart-contracts.
169  */
170 contract ApproveAndCallFallBack {
171     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
172 }
173 
174 /**
175  * @dev Extension of `ERC20` that allows onwer to destroy his own
176  * tokens.
177  */
178 contract BurnableToken is ERC20, Ownable {
179 
180      /**
181       * @dev Allows to burn a specific amount of tokens to the owner.
182       * @param value The amount of token to be burned.
183       */
184      function burn(uint256 value) public onlyOwner {
185          _burn(msg.sender, value);
186      }
187 
188 }
189 
190 /**
191  * @title LockableToken.
192  * @dev Extension of `ERC20` that allows to lock an amount of tokens of specific
193  * addresses for specific time.
194  * @author https://grox.solutions
195  */
196 contract LockableToken is BurnableToken {
197 
198     // stopped state to allow to lock tokens
199     bool private _started;
200 
201     // variables to store info about locked addresses
202     mapping(address => Lock) private _locked;
203     struct Lock {
204         bool locked;
205         Batch[] batches;
206     }
207     struct Batch {
208         uint256 amount;
209         uint256 time;
210     }
211 
212     /**
213      * @dev Allows to lock an amount of tokens of specific addresses.
214      * Available only to the owner.
215      * Can be called once.
216      * @param addresses array of addresses.
217      * @param values array of amounts of tokens.
218      * @param times array of Unix times.
219      */
220     function lock(address[] calldata addresses, uint256[] calldata values, uint256[] calldata times) external onlyOwner {
221         require(!_started);
222         require(addresses.length == values.length && values.length == times.length);
223 
224         for (uint256 i = 0; i < addresses.length; i++) {
225             require(balanceOf(addresses[i]) >= values[i]);
226 
227             if (!_locked[addresses[i]].locked) {
228                 _locked[addresses[i]].locked = true;
229             }
230 
231             _locked[addresses[i]].batches.push(Batch(values[i], block.timestamp + times[i]));
232 
233             if (_locked[addresses[i]].batches.length > 1) {
234                 assert(
235                     _locked[addresses[i]].batches[_locked[addresses[i]].batches.length - 1].amount
236                     < _locked[addresses[i]].batches[_locked[addresses[i]].batches.length - 2].amount
237                     &&
238                     _locked[addresses[i]].batches[_locked[addresses[i]].batches.length - 1].time
239                     > _locked[addresses[i]].batches[_locked[addresses[i]].batches.length - 2].time
240                 );
241             }
242         }
243 
244         _started = true;
245     }
246 
247     /**
248      * @dev modified internal transfer function that prevents any transfer of locked tokens.
249      * @param from address The address which you want to send tokens from
250      * @param to The address to transfer to.
251      * @param value The amount to be transferred.
252      */
253     function _transfer(address from, address to, uint256 value) internal {
254         if (_locked[from].locked) {
255             for (uint256 i = 0; i < _locked[from].batches.length; i++) {
256                 if (block.timestamp <= _locked[from].batches[i].time) {
257                     require(value <= balanceOf(from).sub(_locked[from].batches[i].amount));
258                     break;
259                 }
260             }
261         }
262         super._transfer(from, to, value);
263     }
264 
265     /**
266      * @return true if locking is done.
267      */
268     function started() external view returns(bool) {
269         return _started;
270     }
271 
272 }
273 
274 
275 
276 /**
277  * @title The main project contract.
278  * @author https://grox.solutions
279  */
280 contract DOMToken is LockableToken {
281 
282     // name of the token
283     string private _name = "Diamond Open Market";
284     // symbol of the token
285     string private _symbol = "DOM";
286     // decimals of the token
287     uint8 private _decimals = 18;
288 
289     // initial supply
290     uint256 public constant INITIAL_SUPPLY = 6000000000  * (10 ** 18);
291 
292     /**
293       * @dev constructor function that is called once at deployment of the contract.
294       * @param recipient Address to receive initial supply.
295       */
296     constructor(address recipient) public {
297 
298         _mint(recipient, INITIAL_SUPPLY);
299 
300     }
301 
302     /**
303     * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
304     * @param spender Address of smart contracts to work with.
305     * @param amount Amount of tokens to send.
306     * @param extraData Any extra data.
307     */
308     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
309         require(approve(spender, amount));
310 
311         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
312 
313         return true;
314     }
315 
316     /**
317     * @dev Allows to any owner of the contract withdraw needed ERC20 token
318     * from this contract (promo or bounties for example).
319     * @param ERC20Token Address of ERC20 token.
320     * @param recipient Account to receive tokens.
321     */
322     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
323 
324         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
325         IERC20(ERC20Token).transfer(recipient, amount);
326 
327     }
328 
329     /**
330      * @return the name of the token.
331      */
332     function name() public view returns (string memory) {
333         return _name;
334     }
335 
336     /**
337      * @return the symbol of the token.
338      */
339     function symbol() public view returns (string memory) {
340         return _symbol;
341     }
342 
343     /**
344      * @return the number of decimals of the token.
345      */
346     function decimals() public view returns (uint8) {
347         return _decimals;
348     }
349 
350 }