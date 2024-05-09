1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'TOSS' token contract
5 // Symbol      : TOS
6 // Name        : TOS Token
7 // Total supply: 9999999
8 //
9 //
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
95 contract TossToken is ERC20Interface, Owned, SafeMath {
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
109         symbol = "TOSS";
110         name = "TOSS token";
111         decimals = 8;
112         _totalSupply = 999999900000000;
113         balances[0x061C4b428ef9E4bEF19d8e0755B2d204ba606eca] = _totalSupply;
114         emit Transfer(address(0), 0x061C4b428ef9E4bEF19d8e0755B2d204ba606eca, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public view returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account tokenOwner
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public view returns (uint balance) {
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
150     //
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces 
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Transfer tokens from the from account to the to account
164     // 
165     // The calling account must already have sufficient tokens approve(...)-d
166     // for spending from the from account and
167     // - From account must have sufficient balance to transfer
168     // - Spender must have sufficient allowance to transfer
169     // - 0 value transfers are allowed
170     // ------------------------------------------------------------------------
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = safeSub(balances[from], tokens);
173         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175         emit Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Token owner can approve for spender to transferFrom(...) tokens
191     // from the token owner's account. The spender contract function
192     // receiveApproval(...) is then executed
193     // ------------------------------------------------------------------------
194     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         emit Approval(msg.sender, spender, tokens);
197         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Don't accept ETH
204     // ------------------------------------------------------------------------
205     function () public payable {
206         revert();
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Owner can transfer out any accidentally sent ERC20 tokens
212     // ------------------------------------------------------------------------
213     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
214         return ERC20Interface(tokenAddress).transfer(owner, tokens);
215     }
216 }