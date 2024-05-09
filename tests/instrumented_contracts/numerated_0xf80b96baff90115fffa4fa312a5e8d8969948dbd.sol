1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // Contract function to receive approval and execute function in one call
43 // ----------------------------------------------------------------------------
44 
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Owned contract
51 // ----------------------------------------------------------------------------
52 contract Owned {
53     address public owner;
54 
55     function Owned() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // ERC20 Token, with the addition of symbol, name and decimals and an
68 // initial fixed supply
69 // ----------------------------------------------------------------------------
70 contract YieldbyfinanceToken is ERC20Interface, Owned {
71     using SafeMath for uint;
72 
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81     function YieldbyfinanceToken() public {
82         symbol = "YBFI";
83         name = "Yieldby.finance";
84         decimals = 18;
85         _totalSupply = 25000 * 10**uint(decimals);
86         balances[owner] = _totalSupply;
87         Transfer(address(0), owner, _totalSupply);
88     }
89 
90 
91     // ------------------------------------------------------------------------
92     // Total supply
93     // ------------------------------------------------------------------------
94     function totalSupply() public constant returns (uint) {
95         return _totalSupply  - balances[address(0)];
96     }
97 
98 
99     // ------------------------------------------------------------------------
100     // Get the token balance for account `tokenOwner`
101     // ------------------------------------------------------------------------
102     function balanceOf(address tokenOwner) public constant returns (uint balance) {
103         return balances[tokenOwner];
104     }
105 
106 
107 
108     function transfer(address to, uint tokens) public returns (bool success) {
109         balances[msg.sender] = balances[msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         Transfer(msg.sender, to, tokens);
112         return true;
113     }
114 
115     function burn(uint tokens) public returns (bool success) {
116         balances[msg.sender] = balances[msg.sender].sub(tokens);
117         balances[address(0)] = balances[address(0)].add(tokens);
118         Transfer(msg.sender, address(0), tokens);
119         return true;
120     }
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
129         balances[from] = balances[from].sub(tokens);
130         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
131         balances[to] = balances[to].add(tokens);
132         Transfer(from, to, tokens);
133         return true;
134     }
135 
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147    
148     
149 
150     // ------------------------------------------------------------------------
151     // Owner can transfer out any accidentally sent ERC20 tokens
152     // ------------------------------------------------------------------------
153     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
154         return ERC20Interface(tokenAddress).transfer(owner, tokens);
155     }
156 }