1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Tutorcoin' token contract
5 //
6 // Tutorcoin is a smart contract for online education platform.
7 // 
8 // We are building a next generation online education & knowledge share platform. Though our platform, 
9 // every people can get educated or share his/her knowledge easily and efficiently.
10 //
11 // Tutorcoin can help keep every knowledge sharing process accuracy and clear to the whole community, and 
12 // keep the transaction process secure and efficient. With Tutorcoin, people can easily find a 
13 // better educator by knowing full history of his/her knowledge sharing, and platform can rank and recommend 
14 // educator by it as well.
15 //
16 // Tutorcoin will be used for tracking one’s contribution to the community, keeping the balance of giving new 
17 // knowledge to the community, and getting education from others.
18 //
19 //
20 //
21 // Deployed to : 0xB2bb88A37C3646B5E29481Ea057F06F94A49C584
22 // Symbol      : TTC
23 // Name        : Tutorcoin
24 // Total supply: 1000000000000000
25 // Decimals    : 6
26 //
27 // ----------------------------------------------------------------------------
28 
29 
30 
31 
32 // ----------------------------------------------------------------------------
33 // Tutorcoin is based on ERC-20 interface, here is the interface and methods in it
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
35 // ----------------------------------------------------------------------------
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
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Util functions
56 // ----------------------------------------------------------------------------
57 
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 contract SafeMath {
85     function safeAdd(uint a, uint b) public pure returns (uint c) {
86         c = a + b;
87         require(c >= a);
88     }
89     function safeSub(uint a, uint b) public pure returns (uint c) {
90         require(b <= a);
91         c = a - b;
92     }
93     function safeMul(uint a, uint b) public pure returns (uint c) {
94         c = a * b;
95         require(a == 0 || c / a == b);
96     }
97     function safeDiv(uint a, uint b) public pure returns (uint c) {
98         require(b > 0);
99         c = a / b;
100     }
101 }
102 
103 
104 // ----------------------------------------------------------------------------
105 // Init of Tutorcoin contract
106 //
107 // 'Tutorcoin' token contract
108 //
109 // Tutorcoin is a smart contract for online education platform.
110 // 
111 // We are building a next generation online education & knowledge share platform. Though our platform, 
112 // every people can get educated or share his/her knowledge easily and efficiently.
113 //
114 // Tutorcoin can help keep every knowledge sharing process accuracy and clear to the whole community, and 
115 // keep the transaction process secure and efficient. With Tutorcoin, people can easily find a 
116 // better educator by knowing full history of his/her knowledge sharing, and platform can rank and recommend 
117 // educator by it as well.
118 //
119 // Tutorcoin will be used for tracking one’s contribution to the community, keeping the balance of giving new 
120 // knowledge to the community, and getting education from others.
121 // ----------------------------------------------------------------------------
122 contract TutorcoinToken is ERC20Interface, Owned, SafeMath {
123     string public symbol;
124     string public  name;
125     uint8 public decimals;
126     uint public _totalSupply;
127 
128     mapping(address => uint) balances;
129     mapping(address => mapping(address => uint)) allowed;
130 
131 
132     constructor() public {
133         symbol = "TTC";
134         name = "Tutorcoin";
135         decimals = 6;
136         _totalSupply = 1000000000000000;
137         balances[0xB2bb88A37C3646B5E29481Ea057F06F94A49C584] = _totalSupply;
138         emit Transfer(address(0), 0xB2bb88A37C3646B5E29481Ea057F06F94A49C584, _totalSupply);
139     }
140 
141     function totalSupply() public constant returns (uint) {
142         return _totalSupply  - balances[address(0)];
143     }
144 
145     function balanceOf(address tokenOwner) public constant returns (uint balance) {
146         return balances[tokenOwner];
147     }
148 
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         emit Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Approve the educator to take credit after course
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer TTC from learner to educator
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = safeSub(balances[from], tokens);
172         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
173         balances[to] = safeAdd(balances[to], tokens);
174         emit Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Return the amount of tokens from one learner
181 	// To keep the community balance, learner must have enough TTC for learning new knowledge from the community,
182 	// people can get TTC by giving knowledge to others in the community
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Learner approves educator's class, and agrees to give TTC to educator as the request
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         emit Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199 
200     function () public payable {
201         revert();
202     }
203 
204     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
205         return ERC20Interface(tokenAddress).transfer(owner, tokens);
206     }
207 	
208 }