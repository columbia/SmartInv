1 1 pragma solidity ^0.5.0;
2 
3 
4 2 contract ERC20Interface {
5 3     function totalSupply() public view returns (uint);
6 4     function balanceOf(address tokenOwner) public view returns (uint balance);
7 5     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
8 6     function transfer(address to, uint tokens) public returns (bool success);
9 7     function approve(address spender, uint tokens) public returns (bool success);
10 8     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11 
12 9     event Transfer(address indexed from, address indexed to, uint tokens);
13 10     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 11 }
15 
16 
17 12 contract SafeMath {
18 13     function safeAdd(uint a, uint b) public pure returns (uint c) {
19 14         c = a + b;
20 15         require(c >= a);
21 16     }
22 17     function safeSub(uint a, uint b) public pure returns (uint c) {
23 18         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
24 19         c = a / b;
25 20     }
26 21 }
27 
28 
29 22 contract AlloHash is ERC20Interface, SafeMath {
30 23     string public name;
31 24     string public symbol;
32 25     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
33 
34 26     uint256 public _totalSupply;
35 
36 27     mapping(address => uint) balances;
37 28     mapping(address => mapping(address => uint)) allowed;
38 
39   
40 29     constructor() public {
41 30         name = "AlloHash";
42 31         symbol = "ALH";
43 32         decimals = 18;
44 33         _totalSupply = 180000000000000000000000000;
45 
46 34         balances[msg.sender] = _totalSupply;
47 35         emit Transfer(address(0), msg.sender, _totalSupply);
48 36     }
49 
50 37     function totalSupply() public view returns (uint) {
51 38         return _totalSupply  - balances[address(0)];
52 39     }
53 
54 40     function balanceOf(address tokenOwner) public view returns (uint balance) {
55 41         return balances[tokenOwner];
56 42     }
57 
58 43     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
59 44         return allowed[tokenOwner][spender];
60 45     }
61 
62 46     function approve(address spender, uint tokens) public returns (bool success) {
63 47         allowed[msg.sender][spender] = tokens;
64 48         emit Approval(msg.sender, spender, tokens);
65 49         return true;
66 50     }
67 
68 51     function transfer(address to, uint tokens) public returns (bool success) {
69 52         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
70 53         balances[to] = safeAdd(balances[to], tokens);
71 54         emit Transfer(msg.sender, to, tokens);
72 55         return true;
73 56     }
74 
75 57     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
76 58         balances[from] = safeSub(balances[from], tokens);
77 59         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
78 60         balances[to] = safeAdd(balances[to], tokens);
79 61         emit Transfer(from, to, tokens);
80 62         return true;
81 63     }
82 64 }