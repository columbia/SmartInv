1 pragma solidity ^0.4.25;
2 
3 // 'InfiniCoin' token contract
4 //
5 // Deployed to : 0x70Fe2224D604424e7e574Dc0E0B96DB609Bb40B9
6 // Symbol      : INFC
7 // Name        : InfiniCoin
8 // Total supply: 2100000
9 // Decimals    : 2
10 //
11 
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
45 }
46 
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 contract InfiniCoin is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82  
83     constructor() public {
84         symbol = "INFC";
85         name = "InfiniCoin";
86         decimals = 2;
87         _totalSupply = 2100000;
88         balances[0x70Fe2224D604424e7e574Dc0E0B96DB609Bb40B9] = _totalSupply;
89         emit Transfer(address(0), 0x70Fe2224D604424e7e574Dc0E0B96DB609Bb40B9, _totalSupply);
90     }
91 
92    
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97 
98     function balanceOf(address tokenOwner) public constant returns (uint balance) {
99         return balances[tokenOwner];
100     }
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109    
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         emit Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = safeSub(balances[from], tokens);
119         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(from, to, tokens);
122         return true;
123     }
124 
125 
126     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 
130 
131     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
132         allowed[msg.sender][spender] = tokens;
133         emit Approval(msg.sender, spender, tokens);
134         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
135         return true;
136     }
137 
138 
139     function () public payable {
140         revert();
141     }
142 
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 }