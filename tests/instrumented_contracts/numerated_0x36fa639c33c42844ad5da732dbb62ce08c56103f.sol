1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'GDC' token contract
5 //
6 // Deployed to : 0x46774Bd9D565B82ee36427F0150fE80ee97fD117
7 // Symbol      : GDC
8 // Name        : GLOBAL DECENTRALIZED COMMUNITY
9 // Total supply: 100000000
10 // Decimals    : 18
11 
12 
13 
14 
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 
49 
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
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
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 
84 contract GDC is ERC20Interface, Owned, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94 
95     constructor() public {
96         symbol = "GDC";
97         name = "GLOBAL DECENTRALIZED COMMUNITY";
98         decimals = 18;
99         _totalSupply = 100000000000000000000000000;
100         balances[0x46774Bd9D565B82ee36427F0150fE80ee97fD117] = _totalSupply;
101         emit Transfer(address(0), 0x46774Bd9D565B82ee36427F0150fE80ee97fD117, _totalSupply);
102     }
103 
104 
105 
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply  - balances[address(0)];
108     }
109 
110 
111 
112     function balanceOf(address tokenOwner) public constant returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117 
118     function transfer(address to, uint tokens) public returns (bool success) {
119         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125 
126 
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134 
135     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
136         balances[from] = safeSub(balances[from], tokens);
137         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         emit Transfer(from, to, tokens);
140         return true;
141     }
142 
143 
144 
145     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
146         return allowed[tokenOwner][spender];
147     }
148 
149 
150 
151     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
155         return true;
156     }
157 
158 
159 
160     function () public payable {
161         revert();
162     }
163 
164 
165 
166     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
167         return ERC20Interface(tokenAddress).transfer(owner, tokens);
168     }
169 }