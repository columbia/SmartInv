1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'name' token contract
5 //
6 // Deployed to : your address
7 // Symbol      : stock market term
8 // Name        : Name
9 // Total supply: 100000000
10 // Decimals    : 18
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
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
78     function Owned() public {
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
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95         
96     }
97 }
98      
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and assisted
102 // token transfers
103 // ----------------------------------------------------------------------------
104 contract Extreme is ERC20Interface, Owned, SafeMath {
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112     
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     
117     function Extreme() public {
118         symbol = "XT";
119         name = "Extreme";
120         decimals = 18;
121         _totalSupply = 5000000000000000000000000;
122         balances[0x4DFD4C3D70A13B491B2F10FBB26e3BD2BaD5e93f] = _totalSupply; //MEW address here
123         Transfer(address(0), 0x4DFD4C3D70A13B491B2F10FBB26e3BD2BaD5e93f, _totalSupply);//MEW address here
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return _totalSupply  - balances[address(0)];
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
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to to account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for spender to transferFrom(...) tokens
159     // from the token owner's account
160     //
161     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162     // recommends that there are no checks for the approval double-spend attack
163     // as this should be implemented in user interfaces 
164     // ------------------------------------------------------------------------
165     function approve(address spender, uint tokens) public returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         Approval(msg.sender, spender, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Transfer tokens from the from account to the to account
174     // 
175     // The calling account must already have sufficient tokens approve(...)-d
176     // for spending from the from account and
177     // - From account must have sufficient balance to transfer
178     // - Spender must have sufficient allowance to transfer
179     // - 0 value transfers are allowed
180     // ------------------------------------------------------------------------
181     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
182         balances[from] = safeSub(balances[from], tokens);
183         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
184         balances[to] = safeAdd(balances[to], tokens);
185         Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for spender to transferFrom(...) tokens
201     // from the token owner's account. The spender contract function
202     // receiveApproval(...) is then executed
203     // ------------------------------------------------------------------------
204     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
205         allowed[msg.sender][spender] = tokens;
206         Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211     
212     // ------------------------------------------------------------------------
213     // Don't accept ETH
214     // ------------------------------------------------------------------------
215     function () public payable {
216         
217       
218     }
219 
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }