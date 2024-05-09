1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Komica' token contract
5 //
6 // Deployed to : 0x006bdc1a30995Fd5a318B48c78F01A4ecFeA209E
7 // Symbol      : KOMICA
8 // Name        : Komica Token
9 // Total supply: 188300000000
10 // Decimals    : 18
11 //
12 // 今天我生日ㄛ
13 //
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
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract KomicaToken is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint public _totalSupply;
106 
107     bytes32 public currentChallenge;                 // The coin starts with a challenge
108     uint public timeOfLastProof = now;               // Variable to keep track of when rewards were given
109     uint public difficulty = 10**32;                 // Difficulty starts reasonably low
110 
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     function KomicaToken() public {
120         symbol = "KOMICA";
121         name = "Komica Token";
122         decimals = 18;
123         _totalSupply = 188300000000000000000000000000;
124         balances[0x006bdc1a30995Fd5a318B48c78F01A4ecFeA209E] = _totalSupply;
125         Transfer(address(0), 0x006bdc1a30995Fd5a318B48c78F01A4ecFeA209E, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account tokenOwner
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public constant returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to to account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for spender to transferFrom(...) tokens
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer tokens from the from account to the to account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the from account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = safeSub(balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         balances[to] = safeAdd(balances[to], tokens);
186         Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for spender to transferFrom(...) tokens
202     // from the token owner's account. The spender contract function
203     // receiveApproval(...) is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
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
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     function () public payable {
225         revert();
226     }
227 
228 
229     function proofOfWork(uint nonce){
230         bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input
231         require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
232 
233         uint timeSinceLastProof = (now - timeOfLastProof);  // Calculate time since last reward was given
234         require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
235         balances[msg.sender] += timeSinceLastProof / 60 seconds;  // The reward to the winner grows by the minute
236 
237         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  // Adjusts the difficulty
238 
239         timeOfLastProof = now;                              // Reset the counter
240         currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number - 1));  // Save a hash that will be used as the next proof
241     }
242 }