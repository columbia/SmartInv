1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
41     
42         /* This notifies clients about the amount burnt */
43     event Burn(address indexed from, uint256 value);
44 	
45 	/* This notifies clients about the amount frozen */
46     event Freeze(address indexed from, uint256 value);
47 	
48 	/* This notifies clients about the amount unfrozen */
49     event Unfreeze(address indexed from, uint256 value);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC20 Token, with the addition of symbol, name and decimals and assisted
95 // token transfers
96 // ----------------------------------------------------------------------------
97 contract WealthChainToken is ERC20Interface, Owned, SafeMath {
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102     
103     
104     mapping (address => bool) public frozenAccount;
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107     
108     event FrozenFunds(address target, bool frozen);
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     function WealthChainToken() public {
115         symbol = "WCT";
116         name = "Wealth Chain Token";
117         decimals = 18;
118         _totalSupply = 200000000000000000000000000;
119         balances[0x6CC1d11751Efa9402Ed417696a134D1534272c91] = _totalSupply;
120         Transfer(address(0), 0x6CC1d11751Efa9402Ed417696a134D1534272c91, _totalSupply);
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply  - balances[address(0)];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139     function freezeAccount(address target, bool freeze) onlyOwner {
140         frozenAccount[target] = freeze;
141         emit FrozenFunds(target, freeze);
142     }
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to to account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         require(!frozenAccount[msg.sender]);
151         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         Transfer(msg.sender, to, tokens);
154         return true;
155     }
156     
157     function burn(uint256 _value) returns (bool success) {
158         if (balances[msg.sender] < _value) throw; 
159 		if (_value <= 0) throw; 
160         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value); 
161         _totalSupply = SafeMath.safeSub(_totalSupply,_value);  
162         Burn(msg.sender, _value);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces 
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Transfer tokens from the from account to the to account
184     // 
185     // The calling account must already have sufficient tokens approve(...)-d
186     // for spending from the from account and
187     // - From account must have sufficient balance to transfer
188     // - Spender must have sufficient allowance to transfer
189     // - 0 value transfers are allowed
190     // ------------------------------------------------------------------------
191     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192         balances[from] = safeSub(balances[from], tokens);
193         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
194         balances[to] = safeAdd(balances[to], tokens);
195         Transfer(from, to, tokens);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Returns the amount of tokens approved by the owner that can be
202     // transferred to the spender's account
203     // ------------------------------------------------------------------------
204     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
205         return allowed[tokenOwner][spender];
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Token owner can approve for spender to transferFrom(...) tokens
211     // from the token owner's account. The spender contract function
212     // receiveApproval(...) is then executed
213     // ------------------------------------------------------------------------
214     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         Approval(msg.sender, spender, tokens);
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
218         return true;
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Don't accept ETH
224     // ------------------------------------------------------------------------
225     function () public payable {
226         revert();
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return ERC20Interface(tokenAddress).transfer(owner, tokens);
235     }
236 }