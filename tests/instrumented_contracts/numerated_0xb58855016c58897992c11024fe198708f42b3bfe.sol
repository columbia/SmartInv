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
25 
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 
40 contract ApproveAndCallFallBack {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 
73 
74 contract KelvinToken is ERC20Interface, Owned, SafeMath {
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83 
84    
85     function KelvinToken() public {
86         symbol = "OEG";
87         name = "Oyeng Chain";
88         decimals = 18;
89         _totalSupply = 100000000000000000000000;
90         balances[0x811D38BDca68F53c8237BE3e2366f116cD91Afa8] = _totalSupply;
91         Transfer(address(0), 0x811D38BDca68F53c8237BE3e2366f116cD91Afa8, _totalSupply);
92     }
93 
94 
95     
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101     
102     function balanceOf(address tokenOwner) public constant returns (uint balance) {
103         return balances[tokenOwner];
104     }
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
148     
149     function () public payable {
150         revert();
151     }
152 
153 
154     
155     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERC20Interface(tokenAddress).transfer(owner, tokens);
157     }
158 }