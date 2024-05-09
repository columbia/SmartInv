1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : BCaaS
7 // Name        : Blockchain As A Service
8 // Total supply: 1000,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // ----------------------------------------------------------------------------
14 
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
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and an
98 // initial fixed supply
99 // ----------------------------------------------------------------------------
100 contract BCaaS is ERC20Interface, Owned {
101     using SafeMath for uint;
102 
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint256 public sellPrice;
107     uint256 public buyPrice;
108 
109     /* This generates a public event on the blockchain that will notify clients */
110     event FrozenFunds(address target, bool frozen);
111     uint public _totalSupply;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115     mapping (address => bool) public frozenAccount;
116     // This creates an array with all balances
117     mapping (address => uint256) public balanceOf;
118 
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     function BCaaS() public {
123         symbol = "BCaaS";
124         name = "Blockchain As A Service";
125         decimals = 18;
126         _totalSupply = 100000000 * 10**uint(decimals);
127         balances[owner] = _totalSupply;
128         Transfer(address(0), owner, _totalSupply);
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply  - balances[address(0)];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account `tokenOwner`
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public constant returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to `to` account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces 
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     // 
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = balances[from].sub(tokens);
187         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         Transfer(from, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for `spender` to transferFrom(...) `tokens`
205     // from the token owner's account. The `spender` contract function
206     // `receiveApproval(...)` is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Don't accept ETH
218     // ------------------------------------------------------------------------
219     function () public payable {
220         revert();
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 
231     /* Internal transfer, only can be called by this contract */
232     function _transfer(address _from, address _to, uint _value) internal {
233         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
234         require (balanceOf[_from] >= _value);               // Check if the sender has enough
235         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
236         require(!frozenAccount[_from]);                     // Check if sender is frozen
237         require(!frozenAccount[_to]);                       // Check if recipient is frozen
238         balanceOf[_from] -= _value;                         // Subtract from the sender
239         balanceOf[_to] += _value;                           // Add the same to the recipient
240         Transfer(_from, _to, _value);
241     }
242     /// @notice Create `mintedAmount` tokens and send it to `target`
243     /// @param target Address to receive the tokens
244     /// @param mintedAmount the amount of tokens it will receive
245     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
246         balanceOf[target] += mintedAmount;
247         _totalSupply += mintedAmount;
248         Transfer(0, this, mintedAmount);
249         Transfer(this, target, mintedAmount);
250     }
251 
252     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
253     /// @param target Address to be frozen
254     /// @param freeze either to freeze it or not
255     function freezeAccount(address target, bool freeze) onlyOwner public {
256         frozenAccount[target] = freeze;
257         FrozenFunds(target, freeze);
258     }
259 
260     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
261     /// @param newSellPrice Price the users can sell to the contract
262     /// @param newBuyPrice Price users can buy from the contract
263     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
264         sellPrice = newSellPrice;
265         buyPrice = newBuyPrice;
266     }
267 
268     /// @notice Buy tokens from contract by sending ether
269     function buy() payable public {
270         uint amount = msg.value / buyPrice;               // calculates the amount
271         _transfer(this, msg.sender, amount);              // makes the transfers
272     }
273 
274     /// @notice Sell `amount` tokens to contract
275     /// @param amount amount of tokens to be sold
276     function sell(uint256 amount) public {
277         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
278         _transfer(msg.sender, this, amount);              // makes the transfers
279         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
280     }
281 }