1 pragma solidity 0.8.18;
2 
3 contract GLCK20 {
4     mapping(address => uint256) private _balances;
5     mapping(address => mapping(address => uint256)) private _allowances;
6     mapping(address => bool) public _whitelist;
7     mapping(address => bool) public _blacklist;
8     mapping(address => bool) public _pool;
9     uint256 private _totalSupply;
10     string private _name;
11     string private _symbol;
12     uint8 private _decimals;
13     uint8 public _max;
14     address public _dev;
15     
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20     modifier onlyDev() {
21         require(msg.sender == _dev, "GORLOCK: Only the developer can call this function");
22         _;
23     }
24 
25     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint supply_, uint8 max_) {
26         _name = name_;
27         _symbol = symbol_;
28         _decimals = decimals_;
29         _balances[msg.sender] = supply_ * 10 ** decimals_;
30         _totalSupply = supply_ * 10 ** decimals_;
31         _dev = msg.sender;
32         _whitelist[msg.sender] = true;
33         _max = max_;
34     }
35 
36     function name() public view returns (string memory) {return _name;}
37     function symbol() public view returns (string memory) {return _symbol;}
38     function decimals() public view returns (uint8) {return _decimals;}
39     function totalSupply() public view returns (uint256) {return _totalSupply;}
40     function balanceOf(address account) public view returns (uint256) {return _balances[account];}
41     function allowance(address owner, address spender) public view returns (uint256) {return _allowances[owner][spender];}
42 
43     function changeMax(uint8 max_) external onlyDev {
44         _max = max_;
45     }
46 
47     function maxInt(uint8 max_) internal view returns (uint256) {
48         return _totalSupply * max_ / 100;
49     }
50 
51     function changeDev(address dev_) external onlyDev {
52         _dev = dev_;
53     }
54 
55     function setWhitelist(address address_, bool whitelist_) external onlyDev {
56         _whitelist[address_] = whitelist_;
57     }
58 
59     function setBlacklist(address address_, bool blacklist_) external onlyDev {
60         _blacklist[address_] = blacklist_;
61     }
62 
63     function setPool(address address_, bool pool_) external onlyDev {
64         _pool[address_] = pool_;
65     }
66 
67     function transfer(address to, uint256 amount) public returns (bool) {
68         _transfer(msg.sender, to, amount);
69         return true;
70     }
71 
72     function approve(address spender, uint256 amount) public returns (bool) {
73         _approve(msg.sender, spender, amount);
74         return true;
75     }
76 
77     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
78         _spendAllowance(from, msg.sender, amount);
79         _transfer(from, to, amount);
80         return true;
81     }
82 
83     function _transfer(address from, address to, uint256 amount) internal {
84         require(_balances[from] >= amount, "GORLOCK: transfer amount exceeds balance");
85         require(_whitelist[from] || _whitelist[to] || _pool[to] || _balances[to] + amount <= maxInt(_max), "GORLOCK: Receipient wallet exceeds max with this transfer!");
86         require(!_blacklist[from] && !_blacklist[to], "GORLOCK: Transfer denied. One or both parties are blacklisted.");
87         _balances[from] -= amount;
88         _balances[to] += amount;
89         emit Transfer(from, to, amount);
90     }
91 
92     function _approve(address owner, address spender, uint256 amount) internal {
93         _allowances[owner][spender] = amount;
94         emit Approval(owner, spender, amount);
95     }
96 
97     function _spendAllowance(address owner, address spender, uint256 amount) internal {
98         uint256 currentAllowance = allowance(owner, spender);
99         require(currentAllowance >= amount, "GORLOCK: insufficient allowance");
100         _approve(owner, spender, currentAllowance - amount);
101     }
102 }