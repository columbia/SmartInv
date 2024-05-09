1 pragma solidity ^0.5.1;
2 //version:0.5.1+commit.c8a2cb62.Emscripten.clang
3 //'BZK10' token contract
4 // Symbol      : BZK10
5 // Name        : Bzk10Token
6 // Total supply: 1000000000000
7 // Decimals    : 6
8 
9 
10 
11 // Safe maths
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 
33 // Owned contract
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 
60 
61 
62 contract Pausable is Owned {
63     event Paused(address account);
64     event Unpaused(address account);
65 
66     bool private _paused;
67 
68     constructor () internal {
69         _paused = false;
70     }
71 
72     /**
73      * @return true if the contract is paused, false otherwise.
74      */
75     function paused() public view returns (bool) {
76         return _paused;
77     }
78 
79     /**
80      * @dev Modifier to make a function callable only when the contract is not paused.
81      */
82     modifier whenNotPaused() {
83         require(!_paused);
84         _;
85     }
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is paused.
89      */
90     modifier whenPaused() {
91         require(_paused);
92         _;
93     }
94 
95     /**
96      * @dev called by the owner to pause, triggers stopped state
97      */
98     function pause() public onlyOwner whenNotPaused {
99         _paused = true;
100         emit Paused(msg.sender);
101     }
102 
103     /**
104      * @dev called by the owner to unpause, returns to normal state
105      */
106     function unpause() public onlyOwner whenPaused {
107         _paused = false;
108         emit Unpaused(msg.sender);
109     }
110 }
111 
112 
113 
114 // ERC20 interface
115 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
116 contract ERC20Interface {
117     function totalSupply() public view returns (uint);
118     function balanceOf(address tokenOwner) public view returns (uint balance);
119     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
120     function transfer(address to, uint tokens) public returns (bool success);
121     function approve(address spender, uint tokens) public returns (bool success);
122     function transferFrom(address from, address to, uint tokens) public returns (bool success);
123 
124     event Transfer(address indexed from, address indexed to, uint tokens);
125     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
126 }
127 
128 
129 // Contract function to receive approval and execute function in one call
130 // Borrowed from MiniMeToken
131 contract ApproveAndCallFallBack {
132     function receiveApproval(address from, uint256 tokens, address tokenAddress, bytes memory data) public;
133 }
134 
135 
136 
137 // ERC20 Token, with the addition of symbol, name and decimals and assisted
138 // token transfers
139 contract Bzk10Token is ERC20Interface, Owned, SafeMath, Pausable {
140     string public symbol;
141     string public  name;
142     uint8 public decimals;
143     uint public _totalSupply;
144 
145     mapping(address => uint) balances;
146     mapping(address => mapping(address => uint)) allowed;
147 
148 
149     // Constructor
150     constructor() public {
151         symbol = "BZK10";
152         name = "Bzk10Token";
153         decimals = 6;
154         _totalSupply = 1000000000000;
155         balances[msg.sender] = _totalSupply;
156         emit Transfer(address(0), msg.sender, _totalSupply);
157     }
158 
159 
160     // Total supply
161     function totalSupply() public view returns (uint) {
162         return _totalSupply  - balances[address(0)];
163     }
164     
165     // number of decimals used by the contract
166     function getDecimals() public view returns (uint) {
167         return decimals;
168     }
169 
170 
171 
172     // Get the token balance for account tokenOwner
173     function balanceOf(address tokenOwner) public view returns (uint tokenOwnerBalance) {
174         return balances[tokenOwner];
175     }
176 
177 
178     // Transfer the balance from token owner's account to to account
179     // - Owner's account must have sufficient balance to transfer
180     // - 0 value transfers are allowed
181     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
182         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
183         balances[to] = safeAdd(balances[to], tokens);
184         emit Transfer(msg.sender, to, tokens);
185         return true;
186     }
187 
188 
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account
191     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
192     // recommends that there are no checks for the approval double-spend attack
193     // as this should be implemented in user interfaces 
194     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         emit Approval(msg.sender, spender, tokens);
197         return true;
198     }
199 
200 
201     // Transfer tokens from the "from" account to the "to" account
202     // The calling account must already have sufficient tokens approve(...)-d
203     // for spending from the "from" account and
204     // - "From" account must have sufficient balance to transfer
205     // - Spender must have sufficient allowance to transfer
206     // - 0 value transfers are allowed
207     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
208         balances[from] = safeSub(balances[from], tokens);
209         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
210         balances[to] = safeAdd(balances[to], tokens);
211         emit Transfer(from, to, tokens);
212         return true;
213     }
214 
215 
216     // Returns the amount of tokens approved by the owner that can be
217     // transferred to the spender's account
218     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223 
224     
225     // Token owner can approve for `spender` to transferFrom(...) `tokens`
226     // from the token owner's account. The `spender` contract function
227     // `receiveApproval(...)` is then executed
228     function approveAndCall(address spender, uint tokens, bytes memory data) public whenNotPaused returns (bool success) {
229         allowed[msg.sender][spender] = tokens;
230         emit Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
232         return true;
233     }
234 
235 
236 
237     // Don't accept ETH
238     function () external payable {
239         revert();
240     }
241 
242 
243     // Owner can transfer out any accidentally sent ERC20 tokens
244     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
245         return ERC20Interface(tokenAddress).transfer(owner, tokens);
246     }
247     
248     
249     function destroy() public onlyOwner {
250         selfdestruct(msg.sender);
251     }
252     
253     
254 }