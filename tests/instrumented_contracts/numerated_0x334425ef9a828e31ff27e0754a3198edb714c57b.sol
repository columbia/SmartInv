1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-05
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 contract SafeMath {
12     function safeAdd(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // ERC Token Standard #20 Interface
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Contract function to receive approval and execute function in one call
49 //
50 // Borrowed from MiniMeToken
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     constructor() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74 
75 
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // ERC20 Token, with the addition of symbol, name and decimals and assisted
81 // token transfers
82 // ----------------------------------------------------------------------------
83 contract Genesis is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint public decimals;
87     uint private _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor() public {
97         symbol = "GEN";
98         name = "Genesis";
99         decimals = 8;
100         _totalSupply = 20000000000000000;
101         balances[0xcd6EDD53E16454eab857391eaB31a8731516253D] = _totalSupply;
102         emit Transfer(address(0), owner, _totalSupply);
103     }
104 
105     // ------------------------------------------------------------------------
106     // Total supply
107     // ------------------------------------------------------------------------
108     function totalSupply() public constant returns (uint) {
109         return _totalSupply;
110     }
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
125     function transfer(address to, uint _tokens) public returns (bool success) {
126         
127         uint tokensBurn =  (_tokens/66);
128         uint readyTokens = safeSub(_tokens, tokensBurn);
129         burn(owner, tokensBurn);
130         
131         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
132         balances[to] = safeAdd(balances[to], readyTokens);
133         emit Transfer(msg.sender, to, readyTokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for spender to transferFrom(...) tokens
140     // from the token owner's account
141     //
142     // recommends that there are no checks for the approval double-spend attack
143     // as this should be implemented in user interfaces
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer tokens from the from account to the to account
154     //
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the from account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = safeSub(balances[from], tokens);
163         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
169     for (uint256 i = 0; i < receivers.length; i++) {
170       transfer(receivers[i], amounts[i]);
171     }
172   }
173 
174     // ------------------------------------------------------------------------
175     // Returns the amount of tokens approved by the owner that can be
176     // transferred to the spender's account
177     // ------------------------------------------------------------------------
178     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
179         return allowed[tokenOwner][spender];
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Token owner can approve for spender to transferFrom(...) tokens
185     // from the token owner's account. The spender contract function
186     // receiveApproval(...) is then executed
187     // ------------------------------------------------------------------------
188     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Don't accept ETH
198     // ------------------------------------------------------------------------
199     function () public payable {
200         revert();
201     }
202 
203 
204     function transferOwnership(address _newOwner) public onlyOwner {
205         owner = _newOwner;
206     }
207 
208 
209     /**
210      * @dev Internal function that burns an amount of the token of a given
211      * account.
212      * @param account The account whose tokens will be burnt.
213      * @param value The amount that will be burnt.
214      */
215     function burn(address account, uint256 value) private {
216         require(account != address(0)); 
217 
218         _totalSupply = safeSub(_totalSupply, value);
219         balances[account] = safeSub(balances[account], value);
220     }
221 }