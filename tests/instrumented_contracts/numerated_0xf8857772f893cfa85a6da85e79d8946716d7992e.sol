1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Zcnox' token contract
5 //
6 // Deployed to : 0xBA038f17e3395f755A615810a6B86a0c1cce254E
7 // Symbol      : ZNC
8 // Name        : Zcnox
9 // Total supply: 20000000e18
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // Edited by  Zcnox Digital Marketing Co.ltd
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 contract SafeMath {
23     function safeAdd(uint a, uint b) public pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function safeSub(uint a, uint b) public pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function safeMul(uint a, uint b) public pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function safeDiv(uint a, uint b) public pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     function Owned() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract ZcnoxToken is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111     
112     uint constant PLTime = 1538262000; // Product Launch Date  September 30, 2018 12:00:00 AM
113     
114 
115     address company = 0xE8d5949A846345a891CD166f9cDAfd334abB060d;
116     address team = 0xdFd8Dcfd18F4bcDc74174c0a1eF04C4342EFecb2;
117 
118     address crowdsale = 0xd1e624a8275cb34432afbcac5a31bf4276abe676;
119     address bounty = 0x4E51f4ee18Dc89B2bd10a0bc064844F6B1F08517;
120 
121    
122 
123     uint constant companyTokens = 3000000e18;
124     uint constant teamTokens = 2000000e18;
125     uint constant crowdsaleTokens = 14000000e18;
126     uint constant bountyTokens = 1000000e18;
127 
128     
129 
130     // ------------------------------------------------------------------------
131     // Constructor
132     // ------------------------------------------------------------------------
133     function ZcnoxToken() public {
134         symbol = "ZNC";
135         name = "Zcnox";
136         decimals = 18;
137         _totalSupply = 20000000e18;
138         
139        
140        // Token Distribution
141         distributeToken(company, companyTokens);
142         distributeToken(team, teamTokens);
143         distributeToken(crowdsale, crowdsaleTokens);
144         distributeToken(bounty, bountyTokens);
145     }
146     
147     function distributeToken(address _address, uint _amount) internal returns (bool) {
148         balances[_address] = _amount;
149         Transfer(address(0x0), _address, _amount);
150     }
151     
152     
153     function checkPermissions(address _from) internal constant returns (bool) {
154         
155         //Lock Team Token untill Product Launch
156         if (_from == team && now < PLTime) {
157             return false; 
158         }
159         
160         
161         //Lock Company Token untill Product Launch
162          if (_from == company && now < PLTime) {
163             return false;
164         }
165 
166         if (_from == bounty || _from == crowdsale) {
167             return true;
168         }
169 
170     }
171     
172     // ------------------------------------------------------------------------
173     // Total supply
174     // ------------------------------------------------------------------------
175     function totalSupply() public constant returns (uint) {
176         return _totalSupply  - balances[address(0)];
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Get the token balance for account tokenOwner
182     // ------------------------------------------------------------------------
183     function balanceOf(address tokenOwner) public constant returns (uint balance) {
184         return balances[tokenOwner];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Transfer the balance from token owner's account to to account
190     // - Owner's account must have sufficient balance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transfer(address to, uint tokens) public returns (bool success) {
194         require(checkPermissions(msg.sender));
195         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
196         balances[to] = safeAdd(balances[to], tokens);
197         Transfer(msg.sender, to, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for spender to transferFrom(...) tokens
204     // from the token owner's account
205     //
206     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
207     // recommends that there are no checks for the approval double-spend attack
208     // as this should be implemented in user interfaces 
209     // ------------------------------------------------------------------------
210     function approve(address spender, uint tokens) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         Approval(msg.sender, spender, tokens);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Transfer tokens from the from account to the to account
219     // 
220     // The calling account must already have sufficient tokens approve(...)-d
221     // for spending from the from account and
222     // - From account must have sufficient balance to transfer
223     // - Spender must have sufficient allowance to transfer
224     // - 0 value transfers are allowed
225     // ------------------------------------------------------------------------
226     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
227         require(checkPermissions(msg.sender));
228         balances[from] = safeSub(balances[from], tokens);
229         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
230         balances[to] = safeAdd(balances[to], tokens);
231         Transfer(from, to, tokens);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Returns the amount of tokens approved by the owner that can be
238     // transferred to the spender's account
239     // ------------------------------------------------------------------------
240     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
241         return allowed[tokenOwner][spender];
242     }
243 
244 
245     // ------------------------------------------------------------------------
246     // Token owner can approve for spender to transferFrom(...) tokens
247     // from the token owner's account. The spender contract function
248     // receiveApproval(...) is then executed
249     // ------------------------------------------------------------------------
250     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
251         allowed[msg.sender][spender] = tokens;
252         Approval(msg.sender, spender, tokens);
253         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
254         return true;
255     }
256 
257 
258     // ------------------------------------------------------------------------
259     // Don't accept ETH
260     // ------------------------------------------------------------------------
261     function () public payable {
262         revert();
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Owner can transfer out any accidentally sent ERC20 tokens
268     // ------------------------------------------------------------------------
269     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
270         return ERC20Interface(tokenAddress).transfer(owner, tokens);
271     }
272 }