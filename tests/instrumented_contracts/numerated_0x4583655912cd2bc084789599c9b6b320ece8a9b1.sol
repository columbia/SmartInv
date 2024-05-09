1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Gay Banana' token contract
5 //
6 // Deployed to : 0x127094b40d413Ed499d460bcDd46ff0c55071C75
7 // Symbol      : GNA
8 // Name        : Gay Banana Token
9 // Total supply: 100000000
10 // Decimals    : 18
11 //  
12 //              MMMMMMMMM                         MMMMMMMMM
13 //          MMMMMMMMMMMMMMMMMM               MMMMMMMMMMMMMMMMMM
14 //       MMMMMMMXXXXXXXXXXMMMMMMM         MMMMMMMXXXXXXXXXXMMMMMMM
15 //    MMMMMMXXXXXXXXXXXXXXXXXMMMMMM     MMMMMMXXXXXXXXXXXXXXXXXMMMMMM
16 //   MMMMMXXXXXXXXOOOOOOOOXXXXXXMMMM   MMMMXXXXXXOOOOOOOOXXXXXXXXMMMMM
17 //  MMMMXXXXXXXOOOOOOOOOOOOOOOXXXXMMM MMMXXXXOOOOOOOOOOOOOOOXXXXXXXMMMM
18 // MMMMXXXXXXOOOOOOOOOOOOOOOOOOOOXXXMMMXXXOOOOOOOOOOOOOOOOOOOOXXXXXXMMMM
19 // MMMXXXXXOOOOOOOOOOOOOOOOOOOOOOOOXXXXXOOOOOOOOOOOOOOOOOOOOOOOOXXXXXMMM
20 //MMMXXXXXOOOOOOOOOOO       OOOOOOOOOXOOOOOOOOO       OOOOOOOOOOOOXXXXMMM
21 //MMMXXXXOOOOOOOOO              OOOOOOOOOOO              OOOOOOOOOOXXXMMM
22 //MMMXXXXOOOOOOOO                  OOOOO                  OOOOOOOOOXXXMMM
23 //MMMXXXXOOOOOOO      G A B E        +         A N A       OOOOOOOOXXXMMM
24 //MMMXXXXOOOOOOO                                           OOOOOOOOXXXMMM
25 //MMMXXXXOOOOOOO     F O R E V E R    O N     T H E        OOOOOOOOXXXMMM
26 //MMMXXXXXOOOOOO                                           OOOOOOOXXXXMMM
27 // MMMXXXXOOOOOOO           B L O C K C H A I N           OOOOOOOOXXXMMM
28 // MMMMXXXXOOOOOOO                                       OOOOOOOOXXXMMMM
29 //  MMMXXXXOOOOOOOOO                                    OOOOOOOOOXXXMMM
30 //  MMMMXXXXOOOOOOOOOO                                OOOOOOOOOOXXXMMMM
31 //   MMMXXXXXOOOOOOOOOOO                           OOOOOOOOOOOOXXXXMMM
32 //    MMMXXXXXOOOOOOOOOOOOO                     OOOOOOOOOOOOOOXXXXMMM
33 //     MMMXXXXXOOOOOOOOOOOOOOO               OOOOOOOOOOOOOOOOXXXXMMM
34 //      MMMXXXXXOOOOOOOOOOOOOOOOO         OOOOOOOOOOOOOOOOOXXXXXMMM
35 //       MMMXXXXXXOOOOOOOOOOOOOOOOOO   OOOOOOOOOOOOOOOOOOXXXXXXMMM
36 //         MMMXXXXXXXOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOXXXXXXXMMM
37 //           MMMXXXXXXXXOOOOOOOOOOOOOOOOOOOOOOOOOOOXXXXXXXXMMM
38 //             MMMMXXXXXXXXXOOOOOOOOOOOOOOOOOOOXXXXXXXXXMMMM
39 //                MMMMXXXXXXXXXXXOOOOOOOOOXXXXXXXXXXMMMMM
40 //                   MMMMMXXXXXXXXXXXOXXXXXXXXXXXMMMMM
41 //                      MMMMMMXXXXXXXXXXXXXXXMMMMMM
42 //                          MMMMMMXXXXXXXMMMMMM
43 //                              MMMMMXMMMMM
44 //                                 MMMMM
45 //                                  MMM
46 //                                   M 
47 //
48 // (c) by th3Joker21 Ltd Au 2017. The MIT Licence.
49 // ----------------------------------------------------------------------------
50 
51 
52 // ----------------------------------------------------------------------------
53 // Safe maths
54 // ----------------------------------------------------------------------------
55 contract SafeMath {
56     function safeAdd(uint a, uint b) public pure returns (uint c) {
57         c = a + b;
58         require(c >= a);
59     }
60     function safeSub(uint a, uint b) public pure returns (uint c) {
61         require(b <= a);
62         c = a - b;
63     }
64     function safeMul(uint a, uint b) public pure returns (uint c) {
65         c = a * b;
66         require(a == 0 || c / a == b);
67     }
68     function safeDiv(uint a, uint b) public pure returns (uint c) {
69         require(b > 0);
70         c = a / b;
71     }
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // ERC Token Standard #20 Interface
77 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
78 // ----------------------------------------------------------------------------
79 contract ERC20Interface {
80     function totalSupply() public constant returns (uint);
81     function balanceOf(address tokenOwner) public constant returns (uint balance);
82     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
83     function transfer(address to, uint tokens) public returns (bool success);
84     function approve(address spender, uint tokens) public returns (bool success);
85     function transferFrom(address from, address to, uint tokens) public returns (bool success);
86 
87     event Transfer(address indexed from, address indexed to, uint tokens);
88     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // Contract function to receive approval and execute function in one call
94 //
95 // Borrowed from MiniMeToken
96 // ----------------------------------------------------------------------------
97 contract ApproveAndCallFallBack {
98     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // Owned contract
104 // ----------------------------------------------------------------------------
105 contract Owned {
106     address public owner;
107     address public newOwner;
108 
109     event OwnershipTransferred(address indexed _from, address indexed _to);
110 
111     function Owned() public {
112         owner = msg.sender;
113     }
114 
115     modifier onlyOwner {
116         require(msg.sender == owner);
117         _;
118     }
119 
120     function transferOwnership(address _newOwner) public onlyOwner {
121         newOwner = _newOwner;
122     }
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         OwnershipTransferred(owner, newOwner);
126         owner = newOwner;
127         newOwner = address(0);
128     }
129 }
130 
131 
132 // ----------------------------------------------------------------------------
133 // ERC20 Token, with the addition of symbol, name and decimals and assisted
134 // token transfers
135 // ----------------------------------------------------------------------------
136 contract GayBananaToken is ERC20Interface, Owned, SafeMath {
137     string public symbol;
138     string public  name;
139     uint8 public decimals;
140     uint public _totalSupply;
141 
142     mapping(address => uint) balances;
143     mapping(address => mapping(address => uint)) allowed;
144 
145 
146     // ------------------------------------------------------------------------
147     // Constructor
148     // ------------------------------------------------------------------------
149     function GayBananaToken() public {
150         symbol = "GNA";
151         name = "Gay Banana Token";
152         decimals = 18;
153         _totalSupply = 100000000000000000000000000;
154         balances[0x127094b40d413Ed499d460bcDd46ff0c55071C75] = _totalSupply;
155         Transfer(address(0), 0x127094b40d413Ed499d460bcDd46ff0c55071C75, _totalSupply);
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Total supply
161     // ------------------------------------------------------------------------
162     function totalSupply() public constant returns (uint) {
163         return _totalSupply  - balances[address(0)];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Get the token balance for account tokenOwner
169     // ------------------------------------------------------------------------
170     function balanceOf(address tokenOwner) public constant returns (uint balance) {
171         return balances[tokenOwner];
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer the balance from token owner's account to to account
177     // - Owner's account must have sufficient balance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transfer(address to, uint tokens) public returns (bool success) {
181         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
182         balances[to] = safeAdd(balances[to], tokens);
183         Transfer(msg.sender, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account
191     //
192     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
193     // recommends that there are no checks for the approval double-spend attack
194     // as this should be implemented in user interfaces 
195     // ------------------------------------------------------------------------
196     function approve(address spender, uint tokens) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Transfer tokens from the from account to the to account
205     // 
206     // The calling account must already have sufficient tokens approve(...)-d
207     // for spending from the from account and
208     // - From account must have sufficient balance to transfer
209     // - Spender must have sufficient allowance to transfer
210     // - 0 value transfers are allowed
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
213         balances[from] = safeSub(balances[from], tokens);
214         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
215         balances[to] = safeAdd(balances[to], tokens);
216         Transfer(from, to, tokens);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Returns the amount of tokens approved by the owner that can be
223     // transferred to the spender's account
224     // ------------------------------------------------------------------------
225     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
226         return allowed[tokenOwner][spender];
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Token owner can approve for spender to transferFrom(...) tokens
232     // from the token owner's account. The spender contract function
233     // receiveApproval(...) is then executed
234     // ------------------------------------------------------------------------
235     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
236         allowed[msg.sender][spender] = tokens;
237         Approval(msg.sender, spender, tokens);
238         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Don't accept ETH
245     // ------------------------------------------------------------------------
246     function () public payable {
247         revert();
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Owner can transfer out any accidentally sent ERC20 tokens
253     // ------------------------------------------------------------------------
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
255         return ERC20Interface(tokenAddress).transfer(owner, tokens);
256     }
257 }