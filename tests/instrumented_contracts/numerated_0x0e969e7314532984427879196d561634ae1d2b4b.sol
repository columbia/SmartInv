1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'WEONECOIN' token contract
5 //
6 // Deployed to : 0xC65005DCdB2ca7dFBD1c927d20dCAeaaF827C894
7 // Symbol      : WEONECOIN
8 // Name        : WeOneCoin Token
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // ERC Token Standard #20 Interface
66 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67 // ----------------------------------------------------------------------------
68 contract ERC20Interface {
69     function totalSupply() public constant returns (uint256);
70     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
71     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
72     function transfer(address to, uint256 tokens) public returns (bool success);
73     function approve(address spender, uint256 tokens) public returns (bool success);
74     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
75 
76     event Transfer(address indexed from, address indexed to, uint256 tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Contract function to receive approval and execute function in one call
83 //
84 // ----------------------------------------------------------------------------
85 contract ApproveAndCallFallBack {
86     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // Owned contract
92 // ----------------------------------------------------------------------------
93 contract Owned {
94     address public owner;
95     address public newOwner;
96 
97     event OwnershipTransferred(address indexed _from, address indexed _to);
98 
99     constructor() public {
100         owner = msg.sender;
101     }
102 
103     modifier onlyOwner {
104         require(msg.sender == owner);
105         _;
106     }
107 
108     function transferOwnership(address _newOwner) public onlyOwner {
109         newOwner = _newOwner;
110     }
111     function acceptOwnership() public {
112         require(msg.sender == newOwner);
113         emit OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115         newOwner = address(0);
116     }
117 }
118 
119 
120 // ----------------------------------------------------------------------------
121 // ERC20 Token, with the addition of symbol, name and decimals and assisted
122 // token transfers
123 // ----------------------------------------------------------------------------
124 contract WeOneCoinERC20Token is ERC20Interface, Owned, SafeMath {
125     string public symbol;
126     string public  name;
127     uint8 public decimals;
128     uint256 public _totalSupply;
129 
130     mapping(address => uint256) balances;
131     mapping(address => mapping(address => uint256)) allowed;
132 
133 
134     // ------------------------------------------------------------------------
135     // Constructor
136     // ------------------------------------------------------------------------
137     constructor() public {
138         symbol = "WEONECOIN";
139         name = "WeOneCoin Token";
140         decimals = 18;
141         _totalSupply = 1000000000000000000000000000;
142         balances[0xC65005DCdB2ca7dFBD1c927d20dCAeaaF827C894] = _totalSupply;
143         emit Transfer(address(0), 0xC65005DCdB2ca7dFBD1c927d20dCAeaaF827C894, _totalSupply);
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Total supply
149     // ------------------------------------------------------------------------
150     function totalSupply() public constant returns (uint256) {
151         return _totalSupply  - balances[address(0)];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Get the token balance for account tokenOwner
157     // ------------------------------------------------------------------------
158     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
159         return balances[tokenOwner];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer the balance from token owner's account to to account
165     // - Owner's account must have sufficient balance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transfer(address to, uint256 tokens) public returns (bool success) {
169         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         emit Transfer(msg.sender, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for spender to transferFrom(...) tokens
178     // from the token owner's account
179     //
180     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
181     // recommends that there are no checks for the approval double-spend attack
182     // as this should be implemented in user interfaces 
183     // ------------------------------------------------------------------------
184     function approve(address spender, uint256 tokens) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Transfer tokens from the from account to the to account
193     // 
194     // The calling account must already have sufficient tokens approve(...)-d
195     // for spending from the from account and
196     // - From account must have sufficient balance to transfer
197     // - Spender must have sufficient allowance to transfer
198     // - 0 value transfers are allowed
199     // ------------------------------------------------------------------------
200     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
201         balances[from] = safeSub(balances[from], tokens);
202         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
203         balances[to] = safeAdd(balances[to], tokens);
204         emit Transfer(from, to, tokens);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Returns the amount of tokens approved by the owner that can be
211     // transferred to the spender's account
212     // ------------------------------------------------------------------------
213     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
214         return allowed[tokenOwner][spender];
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Token owner can approve for spender to transferFrom(...) tokens
220     // from the token owner's account. The spender contract function
221     // receiveApproval(...) is then executed
222     // ------------------------------------------------------------------------
223     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
224         allowed[msg.sender][spender] = tokens;
225         emit Approval(msg.sender, spender, tokens);
226         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
227         return true;
228     }
229 
230     // ------------------------------------------------------------------------
231     // can accept ether
232     // ------------------------------------------------------------------------
233     function () public payable {
234     }
235 
236 
237     // ------------------------------------------------------------------------
238     // Owner can transfer out any accidentally sent ERC20 tokens
239     // ------------------------------------------------------------------------
240     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
241 	return ERC20Interface(tokenAddress).transfer(owner, tokens);
242     }
243 
244     function setName (string _value) public onlyOwner returns (bool success) {
245 	name = _value;
246         return true;
247     }
248     
249     function setSymbol (string _value) public onlyOwner returns (bool success) {
250         symbol = _value;
251         return true;
252     }
253 
254     function kill() public onlyOwner {
255 	selfdestruct(owner);
256     }
257 	
258 }