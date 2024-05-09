1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // UBS Token contract - Created for Unified Blockchain Solutions
5 //
6 // Deployed to : 0x6ab399423885c67ec0e272daa8711E7820f36cB0
7 // Symbol      : UBS
8 // Name        : UBS Token
9 // Total supply: 5000000000
10 // Decimals    : 0
11 //
12 
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract UBSToken is ERC20Interface, Owned, SafeMath {
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
109     // Constructor
110     // ------------------------------------------------------------------------
111     function UBSToken() public {
112         symbol = "UBS";
113         name = "UBS Token";
114         decimals = 0;
115         _totalSupply = 5000000000;
116         balances[0x6ab399423885c67ec0e272daa8711E7820f36cB0] = _totalSupply;
117         Transfer(address(0), 0x6ab399423885c67ec0e272daa8711E7820f36cB0, _totalSupply);
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ------------------------------------------------------------------------
124     function totalSupply() public constant returns (uint) {
125         return _totalSupply  - balances[address(0)];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Get the token balance for account tokenOwner
131     // ------------------------------------------------------------------------
132     function balanceOf(address tokenOwner) public constant returns (uint balance) {
133         return balances[tokenOwner];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Transfer the balance from token owner's account to to account
139     // - Owner's account must have sufficient balance to transfer
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         Transfer(msg.sender, to, tokens);
146         return true;
147     }
148     
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to to account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154 
155     function transferMultiple(address[] dests, uint256[] values) public onlyOwner
156     returns (uint256) {
157         uint256 i = 0;
158         while (i < dests.length) {
159             transfer(dests[i], values[i]);
160             i += 1;
161         }
162         return(i);
163 
164     }
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for spender to transferFrom(...) tokens
168     // from the token owner's account
169     //
170     // recommends that there are no checks for the approval double-spend attack
171     // as this should be implemented in user interfaces 
172     // ------------------------------------------------------------------------
173     function approve(address spender, uint tokens) public returns (bool success) {
174         allowed[msg.sender][spender] = tokens;
175         Approval(msg.sender, spender, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Transfer tokens from the from account to the to account
182     // 
183     // The calling account must already have sufficient tokens approve(...)-d
184     // for spending from the from account and
185     // - From account must have sufficient balance to transfer
186     // - Spender must have sufficient allowance to transfer
187     // - 0 value transfers are allowed
188     // ------------------------------------------------------------------------
189     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
190         balances[from] = safeSub(balances[from], tokens);
191         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
192         balances[to] = safeAdd(balances[to], tokens);
193         Transfer(from, to, tokens);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Returns the amount of tokens approved by the owner that can be
200     // transferred to the spender's account
201     // ------------------------------------------------------------------------
202     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
203         return allowed[tokenOwner][spender];
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Token owner can approve for spender to transferFrom(...) tokens
209     // from the token owner's account. The spender contract function
210     // receiveApproval(...) is then executed
211     // ------------------------------------------------------------------------
212     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
213         allowed[msg.sender][spender] = tokens;
214         Approval(msg.sender, spender, tokens);
215         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
216         return true;
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Don't accept ETH
222     // ------------------------------------------------------------------------
223     function () public payable {
224         revert();
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Owner can transfer out any accidentally sent ERC20 tokens
230     // ------------------------------------------------------------------------
231     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
232         return ERC20Interface(tokenAddress).transfer(owner, tokens);
233     }
234 }