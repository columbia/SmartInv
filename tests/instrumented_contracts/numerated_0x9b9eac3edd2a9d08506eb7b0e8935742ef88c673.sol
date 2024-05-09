1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'TPP' CROWDSALE token contract
5 //
6 // Symbol      : TPP
7 // Name        : https://tokenplay.io
8 // Total supply: 100000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract tppToken is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(uint => address) indexes;
106 
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     constructor() public {
114         symbol = "TPP";
115         name = "https://tokenplay.io";
116         decimals = 18;
117         _totalSupply = 100000000000*10**18;
118 
119         balances[owner] = _totalSupply;
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         //return _totalSupply - balances[address(0)];
128         return _totalSupply;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139     function indexOf(uint _index) public constant onlyOwner returns (address) {
140         return indexes[_index];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         emit Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for `spender` to transferFrom(...) `tokens`
159     // from the token owner's account
160     //
161     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162     // recommends that there are no checks for the approval double-spend attack
163     // as this should be implemented in user interfaces
164     // ------------------------------------------------------------------------
165     function approve(address spender, uint tokens) public returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         emit Approval(msg.sender, spender, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Transfer `tokens` from the `from` account to the `to` account
174     //
175     // The calling account must already have sufficient tokens approve(...)-d
176     // for spending from the `from` account and
177     // - From account must have sufficient balance to transfer
178     // - Spender must have sufficient allowance to transfer
179     // - 0 value transfers are allowed
180     // ------------------------------------------------------------------------
181     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
182         balances[from] = safeSub(balances[from], tokens);
183         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
184         balances[to] = safeAdd(balances[to], tokens);
185         emit Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account. The `spender` contract function
202     // `receiveApproval(...)` is then executed
203     // ------------------------------------------------------------------------
204     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
205         allowed[msg.sender][spender] = tokens;
206         emit Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () external payable {
215         revert();
216     }
217 
218     // ------------------------------------------------------------------------
219     // Owner can transfer out any accidentally sent ERC20 tokens
220     // ------------------------------------------------------------------------
221     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
222         return ERC20Interface(tokenAddress).transfer(owner, tokens);
223     }
224 
225     function withdrawBalance() external onlyOwner {
226         owner.transfer(address(this).balance);
227     }
228 }