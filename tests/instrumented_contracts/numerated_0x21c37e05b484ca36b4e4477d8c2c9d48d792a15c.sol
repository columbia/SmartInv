1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'BellaBlu' CROWDSALE token contract
5 //
6 // Deployed to : 0x21c37e05b484ca36b4e4477d8c2c9d48d792a15c
7 // Symbol      : BBCAT
8 // Name        : BellaBlu Token
9 // Total supply: 100000000
10 // Decimals    : 18
11 //
12 // 
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 // It's kitten season. Bella and Blu were lucky enough to find furever homes.
17 // They want to help the hoomans that are working to help all the kittens and 
18 // other animals looking for furever homes. Bella and Blu have made friends all
19 // over the world with people that have dedicated their lives to animal rescue.
20 // Bella and Blu decided it was time to do their part and raise money to help.
21 // And being that they are cats... Well, they decided it was time to show up the Doge too.
22 // On her second birthday, Blu fired up her first mining rig. Eventually she got
23 // bored watching her hash rates and fired up fish tank videos on youtube. Somewhere
24 // along the way... Bella joined in and they had a conversation. Bella, a little
25 // older and wiser at 11, suggested they create their first coin. A little research,
26 // some Solidity, and some nice guys at MIT all added up together to.... BellaBlu Token
27 // Help Bella and Blu help their friends... 
28 //
29 // ----------------------------------------------------------------------------
30 // Safe maths
31 // ----------------------------------------------------------------------------
32 contract SafeMath {
33     function safeAdd(uint a, uint b) internal pure returns (uint c) {
34         c = a + b;
35         require(c >= a);
36     }
37     function safeSub(uint a, uint b) internal pure returns (uint c) {
38         require(b <= a);
39         c = a - b;
40     }
41     function safeMul(uint a, uint b) internal pure returns (uint c) {
42         c = a * b;
43         require(a == 0 || c / a == b);
44     }
45     function safeDiv(uint a, uint b) internal pure returns (uint c) {
46         require(b > 0);
47         c = a / b;
48     }
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // ERC Token Standard #20 Interface
54 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
55 // ----------------------------------------------------------------------------
56 contract ERC20Interface {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Contract function to receive approval and execute function in one call
71 //
72 // Borrowed from MiniMeToken
73 // ----------------------------------------------------------------------------
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // Owned contract
81 // ----------------------------------------------------------------------------
82 contract Owned {
83     address public owner;
84     address public newOwner;
85 
86     event OwnershipTransferred(address indexed _from, address indexed _to);
87 
88     function Owned() public {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     function transferOwnership(address _newOwner) public onlyOwner {
98         newOwner = _newOwner;
99     }
100     function acceptOwnership() public {
101         require(msg.sender == newOwner);
102         OwnershipTransferred(owner, newOwner);
103         owner = newOwner;
104         newOwner = address(0);
105     }
106 }
107 
108 
109 // ----------------------------------------------------------------------------
110 // ERC20 Token, with the addition of symbol, name and decimals and assisted
111 // token transfers
112 // ----------------------------------------------------------------------------
113 contract BellaBluToken is ERC20Interface, Owned, SafeMath {
114     string public symbol;
115     string public  name;
116     uint8 public decimals;
117     uint public _totalSupply;
118     uint public startDate;
119     uint public bonusEnds;
120     uint public endDate;
121 
122     mapping(address => uint) balances;
123     mapping(address => mapping(address => uint)) allowed;
124 
125 
126     // ------------------------------------------------------------------------
127     // Constructor
128     // how deep on decimal. bonus? runs how long?
129     // ------------------------------------------------------------------------
130     function BellaBluToken() public {
131         symbol = "BBCAT";
132         name = "BellaBlu Token";
133         decimals = 18;
134         bonusEnds = now + 8 weeks;
135         endDate = now + 16 weeks;
136 
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Total supply
142     // ------------------------------------------------------------------------
143     function totalSupply() public constant returns (uint) {
144         return _totalSupply  - balances[address(0)];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Get the token balance for account `tokenOwner`
150     // ------------------------------------------------------------------------
151     function balanceOf(address tokenOwner) public constant returns (uint balance) {
152         return balances[tokenOwner];
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer the balance from token owner's account to `to` account
158     // - Owner's account must have sufficient balance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transfer(address to, uint tokens) public returns (bool success) {
162         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
163         balances[to] = safeAdd(balances[to], tokens);
164         Transfer(msg.sender, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Token owner can approve for `spender` to transferFrom(...) `tokens`
171     // from the token owner's account
172     //
173     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
174     // recommends that there are no checks for the approval double-spend attack
175     // as this should be implemented in user interfaces
176     // ------------------------------------------------------------------------
177     function approve(address spender, uint tokens) public returns (bool success) {
178         allowed[msg.sender][spender] = tokens;
179         Approval(msg.sender, spender, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer `tokens` from the `from` account to the `to` account
186     //
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the `from` account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
194         balances[from] = safeSub(balances[from], tokens);
195         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
196         balances[to] = safeAdd(balances[to], tokens);
197         Transfer(from, to, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Returns the amount of tokens approved by the owner that can be
204     // transferred to the spender's account
205     // ------------------------------------------------------------------------
206     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for `spender` to transferFrom(...) `tokens`
213     // from the token owner's account. The `spender` contract function
214     // `receiveApproval(...)` is then executed
215     // ------------------------------------------------------------------------
216     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
217         allowed[msg.sender][spender] = tokens;
218         Approval(msg.sender, spender, tokens);
219         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
220         return true;
221     }
222 
223     // ------------------------------------------------------------------------
224     // 1000 BBCAT Tokens per 1 ETH
225     // ------------------------------------------------------------------------
226     function () public payable {
227         require(now >= startDate && now <= endDate);
228         uint tokens;
229         if (now <= bonusEnds) {
230             tokens = msg.value * 1500;
231         } else {
232             tokens = msg.value * 1000;
233         }
234         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
235         _totalSupply = safeAdd(_totalSupply, tokens);
236         Transfer(address(0), msg.sender, tokens);
237         owner.transfer(msg.value);
238     }
239 
240     //----------------------------------------------------------------
241     // Owner can destroy
242     //----------------------------------------------------------------
243     function destroy() onlyOwner public {
244         selfdestruct(owner);
245     }
246 
247     function destroyAndSend(address _recipient) onlyOwner public {
248         selfdestruct(_recipient);
249     }
250 
251     // ------------------------------------------------------------------------
252     // Owner can transfer out any accidentally sent ERC20 tokens
253     // ------------------------------------------------------------------------
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
255         return ERC20Interface(tokenAddress).transfer(owner, tokens);
256     }
257 }