1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
5 // modified by team garry, thanks heaps BokkyPooBah!
6 //
7 // massive shoutout to https://cryptozombies.io
8 // best solidity learning series out there!
9 // wait what's to come after Garrys coin :) there must be a Garrys game
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // ERC Token Standard #20 Interface
14 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
15 // ----------------------------------------------------------------------------
16 contract ERC20Interface {
17     function totalSupply() public constant returns (uint);
18     function balanceOf(address tokenOwner) public constant returns (uint balance);
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26     
27     // custom events
28     event WeiSent(address indexed to, uint _wei);
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Contract function to receive approval and execute function in one call
34 // Borrowed from MiniMeToken
35 // ----------------------------------------------------------------------------
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // Contract owner and transfer functions
43 // just in case someone wants to get my bacon
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 compliant Garry token :)
75 // Receives ETH and generates Garrys, the world needs more Garrys
76 // Limited to 10000 on this planet, yup
77 // 1 Garry can be exchanged for 1 creature in our upcoming game
78 // ----------------------------------------------------------------------------
79 contract Garrys is ERC20Interface, Owned {
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84     uint public _maxSupply;
85     uint public _ratio;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90     // ------------------------------------------------------------------------
91     // Launched once when contract starts
92     // ------------------------------------------------------------------------
93     function Garrys() public {
94         symbol = "GAR";
95         name = "Garrys";
96         decimals = 18;
97         // the first coin goes to Garry cause, it's a Garry :P, adding it to total supply here
98         _totalSupply = 1 * 10**uint(decimals);      
99         // set ratio, get 100 Garrys for 1 Ether
100         _ratio = 100;
101         // there can never be more than 5000 Garrys in existence, doubt the world can handle 2 :D
102         _maxSupply = 10000 * 10**uint(decimals);    
103         balances[owner] = _totalSupply;
104         // transfer inital coin to Garry, which is 1
105         Transfer(address(0), owner, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // to safe gas, address(0) is removed since it never holds Garrys
112     // they are minted and not initially transferred to address(0)
113     // ------------------------------------------------------------------------
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply;
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account `tokenOwner`
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125     
126 
127     // ------------------------------------------------------------------------
128     // Transfer the balance from token owner's account to `to` account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ------------------------------------------------------------------------
132     function transfer(address to, uint tokens) public returns (bool success) {
133         require(balances[msg.sender] >= tokens);
134         balances[msg.sender] -= tokens;
135         balances[to] += tokens;
136         Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Token owner can approve for `spender` to transferFrom(...) `tokens`
143     // from the token owner's account
144     //
145     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
146     // recommends that there are no checks for the approval double-spend attack
147     // as this should be implemented in user interfaces 
148     // ------------------------------------------------------------------------
149     function approve(address spender, uint tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer `tokens` from the `from` account to the `to` account
158     // 
159     // The calling account must already have sufficient tokens approve(...)
160     // for spending from the `from` account and
161     // - From account must have sufficient balance to transfer
162     // - Spender must have sufficient allowance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         require (balances[from] > tokens);
167         balances[from] -= tokens;
168         allowed[from][msg.sender] -= tokens;
169         balances[to] += tokens;
170         Transfer(from, to, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Returns the amount of tokens approved by the owner that can be
177     // transferred to the spender's account
178     // ------------------------------------------------------------------------
179     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
180         return allowed[tokenOwner][spender];
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for `spender` to transferFrom(...) `tokens`
186     // from the token owner's account. The `spender` contract function
187     // `receiveApproval(...)` is then executed
188     // ------------------------------------------------------------------------
189     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Tokens per Ethererum at a ratio of 100:1
199     // But you need to buy at least 0.0001 Garrys to avoid spamming (currently 5 $cent)
200     // ------------------------------------------------------------------------
201     function () public payable {
202         require(msg.value >= 1000000000000);
203         require(_totalSupply+(msg.value*_ratio)<=_maxSupply);
204         
205         uint tokens;
206         tokens = msg.value*_ratio;
207 
208         balances[msg.sender] += tokens;
209         _totalSupply += tokens;
210         Transfer(address(0), msg.sender, tokens);
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Owner can transfer out any accidentally sent ERC20 tokens
216     // Only if he is in the mood though, I won't give a damn if you are an annoying bot
217     // ------------------------------------------------------------------------
218     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Query Ethereum of contract
225     // ------------------------------------------------------------------------
226     function weiBalance() public constant returns (uint weiBal) {
227         return this.balance;
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Send Contracts Ethereum to address owner
233     // ------------------------------------------------------------------------
234     function weiToOwner(address _address, uint amount) public onlyOwner {
235         require(amount <= this.balance);
236         _address.transfer(amount);
237         WeiSent(_address, amount);
238     }
239 }