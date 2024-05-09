1 pragma solidity ^0.5.6;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 contract SafeMath {
9     function safeAdd(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public returns (uint);
33     function balanceOf(address tokenOwner) public returns (uint balance);
34     function allowance(address tokenOwner, address spender) public returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71 
72 
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and assisted
78 // token transfers
79 // ----------------------------------------------------------------------------
80 contract Token is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint public decimals;
84     string public comments;
85     uint private _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     // ------------------------------------------------------------------------
92     // Constructor
93     // ------------------------------------------------------------------------
94     constructor(
95         uint256 initialSupply,
96         string memory tokenName,
97         uint8 decimalUnits,
98         string memory tokenSymbol,
99         string memory tokenComments
100     ) public {
101         symbol = tokenSymbol;
102         name = tokenName;
103         decimals = decimalUnits;
104         comments = tokenComments;
105         _totalSupply = initialSupply;
106         _totalSupply = _totalSupply * 10 ** decimals;
107         balances[owner] = _totalSupply;
108         emit Transfer(address(0), owner, _totalSupply);
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public returns (uint) {
116         return _totalSupply;
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Get the token balance for account tokenOwner
122     // ------------------------------------------------------------------------
123     function balanceOf(address tokenOwner) public returns (uint balance) {
124         return balances[tokenOwner];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to to account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Token owner can approve for spender to transferFrom(...) tokens
143     // from the token owner's account
144     //
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         emit Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer tokens from the from account to the to account
157     //
158     // The calling account must already have sufficient tokens approve(...)-d
159     // for spending from the from account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
165         balances[from] = safeSub(balances[from], tokens);
166         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
167         balances[to] = safeAdd(balances[to], tokens);
168         emit Transfer(from, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Returns the amount of tokens approved by the owner that can be
175     // transferred to the spender's account
176     // ------------------------------------------------------------------------
177     function allowance(address tokenOwner, address spender) public returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Token owner can approve for spender to transferFrom(...) tokens
184     // from the token owner's account. The spender contract function
185     // receiveApproval(...) is then executed
186     // ------------------------------------------------------------------------
187     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Don't accept ETH
197     // ------------------------------------------------------------------------
198     function () external payable {
199         revert();
200     }
201 
202 
203     function transferOwnership(address _newOwner) public onlyOwner {
204         owner = _newOwner;
205     }
206 
207 
208     /**
209     * @dev Internal function that mints an amount of the token and assigns it to
210     * an account. This encapsulates the modification of balances such that the
211     * proper events are emitted.
212     * @param account The account that will receive the created tokens.
213     * @param value The amount that will be created.
214     */
215     function mint(address account, uint256 value) public onlyOwner {
216         require(account != address(0));
217 
218         _totalSupply = safeAdd(_totalSupply, value);
219         balances[account] = safeAdd(balances[account], value);
220         emit Transfer(address(0), account, value);
221     }
222 
223     /**
224      * @dev Internal function that burns an amount of the token of a given
225      * account.
226      * @param account The account whose tokens will be burnt.
227      * @param value The amount that will be burnt.
228      */
229     function burn(address account, uint256 value) public onlyOwner {
230         require(account != address(0));
231 
232         _totalSupply = safeSub(_totalSupply, value);
233         balances[account] = safeSub(balances[account], value);
234         emit Transfer(account, address(0), value);
235     }
236 }