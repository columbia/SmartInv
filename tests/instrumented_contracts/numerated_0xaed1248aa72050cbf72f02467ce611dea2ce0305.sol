1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // 'GCG' token contract
6 // Deployed to : 0x295B01a324CE1712D135A6b16E576C3b8D72eD23
7 // Symbol      : GCG
8 // Name        : Gulfcoin Gold
9 // Total supply: 990000000
10 // Decimals    : 8
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
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48     function burn(uint256 _value) public returns (bool success);
49 
50     event Burn(address indexed from, uint256 value);
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
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract GCGToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function GCGToken() public {
114         symbol = "GCG";
115         name = "Gulfcoin Gold";
116         decimals = 8;
117         _totalSupply = 99000000000000000;
118         balances[0x295B01a324CE1712D135A6b16E576C3b8D72eD23] = _totalSupply;
119         Transfer(address(0), 0x295B01a324CE1712D135A6b16E576C3b8D72eD23, _totalSupply);
120     }
121                 
122 
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply  - balances[address(0)];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to to account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account
156     //
157     // ------------------------------------------------------------------------
158     function approve(address spender, uint tokens) public returns (bool success) {
159         allowed[msg.sender][spender] = tokens;
160         Approval(msg.sender, spender, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer tokens from the from account to the to account
167     // 
168     // The calling account must already have sufficient tokens approve(...)-d
169     // for spending from the from account and
170     // - From account must have sufficient balance to transfer
171     // - Spender must have sufficient allowance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
175         balances[from] = safeSub(balances[from], tokens);
176         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
177         balances[to] = safeAdd(balances[to], tokens);
178         Transfer(from, to, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Returns the amount of tokens approved by the owner that can be
185     // transferred to the spender's account
186     // ------------------------------------------------------------------------
187     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
188         return allowed[tokenOwner][spender];
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Token owner can approve for spender to transferFrom(...) tokens
194     // from the token owner's account. The spender contract function
195     // receiveApproval(...) is then executed
196     // ------------------------------------------------------------------------
197     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
198         allowed[msg.sender][spender] = tokens;
199         Approval(msg.sender, spender, tokens);
200         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Don't accept ETH
207     // ------------------------------------------------------------------------
208     function () public payable {
209         revert();
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Owner can transfer out any accidentally sent ERC20 tokens
215     // ------------------------------------------------------------------------
216     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
217         return ERC20Interface(tokenAddress).transfer(owner, tokens);
218     }
219 
220     /**
221      * Destroy tokens
222      *
223      * Remove `_value` tokens from the system irreversibly
224      *
225      * @param _value the amount of money to burn
226      */
227     function burn(uint256 _value) public returns (bool success) {
228         require(balances[msg.sender] >= _value);   
229         _totalSupply -= _value;
230         balances[msg.sender] -= _value;                    
231         Burn(msg.sender, _value);
232         return true;
233     }
234 
235 }