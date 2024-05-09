1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 
5 //
6 // Deployed to : 0x8d536DB2871D657D3288De2F45Bc7d313b1e3CFA
7 // Symbol      : JRM
8 // Name        : Jerome
9 // Total supply: 42069
10 // Decimals    : 0
11 //
12 // you will acquire this token, you will like this token.
13 //
14 //
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // this is the devil nerd shit my preacher warned me about
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // boolshit 
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 //i've never heard of minime token. i wrote this. minime author probably is a nerd
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // get owned, nerd
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 //nerd shit
97 // ----------------------------------------------------------------------------
98 contract Jerome is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107 
108     // ------------------------------------------------------------------------
109     // legit
110     // ------------------------------------------------------------------------
111     constructor() public {
112         symbol = "JRM";
113         name = "Jerome";
114         decimals = 0;
115         _totalSupply = 42069;
116         balances[owner] = _totalSupply;
117         emit Transfer(address(0), owner, _totalSupply);
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // nerd shit
123     // ------------------------------------------------------------------------
124     function totalSupply() public constant returns (uint) {
125         return _totalSupply  - balances[address(0)];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     //nerd shit
131     // ------------------------------------------------------------------------
132     function balanceOf(address tokenOwner) public constant returns (uint balance) {
133         return balances[tokenOwner];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     //shittiest part of this nerd shit, why cant i keep your money AND my tokens
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         emit Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     //bla bla bla nerd shit
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     //nerd shit
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = safeSub(balances[from], tokens);
163         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     //more nerd shit
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     //why wont these nerds shut the fuck up and give me my money
180     // ------------------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     //bullshit nerd shit
191     // ------------------------------------------------------------------------
192     function () public payable {
193         revert();
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     //tbh just be glad this part is even here
199     // ------------------------------------------------------------------------
200     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
201         return ERC20Interface(tokenAddress).transfer(owner, tokens);
202     }
203 }