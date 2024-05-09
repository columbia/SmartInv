1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'IVNT4' token contract
5 //
6 // Deployed to : 0xc9af6248b04d25468f289f9a280cd2d7a646858e
7 // Symbol      : IVNT4
8 // Name        : IVNT4 Token
9 // Total supply: 96900000000
10 // Decimals    : 18
11 //
12 // Improved from Moritz Neto with BokkyPooBah
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
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50     function burn(uint256 value) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54     event Burn(address indexed from, uint256 value);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79     
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // Contract function to receive approval and execute function in one call
91 //
92 // Borrowed from MiniMeToken
93 // ----------------------------------------------------------------------------
94 contract ApproveAndCallFallBack {
95     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract IVNT4Token is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     address public ownerAddress;
107     uint8 public decimals;
108     uint public totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "IVNT4";
118         name = "IVNT4 Token";
119         decimals = 18;
120         totalSupply = 969 * 10 ** 26;
121         ownerAddress = 0xc9af6248b04d25468f289f9a280cd2d7a646858e;
122         balances[ownerAddress] = totalSupply;
123         emit Transfer(address(0), ownerAddress, totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return totalSupply - balances[address(0)];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account tokenOwner
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public constant returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to to account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
150         balances[to] = safeAdd(balances[to], tokens);
151         emit Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for spender to transferFrom(...) tokens
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces 
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         emit Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer tokens from the from account to the to account
173     // 
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the from account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         balances[from] = safeSub(balances[from], tokens);
182         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
183         balances[to] = safeAdd(balances[to], tokens);
184         emit Transfer(from, to, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for spender to transferFrom(...) tokens
200     // from the token owner's account. The spender contract function
201     // receiveApproval(...) is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () public payable {
215         revert();
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Owner can transfer out any accidentally sent ERC20 tokens
221     // ------------------------------------------------------------------------
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Destroy tokens
229     // Remove `value` tokens from the system irreversibly
230     // @param value the amount of money to burn
231     // ------------------------------------------------------------------------
232     function burn(uint256 value) public returns (bool success) {
233         require(balances[msg.sender] >= value);   // Check if the sender has enough
234         balances[msg.sender] -= value;            // Subtract from the sender
235         totalSupply -= value;                     // Updates totalSupply
236         emit Burn(msg.sender, value);
237         return true;
238     }
239 }