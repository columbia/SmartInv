1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
6 //| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
7 //| | ____    ____ | || |     _____    | || |     ______   | || |  _______     | || |     ____     | |
8 //| ||_   \  /   _|| || |    |_   _|   | || |   .' ___  |  | || | |_   __ \    | || |   .'    `.   | |
9 //| |  |   \/   |  | || |      | |     | || |  / .'   \_|  | || |   | |__) |   | || |  /  .--.  \  | |
10 //| |  | |\  /| |  | || |      | |     | || |  | |         | || |   |  __ /    | || |  | |    | |  | |
11 //| | _| |_\/_| |_ | || |     _| |_    | || |  \ `.___.'\  | || |  _| |  \ \_  | || |  \  `--'  /  | |
12 //| ||_____||_____|| || |    |_____|   | || |   `._____.'  | || | |____| |___| | || |   `.____.'   | |
13 //| |              | || |              | || |              | || |              | || |              | |
14 //| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
15 // '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
16 //
17 // ----------------------------------------------------------------------------
18 contract ERC20Interface {
19     function totalSupply() public view returns (uint);
20     function balanceOf(address tokenOwner) public view returns (uint balance);
21     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
22     function transfer(address to, uint tokens) public returns (bool success);
23     function approve(address spender, uint tokens) public returns (bool success);
24     function transferFrom(address from, address to, uint tokens) public returns (bool success);
25 
26     event Transfer(address indexed from, address indexed to, uint tokens);
27     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
28 }
29 
30 // ----------------------------------------------------------------------------
31 // Safe Math Library 
32 // ----------------------------------------------------------------------------
33 contract SafeMath {
34     function safeAdd(uint a, uint b) public pure returns (uint c) {
35         c = a + b;
36         require(c >= a);
37     }
38     function safeSub(uint a, uint b) public pure returns (uint c) {
39         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 
45 contract MicroToken is ERC20Interface, SafeMath {
46     string public name;
47     string public symbol;
48     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
49     
50     uint256 public _totalSupply;
51     
52     mapping(address => uint) balances;
53     mapping(address => mapping(address => uint)) allowed;
54     
55     /**
56      * Constrctor function
57      *
58      * Initializes contract with initial supply tokens to the creator of the contract
59      */
60     constructor() public {
61         name = "Micro Launchpad Token";
62         symbol = "MICRO";
63         decimals = 18;
64         _totalSupply = 10000000000000000000000000;
65         
66         balances[msg.sender] = 10000000000000000000000000;
67         emit Transfer(address(0), msg.sender, _totalSupply);
68     }
69     
70     function totalSupply() public view returns (uint) {
71         return _totalSupply  - balances[address(0)];
72     }
73     
74     function balanceOf(address tokenOwner) public view returns (uint balance) {
75         return balances[tokenOwner];
76     }
77     
78     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
79         return allowed[tokenOwner][spender];
80     }
81     
82     function approve(address spender, uint tokens) public returns (bool success) {
83         allowed[msg.sender][spender] = tokens;
84         emit Approval(msg.sender, spender, tokens);
85         return true;
86     }
87     
88     function transfer(address to, uint tokens) public returns (bool success) {
89         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
90         balances[to] = safeAdd(balances[to], tokens);
91         emit Transfer(msg.sender, to, tokens);
92         return true;
93     }
94     
95     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
96         balances[from] = safeSub(balances[from], tokens);
97         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
98         balances[to] = safeAdd(balances[to], tokens);
99         emit Transfer(from, to, tokens);
100         return true;
101     }
102 }