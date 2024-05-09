1 pragma solidity ^0.5.1;
2 
3 // ----------------------------------------------------------------------------
4 // 'IT Services' token contract
5 //
6 // Deployed to : 0x88F30FD7d35B4A95d5b6c86926d3Eabb35ff4403
7 // Symbol      : ITS
8 // Name        : IT Services Token By SatyaSys
9 // Total supply: 15840000000
10 // Decimals    : 2
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
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
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public view returns (uint);
47     function balanceOf(address tokenOwner) public view returns (uint balance);
48     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
65     
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract ITSToken is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "ITS";
118         name = "ITSToken";
119         decimals = 2;
120         _totalSupply = 15840000000;
121         balances[0x88F30FD7d35B4A95d5b6c86926d3Eabb35ff4403] = _totalSupply;
122         emit Transfer(address(0), 0x88F30FD7d35B4A95d5b6c86926d3Eabb35ff4403, _totalSupply);
123     }
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public view returns (uint) {
129         return _totalSupply  - balances[address(0)];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account tokenOwner
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public view returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to to account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
148         balances[to] = safeAdd(balances[to], tokens);
149         emit Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for spender to transferFrom(...) tokens
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces 
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer tokens from the from account to the to account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the from account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         balances[from] = safeSub(balances[from], tokens);
180         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
181         balances[to] = safeAdd(balances[to], tokens);
182         emit Transfer(from, to, tokens);
183         return true;
184     }
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for spender to transferFrom(...) tokens
197     // from the token owner's account. The spender contract function
198     // receiveApproval(...) is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         emit Approval(msg.sender, spender, tokens);
203         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Don't accept ETH
210     // ------------------------------------------------------------------------
211     function () external payable {
212         revert();
213     }
214 event Burn(address indexed burner, uint256 value);
215   function burn(uint256 _value) public {
216     _burn(msg.sender, _value);
217   }
218 function _burn(address _who, uint256 _value) internal {
219     require(_value <= balances[_who]);
220 balances[_who] = balances[_who] - _value;
221     _totalSupply = _totalSupply - _value;
222     emit Burn(_who, _value);
223     emit Transfer(_who, address(0), _value);
224   }
225 
226     // ------------------------------------------------------------------------
227     // Owner can transfer out any accidentally sent ERC20 tokens
228     // ------------------------------------------------------------------------
229     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230         return ERC20Interface(tokenAddress).transfer(owner, tokens);
231     }
232 }