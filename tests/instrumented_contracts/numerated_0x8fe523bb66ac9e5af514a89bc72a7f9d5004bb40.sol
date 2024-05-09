1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'EGYPT' token contract
5 //
6 // Deployed to : 0xb7251F6b13D411B0D22e18075e5CD584c7814137
7 // Symbol      : EGY
8 // Name        : EGYPT
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract EGYPT is ERC20Interface, Owned, SafeMath {
103     string public name;                   // Token Name
104     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
105     string public symbol;                 // An identifier: eg SBX, XPR etc..
106     uint public _totalSupply;
107     string public version = 'H1.0';
108     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
109     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
110     address public fundsWallet;           // Where should the raised ETH go?
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     function EGYPT() public {
120     name = "EGYPT";                                                    // Set the name for display purposes (CHANGE THIS)
121     decimals = 18;                                                      // Amount of decimals for display purposes (CHANGE THIS)
122     symbol = "EGY";                                                    // Set the symbol for display purposes (CHANGE THIS)
123     _totalSupply = 1000000000000000000000000000;                          // Update total supply (1000 for example) (CHANGE THIS)
124     balances[0xb7251F6b13D411B0D22e18075e5CD584c7814137] = _totalSupply; // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
125     Transfer(address(0), 0xb7251F6b13D411B0D22e18075e5CD584c7814137, _totalSupply);
126     unitsOneEthCanBuy = 5000;                                          // Set the price of your token for the ICO (CHANGE THIS)
127     fundsWallet = msg.sender;                                           // The owner of the contract gets ETH
128     }
129 
130     function() payable{
131     totalEthInWei = totalEthInWei + msg.value;
132     uint256 amount = msg.value * unitsOneEthCanBuy;
133     require(balances[fundsWallet] >= amount);
134 
135     balances[fundsWallet] = balances[fundsWallet] - amount;
136     balances[msg.sender] = balances[msg.sender] + amount;
137 
138     Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
139 
140     //Transfer ether to fundsWallet
141     fundsWallet.transfer(msg.value);
142     }
143 
144     // ------------------------------------------------------------------------
145     // Total supply
146     // ------------------------------------------------------------------------
147     function totalSupply() public constant returns (uint) {
148         return _totalSupply  - balances[address(0)];
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Get the token balance for account tokenOwner
154     // ------------------------------------------------------------------------
155     function balanceOf(address tokenOwner) public constant returns (uint balance) {
156         return balances[tokenOwner];
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer the balance from token owner's account to to account
162     // - Owner's account must have sufficient balance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transfer(address to, uint tokens) public returns (bool success) {
166         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
167         balances[to] = safeAdd(balances[to], tokens);
168         Transfer(msg.sender, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Token owner can approve for spender to transferFrom(...) tokens
175     // from the token owner's account
176     //
177     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
178     // recommends that there are no checks for the approval double-spend attack
179     // as this should be implemented in user interfaces
180     // ------------------------------------------------------------------------
181     function approve(address spender, uint tokens) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         Approval(msg.sender, spender, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Transfer tokens from the from account to the to account
190     //
191     // The calling account must already have sufficient tokens approve(...)-d
192     // for spending from the from account and
193     // - From account must have sufficient balance to transfer
194     // - Spender must have sufficient allowance to transfer
195     // - 0 value transfers are allowed
196     // ------------------------------------------------------------------------
197     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
198         balances[from] = safeSub(balances[from], tokens);
199         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
200         balances[to] = safeAdd(balances[to], tokens);
201         Transfer(from, to, tokens);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Returns the amount of tokens approved by the owner that can be
208     // transferred to the spender's account
209     // ------------------------------------------------------------------------
210     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
211         return allowed[tokenOwner][spender];
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Token owner can approve for spender to transferFrom(...) tokens
217     // from the token owner's account. The spender contract function
218     // receiveApproval(...) is then executed
219     // ------------------------------------------------------------------------
220     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
221         allowed[msg.sender][spender] = tokens;
222         Approval(msg.sender, spender, tokens);
223         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
224         return true;
225     }
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }