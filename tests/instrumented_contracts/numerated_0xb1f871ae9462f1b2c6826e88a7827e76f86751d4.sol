1 pragma solidity =0.4.22;
2 
3 // ----------------------------------------------------------------------------
4 // ‘GNYerc20’ token contract
5 //
6 // Symbol      : GNYerc20
7 // Name        : GNYerc20
8 // Total supply: 400000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 // ----------------------------------------------------------------------------
53 // ERC20 Token, with the addition of symbol, name and decimals and assisted
54 // token transfers
55 // ----------------------------------------------------------------------------
56 contract GNYerc20Token is ERC20Interface, SafeMath {
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint public _totalSupply;
61 
62     mapping(address => uint) balances;
63     mapping(address => mapping(address => uint)) allowed;
64     
65     // Triggered whenever approve(address _spender, uint256 _value) is called.
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     // Triggered when tokens are transferred.
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     
70     constructor () public {
71         symbol = "GNYerc20";
72         name = "GNYerc20";
73         decimals = 18;
74         _totalSupply = 400000000000000000000000000;
75         balances[msg.sender] = _totalSupply; 
76     }
77 
78     
79     function totalSupply() public view returns (uint256) {
80       return _totalSupply;
81     }
82 
83     function transfer(address to, uint tokens) public returns (bool success) {
84         require(to != 0x0);
85         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
86         balances[to] = safeAdd(balances[to], tokens);
87         emit Transfer(msg.sender, to, tokens);
88         return true;
89     }
90 
91     function approve(address spender, uint tokens) public returns (bool success) {
92         allowed[msg.sender][spender] = tokens;
93         emit Approval(msg.sender, spender, tokens);
94         return true;
95     }
96 
97     function balanceOf(address owner) public view returns (uint256 balance) {
98         return balances[owner];
99     }
100 
101     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
102         balances[from] = safeSub(balances[from], tokens);
103         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(from, to, tokens);
106         return true;
107     }
108 
109     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
110         return allowed[tokenOwner][spender];
111     }
112 }