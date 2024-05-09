1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Nikola' token contract
5 //
6 // Symbol      : NIKL
7 // Name        : Nikola
8 // Total supply: 50000000
9 // Decimals    : 0
10 //
11 // Enjoy.
12 //
13 // (c) by Ps Mansoor
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
101 contract Nikola is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint public _totalSupply;
106 
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111      uint remaining;
112      uint price;
113      
114      address public fundsWallet;           // Where should the raised ETH go?
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function Nikola() public {
121         symbol = "NIKL";
122         name = "NIKOLA";
123         decimals = 0;
124         _totalSupply = 50000000;
125         
126     //    fundsWallet = 0xADA046d84E344E2b1233F3661981D8c2D182C9aA;
127           fundsWallet = msg.sender;
128       
129         balances[fundsWallet] = _totalSupply;
130         
131         remaining = 0;
132         
133         price = 1;
134         
135         Transfer(address(0),fundsWallet, _totalSupply);
136         
137         
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public constant returns (uint) {
145         return _totalSupply  - balances[address(0)];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account tokenOwner
151     // ------------------------------------------------------------------------
152     function balanceOf(address tokenOwner) public constant returns (uint balance) {
153         return balances[tokenOwner];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer the balance from token owner's account to to account
159     // - Owner's account must have sufficient balance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transfer(address to, uint tokens) public returns (bool success) {
163         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         Transfer(msg.sender, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for spender to transferFrom(...) tokens
172     // from the token owner's account
173     //
174     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
175     // recommends that there are no checks for the approval double-spend attack
176     // as this should be implemented in user interfaces 
177     // ------------------------------------------------------------------------
178     function approve(address spender, uint tokens) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         Approval(msg.sender, spender, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Transfer tokens from the from account to the to account
187     // 
188     // The calling account must already have sufficient tokens approve(...)-d
189     // for spending from the from account and
190     // - From account must have sufficient balance to transfer
191     // - Spender must have sufficient allowance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
195         balances[from] = safeSub(balances[from], tokens);
196         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
197         balances[to] = safeAdd(balances[to], tokens);
198         Transfer(from, to, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred to the spender's account
206     // ------------------------------------------------------------------------
207     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
208         return allowed[tokenOwner][spender];
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Token owner can approve for spender to transferFrom(...) tokens
214     // from the token owner's account. The spender contract function
215     // receiveApproval(...) is then executed
216     // ------------------------------------------------------------------------
217     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
218         allowed[msg.sender][spender] = tokens;
219         Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Don't accept ETH
227     // ------------------------------------------------------------------------
228 //    function () public payable {
229 //        revert();
230  //   }
231 
232 
233   function () payable public
234    {
235        BuyTickets( (msg.value/(1000000000000000000*0.001))*price );
236        
237    }
238   
239    function BuyTickets(uint amount) payable public
240    {
241      
242         require( (msg.value)>(1000000000000000000*0.001) && amount < _totalSupply);
243 
244         balances[msg.sender] +=amount;
245         _totalSupply-=amount;
246        
247     
248         balances[fundsWallet] = _totalSupply;
249         
250         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
251 
252         //Transfer ether to fundsWallet
253         fundsWallet.transfer(msg.value);      
254         
255    }
256     
257 
258 
259     // ------------------------------------------------------------------------
260     // Owner can transfer out any accidentally sent ERC20 tokens
261     // ------------------------------------------------------------------------
262     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
263         return ERC20Interface(tokenAddress).transfer(owner, tokens);
264     }
265 }