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
30 
31     address internal _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor(address initialOwner) internal {
36         _owner = initialOwner;
37         emit OwnershipTransferred(address(0), _owner);
38     }
39 
40     function owner() public view returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(isOwner(), "Caller is not the owner");
46         _;
47     }
48 
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     function transferOwnership(address newOwner) public onlyOwner {
59         require(newOwner != address(0), "New owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://eips.ethereum.org/EIPS/eip-20
69  */
70 interface IERC20 {
71     function transfer(address to, uint256 value) external returns (bool);
72     function approve(address spender, uint256 value) external returns (bool);
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74     function totalSupply() external view returns (uint256);
75     function balanceOf(address who) external view returns (uint256);
76     function allowance(address owner, address spender) external view returns (uint256);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @title Standard ERC20 token
83  *
84  * @dev Implementation of the basic standard token.
85  * See https://eips.ethereum.org/EIPS/eip-20
86  */
87 contract ERC20 is IERC20 {
88     using SafeMath for uint256;
89 
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowed;
93 
94     uint256 private _totalSupply;
95 
96     function totalSupply() public view returns (uint256) {
97         return _totalSupply;
98     }
99 
100     function balanceOf(address owner) public view returns (uint256) {
101         return _balances[owner];
102     }
103 
104     function allowance(address owner, address spender) public view returns (uint256) {
105         return _allowed[owner][spender];
106     }
107 
108     function transfer(address to, uint256 value) public returns (bool) {
109         _transfer(msg.sender, to, value);
110         return true;
111     }
112 
113     function approve(address spender, uint256 value) public returns (bool) {
114         _approve(msg.sender, spender, value);
115         return true;
116     }
117 
118     function transferFrom(address from, address to, uint256 value) public returns (bool) {
119         _transfer(from, to, value);
120         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
121         return true;
122     }
123 
124     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
125         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
126         return true;
127     }
128 
129     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
130         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
131         return true;
132     }
133 
134     function _transfer(address from, address to, uint256 value) internal {
135         require(to != address(0));
136 
137         _balances[from] = _balances[from].sub(value);
138         _balances[to] = _balances[to].add(value);
139         emit Transfer(from, to, value);
140     }
141 
142     function _mint(address account, uint256 value) internal {
143         require(account != address(0));
144 
145         _totalSupply = _totalSupply.add(value);
146         _balances[account] = _balances[account].add(value);
147         emit Transfer(address(0), account, value);
148     }
149 
150     function _approve(address owner, address spender, uint256 value) internal {
151         require(spender != address(0));
152         require(owner != address(0));
153 
154         _allowed[owner][spender] = value;
155         emit Approval(owner, spender, value);
156     }
157 
158     function _burn(address account, uint256 value) internal {
159         _totalSupply = _totalSupply.sub(value);
160         _balances[account] = _balances[account].sub(value);
161         emit Transfer(account, address(0), value);
162     }
163 
164     function burn(uint256 amount) public {
165         _burn(msg.sender, amount);
166     }
167 
168     function burnFrom(address account, uint256 amount) public {
169         _burn(account, amount);
170         _approve(account, msg.sender, _allowed[account][msg.sender].sub(amount));
171     }
172 
173 }
174 
175 /**
176  * @title ApproveAndCall Interface.
177  * @dev ApproveAndCall system allows to communicate with smart-contracts.
178  */
179 contract ApproveAndCallFallBack {
180     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
181 }
182 
183 /**
184  * @title The main project contract.
185  * @author https://grox.solutions
186  */
187 contract SDUMToken is ERC20, Ownable {
188 
189     // name of the token
190     string private _name = "SDU Mining";
191     // symbol of the token
192     string private _symbol = "SDUM";
193     // decimals of the token
194     uint8 private _decimals = 4;
195 
196     // initial supply
197     uint256 public constant INITIAL_SUPPLY = 175000000000 * (10 ** 4);
198 
199     // exchange address
200     address private _exchange;
201 
202     /**
203      * @dev constructor function that is called once at deployment of the contract.
204      * @param recipient Address to receive initial supply.
205      */
206     constructor(address recipient, address initialOwner) public Ownable(initialOwner) {
207 
208         _mint(recipient, INITIAL_SUPPLY);
209 
210     }
211 
212     /**
213      * @dev modified transfer function that allows to safely send tokens to exchange contract.
214      * @param to The address to transfer to.
215      * @param value The amount to be transferred.
216      */
217     function transfer(address to, uint256 value) public returns (bool) {
218 
219         if (to == _exchange) {
220             approveAndCall(to, value, new bytes(0));
221         } else {
222             super.transfer(to, value);
223         }
224 
225         return true;
226 
227     }
228 
229     /**
230      * @dev modified transferFrom function that allows to safely send tokens to exchange contract.
231      * @param from address The address which you want to send tokens from
232      * @param to address The address which you want to transfer to
233      * @param value uint256 the amount of tokens to be transferred
234      */
235     function transferFrom(address from, address to, uint256 value) public returns (bool) {
236 
237         if (to == _exchange) {
238             ApproveAndCallFallBack(to).receiveApproval(msg.sender, value, address(this), new bytes(0));
239         } else {
240             super.transferFrom(from, to, value);
241         }
242 
243         return true;
244     }
245 
246     /**
247      * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
248      * @param spender Address of smart contracts to work with.
249      * @param amount Amount of tokens to send.
250      * @param extraData Any extra data.
251      */
252     function approveAndCall(address spender, uint256 amount, bytes memory extraData) public returns (bool) {
253         require(approve(spender, amount));
254 
255         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
256 
257         return true;
258     }
259 
260     /**
261      * @dev Function to change the Exchange address.
262      * Available only to the owner.
263      * @param addr new address.
264      */
265     function setExchangeAddress(address addr) external onlyOwner {
266         require(addr != address(0), "Exchange is the zero address");
267 
268         _exchange = addr;
269     }
270 
271     /**
272      * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
273      * @param ERC20Token Address of ERC20 token.
274      * @param recipient Account to receive tokens.
275      */
276     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
277 
278         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
279         IERC20(ERC20Token).transfer(recipient, amount);
280 
281     }
282 
283     /**
284      * @return the name of the token.
285      */
286     function name() public view returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @return the symbol of the token.
292      */
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @return the number of decimals of the token.
299      */
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 
304     /**
305      * @return the SDUM Exchange address.
306      */
307     function exchange() public view returns (address) {
308         return _exchange;
309     }
310 
311 }