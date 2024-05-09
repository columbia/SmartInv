1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'OneEightXCoin' token contract
5 //
6 // Deployed to : 0xB4Bf52382a05936d5691f3d12Fdc58253F159c1C
7 // Symbol      : OEX
8 // Name        : OneEightXCoin
9 // Total supply: 100000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71     function acceptOwnership() public {
72         require(msg.sender == newOwner);
73         emit OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75         newOwner = address(0);
76     }
77 }
78 
79 
80 
81 contract OneEightXCoin is ERC20Interface, Owned, SafeMath {
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     constructor() public {
92         symbol = "OEX";
93         name = "OneEightXCoin";
94         decimals = 18;
95         _totalSupply = 18000000000000000000000000;
96         balances[0xB4Bf52382a05936d5691f3d12Fdc58253F159c1C] = _totalSupply;
97         emit Transfer(address(0), 0xB4Bf52382a05936d5691f3d12Fdc58253F159c1C, _totalSupply);
98     }
99 
100 
101 
102     function totalSupply() public constant returns (uint) {
103         return _totalSupply  - balances[address(0)];
104     }
105 
106 
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112 
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
115         balances[to] = safeAdd(balances[to], tokens);
116         emit Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120 
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         emit Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128 
129 
130     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
131         balances[from] = safeSub(balances[from], tokens);
132         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
133         balances[to] = safeAdd(balances[to], tokens);
134         emit Transfer(from, to, tokens);
135         return true;
136         
137     }
138 
139 
140 
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145 
146 
147     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151         return true;
152     }
153 
154 
155 
156     function () public payable {
157         revert();
158     }
159 
160 
161     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
162         return ERC20Interface(tokenAddress).transfer(owner, tokens);
163     }
164 }