1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
5 // modified by Team Chibi Fighters, thanks heaps BokkyPooBah!
6 //
7 // massive shoutout to https://cryptozombies.io
8 // best solidity learning series out there!
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // ERC Token Standard #20 Interface
13 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
14 // ----------------------------------------------------------------------------
15 contract ERC20Interface {
16     function totalSupply() public constant returns (uint);
17     function balanceOf(address tokenOwner) public constant returns (uint balance);
18     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
19     function transfer(address to, uint tokens) public returns (bool success);
20     function approve(address spender, uint tokens) public returns (bool success);
21     function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // Contract function to receive approval and execute function in one call
30 // Borrowed from MiniMeToken
31 // ----------------------------------------------------------------------------
32 contract ApproveAndCallFallBack {
33     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // Contract owner and transfer functions
39 // just in case someone wants to get my bacon
40 // ----------------------------------------------------------------------------
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ERC20 compliant Founder Chibi Token
71 // Receives ETH and generates Founder Chibi Token
72 // 1 Founder Chibi Fighter can be exchanged for 1 Founder Chibi in our upcoming game
73 // https://chibifighters.io Chibi Fighters
74 // ----------------------------------------------------------------------------
75 contract Founders is ERC20Interface, Owned {
76     string public symbol;
77     string public  name;
78     uint8 public decimals;
79     uint public _totalSupply;
80     uint public _ratio;
81     bool disabled;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85     
86     // ------------------------------------------------------------------------
87     // Launched once when contract starts
88     // ------------------------------------------------------------------------
89     function Founders() public {
90         disabled = false;
91         symbol = "FCF";
92         name = "Founder Chibi Fighters";
93         decimals = 18;
94         // the first coins go to creator to share among GARRY investors
95         _totalSupply = 330 * 10**uint(decimals);      
96         // set ratio, get 100 Founders for 1 Ether
97         _ratio = 100;
98         balances[owner] = _totalSupply;
99         emit Transfer(address(0), owner, _totalSupply);
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Total supply
105     // ------------------------------------------------------------------------
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply;
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Get the token balance for account `tokenOwner`
113     // ------------------------------------------------------------------------
114     function balanceOf(address tokenOwner) public constant returns (uint balance) {
115         return balances[tokenOwner];
116     }
117     
118 
119     // ------------------------------------------------------------------------
120     // Transfer the balance from token owner's account to `to` account
121     // - Owner's account must have sufficient balance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transfer(address to, uint tokens) public returns (bool success) {
125         require(balances[msg.sender] >= tokens);
126         balances[msg.sender] -= tokens;
127         balances[to] += tokens;
128         emit Transfer(msg.sender, to, tokens);
129         return true;
130     }
131     
132 
133     // ------------------------------------------------------------------------
134     // Token owner can approve for `spender` to transferFrom(...) `tokens`
135     // from the token owner's account
136     //
137     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
138     // recommends that there are no checks for the approval double-spend attack
139     // as this should be implemented in user interfaces 
140     // ------------------------------------------------------------------------
141     function approve(address spender, uint tokens) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         emit Approval(msg.sender, spender, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer `tokens` from the `from` account to the `to` account
150     // 
151     // The calling account must already have sufficient tokens approve(...)
152     // for spending from the `from` account and
153     // - From account must have sufficient balance to transfer
154     // - Spender must have sufficient allowance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         require (allowed[from][msg.sender] >= tokens);
159         require (balances[from] >= tokens);
160         
161         balances[from] -= tokens;
162         allowed[from][msg.sender] -= tokens;
163         balances[to] += tokens;
164         emit Transfer(from, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Returns the amount of tokens approved by the owner that can be
171     // transferred to the spender's account
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for `spender` to transferFrom(...) `tokens`
180     // from the token owner's account. The `spender` contract function
181     // `receiveApproval(...)` is then executed
182     // ------------------------------------------------------------------------
183     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         emit Approval(msg.sender, spender, tokens);
186         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
187         return true;
188     }
189 
190     // ------------------------------------------------------------------------
191     // Disable minting of Founder Chibis after Release
192     // ------------------------------------------------------------------------
193     function disableContract(bool _disabled) public onlyOwner returns (bool success) {
194         disabled = _disabled;
195         return true;
196     }
197 
198     // ------------------------------------------------------------------------
199     // Tokens per Ethererum at a ratio of 100:1
200     // 0.01 is minimum to avoid spamming
201     // ------------------------------------------------------------------------
202     function () public payable {
203         require(msg.value >= 10000000000000000);
204         require(disabled == false);
205         
206         uint tokens;
207         tokens = msg.value*_ratio;
208 
209         balances[msg.sender] += tokens;
210         _totalSupply += tokens;
211         emit Transfer(address(0), msg.sender, tokens);
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Owner can transfer out any accidentally sent ERC20 tokens
217     // Only if he is in the mood though, I won't give a damn if you are an annoying bot
218     // ------------------------------------------------------------------------
219     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
220         return ERC20Interface(tokenAddress).transfer(owner, tokens);
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Query Ethereum of contract
226     // ------------------------------------------------------------------------
227     function weiBalance() public constant returns (uint weiBal) {
228         return address(this).balance;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Send Contracts Ethereum to address owner
234     // ------------------------------------------------------------------------
235     function weiToOwner(address _address, uint amount) public onlyOwner {
236         require(amount <= address(this).balance);
237         _address.transfer(amount);
238     }
239 }