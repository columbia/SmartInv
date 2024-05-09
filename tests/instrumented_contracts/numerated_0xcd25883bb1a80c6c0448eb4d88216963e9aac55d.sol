1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'BYB' token contract
5 //
6 // Deployed to : 0x96A14D81E5c72aD8F6BD5E4FB3Be53692a305629
7 // Symbol      : BYB
8 // Name        : Baye Coin
9 // Total supply: 20000001
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by HURTEK BILISIM ve TEKNOLOJI AS 07.12.2018. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath
22 {
23     function safeAdd(uint a, uint b) public pure returns(uint c)
24 {
25     c = a + b;
26     require(c >= a);
27 }
28 function safeSub(uint a, uint b) public pure returns(uint c)
29 {
30     require(b <= a);
31     c = a - b;
32 }
33 function safeMul(uint a, uint b) public pure returns(uint c)
34 {
35     c = a * b;
36     require(a == 0 || c / a == b);
37 }
38 function safeDiv(uint a, uint b) public pure returns(uint c)
39 {
40     require(b > 0);
41     c = a / b;
42 }
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface
51 {
52     function totalSupply() public constant returns(uint);
53 function balanceOf(address tokenOwner) public constant returns(uint balance);
54 function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
55 function transfer(address to, uint tokens) public returns(bool success);
56 function approve(address spender, uint tokens) public returns(bool success);
57 function transferFrom(address from, address to, uint tokens) public returns(bool success);
58 
59 event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Contract function to receive approval and execute function in one call
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack
68 {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // Owned contract
75 // ----------------------------------------------------------------------------
76 contract Owned
77 {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83 constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner
88 {
89     require(msg.sender == owner);
90     _;
91 }
92 
93 function transferOwnership(address _newOwner) public onlyOwner {
94         newOwner = _newOwner;
95     }
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98 emit OwnershipTransferred(owner, newOwner);
99 owner = newOwner;
100         newOwner = address(0);
101     }
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // ERC20 Token, with the addition of symbol, name and decimals and assisted
107 // token transfers
108 // ----------------------------------------------------------------------------
109 contract BayeCoin is ERC20Interface, Owned, SafeMath {
110     string public symbol;
111     string public name;
112     uint8 public decimals;
113     uint public _totalSupply;
114 
115     mapping(address => uint) balances;
116     mapping(address => mapping(address => uint)) allowed;
117 
118 
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     constructor() public {
123         symbol = "BYB";
124         name = "Baye Coin";
125         decimals = 18;
126         _totalSupply = 20000001000000000000000000;
127         balances[0x96A14D81E5c72aD8F6BD5E4FB3Be53692a305629] = _totalSupply;
128         emit Transfer(address(0), 0x96A14D81E5c72aD8F6BD5E4FB3Be53692a305629, _totalSupply);
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns(uint)
136 {
137     return _totalSupply - balances[address(0)];
138 }
139 
140 
141 // ------------------------------------------------------------------------
142 // Get the token balance for account tokenOwner
143 // ------------------------------------------------------------------------
144 function balanceOf(address tokenOwner) public constant returns(uint balance)
145 {
146     return balances[tokenOwner];
147 }
148 
149 
150 // ------------------------------------------------------------------------
151 // Transfer the balance from token owner's account to to account
152 // - Owner's account must have sufficient balance to transfer
153 // - 0 value transfers are allowed
154 // ------------------------------------------------------------------------
155 function transfer(address to, uint tokens) public returns(bool success)
156 {
157     balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158     balances[to] = safeAdd(balances[to], tokens);
159     emit Transfer(msg.sender, to, tokens);
160     return true;
161 }
162 
163 
164 // ------------------------------------------------------------------------
165 // Token owner can approve for spender to transferFrom(...) tokens
166 // from the token owner's account
167 //
168 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169 // recommends that there are no checks for the approval double-spend attack
170 // as this should be implemented in user interfaces 
171 // ------------------------------------------------------------------------
172 function approve(address spender, uint tokens) public returns(bool success)
173 {
174     allowed[msg.sender][spender] = tokens;
175     emit Approval(msg.sender, spender, tokens);
176     return true;
177 }
178 
179 
180 // ------------------------------------------------------------------------
181 // Transfer tokens from the from account to the to account
182 // 
183 // The calling account must already have sufficient tokens approve(...)-d
184 // for spending from the from account and
185 // - From account must have sufficient balance to transfer
186 // - Spender must have sufficient allowance to transfer
187 // - 0 value transfers are allowed
188 // ------------------------------------------------------------------------
189 function transferFrom(address from, address to, uint tokens) public returns(bool success)
190 {
191     balances[from] = safeSub(balances[from], tokens);
192     allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193     balances[to] = safeAdd(balances[to], tokens);
194     emit Transfer(from, to, tokens);
195     return true;
196 }
197 
198 
199 // ------------------------------------------------------------------------
200 // Returns the amount of tokens approved by the owner that can be
201 // transferred to the spender's account
202 // ------------------------------------------------------------------------
203 function allowance(address tokenOwner, address spender) public constant returns(uint remaining)
204 {
205     return allowed[tokenOwner][spender];
206 }
207 
208 
209 // ------------------------------------------------------------------------
210 // Token owner can approve for spender to transferFrom(...) tokens
211 // from the token owner's account. The spender contract function
212 // receiveApproval(...) is then executed
213 // ------------------------------------------------------------------------
214 function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success)
215 {
216     allowed[msg.sender][spender] = tokens;
217     emit Approval(msg.sender, spender, tokens);
218     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
219     return true;
220 }
221 
222 
223 // ------------------------------------------------------------------------
224 // Don't accept ETH
225 // ------------------------------------------------------------------------
226 function() public payable {
227         revert();
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success)
235 {
236     return ERC20Interface(tokenAddress).transfer(owner, tokens);
237 }
238 }