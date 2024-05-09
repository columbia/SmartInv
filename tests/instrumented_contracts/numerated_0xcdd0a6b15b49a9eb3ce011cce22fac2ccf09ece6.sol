1 pragma solidity ^0.4.18;
2 
3 // ------------------------------------------------------------------------------------
4 // 'ARMTOKEN' Token Contract
5 //
6 // Contract Address : 0xcDd0A6B15B49A9eb3Ce011CCE22FAc2ccf09ecE6 [Please don't send ETH to this Contract Address because it'll never mint Token]
7 // Symbol      		: TARM
8 // Name        		: ARMTOKEN
9 // Total Supply		: 330,000,000 TARM
10 // Decimals    		: 18
11 // Holder Address	: 0x479E6472a7E752a968974C91Ae7fB0d59ce2b122
12 //
13 // © By 'ARMTOKEN' With 'TARM' Symbol 2020.
14 //
15 // ------------------------------------------------------------------------------------
16 
17 
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 contract ARMTOKEN is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     function ARMTOKEN() public {
94         symbol = "TARM";
95         name = "ARMTOKEN";
96         decimals = 18;
97         _totalSupply = 330000000000000000000000000;
98         balances[0x479E6472a7E752a968974C91Ae7fB0d59ce2b122] = _totalSupply;
99         Transfer(address(0), 0x479E6472a7E752a968974C91Ae7fB0d59ce2b122, _totalSupply);
100     }
101 
102 
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112 
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
115         balances[to] = safeAdd(balances[to], tokens);
116         Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120 
121     function approve(address spender, uint tokens) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         Approval(msg.sender, spender, tokens);
124         return true;
125     }
126 
127 
128     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
129         balances[from] = safeSub(balances[from], tokens);
130         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
131         balances[to] = safeAdd(balances[to], tokens);
132         Transfer(from, to, tokens);
133         return true;
134     }
135 
136 
137     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141 
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146         return true;
147     }
148 
149 
150     function () public payable {
151         revert();
152     }
153 
154 
155     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERC20Interface(tokenAddress).transfer(owner, tokens);
157     }
158 }