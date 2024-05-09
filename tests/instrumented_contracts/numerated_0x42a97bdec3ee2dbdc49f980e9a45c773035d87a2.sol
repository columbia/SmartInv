1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 //
6 // YEAH IT'S JUST A TEMPLATE ERC20
7 // SEE FOR YOURSELF I COULDN'T RUG PULL IF I WANTED TO
8 // 
9 // Cardano still doesn't have smart contracts as of 8/27/2020
10 // ----------------------------------------------------------------------------
11 contract ERC20Interface {
12     function totalSupply() public view returns (uint);
13     function balanceOf(address tokenOwner) public view returns (uint balance);
14     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
15     function transfer(address to, uint tokens) public returns (bool success);
16     function approve(address spender, uint tokens) public returns (bool success);
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18 
19     event Transfer(address indexed from, address indexed to, uint tokens);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 }
22 
23 // ----------------------------------------------------------------------------
24 // Safe Math Library 
25 // ----------------------------------------------------------------------------
26 contract SafeMath {
27     function safeAdd(uint a, uint b) public pure returns (uint c) {
28         c = a + b;
29         require(c >= a);
30     }
31     function safeSub(uint a, uint b) public pure returns (uint c) {
32         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 contract JeffToken is ERC20Interface, SafeMath {
39     string public name;
40     string public symbol;
41     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
42     
43     uint256 public _totalSupply;
44     
45     mapping(address => uint) balances;
46     mapping(address => mapping(address => uint)) allowed;
47     
48     /**
49      * Constrctor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     constructor() public {
54         name = "JeffToken";
55         symbol = "JEFF";
56         decimals = 18;
57         _totalSupply = 60000000000000000000000;
58         
59         balances[msg.sender] = _totalSupply;
60         emit Transfer(address(0), msg.sender, _totalSupply);
61     }
62     
63     function totalSupply() public view returns (uint) {
64         return _totalSupply  - balances[address(0)];
65     }
66     
67     function balanceOf(address tokenOwner) public view returns (uint balance) {
68         return balances[tokenOwner];
69     }
70     
71     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
72         return allowed[tokenOwner][spender];
73     }
74     
75     function approve(address spender, uint tokens) public returns (bool success) {
76         allowed[msg.sender][spender] = tokens;
77         emit Approval(msg.sender, spender, tokens);
78         return true;
79     }
80     
81     function transfer(address to, uint tokens) public returns (bool success) {
82         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
83         balances[to] = safeAdd(balances[to], tokens);
84         emit Transfer(msg.sender, to, tokens);
85         return true;
86     }
87     
88     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
89         balances[from] = safeSub(balances[from], tokens);
90         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
91         balances[to] = safeAdd(balances[to], tokens);
92         emit Transfer(from, to, tokens);
93         return true;
94     }
95 }