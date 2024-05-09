1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5     ERC20I (ERC20 0xInuarashi Edition)
6     Minified and Gas Optimized
7     Contributors: 0xInuarashi (Message to Martians, Anonymice), 0xBasset (Ether Orcs)
8 */
9 
10 contract ERC20I {
11     // Token Params
12     string public name;
13     string public symbol;
14     constructor(string memory name_, string memory symbol_) {
15         name = name_;
16         symbol = symbol_;
17     }
18 
19     // Decimals
20     uint8 public constant decimals = 18;
21 
22     // Supply
23     uint256 public totalSupply;
24     
25     // Mappings of Balances
26     mapping(address => uint256) public balanceOf;
27     mapping(address => mapping(address => uint256)) public allowance;
28 
29     // Events
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33     // Internal Functions
34     function _mint(address to_, uint256 amount_) internal virtual {
35         totalSupply += amount_;
36         balanceOf[to_] += amount_;
37         emit Transfer(address(0x0), to_, amount_);
38     }
39     function _burn(address from_, uint256 amount_) internal virtual {
40         balanceOf[from_] -= amount_;
41         totalSupply -= amount_;
42         emit Transfer(from_, address(0x0), amount_);
43     }
44     function _approve(address owner_, address spender_, uint256 amount_) internal virtual {
45         allowance[owner_][spender_] = amount_;
46         emit Approval(owner_, spender_, amount_);
47     }
48 
49     // Public Functions
50     function approve(address spender_, uint256 amount_) public virtual returns (bool) {
51         _approve(msg.sender, spender_, amount_);
52         return true;
53     }
54     function transfer(address to_, uint256 amount_) public virtual returns (bool) {
55         balanceOf[msg.sender] -= amount_;
56         balanceOf[to_] += amount_;
57         emit Transfer(msg.sender, to_, amount_);
58         return true;
59     }
60     function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
61         if (allowance[from_][msg.sender] != type(uint256).max) {
62             allowance[from_][msg.sender] -= amount_; }
63         balanceOf[from_] -= amount_;
64         balanceOf[to_] += amount_;
65         emit Transfer(from_, to_, amount_);
66         return true;
67     }
68 
69     // 0xInuarashi Custom Functions
70     function multiTransfer(address[] memory to_, uint256[] memory amounts_) public virtual {
71         require(to_.length == amounts_.length, "ERC20I: To and Amounts length Mismatch!");
72         for (uint256 i = 0; i < to_.length; i++) {
73             transfer(to_[i], amounts_[i]);
74         }
75     }
76     function multiTransferFrom(address[] memory from_, address[] memory to_, uint256[] memory amounts_) public virtual {
77         require(from_.length == to_.length && from_.length == amounts_.length, "ERC20I: From, To, and Amounts length Mismatch!");
78         for (uint256 i = 0; i < from_.length; i++) {
79             transferFrom(from_[i], to_[i], amounts_[i]);
80         }
81     }
82 }
83 
84 abstract contract ERC20IBurnable is ERC20I {
85     function burn(uint256 amount_) external virtual {
86         _burn(msg.sender, amount_);
87     }
88     function burnFrom(address from_, uint256 amount_) public virtual {
89         uint256 _currentAllowance = allowance[from_][msg.sender];
90         require(_currentAllowance >= amount_, "ERC20IBurnable: Burn amount requested exceeds allowance!");
91 
92         if (allowance[from_][msg.sender] != type(uint256).max) {
93             allowance[from_][msg.sender] -= amount_; }
94 
95         _burn(from_, amount_);
96     }
97 }
98 
99 abstract contract Ownable {
100     address public owner;
101     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
102     constructor() { owner = msg.sender; }
103     modifier onlyOwner {
104         require(owner == msg.sender, "Ownable: caller is not the owner");
105         _;
106     }
107     function _transferOwnership(address newOwner_) internal virtual {
108         address _oldOwner = owner;
109         owner = newOwner_;
110         emit OwnershipTransferred(_oldOwner, newOwner_);    
111     }
112     function transferOwnership(address newOwner_) public virtual onlyOwner {
113         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
114         _transferOwnership(newOwner_);
115     }
116     function renounceOwnership() public virtual onlyOwner {
117         _transferOwnership(address(0x0));
118     }
119 }
120 
121 contract Shell is ERC20IBurnable, Ownable {
122     constructor() ERC20I("Shell", "SHELL") {}
123 
124     mapping(address => bool) isController;
125     function setController(address address_, bool bool_) external onlyOwner {
126         isController[address_] = bool_;
127     }
128     modifier onlyControllers {
129         require(isController[msg.sender], "You are not authorized!"); _;
130     }
131 
132     function mint(address to_, uint256 amount_) external onlyControllers {
133         _mint(to_, amount_);
134     }
135 
136     function burnAsController(address from_, uint256 amount_) external onlyControllers {
137         _burn(from_, amount_);
138     }
139 }