1 pragma solidity >=0.4.22 <0.6.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : FIXED
7 // Name        : Example Fixed Supply Token
8 // Total supply: 1,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public view returns (uint);
46     function balanceOf(address tokenOwner) public view returns (uint balance);
47     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 //contract ApproveAndCallFallBack {
63 //    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public {
64 //        
65 //    }
66 //}
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and a
101 // fixed supply
102 // ----------------------------------------------------------------------------
103 contract FixedSupplyToken is ERC20Interface, Owned {
104     using SafeMath for uint;
105 
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint _totalSupply;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor() public {
119         symbol = "ECn";
120         name = "E-coin";
121         decimals = 18;
122         _totalSupply = 30000000000 * 10**uint(decimals);
123         balances[owner] = _totalSupply;
124         emit Transfer(address(0), owner, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public view returns (uint) {
132         return _totalSupply.sub(balances[address(0)]);
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public view returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = balances[msg.sender].sub(tokens);
151         balances[to] = balances[to].add(tokens);
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
182         balances[from] = balances[from].sub(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         balances[to] = balances[to].add(tokens);
185         emit Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account. The `spender` contract function
202     // `receiveApproval(...)` is then executed
203     // ------------------------------------------------------------------------
204 //    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
205 //        allowed[msg.sender][spender] = tokens;
206 //        emit Approval(msg.sender, spender, tokens);
207 //        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
208 //        return true;
209 //    }
210 
211 
212     // ------------------------------------------------------------------------
213     // Don't accept ETH
214     // ------------------------------------------------------------------------
215     function() external payable {
216         revert();
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
224         return ERC20Interface(tokenAddress).transfer(owner, tokens);
225     }
226 }