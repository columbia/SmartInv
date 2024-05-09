1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------//
4 // (Quantum Bit) is created by NASA contracting company Inov8ive Technologies and is
5 // intended to be the first Quantum Distributed Ledger which will send current cryptocurrency
6 // data through time, creating a Past, Present and Future Quantum Distributed Ledger.
7 // link Kiteletter.com
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract Token is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint public decimals;
99     uint public _totalSupply;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     constructor() public {
109         symbol = "OMNIS";
110         name = "OMNIS-BIT";
111         decimals = 18;
112         _totalSupply = 1000000000;
113         _totalSupply = _totalSupply * 10 ** decimals;
114         balances[0xa7ee1c1f095171D4232eccF7aC9ba486D5E819c9] = _totalSupply;
115         emit Transfer(address(0), 0xa7ee1c1f095171D4232eccF7aC9ba486D5E819c9, _totalSupply);
116     }
117     
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         emit Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces
155     // ------------------------------------------------------------------------
156     function approve(address spender, uint tokens) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         emit Approval(msg.sender, spender, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer tokens from the from account to the to account
165     //
166     // The calling account must already have sufficient tokens approve(...)-d
167     // for spending from the from account and
168     // - From account must have sufficient balance to transfer
169     // - Spender must have sufficient allowance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
173         balances[from] = safeSub(balances[from], tokens);
174         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         emit Transfer(from, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186         return allowed[tokenOwner][spender];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Token owner can approve for spender to transferFrom(...) tokens
192     // from the token owner's account. The spender contract function
193     // receiveApproval(...) is then executed
194     // ------------------------------------------------------------------------
195     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         emit Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Don't accept ETH
205     // ------------------------------------------------------------------------
206     function () public payable {
207         revert();
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Owner can transfer out any accidentally sent ERC20 tokens
213     // ------------------------------------------------------------------------
214     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
215         return ERC20Interface(tokenAddress).transfer(owner, tokens);
216     }
217     
218     
219      /**
220      * @dev Internal function that mints an amount of the token and assigns it to
221      * an account. This encapsulates the modification of balances such that the
222      * proper events are emitted.
223      * @param account The account that will receive the created tokens.
224      * @param value The amount that will be created.
225      */
226     function mint(address account, uint256 value) public onlyOwner {
227         require(account != address(0));
228 
229         _totalSupply = safeAdd(_totalSupply, value);
230         balances[account] = safeAdd(balances[account], value);
231         emit Transfer(address(0), account, value);
232     }
233 
234     /**
235      * @dev Internal function that burns an amount of the token of a given
236      * account.
237      * @param account The account whose tokens will be burnt.
238      * @param value The amount that will be burnt.
239      */
240     function burn(address account, uint256 value) public onlyOwner {
241         require(account != address(0));
242 
243         _totalSupply = safeSub(_totalSupply, value);
244         balances[account] = safeSub(balances[account], value);
245         emit Transfer(account, address(0), value);
246     }
247 }