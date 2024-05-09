1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'Quaffle' token contract
5 //
6 // Deployed to : 0x32FC28D09D7fA2DC92bE1DdC61B31F37D74fb628
7 // Symbol      : QUAF
8 // Name        : Quaffle
9 // Total supply: 500,000
10 // Decimals    : 18
11 //
12 //
13 // created by u/TheQuaffle
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36     
37      //not a SafeMath function
38     function max(uint a, uint b) private pure returns (uint) {
39         return a > b ? a : b;
40     }
41     
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public view returns (uint);
51     function balanceOf(address tokenOwner) public view returns (uint balance);
52     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals and a
104 // fixed supply
105 // ----------------------------------------------------------------------------
106 contract Quaffle is ERC20Interface, Owned {
107     using SafeMath for uint;
108 
109     string public symbol;
110     string public  name;
111     uint8 public decimals;
112     uint _totalSupply;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     constructor() public {
122         symbol = "QUAF";
123         name = "Quaffle";
124         decimals = 18;
125         _totalSupply = 500000000000000000000000;
126         balances[0x32FC28D09D7fA2DC92bE1DdC61B31F37D74fb628] = _totalSupply;
127         emit Transfer(address(0), 0x32FC28D09D7fA2DC92bE1DdC61B31F37D74fb628, _totalSupply);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public view returns (uint) {
135         return _totalSupply.sub(balances[address(0)]);
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account `tokenOwner`
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public view returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152      function transfer(address to, uint tokens) public returns (bool success) {
153         
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         
156         uint tokenBurnFactor = 200;
157         uint _tokensBurned = tokens.div(tokenBurnFactor);
158         uint _tokensRecieved = tokens.sub(_tokensBurned);
159         
160         balances[to] = balances[to].add(_tokensRecieved);
161         _totalSupply = _totalSupply.sub(_tokensBurned);
162         
163         emit Transfer(msg.sender, to, _tokensRecieved);
164         emit Transfer(msg.sender, address(0), _tokensBurned);
165         
166         
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Token owner can approve for `spender` to transferFrom(...) `tokens`
173     // from the token owner's account
174     //
175     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
176     // recommends that there are no checks for the approval double-spend attack
177     // as this should be implemented in user interfaces
178     // ------------------------------------------------------------------------
179     function approve(address spender, uint tokens) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Transfer `tokens` from the `from` account to the `to` account
188     //
189     // The calling account must already have sufficient tokens approve(...)-d
190     // for spending from the `from` account and
191     // - From account must have sufficient balance to transfer
192     // - Spender must have sufficient allowance to transfer
193     // - 0 value transfers are allowed
194     // ------------------------------------------------------------------------
195     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
196         balances[from] = balances[from].sub(tokens);
197         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
198         
199         uint tokenBurnFactor = 200;
200         uint _tokensBurned = tokens.div(tokenBurnFactor);
201         uint _tokensRecieved = tokens.sub(_tokensBurned);
202       
203         
204         balances[to] = balances[to].add(_tokensRecieved);
205         _totalSupply = _totalSupply.sub(_tokensBurned);
206         
207         emit Transfer(from, to, _tokensRecieved);
208         emit Transfer(msg.sender, address(0), _tokensBurned);
209         
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for `spender` to transferFrom(...) `tokens`
225     // from the token owner's account. The `spender` contract function
226     // `receiveApproval(...)` is then executed
227     // ------------------------------------------------------------------------
228     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
229         allowed[msg.sender][spender] = tokens;
230         emit Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Don't accept ETH
238     // ------------------------------------------------------------------------
239     function () external payable {
240         revert();
241     }
242 
243 
244     // ------------------------------------------------------------------------
245     // Owner can transfer out any accidentally sent ERC20 tokens
246     // ------------------------------------------------------------------------
247     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
248         return ERC20Interface(tokenAddress).transfer(owner, tokens);
249     }
250 }