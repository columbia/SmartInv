1 pragma solidity ^0.4.2;
2 
3 contract DappTokenSale {
4     address admin;
5     DappToken public tokenContract;
6     uint256 public tokenPrice;
7     uint256 public tokensSold;
8 
9     event Sell(address _buyer, uint256 _amount);
10 
11     function DappTokenSale(DappToken _tokenContract, uint256 _tokenPrice) public {
12         admin = msg.sender;
13         tokenContract = _tokenContract;
14         tokenPrice = _tokenPrice;
15     }
16 
17     function multiply(uint x, uint y) internal pure returns (uint z) {
18         require(y == 0 || (z = x * y) / y == x);
19     }
20 
21     function buyTokens(uint256 _numberOfTokens) public payable {
22         require(msg.value == multiply(_numberOfTokens, tokenPrice));
23         require(tokenContract.balanceOf(this) >= _numberOfTokens);
24         require(tokenContract.transfer(msg.sender, _numberOfTokens));
25 
26         tokensSold += _numberOfTokens;
27 
28         Sell(msg.sender, _numberOfTokens);
29     }
30 
31     function endSale() public {
32         require(msg.sender == admin);
33         require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
34 
35         // UPDATE: Let's not destroy the contract here
36         // Just transfer the balance to the admin
37         admin.transfer(address(this).balance);
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Safe maths
44 // ----------------------------------------------------------------------------
45 contract SafeMath {
46     function safeAdd(uint a, uint b) public pure returns (uint c) {
47         c = a + b;
48         require(c >= a);
49     }
50     function safeSub(uint a, uint b) public pure returns (uint c) {
51         require(b <= a);
52         c = a - b;
53     }
54     function safeMul(uint a, uint b) public pure returns (uint c) {
55         c = a * b;
56         require(a == 0 || c / a == b);
57     }
58     function safeDiv(uint a, uint b) public pure returns (uint c) {
59         require(b > 0);
60         c = a / b;
61     }
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // ERC Token Standard #20 Interface
67 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
68 // ----------------------------------------------------------------------------
69 contract ERC20Interface {
70     function totalSupply() public constant returns (uint);
71     function balanceOf(address tokenOwner) public constant returns (uint balance);
72     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
73     function transfer(address to, uint tokens) public returns (bool success);
74     function approve(address spender, uint tokens) public returns (bool success);
75     function transferFrom(address from, address to, uint tokens) public returns (bool success);
76 
77     event Transfer(address indexed from, address indexed to, uint tokens);
78     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // Contract function to receive approval and execute function in one call
84 //
85 // Borrowed from MiniMeToken
86 // ----------------------------------------------------------------------------
87 contract ApproveAndCallFallBack {
88     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // Owned contract
94 // ----------------------------------------------------------------------------
95 contract Owned {
96     address public owner;
97     address public newOwner;
98 
99     event OwnershipTransferred(address indexed _from, address indexed _to);
100 
101     function Owned() public {
102         owner = msg.sender;
103     }
104 
105     modifier onlyOwner {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     function transferOwnership(address _newOwner) public onlyOwner {
111         newOwner = _newOwner;
112     }
113     function acceptOwnership() public {
114         require(msg.sender == newOwner);
115         OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117         newOwner = address(0);
118     }
119 }
120 
121 
122 // ----------------------------------------------------------------------------
123 // ERC20 Token, with the addition of symbol, name and decimals and assisted
124 // token transfers
125 // ----------------------------------------------------------------------------
126 contract DappToken is ERC20Interface, Owned, SafeMath {
127     string public symbol;
128     string public  name;
129     uint8 public decimals;
130     uint public _totalSupply;
131 
132     mapping(address => uint) balances;
133     mapping(address => mapping(address => uint)) allowed;
134 
135 
136     // ------------------------------------------------------------------------
137     // Constructor
138     // ------------------------------------------------------------------------
139     function DappToken() public {
140         symbol = "PLTS";
141         name = "Ploutos";
142         decimals = 18;
143         _totalSupply = 200000000000000000000000000;
144         balances[0x2Eee02ceedc1b93055CBA6637af0B3fD93c5d973] = _totalSupply;
145         Transfer(address(0), 0x2Eee02ceedc1b93055CBA6637af0B3fD93c5d973, _totalSupply);
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply  - balances[address(0)];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account tokenOwner
159     // ------------------------------------------------------------------------
160     function balanceOf(address tokenOwner) public constant returns (uint balance) {
161         return balances[tokenOwner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to to account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint tokens) public returns (bool success) {
171         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(msg.sender, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for spender to transferFrom(...) tokens
180     // from the token owner's account
181     //
182     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
183     // recommends that there are no checks for the approval double-spend attack
184     // as this should be implemented in user interfaces 
185     // ------------------------------------------------------------------------
186     function approve(address spender, uint tokens) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         Approval(msg.sender, spender, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Transfer tokens from the from account to the to account
195     // 
196     // The calling account must already have sufficient tokens approve(...)-d
197     // for spending from the from account and
198     // - From account must have sufficient balance to transfer
199     // - Spender must have sufficient allowance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
203         balances[from] = safeSub(balances[from], tokens);
204         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
205         balances[to] = safeAdd(balances[to], tokens);
206         Transfer(from, to, tokens);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Returns the amount of tokens approved by the owner that can be
213     // transferred to the spender's account
214     // ------------------------------------------------------------------------
215     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
216         return allowed[tokenOwner][spender];
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Token owner can approve for spender to transferFrom(...) tokens
222     // from the token owner's account. The spender contract function
223     // receiveApproval(...) is then executed
224     // ------------------------------------------------------------------------
225     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
226         allowed[msg.sender][spender] = tokens;
227         Approval(msg.sender, spender, tokens);
228         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
229         return true;
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Don't accept ETH
235     // ------------------------------------------------------------------------
236     function () public payable {
237         revert();
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Owner can transfer out any accidentally sent ERC20 tokens
243     // ------------------------------------------------------------------------
244     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
245         return ERC20Interface(tokenAddress).transfer(owner, tokens);
246     }
247 }