1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3                                      
4 
5 /*
6     @author @sheeeev66 of @thecoredevs
7 */
8 
9 contract ERC20 {
10     // Supply
11     uint256 public totalSupply; 
12     uint256 public maxTotalSupply = 10000000000000000000000000;
13     // Mappings of Balances
14     mapping(address => uint256) public balanceOf;
15     mapping(address => mapping(address => uint256)) public allowance;
16 
17     // Events
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     function name() external pure returns (string memory) {
22         return "Zen Token";
23     }
24 
25     function symbol() external pure returns (string memory) {
26         return "ZEN";
27     }
28 
29     function decimals() external pure returns (uint8) {
30         return 18;
31     }
32 
33     // Internal Functions
34     function _mint(address to_, uint256 _amount) internal {
35         uint256 _totalAfterAmount = totalSupply + _amount;
36         require(_totalAfterAmount <= maxTotalSupply, "You cannot mint more than Mox Total Supply!");
37         totalSupply += _amount;
38         balanceOf[to_] += _amount;
39         emit Transfer(address(0x0), to_, _amount);
40     }
41 
42     function _burn(address from_, uint256 _amount) internal {
43         balanceOf[from_] -= _amount;
44         totalSupply -= _amount;
45         emit Transfer(from_, address(0x0), _amount);
46     }
47     
48     function _approve(address owner_, address _spender, uint256 _amount) internal {
49         allowance[owner_][_spender] = _amount;
50         emit Approval(owner_, _spender, _amount);
51     }
52 
53     // Public Functions
54     function approve(address _spender, uint256 _amount) public returns (bool) {
55         _approve(msg.sender, _spender, _amount);
56         return true;
57     }
58 
59 
60     function transfer(address to_, uint256 _amount) public returns (bool) {
61         balanceOf[msg.sender] -= _amount;
62         balanceOf[to_] += _amount;
63         emit Transfer(msg.sender, to_, _amount);
64         return true;
65     }
66 
67     function transferFrom(address from_, address to_, uint256 _amount) public returns (bool) {
68         if (allowance[from_][msg.sender] != type(uint256).max) {
69             allowance[from_][msg.sender] -= _amount; }
70         balanceOf[from_] -= _amount;
71         balanceOf[to_] += _amount;
72         emit Transfer(from_, to_, _amount);
73         return true;
74     }
75 
76     function burn(uint256 _amount) external { // should you allow anyone to burn?
77         _burn(msg.sender, _amount);
78     }
79     
80     function burnFrom(address from_, uint256 _amount) public {
81         uint256 _currentAllowance = allowance[from_][msg.sender];
82         require(_currentAllowance >= _amount, "ERC20IBurnable: Burn amount requested exceeds allowance!");
83 
84         if (allowance[from_][msg.sender] != type(uint256).max) {
85             allowance[from_][msg.sender] -= _amount; }
86 
87         _burn(from_, _amount);
88     }
89 }
90 
91 contract Control  {
92     address public owner;
93     mapping(address => bool) public controllers;
94 
95     constructor() { owner = msg.sender; }
96     
97     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
98     modifier onlyController { require(controllers[msg.sender], "Not Controller!"); _; }
99 
100     function transferOwnership(address new_) external onlyOwner { owner = new_; }
101     
102     function setController(address address_, bool bool_) external onlyOwner {
103         controllers[address_] = bool_;
104     }
105 }
106 
107 contract ZenTokenV2 is ERC20, Control {
108 
109     // bool disableYieldTokenMint; this is done by setting the address in the yield contract to 0
110 
111     ERC20 public immutable oldToken;
112 
113     constructor(address _oldToken) { oldToken = ERC20(_oldToken); }
114     
115 
116 
117 
118     // functions for yield token
119     function mintAsController(address to_, uint256 _amount) external onlyController {
120         _mint(to_, _amount);
121     }
122     function burnAsController(address from_, uint256 _amount) external onlyController {
123         _burn(from_, _amount);
124     }
125 
126     // migration
127         bool public migrationEnabled = false;
128     function toggleMigration() external onlyOwner {
129         migrationEnabled = !migrationEnabled;
130     }
131 
132     function migrate() external {
133         require(migrationEnabled, "Migration is not enabled!");
134         uint userBal = oldToken.balanceOf(msg.sender);
135         oldToken.burnFrom(msg.sender, userBal);
136         _mint(msg.sender, userBal / 10);
137     }
138 }