1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {return msg.sender;}
6     function _msgData() internal view virtual returns (bytes memory) {
7         this;
8         return msg.data;
9     }
10 }
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a, "SafeMath: subtraction overflow");
30         return a - b;
31     }   
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         return a - b;
35     }
36 }
37 contract TokenOf is Context, IERC20 {
38     using SafeMath for uint256;
39     mapping (address => uint256) private _balances;
40     mapping (address => mapping (address => uint256)) private _allowances;
41     struct LockDetails{
42         uint256 lockedTokencnt;
43         uint256 releaseTime;
44     }
45     mapping (address => bool) public isManager;
46     mapping(address => LockDetails) private Locked_list;
47     uint256 private _totalSupply;
48     string private _name;
49     string private _symbol;
50     uint8 private _decimals;
51     address private _admin;
52 
53     constructor (string memory name_, string memory symbol_) public {
54         _admin = msg.sender;
55         _name = name_;
56         _symbol = symbol_;
57         _decimals = 18;
58         isManager[msg.sender]=true;
59         _mint(msg.sender , 1000000000 * (10 ** uint256(_decimals) )) ;
60     }
61     function _mint(address account, uint256 amount) internal virtual {
62         require(account != address(0), "ERC20: mint to the zero address");
63         require(msg.sender == _admin, "Admin only function");
64         _beforeTokenTransfer(address(0), account, amount);
65         _totalSupply = _totalSupply.add(amount);
66         _balances[account] = _balances[account].add(amount);
67         emit Transfer(address(0), account, amount);
68     }
69     
70     function checkManage(address walletAddress) public view virtual returns (bool) {return isManager[walletAddress] == true ? true :false;}
71     function setManage(address walletAddress , bool st) public returns (bool) {
72         require(msg.sender == _admin , "Owner only function"); // internal owner
73         isManager[walletAddress]=st;
74         return true;
75     }
76 
77     function checkadmin() public view virtual returns (address) {return _admin;}
78     function moveadmintoother(address walletAddress) public returns (bool) {
79         require(walletAddress != address(0), "ERC20: transfer from the zero address");
80         require(msg.sender == _admin , "Owner only function"); // internal owner
81         _admin = walletAddress;
82         return true;
83     }
84 
85     function Lock_wallet(address _adr, uint256 lockamount,uint256 releaseTime ) public returns (bool) {
86         require(msg.sender==_admin || isManager[msg.sender] == true , "Admin or manager only function");
87         _Lock_wallet(_adr,lockamount,releaseTime);
88         return true;
89     }
90     function _Lock_wallet(address account, uint256 amount,uint256 releaseTime) internal {
91         LockDetails memory eaLock = Locked_list[account];
92         if( eaLock.releaseTime > 0 ){
93             eaLock.lockedTokencnt = amount;
94             eaLock.releaseTime = releaseTime;
95         }else{
96             eaLock = LockDetails(amount, releaseTime);
97         }
98         Locked_list[account] = eaLock;
99     }
100     function admin_mintMore(uint256 amount) public virtual returns (bool) {
101         _mint(msg.sender, amount);
102         return true;
103     }
104     function name() public view virtual returns (string memory) {return _name;}
105     function symbol() public view virtual returns (string memory) {return _symbol;}
106     function decimals() public view virtual returns (uint8) {return _decimals;}
107     function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
108     function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
109     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
110         _transfer(_msgSender(), recipient, amount);
111         return true;
112     }
113     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
114         _transfer(sender, recipient, amount);
115         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
116         return true;
117     }
118     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
119         require(sender != address(0), "ERC20: transfer from the zero address");
120         require(recipient != address(0), "ERC20: transfer to the zero address");
121         uint256 LockhasTime = Locked_list[sender].releaseTime;
122         uint256 LockhasMax = Locked_list[sender].lockedTokencnt;
123         if( block.timestamp < LockhasTime){
124             uint256 OK1 = _balances[sender].sub(LockhasMax, "ERC20: the amount to unlock is bigger then locked token count");
125             require( OK1 >= amount , "Your Wallet has time lock");
126         }
127 
128         _beforeTokenTransfer(sender, recipient, amount);
129         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
130         _balances[recipient] = _balances[recipient].add(amount);
131         emit Transfer(sender, recipient, amount);
132     }
133     function getwithdrawablemax(address account) public view returns (uint256) {
134         return Locked_list[account].lockedTokencnt;
135     }
136     function getLocked_list(address account) public view returns (uint256) {
137         return Locked_list[account].releaseTime;
138     }
139     function getLockinfo(address userwallet) public view virtual returns (uint256[] memory) {
140         uint256 LockhasTime = Locked_list[userwallet].releaseTime;
141         uint256 LockhasMax = Locked_list[userwallet].lockedTokencnt;
142         uint256[] memory rets = new uint256[](2);
143         rets[0] = LockhasTime;
144         rets[2] = LockhasMax;
145         return rets;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {return _allowances[owner][spender];}
149     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
150         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
151         return true;
152     }
153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
155         return true;
156     }    
157     function _burn(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: burn from the zero address");
159         _beforeTokenTransfer(account, address(0), amount);
160         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
161         _totalSupply = _totalSupply.sub(amount);
162         emit Transfer(account, address(0), amount);
163     }
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168     function _approve(address owner, address spender, uint256 amount) internal virtual {
169         require(owner != address(0), "ERC20: approve from the zero address");
170         require(spender != address(0), "ERC20: approve to the zero address");
171         _allowances[owner][spender] = amount;
172         emit Approval(owner, spender, amount);
173     }
174     function _setupDecimals(uint8 decimals_) internal virtual {_decimals = decimals_;}
175     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
176 }