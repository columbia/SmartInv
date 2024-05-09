1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract SafeMath {
6     function safeAdd(uint a, uint b) public pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) public pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 
73 contract RainbowToken is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83 
84     function RainbowToken() public {
85         symbol = "RNBT";
86         name = "Rainbow Token";
87         decimals = 18;
88         _totalSupply = 100000000000000000000000000;
89         balances[0x544731de8555FAa267890Ddf6DfC0C1dEC825607] = _totalSupply;
90         Transfer(address(0), 0x544731de8555FAa267890Ddf6DfC0C1dEC825607, _totalSupply);
91     }
92 
93 
94 
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply  - balances[address(0)];
97     }
98 
99 
100 
101     function balanceOf(address tokenOwner) public constant returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106 
107     function transfer(address to, uint tokens) public returns (bool success) {
108         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         Transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114 
115 
116     function approve(address spender, uint tokens) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         Approval(msg.sender, spender, tokens);
119         return true;
120     }
121 
122 
123 
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         balances[from] = safeSub(balances[from], tokens);
126         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         Transfer(from, to, tokens);
129         return true;
130     }
131 
132 
133 
134     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
135         return allowed[tokenOwner][spender];
136     }
137 
138 
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147 
148     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
149         return ERC20Interface(tokenAddress).transfer(owner, tokens);
150     }
151 }