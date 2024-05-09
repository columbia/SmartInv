1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'btcc' token contract
5 //
6 // Symbol      : BTCC
7 // Name        : BTCCREDIT Token
8 // Total supply: 300000000
9 // Decimals    : 18
10 // 
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a, "Sum should be greater then any one digit");
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a, "Right side value should be less than left side");
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b, "Multiplied result should not be zero");
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0, "Divisible value should be greater than zero");
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51     event FrozenFunds(address indexed target, bool frozen);
52     event Burn(address indexed from, uint256 value);
53     event Debug(bool destroyed);
54 
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
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner, "You are not owner");
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner, "You are not owner");
91         emit OwnershipTransferred(owner, newOwner);
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
102 contract BTCCToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107     uint private _distributedTokenCount;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111     mapping(address => bool) public frozenAccount;
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "BTCC";
118         name = "BTCCREDIT Token";
119         decimals = 18;
120         _totalSupply = 300000000 * (10 ** uint(decimals)); //300 million
121     }
122 
123     function distributeTokens(address _address,  uint _amount) public onlyOwner returns (bool) {
124         
125         uint total = safeAdd(_distributedTokenCount, _amount);
126         require (total <= _totalSupply, "Distributed Tokens exceeded Total Suuply");
127         balances[_address] = safeAdd(balances[_address], _amount);
128 
129         _distributedTokenCount = safeAdd(_distributedTokenCount, _amount);
130         
131         emit Transfer (address(0), _address, _amount);
132         return true;
133     }
134 
135     // ------------------------------------------------------------------------
136     // Distributed Token Count
137     // ------------------------------------------------------------------------
138     function distributedTokenCount() public view onlyOwner returns (uint) {
139         return _distributedTokenCount;
140     }
141 
142     // ------------------------------------------------------------------------
143     // Total supply
144     // ------------------------------------------------------------------------
145     function totalSupply() public view returns (uint) {
146         return _totalSupply - balances[address(0)];
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Get the token balance for account tokenOwner
152     // ------------------------------------------------------------------------
153     function balanceOf(address tokenOwner) public view returns (uint balance) {
154         return balances[tokenOwner];
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer the balance from token owner's account to to account
160     // - Owner's account must have sufficient balance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transfer(address to, uint tokens) public returns (bool success) {
164         require(!frozenAccount[msg.sender], "Account is frozen"); // If account is frozen, it'll not allow : Fix - 1
165         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         emit Transfer(msg.sender, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for spender to transferFrom(...) tokens
174     // from the token owner's account
175     //
176     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
177     // recommends that there are no checks for the approval double-spend attack
178     // as this should be implemented in user interfaces 
179     // ------------------------------------------------------------------------
180     function approve(address spender, uint tokens) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Transfer tokens from the from account to the to account
189     // 
190     // The calling account must already have sufficient tokens approve(...)-d
191     // for spending from the from account and
192     // - From account must have sufficient balance to transfer
193     // - Spender must have sufficient allowance to transfer
194     // - 0 value transfers are allowed
195     // ------------------------------------------------------------------------
196     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
197         require(!frozenAccount[from], "Sender account is frozen"); // Check's if from account is frozen or not : Fix - 2
198         balances[from] = safeSub(balances[from], tokens);
199         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
200         balances[to] = safeAdd(balances[to], tokens);
201         emit Transfer(from, to, tokens);
202         return true;
203     }
204     
205     // ------------------------------------------------------------------------
206     // Mint tokens 
207     // 
208     // Increase the total supply
209     // - assign the newly minted tokens to target address
210     // - token count to be added in total suuply - mintedAmount
211     // ------------------------------------------------------------------------    
212     function mintToken(address _target, uint256 _mintedAmount) public onlyOwner {
213         require(!frozenAccount[_target], "Account is frozen");
214         balances[_target] = safeAdd(balances[_target], _mintedAmount);
215         _totalSupply = safeAdd(_totalSupply, _mintedAmount);
216 
217         emit Transfer(0, this, _mintedAmount);
218         emit Transfer(this, _target, _mintedAmount);
219     }
220 
221     function freezeAccount(address _target, bool _freeze) public onlyOwner {
222         frozenAccount[_target] = _freeze;
223         emit FrozenFunds(_target, _freeze);
224     }
225 
226 
227     // Burn tokens
228     function burn(uint256 _burnedAmount) public returns (bool success) {
229         require(balances[msg.sender] >= _burnedAmount, "Not enough balance");
230         balances[msg.sender] = safeSub(balances[msg.sender], _burnedAmount);
231         _totalSupply = safeSub(_totalSupply, _burnedAmount);
232         emit Burn(msg.sender, _burnedAmount);
233         return true;
234     }
235 
236     function burnFrom(address _from, uint256 _burnedAmount) public returns (bool success) {
237         require(balances[_from] >= _burnedAmount, "Not enough balance");
238         require(_burnedAmount <= allowed[_from][msg.sender], "Amount not allowed");
239 
240         balances[_from] = safeSub(balances[_from], _burnedAmount);
241         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _burnedAmount);        
242         _totalSupply = safeSub(_totalSupply, _burnedAmount);
243         
244         emit Burn(_from, _burnedAmount);
245         return true;
246     }
247 
248     // ------------------------------------------------------------------------
249     // Returns the amount of tokens approved by the owner that can be
250     // transferred to the spender's account
251     // ------------------------------------------------------------------------
252     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
253         return allowed[tokenOwner][spender];
254     }
255 
256 
257     // ------------------------------------------------------------------------
258     // Token owner can approve for spender to transferFrom(...) tokens
259     // from the token owner's account. The spender contract function
260     // receiveApproval(...) is then executed
261     // ------------------------------------------------------------------------
262     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
263         allowed[msg.sender][spender] = tokens;
264         emit Approval(msg.sender, spender, tokens);
265         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
266         return true;
267     }
268 
269 
270     // ------------------------------------------------------------------------
271     // Don't accept ETH
272     // ------------------------------------------------------------------------
273     function () public payable {
274         revert("Reverted the wrongly deposited ETH");
275     }
276 
277 
278     // ------------------------------------------------------------------------
279     // Owner can transfer out any accidentally sent ERC20 tokens
280     // ------------------------------------------------------------------------
281     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
282         return ERC20Interface(tokenAddress).transfer(owner, tokens);
283     }
284     
285     function destroyContract() public onlyOwner {
286         emit Debug(true);
287         selfdestruct(this);
288     }
289 }