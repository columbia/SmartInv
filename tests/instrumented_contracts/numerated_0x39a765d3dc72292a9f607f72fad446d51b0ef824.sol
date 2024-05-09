1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Crypto Commonwealth token contract
5 //
6 // Deployed to : 0x445419a4644985a12346Bbd31C41f5017f3527E8
7 // Symbol      : COMM
8 // Name        : Crypto Commonwealth
9 // Total supply: 1000000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard Interface
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69     
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract COMM is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     constructor() public {
109         symbol = "COMM";
110         name = "Crypto Commonwealth";
111         decimals = 18;
112         _totalSupply = 1000000000000000000000000000;
113         balances[0x445419a4644985a12346Bbd31C41f5017f3527E8] = _totalSupply;
114         emit Transfer(address(0), 0x445419a4644985a12346Bbd31C41f5017f3527E8, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account tokenOwner
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to to account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         emit Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for spender to transferFrom(...) tokens
149     // from the token owner's account
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer tokens from the from account to the to account
160     // 
161     // The calling account must already have sufficient tokens approve(...)-d
162     // for spending from the from account and
163     // - From account must have sufficient balance to transfer
164     // - Spender must have sufficient allowance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = safeSub(balances[from], tokens);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for spender to transferFrom(...) tokens
187     // from the token owner's account. The spender contract function
188     // receiveApproval(...) is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         emit Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Don't accept ETH
200     // ------------------------------------------------------------------------
201     function () public payable {
202         revert();
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Owner can transfer out any accidentally sent ERC20 tokens
208     // ------------------------------------------------------------------------
209     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
210         return ERC20Interface(tokenAddress).transfer(owner, tokens);
211     }
212 }