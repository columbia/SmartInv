1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Antz' token
5 //
6 // Symbol      : ANTZ
7 // Name        : Antz Token
8 // Total supply: 25,000,000
9 // Decimals    : 18
10 //
11 // Antz are taking over the world.
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract AntzToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public totalSupply;
105     uint public unitsPerTransaction;
106     uint public tokensDistributed;
107     uint public numDistributions;
108     uint public numDistributionsRemaining;
109     
110     address public fundsWallet;  
111     address public developersWallet;
112     uint public developersCut;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     function AntzToken() public {   
122 		fundsWallet = 0;       
123         balances[fundsWallet] = 25000000000000000000000000;  
124 
125         totalSupply = 25000000000000000000000000;  
126         
127         name = "Antz Token";                                 
128         decimals = 18;                                              
129         symbol = "ANTZ";                                           
130         unitsPerTransaction = 500000000000000000000;                                
131         
132         developersWallet = 0x78061eE39Cd5eDFe1D935168234a3BEEeF9d4b5a;
133         developersCut = safeDiv(totalSupply,10);
134         balances[developersWallet] = safeAdd(balances[developersWallet], developersCut);
135         Transfer(fundsWallet, developersWallet, developersCut);
136         tokensDistributed = developersCut;   
137         
138         numDistributionsRemaining = (totalSupply - tokensDistributed) / unitsPerTransaction;   
139         numDistributions = 1;       
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Total supply
145     // ------------------------------------------------------------------------
146     function totalSupply() public constant returns (uint) {
147         return totalSupply;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Get the token balance for account `tokenOwner`
153     // ------------------------------------------------------------------------
154     function balanceOf(address tokenOwner) public constant returns (uint balance) {
155         return balances[tokenOwner];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to `to` account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transfer(address to, uint tokens) public returns (bool success) {
165         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         Transfer(msg.sender, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for `spender` to transferFrom(...) `tokens`
174     // from the token owner's account
175     //
176     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
177     // recommends that there are no checks for the approval double-spend attack
178     // as this should be implemented in user interfaces
179     // ------------------------------------------------------------------------
180     function approve(address spender, uint tokens) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         Approval(msg.sender, spender, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Transfer `tokens` from the `from` account to the `to` account
189     //
190     // The calling account must already have sufficient tokens approve(...)-d
191     // for spending from the `from` account and
192     // - From account must have sufficient balance to transfer
193     // - Spender must have sufficient allowance to transfer
194     // - 0 value transfers are allowed
195     // ------------------------------------------------------------------------
196     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
197         balances[from] = safeSub(balances[from], tokens);
198         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
199         balances[to] = safeAdd(balances[to], tokens);
200         Transfer(from, to, tokens);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Returns the amount of tokens approved by the owner that can be
207     // transferred to the spender's account
208     // ------------------------------------------------------------------------
209     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
210         return allowed[tokenOwner][spender];
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Token owner can approve for `spender` to transferFrom(...) `tokens`
216     // from the token owner's account. The `spender` contract function
217     // `receiveApproval(...)` is then executed
218     // ------------------------------------------------------------------------
219     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
220         allowed[msg.sender][spender] = tokens;
221         Approval(msg.sender, spender, tokens);
222         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
223         return true;
224     }
225 
226     // ------------------------------------------------------------------------
227     // Fixed amount of tokens per transaction, return Eth
228     // ------------------------------------------------------------------------
229     function () public payable {
230     
231         if(numDistributionsRemaining > 0 && balances[msg.sender] == 0 && balances[fundsWallet] >= unitsPerTransaction){
232         	// Do the transaction
233         	uint tokens = unitsPerTransaction;
234         	balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
235         	tokensDistributed = safeAdd(tokensDistributed, tokens);
236         	numDistributions = safeAdd(numDistributions, 1);
237         	numDistributionsRemaining = safeSub(numDistributionsRemaining, 1);
238         	Transfer(fundsWallet, msg.sender, tokens);
239         } 
240         
241         // Refund remaining ETH 
242         msg.sender.transfer(msg.value);
243     }
244 
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20Interface(tokenAddress).transfer(owner, tokens);
251     }
252 }