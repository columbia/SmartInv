1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4 
5     function transfer(address to, uint256 value) external returns (bool);
6     function approve(address spender, uint256 value) external returns (bool);
7     function transferFrom(address from, address to, uint256 value) external returns (bool);
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address who) external view returns (uint256);
10     function allowance(address owner, address spender) external view returns (uint256);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {return 0;}
19         uint256 c = a * b;
20         require(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b > 0);
26         uint256 c = a / b;
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a);
32         uint256 c = a - b;
33         return c;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a);
39         return c;
40     }
41 
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b != 0);
44         return a % b;
45     }
46 }
47 
48 contract ERC20 is IERC20 {
49 
50     using SafeMath for uint256;
51     mapping (address => uint256) private _balances;
52     mapping (address => mapping (address => uint256)) private _allowed;
53     uint256 private _totalSupply;
54 
55     function totalSupply() public view returns (uint256) {
56         return _totalSupply;
57     }
58 
59     function balanceOf(address owner) public view returns (uint256) {
60         return _balances[owner];
61     }
62 
63     function allowance(address owner, address spender) public view returns (uint256) {
64         return _allowed[owner][spender];
65     }
66 
67     function transfer(address to, uint256 value) public returns (bool) {
68         _transfer(msg.sender, to, value);
69         return true;
70     }
71 
72     function approve(address spender, uint256 value) public returns (bool) {
73         require(spender != address(0));
74         _allowed[msg.sender][spender] = value;
75         emit Approval(msg.sender, spender, value);
76         return true;
77     }
78 
79     function transferFrom(address from, address to, uint256 value) public returns (bool) {
80         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
81         _transfer(from, to, value);
82         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
83         return true;
84     }
85 
86     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
87         require(spender != address(0));
88         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
89         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
90         return true;
91     }
92 
93     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
94         require(spender != address(0));
95         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
96         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
97         return true;
98     }
99 
100     function _transfer(address from, address to, uint256 value) internal {
101         require(to != address(0));
102         _balances[from] = _balances[from].sub(value);
103         _balances[to] = _balances[to].add(value);
104         emit Transfer(from, to, value);
105     }
106 
107     function _mint(address account, uint256 value) internal {
108         require(account != address(0));
109         _totalSupply = _totalSupply.add(value);
110         _balances[account] = _balances[account].add(value);
111         emit Transfer(address(0), account, value);
112     }
113 
114     function _burn(address account, uint256 value) internal {
115         require(account != address(0));
116         _totalSupply = _totalSupply.sub(value);
117         _balances[account] = _balances[account].sub(value);
118         emit Transfer(account, address(0), value);
119     }
120 
121     function _burnFrom(address account, uint256 value) internal {
122         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
123         _burn(account, value);
124         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
125     }
126 }
127 
128 library Roles {
129 
130     struct Role {mapping (address => bool) bearer;}
131 
132     function add(Role storage role, address account) internal {
133         require(account != address(0));
134         require(!has(role, account));
135         role.bearer[account] = true;
136     }
137 
138     function remove(Role storage role, address account) internal {
139         require(account != address(0));
140         require(has(role, account));
141         role.bearer[account] = false;
142     }
143 
144     function has(Role storage role, address account) internal view returns (bool) {
145         require(account != address(0));
146         return role.bearer[account];
147     }
148 }
149 
150 contract Ownable {
151 
152     address private _owner;
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     constructor () internal {
156         _owner = msg.sender;
157         emit OwnershipTransferred(address(0), _owner);
158     }
159 
160     function owner() public view returns (address) {
161         return _owner;
162     }
163 
164     modifier onlyOwner() {
165         require(isOwner());
166         _;
167     }
168 
169     function isOwner() public view returns (bool) {
170         return msg.sender == _owner;
171     }
172 
173     function renounceOwnership() internal onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) internal onlyOwner {
179         _transferOwnership(newOwner);
180     }
181 
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0));
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 library SafeERC20 {
190 
191     using SafeMath for uint256;
192 
193     function safeTransfer(IERC20 token, address to, uint256 value) internal {
194         require(token.transfer(to, value));
195     }
196 
197     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
198         require(token.transferFrom(from, to, value));
199     }
200 
201     function safeApprove(IERC20 token, address spender, uint256 value) internal {
202         require((value == 0) || (token.allowance(address(this), spender) == 0));
203         require(token.approve(spender, value));
204     }
205 
206     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
207         uint256 newAllowance = token.allowance(address(this), spender).add(value);
208         require(token.approve(spender, newAllowance));
209     }
210 
211     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
212         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
213         require(token.approve(spender, newAllowance));
214     }
215 }
216 
217  contract FBB_Token is ERC20, Ownable {
218 
219    using SafeERC20 for ERC20;
220    address public creator;
221    string public name;
222    string public symbol;
223    uint8 public decimals;
224    uint256 private tokensToMint;
225 
226    constructor() public {
227 
228      creator = 0xbC57B9bb80DD02c882fcE8cf5700f8A2a003838E;
229      name = "FilmBusinessBuster";
230      symbol = "FBB";
231      decimals = 3;
232      tokensToMint = 1000000000;
233    }
234 
235    function mintFBB() public onlyOwner returns (bool) {
236      _mint(creator, tokensToMint);
237      return true;
238    }
239  }