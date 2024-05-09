1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ⚙️ ALL BEST ICO DeFi (ALLBI)!
5 //
6 // Deployed to : 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4
7 // Symbol      : ALLBI
8 // Name        : ALL BEST ICO
9 // Total supply: 666000000.000000000000000000
10 // Decimals    : 18
11 //
12 // ®NEW ️Official ALL BEST ICO  (ALLBI) Smart Contract!
13 // *You can buy our NFT offers from: https://opensea.io/collection/allbi-onlexpa-nfts
14 
15 // 🌐 ALLBESTICO.com (ALLBI) is extraordinary! We have a unique business model which is far superior than any other available platforms.
16 // 👉 We will help you to create and develop your Crypto Project through our system!
17 //
18 // 1️⃣. Create Your Account:
19 // ✅Sign up on our site and enter ALLBI Tokens Address which you will use to create your Cryptocurrency!
20 //
21 // 2️⃣. Sign in to your Profile:
22 // ✅ You will receive a Bonus (see more information in your profile). You can enter your Cryptocurrency parameters whenever you like, after making the payment!
23 // 
24 // 3️⃣. Pay and create Your Crypto Project (ICO):
25 // ✅ If you choose to create your Crypto Project, you must select your Crypto Project parameters - (name, number of characters, site name ... etc.) – see 📃 https://allbestico.com/whitepaper.pdf
26 // 
27 // 📊 Every project that has been created on our platform will receive huge opportunities for successful realization. 
28 // ✅ All new crypto projects will be advertised on our site! We'll teach you how to properly manage your Cryptocurrency, how to send tokens to other crypto addresses, how to get paid for them and so on.
29 
30 // 🧐see our site for more information: ALLBESTICO.com (ALLBI) (c) by / Lex Partners Ltd™️
31 // *You can buy our NFT offers from:https://opensea.io/collection/allbi-onlexpa-nfts
32 
33 // ----------------------------------------------------------------------------
34 // Safe maths
35 // ----------------------------------------------------------------------------
36 contract SafeMath {
37     function safeAdd(uint a, uint b) public pure returns (uint c) {
38         c = a + b;
39         require(c >= a);
40     }
41     function safeSub(uint a, uint b) public pure returns (uint c) {
42         require(b <= a);
43         c = a - b;
44     }
45     function safeMul(uint a, uint b) public pure returns (uint c) {
46         c = a * b;
47         require(a == 0 || c / a == b);
48     }
49     function safeDiv(uint a, uint b) public pure returns (uint c) {
50         require(b > 0);
51         c = a / b;
52     }
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // ERC Token Standard #20 Interface
58 // ----------------------------------------------------------------------------
59 contract ERC20Interface {
60     function totalSupply() public constant returns (uint);
61     function balanceOf(address tokenOwner) public constant returns (uint balance);
62     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
63     function transfer(address to, uint tokens) public returns (bool success);
64     function approve(address spender, uint tokens) public returns (bool success);
65     function transferFrom(address from, address to, uint tokens) public returns (bool success);
66 
67     event Transfer(address indexed from, address indexed to, uint tokens);
68     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Contract function to receive approval and execute function in one call
74 //
75 // Borrowed from MiniMeToken
76 // ----------------------------------------------------------------------------
77 contract ApproveAndCallFallBack {
78     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // Owned contract
84 // ----------------------------------------------------------------------------
85 contract Owned {
86     address public owner;
87     address public newOwner;
88 
89     event OwnershipTransferred(address indexed _from, address indexed _to);
90 
91     function Owned() public {
92         owner = msg.sender;
93     }
94 
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99 
100     function transferOwnership(address _newOwner) public onlyOwner {
101         newOwner = _newOwner;
102     }
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107         newOwner = address(0);
108     }
109 }
110 
111 
112 // ----------------------------------------------------------------------------
113 // ERC20 Token, with the addition of symbol, name and decimals and assisted
114 // token transfers
115 // ----------------------------------------------------------------------------
116 contract ALLBI is ERC20Interface, Owned, SafeMath {
117     string public symbol;
118     string public  name;
119     uint8 public decimals;
120     uint public _totalSupply;
121 
122     mapping(address => uint) balances;
123     mapping(address => mapping(address => uint)) allowed;
124 
125 
126     // ------------------------------------------------------------------------
127     // Constructor
128     // ------------------------------------------------------------------------
129     function ALLBI () public {
130         symbol = "ALLBI";
131         name = "ALL BEST ICO";
132         decimals = 18;
133         _totalSupply = 666000000000000000000000000;
134         balances[0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4] = _totalSupply; //MEW address here
135         Transfer(address(0), 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4, _totalSupply);//MEW address here
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Total supply
141     // ------------------------------------------------------------------------
142     function totalSupply() public constant returns (uint) {
143         return _totalSupply  - balances[address(0)];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Get the token balance for account tokenOwner
149     // ------------------------------------------------------------------------
150     function balanceOf(address tokenOwner) public constant returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer the balance from token owner's account to to account
157     // - Owner's account must have sufficient balance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transfer(address to, uint tokens) public returns (bool success) {
161         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
162         balances[to] = safeAdd(balances[to], tokens);
163         Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for spender to transferFrom(...) tokens
170     // from the token owner's account
171     //
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces 
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Transfer tokens from the from account to the to account
184     // 
185     // The calling account must already have sufficient tokens approve(...)-d
186     // for spending from the from account and
187     // - From account must have sufficient balance to transfer
188     // - Spender must have sufficient allowance to transfer
189     // - 0 value transfers are allowed
190     // ------------------------------------------------------------------------
191     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192         balances[from] = safeSub(balances[from], tokens);
193         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
194         balances[to] = safeAdd(balances[to], tokens);
195         Transfer(from, to, tokens);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Returns the amount of tokens approved by the owner that can be
202     // transferred to the spender's account
203     // ------------------------------------------------------------------------
204     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
205         return allowed[tokenOwner][spender];
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Token owner can approve for spender to transferFrom(...) tokens
211     // from the token owner's account. The spender contract function
212     // receiveApproval(...) is then executed
213     // ------------------------------------------------------------------------
214     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         Approval(msg.sender, spender, tokens);
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
218         return true;
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Don't accept ETH
224     // ------------------------------------------------------------------------
225     function () public payable {
226         revert();
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return ERC20Interface(tokenAddress).transfer(owner, tokens);
235     }
236 }