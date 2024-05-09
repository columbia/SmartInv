1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //
5 //
6 // Deployed to : 0x99b5787C5182aBAbF1b081e958cc5d8F648cD1af
7 // Symbol      : SPRK
8 // Name        : SparkPoint
9 // Total supply: 20000000000
10 // Decimals    : 18
11 //
12 //
13 //
14 // 
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
55     event Burn(address indexed from, uint256 value);
56 
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Contract function to receive approval and execute function in one call
62 //
63 //
64 // ----------------------------------------------------------------------------
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // Owned contract
72 // ----------------------------------------------------------------------------
73 contract Owned {
74     address public owner;
75     address public newOwner;
76 
77     event OwnershipTransferred(address indexed _from, address indexed _to);
78 
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function transferOwnership(address _newOwner) public onlyOwner {
89         newOwner = _newOwner;
90     }
91     function acceptOwnership() public {
92         require(msg.sender == newOwner);
93         emit OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95         newOwner = address(0);
96     }
97 }
98 
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and assisted
102 // token transfers
103 // ----------------------------------------------------------------------------
104 contract SparkPoint is ERC20Interface, Owned, SafeMath {
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor () public {
118         symbol = "SPRK";
119         name = "SparkPoint";
120         decimals = 18;
121         _totalSupply = 20000000000000000000000000000;
122         balances[0x99b5787C5182aBAbF1b081e958cc5d8F648cD1af] = _totalSupply;
123         emit Transfer(address(0), 0x99b5787C5182aBAbF1b081e958cc5d8F648cD1af, _totalSupply);
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
210     function burn(uint256 _value) public returns (bool success) {
211         require(balances[msg.sender] >= _value);   // Check if the sender has enough
212         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);  // Subtract from the sender
213         _totalSupply = SafeMath.safeSub(_totalSupply, _value);                // Updates totalSupply
214         emit Burn(msg.sender, _value);
215         return true;
216         }
217 
218 
219     // ------------------------------------------------------------------------
220     // Don't accept ETH
221     // ------------------------------------------------------------------------
222     function () public payable {
223         revert();
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }