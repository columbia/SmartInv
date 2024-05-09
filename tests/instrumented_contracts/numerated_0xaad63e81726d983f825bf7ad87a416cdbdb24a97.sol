1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'India Stocks Coin' token contract
5 //
6 // Deployed to : 0xb297a793A26a2C2299910fFfBC7c69f70e7714Ac
7 // Symbol      : INSC
8 // Name        : India Stocks Coin
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     function Owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract IndiaStocksCoin is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107     function IndiaStocksCoin() public {
108         symbol = "INSC";
109         name = "India Stocks Coin";
110         decimals = 18;
111         _totalSupply = 1000000000000000000000000000;
112         balances[0xb297a793A26a2C2299910fFfBC7c69f70e7714Ac] = _totalSupply;
113         Transfer(address(0), 0xb297a793A26a2C2299910fFfBC7c69f70e7714Ac, _totalSupply);
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account tokenOwner
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to to account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for spender to transferFrom(...) tokens
148     // from the token owner's account
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces 
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer tokens from the from account to the to account
161     // 
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the from account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = safeSub(balances[from], tokens);
170         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         Transfer(from, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for spender to transferFrom(...) tokens
188     // from the token owner's account. The spender contract function
189     // receiveApproval(...) is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () public payable {
203         revert();
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }