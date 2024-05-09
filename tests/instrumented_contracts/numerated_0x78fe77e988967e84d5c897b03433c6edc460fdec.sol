1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 // 'Aramco Coin' token contract
5 //
6 // Deployed to : 0xA0f0431d2a772b4ED748D37373bEb99F7c6a1D24
7 // Symbol      : ARM
8 // Name        : Aramco Coin
9 // Total supply: 50,00,00,000.000000
10 // Decimals    : 6
11 //
12 // (c) Aramco Coin
13 // (c) Aramco Coin 2018
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 contract SafeMath {
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function safeMul(uint a, uint b) public pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function safeDiv(uint a, uint b) public pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token
98 // ----------------------------------------------------------------------------
99 contract Aramco is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     function Aramco() public {
113         symbol = "ARM";
114         name = "Aramco";
115         decimals = 6;
116         _totalSupply = 500000000000000;
117         balances[0xA0f0431d2a772b4ED748D37373bEb99F7c6a1D24] = _totalSupply;
118         Transfer(address(0), 0xA0f0431d2a772b4ED748D37373bEb99F7c6a1D24, _totalSupply);
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public constant returns (uint) {
126         return _totalSupply  - balances[address(0)];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account tokenOwner
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to to account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns (bool success) {
144         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
145         balances[to] = safeAdd(balances[to], tokens);
146         Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for spender to transferFrom(...) tokens
153     // from the token owner's account
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         Approval(msg.sender, spender, tokens);
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
175         Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
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
196         Approval(msg.sender, spender, tokens);
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