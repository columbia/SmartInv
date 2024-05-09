1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //**********************
5 // 'CRN' Token contract
6 // 'Our official site: https://cryption.online
7 // 'Our official twitter: https://twitter.com/Cryption-token
8 // Deployed to : 0xd0d2d007d4463f8eac2e56fdcab4b260137b7822
9 //**********************
10 // Symbol      : CRN
11 // Name        : Cryption Token
12 // Total supply: 2000000000
13 // Decimals    : 18
14 // 
15 // Enjoy.
16 //
17 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2019. The MIT Licence.
18 // ----------------------------------------------------------------------------
19 
20 
21 // ----------------------------------------------------------------------------
22 // Safe maths
23 // ----------------------------------------------------------------------------
24 contract SafeMath {
25     function safeAdd(uint a, uint b) public pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function safeSub(uint a, uint b) public pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33     function safeMul(uint a, uint b) public pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37     function safeDiv(uint a, uint b) public pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC Token Standard #20 Interface
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 // ----------------------------------------------------------------------------
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 //
64 // Borrowed from MiniMeToken
65 // ----------------------------------------------------------------------------
66 contract ApproveAndCallFallBack {
67     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // Owned contract
73 // ----------------------------------------------------------------------------
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96         newOwner = address(0);
97     }
98 }
99 
100 
101 // ----------------------------------------------------------------------------
102 // ERC20 Token, with the addition of symbol, name and decimals and assisted
103 // token transfers 
104 // ----------------------------------------------------------------------------
105 contract Cryption is ERC20Interface, Owned, SafeMath {
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint public _totalSupply;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor () public {
119         symbol = "CRN";
120         name = "Cryption Token";
121         decimals = 18;
122         _totalSupply = 2000000000000000000000000000;
123         balances[0xD0d2d007d4463f8eac2E56fdcaB4b260137b7822] = _totalSupply;
124         emit Transfer(address(0), 0xD0d2d007d4463f8eac2E56fdcaB4b260137b7822, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account tokenOwner
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
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
152         emit Transfer(msg.sender, to, tokens);
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
167         emit Approval(msg.sender, spender, tokens);
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
185         emit Transfer(from, to, tokens);
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
206         emit Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Don't accept ETH
214     // ------------------------------------------------------------------------
215     function () public payable {
216         revert();
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
224         return ERC20Interface(tokenAddress).transfer(owner, tokens);
225     }
226 }