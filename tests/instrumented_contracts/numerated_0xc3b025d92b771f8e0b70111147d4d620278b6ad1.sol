1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'UNC' 'Uncloak' token contract
5 // Symbol      : UNC
6 // Name        : Uncloak
7 // Total supply: 4,200,000,000
8 // Decimals    : 18
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC20 Standard Interface
37 // ----------------------------------------------------------------------------
38 contract ERC20 {
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
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
68     function Owned() public {
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
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals
91 // Receives ETH and generates tokens
92 // ----------------------------------------------------------------------------
93 contract Uncloak is ERC20, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function Uncloak() public {
107         symbol = "UNC";
108         name = "Uncloak";
109         decimals = 18;
110         _totalSupply = 4200000000 * 10**uint(decimals);
111         balances[owner] = _totalSupply;
112         Transfer(address(0), owner, _totalSupply);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint) {
120         return _totalSupply;
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         require(to != address(this)); //make sure we're not transfering to this contract
139         
140         //check edge cases
141         if (balances[msg.sender] >= tokens
142             && tokens > 0) {
143         
144                 //update balances
145                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146                 balances[to] = safeAdd(balances[to], tokens);
147                 
148                 //log event
149                 Transfer(msg.sender, to, tokens);
150                 return true;
151         }
152         else {
153             return false;
154         }
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer `tokens` from the `from` account to the `to` account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the `from` account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         require(to != address(this));
180         
181         //check edge cases
182         if (allowed[from][msg.sender] >= tokens
183             && balances[from] >= tokens
184             && tokens > 0) {
185 
186             //update balances and allowances
187             balances[from] = safeSub(balances[from], tokens);
188             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
189             balances[to] = safeAdd(balances[to], tokens);
190             
191             //log event
192             Transfer(from, to, tokens);
193             return true;
194 
195         }
196         else {
197             return false;
198         }
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Returns the amount of tokens approved by the owner that can be
204     // transferred to the spender's account
205     // ------------------------------------------------------------------------
206     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for `spender` to transferFrom(...) `tokens`
213     // from the token owner's account. The `spender` contract function
214     // `receiveApproval(...)` is then executed
215     // ------------------------------------------------------------------------
216     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
217         allowed[msg.sender][spender] = tokens;
218         Approval(msg.sender, spender, tokens);
219         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
220         return true;
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Doesn't Accept Eth
226     // ------------------------------------------------------------------------
227     function () public payable {
228         revert();
229     }
230 }