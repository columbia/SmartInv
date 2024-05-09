1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'OjuT' token contract
5 //
6 // Deployed to : 0x25B0db4FD8062a74685032e87a675A3df5a9F228
7 // Symbol      : OjuT
8 // Name        : OjuT Token
9 // Total supply: 1250000000
10 // Decimals    : 18
11 //
12 // Improved from Moritz Neto with BokkyPooBah
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50     function burn(uint256 value) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54     event Burn(address indexed from, uint256 value);
55     event FrozenFunds(address target, bool frozen);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // Contract function to receive approval and execute function in one call
92 //
93 // Borrowed from MiniMeToken
94 // ----------------------------------------------------------------------------
95 contract ApproveAndCallFallBack {
96     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
97 }
98 
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and assisted
102 // token transfers
103 // ----------------------------------------------------------------------------
104 contract OjuTToken is ERC20Interface, Owned, SafeMath {
105     string public symbol;
106     string public  name;
107     address public ownerAddress;
108     uint8 public decimals;
109     uint public totalSupply;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113     mapping(address => bool) public frozenAccount;
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor() public {
119         symbol = "OjuT";
120         name = "OjuT Token";
121         decimals = 18;
122         totalSupply = 125 * 10 ** 25;
123         ownerAddress = 0x25B0db4FD8062a74685032e87a675A3df5a9F228;
124         balances[ownerAddress] = totalSupply;
125         emit Transfer(address(0), ownerAddress, totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return totalSupply - balances[address(0)];
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
151         // Prevent transfer to 0x0 address. Use burn() instead
152         require(to != 0x0);
153         // Check if sender is frozen
154         require(!frozenAccount[msg.sender]);     
155         // Check if recipient is frozen                
156         require(!frozenAccount[to]);                   
157         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         emit Transfer(msg.sender, to, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for spender to transferFrom(...) tokens
166     // from the token owner's account
167     //
168     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169     // recommends that there are no checks for the approval double-spend attack
170     // as this should be implemented in user interfaces 
171     // ------------------------------------------------------------------------
172     function approve(address spender, uint tokens) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         emit Approval(msg.sender, spender, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer tokens from the from account to the to account
181     // 
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the from account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
189         // Prevent transfer to 0x0 address. Use burn() instead
190         require(to != 0x0);   
191         // Check if sender is frozen
192         require(!frozenAccount[from]);     
193         // Check if recipient is frozen                
194         require(!frozenAccount[to]);                       
195         balances[from] = safeSub(balances[from], tokens);
196         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
197         balances[to] = safeAdd(balances[to], tokens);
198         emit Transfer(from, to, tokens);
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
219         emit Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Don't accept ETH
227     // ------------------------------------------------------------------------
228     function () public payable {
229         revert();
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Owner can transfer out any accidentally sent ERC20 tokens
235     // ------------------------------------------------------------------------
236     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
237         return ERC20Interface(tokenAddress).transfer(owner, tokens);
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Destroy tokens
243     // Remove `value` tokens from the system irreversibly
244     // @param value the amount of money to burn
245     // ------------------------------------------------------------------------
246     function burn(uint256 value) public returns (bool success) {
247         require(balances[msg.sender] >= value);   // Check if the sender has enough
248         balances[msg.sender] -= value;            // Subtract from the sender
249         totalSupply -= value;                     // Updates totalSupply
250         emit Burn(msg.sender, value);
251         return true;
252     }
253 
254     // ------------------------------------------------------------------------
255     // Freeze account - Prevent | Allow` `target` from sending & receiving tokens
256     // @param target Address to be frozen
257     // @param freeze either to freeze it or not
258     // ------------------------------------------------------------------------
259     function freezeAccount(address target, bool freeze) onlyOwner public {
260         frozenAccount[target] = freeze;
261         emit FrozenFunds(target, freeze);
262     }
263 }