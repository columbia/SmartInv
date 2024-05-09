1 pragma solidity ^0.5.0;
2 
3 /*
4 
5                       /|      __
6 *             +      / |   ,-~ /             +
7      .              Y :|  //  /                .         *
8          .          | jj /( .^     *
9                *    >-"~"-v"              .        *        .
10 *                  /       Y
11    .     .        jo  o    |     .            +
12                  ( ~T~     j                     +     .
13       +           >._-' _./         +
14                /| ;-"~ _  l
15   .           / l/ ,-"~    \     +
16               \//\/      .- \
17        +       Y        /    Y
18                l       I     !
19                ]\      _\    /"\
20               (" ~----( ~   Y.  )
21           ~~~~~~~~~~~Thumper~~~~~~~~~~~~~~
22 
23 */
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 pragma solidity ^0.5.0;
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b > 0, "SafeMath: division by zero");
61         uint256 c = a / b;
62         return c;
63     }
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0, "SafeMath: modulo by zero");
66         return a % b;
67     }
68 }
69 
70 pragma solidity ^0.5.0;
71 contract ERC20 is IERC20 {
72     using SafeMath for uint256;
73     mapping (address => uint256) private _balances;
74     mapping (address => mapping (address => uint256)) private _allowances;
75     uint256 private _totalSupply;
76     function totalSupply() public view returns (uint256) {
77         return _totalSupply;
78     }
79     function balanceOf(address account) public view returns (uint256) {
80         return _balances[account];
81     }
82     function transfer(address recipient, uint256 amount) public returns (bool) {
83         _transfer(msg.sender, recipient, amount);
84         return true;
85     }
86     function allowance(address owner, address spender) public view returns (uint256) {
87         return _allowances[owner][spender];
88     }
89     function approve(address spender, uint256 value) public returns (bool) {
90         _approve(msg.sender, spender, value);
91         return true;
92     }
93     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
94         _transfer(sender, recipient, amount);
95         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
96         return true;
97     }
98     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
99         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
100         return true;
101     }
102     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
103         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
104         return true;
105     }
106     function _transfer(address sender, address recipient, uint256 amount) internal {
107         require(sender != address(0), "ERC20: transfer from the zero address");
108         require(recipient != address(0), "ERC20: transfer to the zero address");
109 
110         _balances[sender] = _balances[sender].sub(amount);
111         _balances[recipient] = _balances[recipient].add(amount);
112         emit Transfer(sender, recipient, amount);
113     }
114     function _mint(address account, uint256 amount) internal {
115         require(account != address(0), "ERC20: mint to the zero address");
116 
117         _totalSupply = _totalSupply.add(amount);
118         _balances[account] = _balances[account].add(amount);
119         emit Transfer(address(0), account, amount);
120     }
121     function _approve(address owner, address spender, uint256 value) internal {
122         require(owner != address(0), "ERC20: approve from the zero address");
123         require(spender != address(0), "ERC20: approve to the zero address");
124 
125         _allowances[owner][spender] = value;
126         emit Approval(owner, spender, value);
127     }
128 }
129 
130 pragma solidity ^0.5.0;
131 contract Thumper is ERC20 {
132     string private _name;
133     string private _symbol;
134     uint8 private _decimals;
135 
136     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
137       _name = name;
138       _symbol = symbol;
139       _decimals = decimals;
140       _mint(tokenOwnerAddress, totalSupply);
141       feeReceiver.transfer(msg.value);
142     }
143     function name() public view returns (string memory) {
144       return _name;
145     }
146     function symbol() public view returns (string memory) {
147       return _symbol;
148     }
149     function decimals() public view returns (uint8) {
150       return _decimals;
151     }
152 }