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
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // Contract function to receive approval and execute function in one call
31 // Borrowed from MiniMeToken
32 // ----------------------------------------------------------------------------
33 contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // Contract owner and transfer functions
40 // just in case someone wants to get my bacon
41 // ----------------------------------------------------------------------------
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // ERC20 compliant Garry token :)
72 // Receives ETH and generates Garrys, the world needs more Garrys
73 // Limited to 10000 on this planet, yup
74 // 1 Garry can be exchanged for 1 creature in our upcoming game
75 // ----------------------------------------------------------------------------
76 contract Garrys is ERC20Interface, Owned {
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81     uint public _maxSupply;
82     uint public _ratio;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86     
87     address GameContract;
88     
89     // ------------------------------------------------------------------------
90     // Launched once when contract starts
91     // ------------------------------------------------------------------------
92     function Garrys() public {
93         symbol = "GAR";
94         name = "Garrys";
95         decimals = 18;
96         // the first coin goes to Garry cause, it's a Garry :P, adding it to total supply here
97         _totalSupply = 1 * 10**uint(decimals);      
98         // set ratio, get 100 Garrys for 1 Ether
99         _ratio = 100;
100         // there can never be more than 10000 Garrys in existence, doubt the world can handle 2 :D
101         _maxSupply = 10000 * 10**uint(decimals);    
102         balances[owner] = _totalSupply;
103         // transfer inital coin to Garry, which is 1
104         Transfer(address(0), owner, _totalSupply);
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Total supply
110     // to safe gas, address(0) is removed since it never holds Garrys
111     // they are minted and not initially transferred to address(0)
112     // ------------------------------------------------------------------------
113     function totalSupply() public constant returns (uint) {
114         return _totalSupply;
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public constant returns (uint balance) {
122         return balances[tokenOwner];
123     }
124     
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public returns (bool success) {
132         require(balances[msg.sender] >= tokens);
133         balances[msg.sender] -= tokens;
134         balances[to] += tokens;
135         Transfer(msg.sender, to, tokens);
136         return true;
137     }
138     
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account
143     //
144     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer `tokens` from the `from` account to the `to` account
157     // 
158     // The calling account must already have sufficient tokens approve(...)
159     // for spending from the `from` account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
165         require (allowed[from][msg.sender] >= tokens);
166         require (balances[from] >= tokens);
167         
168         balances[from] -= tokens;
169         allowed[from][msg.sender] -= tokens;
170         balances[to] += tokens;
171         Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for `spender` to transferFrom(...) `tokens`
187     // from the token owner's account. The `spender` contract function
188     // `receiveApproval(...)` is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Tokens per Ethererum at a ratio of 100:1
200     // But you need to buy at least 0.0001 Garrys to avoid spamming (currently 5 $cent)
201     // ------------------------------------------------------------------------
202     function () public payable {
203         require(msg.value >= 1000000000000);
204         require(_totalSupply+(msg.value*_ratio)<=_maxSupply);
205         
206         uint tokens;
207         tokens = msg.value*_ratio;
208 
209         balances[msg.sender] += tokens;
210         _totalSupply += tokens;
211         Transfer(address(0), msg.sender, tokens);
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
228         return this.balance;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Send Contracts Ethereum to address owner
234     // ------------------------------------------------------------------------
235     function weiToOwner(address _address, uint amount) public onlyOwner {
236         require(amount <= this.balance);
237         _address.transfer(amount);
238     }
239 }