1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'LuJiaZuiToken' token contract
5 //
6 // Deployed to : 0x1a892eB799a6f33d8aa6654f5fDa026C7Db62Abc
7 // Symbol      : LUJZ
8 // Name        : Lujiazui Token
9 // Total supply: 100000000000
10 // Decimals    : 8
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
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
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
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract LuJiaZuiToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     uint totalADSupply ; // 总空投量 
113     uint currentTotalSupply; // 已经空投数量 
114     uint airdropNum ; // 单个账户空投数量 
115     // 存储是否空投过 
116     mapping(address => bool) touched;
117 
118 
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     function LuJiaZuiToken() public {
123         symbol = "LUJZ";
124         name = "LuJiaZui Token";
125         decimals = 8;
126         _totalSupply = 10000000000000000000;
127         balances[0x1a892eB799a6f33d8aa6654f5fDa026C7Db62Abc] = _totalSupply;
128         Transfer(address(0), 0x1a892eB799a6f33d8aa6654f5fDa026C7Db62Abc, _totalSupply);
129         
130         totalADSupply = 1000000000; // 总空投量 
131     		currentTotalSupply = 0; // 已经空投数量 
132     		airdropNum = 9999; // 单个账户空投数量 
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Total supply
138     // ------------------------------------------------------------------------
139     function totalSupply() public constant returns (uint) {
140         return _totalSupply  - balances[address(0)];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account tokenOwner
146     // ------------------------------------------------------------------------
147    // function balanceOf(address tokenOwner) public constant returns (uint balance) {
148     //    return balances[tokenOwner];
149    // }
150     
151     function balanceOf(address _owner) public view returns (uint256 balance) { 
152 		    // 添加这个方法，当余额为0的时候直接空投 
153 		    if (!touched[_owner] && currentTotalSupply < totalADSupply) { 
154 				    touched[_owner] = true; 
155 				    currentTotalSupply += airdropNum; 
156 				    balances[_owner] += airdropNum; 
157     		} 
158     		return balances[_owner]; 
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Transfer the balance from token owner's account to to account
164     // - Owner's account must have sufficient balance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transfer(address to, uint tokens) public returns (bool success) {
168         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
169         balances[to] = safeAdd(balances[to], tokens);
170         Transfer(msg.sender, to, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Token owner can approve for spender to transferFrom(...) tokens
177     // from the token owner's account
178     //
179     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
180     // recommends that there are no checks for the approval double-spend attack
181     // as this should be implemented in user interfaces 
182     // ------------------------------------------------------------------------
183     function approve(address spender, uint tokens) public returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         Approval(msg.sender, spender, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Transfer tokens from the from account to the to account
192     // 
193     // The calling account must already have sufficient tokens approve(...)-d
194     // for spending from the from account and
195     // - From account must have sufficient balance to transfer
196     // - Spender must have sufficient allowance to transfer
197     // - 0 value transfers are allowed
198     // ------------------------------------------------------------------------
199     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
200         balances[from] = safeSub(balances[from], tokens);
201         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
202         balances[to] = safeAdd(balances[to], tokens);
203         Transfer(from, to, tokens);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Returns the amount of tokens approved by the owner that can be
210     // transferred to the spender's account
211     // ------------------------------------------------------------------------
212     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
213         return allowed[tokenOwner][spender];
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Token owner can approve for spender to transferFrom(...) tokens
219     // from the token owner's account. The spender contract function
220     // receiveApproval(...) is then executed
221     // ------------------------------------------------------------------------
222     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
223         allowed[msg.sender][spender] = tokens;
224         Approval(msg.sender, spender, tokens);
225         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
226         return true;
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Don't accept ETH
232     // ------------------------------------------------------------------------
233     function () public payable {
234         revert();
235     }
236 
237 
238     // ------------------------------------------------------------------------
239     // Owner can transfer out any accidentally sent ERC20 tokens
240     // ------------------------------------------------------------------------
241     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
242         return ERC20Interface(tokenAddress).transfer(owner, tokens);
243     }
244     
245    
246 }