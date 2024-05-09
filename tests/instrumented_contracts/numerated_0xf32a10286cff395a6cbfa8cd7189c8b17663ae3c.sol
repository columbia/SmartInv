1 // $$$$$$$\                                
2 // $$  __$$\                               
3 // $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\  
4 // $$$$$$$  |$$  __$$\ $$  __$$\ $$  __$$\ 
5 // $$  ____/ $$ /  $$ |$$ /  $$ |$$$$$$$$ |
6 // $$ |      $$ |  $$ |$$ |  $$ |$$   ____|
7 // $$ |      \$$$$$$  |\$$$$$$$ |\$$$$$$$\ 
8 // \__|       \______/  \____$$ | \_______|
9 //                     $$\   $$ |          
10 //                     \$$$$$$  |          
11 //                      \______/           
12 //
13 // By Kuma Labs for the people. WAGMI
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.7;
17 
18 contract Poge {
19     address public owner;
20 
21 	string public name;
22     string public symbol;
23     uint public decimals;
24     uint public totalSupply;
25 
26     mapping(address => uint256) private _balances;
27     mapping(address => mapping(address => uint256)) private _allowances;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     modifier onlyOwner() { // will be renounced
34         require(msg.sender == owner, "not owner");
35         _;
36     }
37 
38     constructor() {
39         owner = msg.sender;
40 
41         name = "Poge";
42         symbol = "POGE";
43         decimals = 18;
44         totalSupply = 10 * 10**9 * 10**18;
45 
46         _balances[msg.sender] = totalSupply;
47         emit Transfer(address(0), msg.sender, totalSupply);
48     }
49 	
50     // owner funcs
51     function renounceOwnership() external onlyOwner {
52         address oldOwner = owner;
53         owner = address(0);
54         emit OwnershipTransferred(oldOwner, address(0));
55     }
56 
57 	// view funcs
58 	function allowance(address owner_, address spender) public view returns (uint256) {
59         return _allowances[owner_][spender];
60     }
61     function balanceOf(address account) public view returns (uint256) {
62         return _balances[account];
63     }
64 
65 	// basic funcs
66     function transfer(address to, uint256 amount) public returns (bool) {
67         _transfer(msg.sender, to, amount);
68         return true;
69     }
70     function approve(address spender, uint256 amount) public returns (bool) {
71         _approve(msg.sender, spender, amount);
72         return true;
73     }
74     function transferFrom(
75         address from,
76         address to,
77         uint256 amount
78     ) public returns (bool) {
79         if (_allowances[from][msg.sender] != type(uint256).max) {
80             _allowances[from][msg.sender] -= amount;
81         }
82         _transfer(from, to, amount);
83         return true;
84     }
85 
86 
87     // internal funcs
88     function _transfer(
89         address from,
90         address to,
91         uint256 amount
92     ) internal virtual {
93         require(from != address(0), "ERC20: transfer from the zero address");
94         require(to != address(0), "ERC20: transfer to the zero address");
95 
96         _balances[from] -= amount;
97         _balances[to] += amount;
98         emit Transfer(from, to, amount);
99     }
100 
101     function _approve(
102         address owner_,
103         address spender,
104         uint256 amount
105     ) internal virtual {
106         require(owner_ != address(0), "ERC20: approve from the zero address");
107         require(spender != address(0), "ERC20: approve to the zero address");
108 
109         _allowances[owner_][spender] = amount;
110         emit Approval(owner_, spender, amount);
111     }
112 
113 
114 }