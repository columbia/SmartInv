1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ⚙️ ALL BEST ICO (ALLBI)!
5 //
6 // Deployed to : 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4
7 // Symbol      : ALLBI
8 // Name        : ALL BEST ICO
9 // Total supply: 486000000.000000000000000000
10 // Decimals    : 18
11 //
12 // ®️Official Smart Contract!
13 //
14 // 🌐 ALLBESTICO.com (ALLBI) is extraordinary! We have a unique business model which is far superior than any other available platforms.
15 // 👉 We will help you to create and develop your Crypto Project through our system!
16 //
17 // 1️⃣. Create Your Account:
18 // ✅Sign up on our site and enter ALLBI Tokens Address which you will use to create your Cryptocurrency!
19 //
20 // 2️⃣. Sign in to your Profile:
21 // ✅ You will receive +100 ALLBI Tokens as a Bonus (see more information in your profile). You can enter your Cryptocurrency parameters whenever you like, after making the payment!
22 // 
23 // 3️⃣. Pay and create Your Crypto Project (ICO):
24 // ✅ If you choose to create your Crypto Project, you must select your Crypto Project parameters - (name, number of characters, site name ... etc.) – see 📃 https://allbestico.com/whitepaper.pdf
25 // 
26 // 📊 Every project that has been created on our platform will receive huge opportunities for successful realization. 
27 // ✅ All new crypto projects will be advertised on our site! We'll teach you how to properly manage your Cryptocurrency, how to send tokens to other crypto addresses, how to get paid for them and so on.
28 
29 // 🧐see our site for more information: ALLBESTICO.com (ALLBI) (c) by / Lex Partners Ltd™️
30 // ----------------------------------------------------------------------------
31 
32 // ----------------------------------------------------------------------------
33 // Safe maths
34 // ----------------------------------------------------------------------------
35 contract SafeMath {
36     function safeAdd(uint a, uint b) public pure returns (uint c) {
37         c = a + b;
38         require(c >= a);
39     }
40     function safeSub(uint a, uint b) public pure returns (uint c) {
41         require(b <= a);
42         c = a - b;
43     }
44     function safeMul(uint a, uint b) public pure returns (uint c) {
45         c = a * b;
46         require(a == 0 || c / a == b);
47     }
48     function safeDiv(uint a, uint b) public pure returns (uint c) {
49         require(b > 0);
50         c = a / b;
51     }
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // ERC Token Standard #20 Interface
57 // ----------------------------------------------------------------------------
58 contract ERC20Interface {
59     function totalSupply() public constant returns (uint);
60     function balanceOf(address tokenOwner) public constant returns (uint balance);
61     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
62     function transfer(address to, uint tokens) public returns (bool success);
63     function approve(address spender, uint tokens) public returns (bool success);
64     function transferFrom(address from, address to, uint tokens) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // Contract function to receive approval and execute function in one call
73 //
74 // Borrowed from MiniMeToken
75 // ----------------------------------------------------------------------------
76 contract ApproveAndCallFallBack {
77     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned {
85     address public owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals and assisted
113 // token transfers
114 // ----------------------------------------------------------------------------
115 contract ALLBIVerified is ERC20Interface, Owned, SafeMath {
116     string public symbol;
117     string public  name;
118     uint8 public decimals;
119     uint public _totalSupply;
120 
121     mapping(address => uint) balances;
122     mapping(address => mapping(address => uint)) allowed;
123 
124 
125     // ------------------------------------------------------------------------
126     // Constructor
127     // ------------------------------------------------------------------------
128     function ALLBIVerified () public {
129         symbol = "ALLBI";
130         name = "ALL BEST ICO Verified";
131         decimals = 18;
132         _totalSupply = 486000000000000000000000000;
133         balances[0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4] = _totalSupply; //MEW address here
134         Transfer(address(0), 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4, _totalSupply);//MEW address here
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Total supply
140     // ------------------------------------------------------------------------
141     function totalSupply() public constant returns (uint) {
142         return _totalSupply  - balances[address(0)];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Get the token balance for account tokenOwner
148     // ------------------------------------------------------------------------
149     function balanceOf(address tokenOwner) public constant returns (uint balance) {
150         return balances[tokenOwner];
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer the balance from token owner's account to to account
156     // - Owner's account must have sufficient balance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transfer(address to, uint tokens) public returns (bool success) {
160         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
161         balances[to] = safeAdd(balances[to], tokens);
162         Transfer(msg.sender, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account
170     //
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces 
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint tokens) public returns (bool success) {
175         allowed[msg.sender][spender] = tokens;
176         Approval(msg.sender, spender, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer tokens from the from account to the to account
183     // 
184     // The calling account must already have sufficient tokens approve(...)-d
185     // for spending from the from account and
186     // - From account must have sufficient balance to transfer
187     // - Spender must have sufficient allowance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
191         balances[from] = safeSub(balances[from], tokens);
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193         balances[to] = safeAdd(balances[to], tokens);
194         Transfer(from, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Returns the amount of tokens approved by the owner that can be
201     // transferred to the spender's account
202     // ------------------------------------------------------------------------
203     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
204         return allowed[tokenOwner][spender];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for spender to transferFrom(...) tokens
210     // from the token owner's account. The spender contract function
211     // receiveApproval(...) is then executed
212     // ------------------------------------------------------------------------
213     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         Approval(msg.sender, spender, tokens);
216         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     function () public payable {
225         revert();
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Owner can transfer out any accidentally sent ERC20 tokens
231     // ------------------------------------------------------------------------
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 }