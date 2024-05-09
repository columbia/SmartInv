1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'SWBT' token contract
5 //
6 // Deployed to : 0x6758e7c7588bbb772912e0f05bbC203b0782ac16
7 // Symbol      : SWBT
8 // Name        :  LU1951456018
9 // Total supply: 200,000
10 // Decimals    : 18
11 // Worth: 250 EUR each
12 // Agreements & Information: https://www.dropbox.com/sh/znrjo0rsqbuvdn2/AAAPneLjGJneh_bfLTquYxDLa?dl=0
13 //
14 // Enjoy.
15 //
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
78     constructor() public {
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
92         emit OwnershipTransferred(owner, newOwner);
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
103 contract LU1951456018 is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108     address public owner;
109 
110     uint256 public sellPrice;
111     uint256 public buyPrice;
112 
113     mapping (address => bool) public frozenAccount;
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117     /* This generates a public event on the blockchain that will notify clients */
118     event FrozenFunds(address target, bool frozen);
119     
120 
121     // ------------------------------------------------------------------------
122     // Constructor
123     // ------------------------------------------------------------------------
124     constructor() public {
125         symbol = "SWBT";
126         name = "LU1951456018";
127         decimals = 18;
128         _totalSupply = 2e23;
129         owner = msg.sender;
130         balances[owner] = _totalSupply;
131         emit Transfer(address(0), owner, _totalSupply);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint) {
139         return _totalSupply  - balances[address(0)];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account tokenOwner
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public constant returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to to account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         require( to == owner || msg.sender == owner );
158         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
159         balances[to] = safeAdd(balances[to], tokens);
160         emit Transfer(msg.sender, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Token owner can approve for spender to transferFrom(...) tokens
167     // from the token owner's account
168     //
169     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
170     // recommends that there are no checks for the approval double-spend attack
171     // as this should be implemented in user interfaces 
172     // ------------------------------------------------------------------------
173     function approve(address spender, uint tokens) public returns (bool success) {
174         allowed[msg.sender][spender] = tokens;
175         emit Approval(msg.sender, spender, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Transfer tokens from the from account to the to account
182     // 
183     // The calling account must already have sufficient tokens approve(...)-d
184     // for spending from the from account and
185     // - From account must have sufficient balance to transfer
186     // - Spender must have sufficient allowance to transfer
187     // - 0 value transfers are allowed
188     // ------------------------------------------------------------------------
189     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
190         require( to == owner || msg.sender == owner );
191         balances[from] = safeSub(balances[from], tokens);
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193         balances[to] = safeAdd(balances[to], tokens);
194         emit Transfer(from, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Returns the amount of tokens approved by the owner that can be
201     // transferred to the spender's account
202     // ------------------------------------------------------------------------
203     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
204         return allowed[tokenOwner][spender];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for spender to transferFrom(...) tokens
210     // from the token owner's account. The spender contract function
211     // receiveApproval(...) is then executed
212     // ------------------------------------------------------------------------
213     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
217         return true;
218     }
219 
220     /* Internal transfer, only can be called by this contract */
221     function _itransfer(address _from, address _to, uint _value) internal {
222         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
223         require (balances[_from] >= _value);                   // Check if the sender has enough
224         require (balances[_to] + _value >= balances[_to]);    // Check for overflows
225         require(!frozenAccount[_from]);                         // Check if sender is frozen
226         require(!frozenAccount[_to]);                           // Check if recipient is frozen
227         balances[_from] -= _value;                             // Subtract from the sender
228         balances[_to] += _value;                               // Add the same to the recipient
229         emit Transfer(_from, _to, _value);
230     }
231 
232     // ------------------------------------------------------------------------
233     // Don't accept ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         revert();
237     }
238 
239 
240     // ------------------------------------------------------------------------
241     // Owner can transfer out any accidentally sent ERC20 tokens
242     // ------------------------------------------------------------------------
243     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
244         return ERC20Interface(tokenAddress).transfer(owner, tokens);
245     }
246 
247 
248     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
249     /// @param target Address to be frozen
250     /// @param freeze either to freeze it or not
251     function freezeAccount(address target, bool freeze) onlyOwner public {
252         frozenAccount[target] = freeze;
253         emit FrozenFunds(target, freeze);
254     }
255 
256     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
257     /// @param newSellPrice Price the users can sell to the contract
258     /// @param newBuyPrice Price users can buy from the contract
259     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
260         sellPrice = newSellPrice;
261         buyPrice = newBuyPrice;
262     }
263 
264     /// @notice Buy tokens from contract by sending ether
265     function buy() payable public {
266         uint amount = msg.value / buyPrice;                 // calculates the amount
267         _itransfer(owner, msg.sender, amount);       // makes the transfers
268     }
269 
270 }