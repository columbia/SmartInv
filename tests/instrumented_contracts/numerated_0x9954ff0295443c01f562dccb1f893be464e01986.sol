1 pragma solidity ^0.4.22;
2 
3 contract pahoo {
4 
5     string public name = "pahoo";
6     string public symbol = "pahoo";
7     uint256 public decimals = 18;
8     address public adminWallet;
9 
10     mapping(address => uint256) public balanceOf;
11     mapping(address => mapping(address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 1000000000;
14     bool public stopped = false;
15     uint public constant TOKEN_SUPPLY_TOTAL = 1000000000000000000000000000;
16     uint256 constant valueFounder = TOKEN_SUPPLY_TOTAL;
17     address owner = 0x0;
18 
19     mapping (address => bool) public LockWallets;
20 
21     function lockWallet(address _wallet) public isOwner{
22         LockWallets[_wallet]=true;
23     }
24 
25     function unlockWallet(address _wallet) public isOwner{
26         LockWallets[_wallet]=false;
27     }
28 
29     function containsLock(address _wallet) public view returns (bool){
30         return LockWallets[_wallet];
31     }
32 
33     modifier isOwner {
34         assert(owner == msg.sender);
35         _;
36     }
37 
38     modifier isRunning {
39         assert(!stopped);
40         _;
41     }
42 
43     modifier validAddress {
44         assert(0x0 != msg.sender);
45         _;
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50         adminWallet = owner;
51         totalSupply = valueFounder;
52         balanceOf[owner] = valueFounder;
53         emit Transfer(0x0, owner, valueFounder);
54     }
55 
56     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
57         if (containsLock(msg.sender) == true) {
58             revert("Wallet Locked");
59         }
60 
61         require(balanceOf[msg.sender] >= _value);
62         require(balanceOf[_to] + _value >= balanceOf[_to]);
63         balanceOf[msg.sender] -= _value;
64         balanceOf[_to] += _value;
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
70 
71         if (containsLock(_from) == true) {
72             revert("Wallet Locked");
73         }
74 
75         require(balanceOf[_from] >= _value);
76         require(balanceOf[_to] + _value >= balanceOf[_to]);
77         require(allowance[_from][msg.sender] >= _value);
78         balanceOf[_to] += _value;
79         balanceOf[_from] -= _value;
80         allowance[_from][msg.sender] -= _value;
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
86         require(_value == 0 || allowance[msg.sender][_spender] == 0);
87         allowance[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function stop() public isOwner {
93         stopped = true;
94     }
95 
96     function start() public isOwner {
97         stopped = false;
98     }
99 
100     function setName(string _name) public isOwner {
101         name = _name;
102     }
103 
104     function setSymbol(string _symbol) public isOwner {
105         symbol = _symbol;
106     }
107 
108     function burn(uint256 _value) public {
109         require(balanceOf[msg.sender] >= _value);
110         balanceOf[msg.sender] -= _value;
111         balanceOf[0x0] += _value;
112         emit Transfer(msg.sender, 0x0, _value);
113     }
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }