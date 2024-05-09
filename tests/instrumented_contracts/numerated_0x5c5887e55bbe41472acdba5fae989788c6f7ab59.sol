1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'STK Coin' token contract
5 // Deployed to : 0x078133D191F56c4685dF4f40c524e928f34c378A
6 // Symbol      : STK
7 // Name        : STK Coin
8 // Total supply: 200000000000000000000000000 
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
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
73 contract STKCoin is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82     constructor() public {
83         symbol = "STK";
84         name = "STK Coin";
85         decimals = 18;
86         _totalSupply = 200000000000000000000000000;
87         balances[0x078133D191F56c4685dF4f40c524e928f34c378A] = _totalSupply;
88         emit Transfer(address(0), 0x078133D191F56c4685dF4f40c524e928f34c378A, _totalSupply);
89     }
90 
91 
92  
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97 
98  
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104   
105     function transfer(address to, uint tokens) public returns (bool success) {
106         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
107         balances[to] = safeAdd(balances[to], tokens);
108         emit Transfer(msg.sender, to, tokens);
109         return true;
110     }
111 
112 
113  
114     function approve(address spender, uint tokens) public returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         emit Approval(msg.sender, spender, tokens);
117         return true;
118     }
119 
120 
121     
122     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
123         balances[from] = safeSub(balances[from], tokens);
124         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
125         balances[to] = safeAdd(balances[to], tokens);
126         emit Transfer(from, to, tokens);
127         return true;
128     }
129 
130 
131    
132     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
133         return allowed[tokenOwner][spender];
134     }
135 
136 
137     
138     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         emit Approval(msg.sender, spender, tokens);
141         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
142         return true;
143     }
144 
145 
146     
147     function () public payable {
148         revert();
149     }
150 
151 
152     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
153         return ERC20Interface(tokenAddress).transfer(owner, tokens);
154     }
155 }