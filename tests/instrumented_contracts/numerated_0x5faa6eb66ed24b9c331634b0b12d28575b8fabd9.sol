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
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     constructor () internal {
39         _owner = msg.sender;
40         emit OwnershipTransferred(address(0), _owner);
41     }
42 
43     /**
44      * @return the address of the owner.
45      */
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(isOwner(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     /**
59      * @return true if `msg.sender` is the owner of the contract.
60      */
61     function isOwner() public view returns (bool) {
62         return msg.sender == _owner;
63     }
64 
65     /**
66      * @dev Allows the current owner to relinquish control of the contract.
67      * It will not be possible to call the functions with the `onlyOwner`
68      * modifier anymore.
69      * @notice Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://eips.ethereum.org/EIPS/eip-20
99  */
100 interface IERC20 {
101     function transfer(address to, uint256 value) external returns (bool);
102     function approve(address spender, uint256 value) external returns (bool);
103     function transferFrom(address from, address to, uint256 value) external returns (bool);
104     function totalSupply() external view returns (uint256);
105     function balanceOf(address who) external view returns (uint256);
106     function allowance(address owner, address spender) external view returns (uint256);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * See https://eips.ethereum.org/EIPS/eip-20
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
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address owner) public view returns (uint256) {
131         return _balances[owner];
132     }
133 
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowed[owner][spender];
136     }
137 
138     function transfer(address to, uint256 value) public returns (bool) {
139         _transfer(msg.sender, to, value);
140         return true;
141     }
142 
143     function approve(address spender, uint256 value) public returns (bool) {
144         _approve(msg.sender, spender, value);
145         return true;
146     }
147 
148     function transferFrom(address from, address to, uint256 value) public returns (bool) {
149         _transfer(from, to, value);
150         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
151         return true;
152     }
153 
154     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
155         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
156         return true;
157     }
158 
159     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
160         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
161         return true;
162     }
163 
164     function _transfer(address from, address to, uint256 value) internal {
165         require(to != address(0));
166 
167         _balances[from] = _balances[from].sub(value);
168         _balances[to] = _balances[to].add(value);
169         emit Transfer(from, to, value);
170     }
171 
172     function _mint(address account, uint256 value) internal {
173         require(account != address(0));
174 
175         _totalSupply = _totalSupply.add(value);
176         _balances[account] = _balances[account].add(value);
177         emit Transfer(address(0), account, value);
178     }
179 
180     function _burn(address account, uint256 value) internal {
181         require(account != address(0));
182 
183         _totalSupply = _totalSupply.sub(value);
184         _balances[account] = _balances[account].sub(value);
185         emit Transfer(account, address(0), value);
186     }
187 
188     function _approve(address owner, address spender, uint256 value) internal {
189         require(spender != address(0));
190         require(owner != address(0));
191 
192         _allowed[owner][spender] = value;
193         emit Approval(owner, spender, value);
194     }
195 
196 }
197 
198 /**
199  * @title ApproveAndCall Interface.
200  * @dev ApproveAndCall system allows to communicate with smart-contracts.
201  */
202 contract ApproveAndCallFallBack {
203     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
204 }
205 
206 /**
207  * @title The main project contract.
208  * @author https://grox.solutions
209  */
210 contract ETAOToken is ERC20, Ownable {
211 
212     // name of the token
213     string private _name = "E-TAO";
214     // symbol of the token
215     string private _symbol = "ETAO";
216     // decimals of the token
217     uint8 private _decimals = 18;
218 
219     // initial supply
220     uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** 18);
221 
222     /**
223       * @dev constructor function that is called once at deployment of the contract.
224       * @param recipient Address to receive initial supply.
225       */
226     constructor(address recipient) public {
227 
228         _mint(recipient, INITIAL_SUPPLY);
229 
230     }
231 
232     /**
233      * @dev Allows to burn a specific amount of tokens to the owner.
234      * @param value The amount of token to be burned.
235      */
236     function burn(uint256 value) public onlyOwner {
237         _burn(msg.sender, value);
238     }
239 
240     /**
241     * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
242     * @param spender Address of smart contracts to work with.
243     * @param amount Amount of tokens to send.
244     * @param extraData Any extra data.
245     */
246     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
247         require(approve(spender, amount));
248 
249         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
250 
251         return true;
252     }
253 
254     /**
255     * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
256     * @param ERC20Token Address of ERC20 token.
257     * @param recipient Account to receive tokens.
258     */
259     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
260 
261         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
262         IERC20(ERC20Token).transfer(recipient, amount);
263 
264     }
265 
266     /**
267      * @return the name of the token.
268      */
269     function name() public view returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @return the symbol of the token.
275      */
276     function symbol() public view returns (string memory) {
277         return _symbol;
278     }
279 
280     /**
281      * @return the number of decimals of the token.
282      */
283     function decimals() public view returns (uint8) {
284         return _decimals;
285     }
286 
287 }