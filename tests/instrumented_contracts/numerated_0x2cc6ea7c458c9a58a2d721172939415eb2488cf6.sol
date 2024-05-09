1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
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
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
80 contract tbriks is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint public decimals;
84     uint private _totalSupply;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90     // ------------------------------------------------------------------------
91     // Constructor
92     // ------------------------------------------------------------------------
93     constructor() public {
94         symbol = "XTBX";
95         name = "tbriks";
96         decimals = 3;
97         _totalSupply = 900000000;
98         _totalSupply = _totalSupply * 10 ** decimals;
99         balances[owner] = _totalSupply;
100         emit Transfer(address(0), owner, _totalSupply);
101     }
102     
103 
104     // ------------------------------------------------------------------------
105     // Total supply
106     // ------------------------------------------------------------------------
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply;
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Get the token balance for account tokenOwner
114     // ------------------------------------------------------------------------
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Transfer the balance from token owner's account to to account
122     // - Owner's account must have sufficient balance to transfer
123     // - 0 value transfers are allowed
124     // ------------------------------------------------------------------------
125     function transfer(address to, uint tokens) public returns (bool success) {
126         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(msg.sender, to, tokens);
129         return true;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Token owner can approve for spender to transferFrom(...) tokens
135     // from the token owner's account
136     //
137     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
138     // recommends that there are no checks for the approval double-spend attack
139     // as this should be implemented in user interfaces
140     // ------------------------------------------------------------------------
141     function approve(address spender, uint tokens) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         emit Approval(msg.sender, spender, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer tokens from the from account to the to account
150     //
151     // The calling account must already have sufficient tokens approve(...)-d
152     // for spending from the from account and
153     // - From account must have sufficient balance to transfer
154     // - Spender must have sufficient allowance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         balances[from] = safeSub(balances[from], tokens);
159         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
160         balances[to] = safeAdd(balances[to], tokens);
161         emit Transfer(from, to, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Returns the amount of tokens approved by the owner that can be
168     // transferred to the spender's account
169     // ------------------------------------------------------------------------
170     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
171         return allowed[tokenOwner][spender];
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Token owner can approve for spender to transferFrom(...) tokens
177     // from the token owner's account. The spender contract function
178     // receiveApproval(...) is then executed
179     // ------------------------------------------------------------------------
180     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Don't accept ETH
190     // ------------------------------------------------------------------------
191     function () public payable {
192         revert();
193     }
194 
195     
196     function transferOwnership(address _newOwner) public onlyOwner {
197         owner = _newOwner;
198     }
199     
200     
201      /**
202      * @dev Internal function that mints an amount of the token and assigns it to
203      * an account. This encapsulates the modification of balances such that the
204      * proper events are emitted.
205      * @param account The account that will receive the created tokens.
206      * @param value The amount that will be created.
207      */
208     function mint(address account, uint256 value) public onlyOwner {
209         require(account != address(0));
210 
211         _totalSupply = safeAdd(_totalSupply, value);
212         balances[account] = safeAdd(balances[account], value);
213         emit Transfer(address(0), account, value);
214     }
215 
216     /**
217      * @dev Internal function that burns an amount of the token of a given
218      * account.
219      * @param account The account whose tokens will be burnt.
220      * @param value The amount that will be burnt.
221      */
222     function burn(address account, uint256 value) public onlyOwner {
223         require(account != address(0));
224 
225         _totalSupply = safeSub(_totalSupply, value);
226         balances[account] = safeSub(balances[account], value);
227         emit Transfer(account, address(0), value);
228     }
229 
230 }