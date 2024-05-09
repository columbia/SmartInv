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
158 }
159 
160 /**
161  * @title ApproveAndCall Interface.
162  * @dev ApproveAndCall system allows to communicate with smart-contracts.
163  */
164 interface ApproveAndCallFallBack {
165     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
166 }
167 
168 /**
169  * @title The main project contract.
170  * @author https://grox.solutions
171  */
172 contract SDUToken is ERC20, Ownable {
173 
174     // name of the token
175     string private _name = "Single Digital Unit";
176     // symbol of the token
177     string private _symbol = "SDU";
178     // decimals of the token
179     uint8 private _decimals = 4;
180 
181     // initial supply
182     uint256 public constant INITIAL_SUPPLY = 21000000000000 * (10 ** 4);
183 
184     /**
185      * @dev constructor function that is called once at deployment of the contract.
186      * @param recipient Address to receive initial supply.
187      * @param initialOwner Address of owner of the contract.
188      */
189     constructor(address recipient, address initialOwner) public Ownable(initialOwner) {
190 
191         _mint(recipient, INITIAL_SUPPLY);
192 
193     }
194 
195     /**
196      * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
197      * @param spender Address of smart contracts to work with.
198      * @param amount Amount of tokens to send.
199      * @param extraData Any extra data.
200      */
201     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
202         require(approve(spender, amount));
203 
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
205 
206         return true;
207     }
208 
209     /**
210      * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
211      * @param ERC20Token Address of ERC20 token.
212      * @param recipient Account to receive tokens.
213      */
214     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
215 
216         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
217         IERC20(ERC20Token).transfer(recipient, amount);
218 
219     }
220 
221     /**
222      * @return the name of the token.
223      */
224     function name() public view returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @return the symbol of the token.
230      */
231     function symbol() public view returns (string memory) {
232         return _symbol;
233     }
234 
235     /**
236      * @return the number of decimals of the token.
237      */
238     function decimals() public view returns (uint8) {
239         return _decimals;
240     }
241 
242 }