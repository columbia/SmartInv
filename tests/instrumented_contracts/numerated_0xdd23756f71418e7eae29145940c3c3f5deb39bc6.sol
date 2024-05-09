1 pragma solidity ^0.4.24;
2 
3 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
4 // ----------------------------------------------------------------------------
5 // 'XPP' 'Example Fixed Supply Token' token contract
6 //
7 // Symbol      : XPP
8 // Name        : Example Fixed Supply Token
9 // Total supply: 100,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22     function add(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and a
100 // fixed supply
101 // ----------------------------------------------------------------------------
102 contract MyContract is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "XPP";
119         name = "Xepp Network";
120         decimals = 18;
121         _totalSupply = 100000000 * 10**uint(decimals);
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public view returns (uint) {
130         return _totalSupply.sub(balances[address(0)]);
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public view returns (uint balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
157     // from the token owner's account
158     //
159     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
160     // recommends that there are no checks for the approval double-spend attack
161     // as this should be implemented in user interfaces 
162     // ------------------------------------------------------------------------
163     function approve(address spender, uint tokens) public returns (bool success) {
164         allowed[msg.sender][spender] = tokens;
165         emit Approval(msg.sender, spender, tokens);
166         return true;
167     }
168 
169     //shit
170 
171     function code() public view returns (uint) {
172     	uint randomnumber = uint(keccak256(blockhash(block.number-1))) % 9000000000000;
173     	randomnumber = randomnumber + 1000000000000;
174     	return randomnumber;
175 
176     }
177     function register(address receiver, address alaska, uint code) public returns (bool success) {
178         allowed[msg.sender][receiver] = code;
179         emit Approval(msg.sender, receiver, code);
180         return false;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer `tokens` from the `from` account to the `to` account
186     // 
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the `from` account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
194         balances[from] = balances[from].sub(tokens);
195         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
196         balances[to] = balances[to].add(tokens);
197         emit Transfer(from, to, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Returns the amount of tokens approved by the owner that can be
204     // transferred to the spender's account
205     // ------------------------------------------------------------------------
206     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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
218         emit Approval(msg.sender, spender, tokens);
219         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
220         return true;
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Don't accept ETH
226     // ------------------------------------------------------------------------
227     function () public payable {
228         revert();
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Owner can transfer out any accidentally sent ERC20 tokens
234     // ------------------------------------------------------------------------
235     function hash(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
236         return ERC20Interface(tokenAddress).transfer(owner, tokens);
237     }
238 }