1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Mining Capital Coin ERC-20 Token
6 //
7 // Symbol      : CPTL
8 // Name        : Capital Coin
9 // Total supply: 5,000,000,000.000000000000000000
10 // Decimals    : 8
11 //
12 //
13 // (c) 2020 - Mininng Capital Coin <contact@miningcapitalcoin.com>.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe math helper library
19 // ----------------------------------------------------------------------------
20 library SafeMath 
21 {
22     
23     function add(uint a, uint b) internal pure returns (uint c) 
24     {
25         c = a + b;
26         require(c >= a);
27     }
28     
29     function sub(uint a, uint b) internal pure returns (uint c) 
30     {
31         require(b <= a);
32         c = a - b;
33     }
34     
35     function mul(uint a, uint b) internal pure returns (uint c) 
36     {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     
41     function div(uint a, uint b) internal pure returns (uint c) 
42     {
43         require(b > 0);
44         c = a / b;
45     }
46     
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
53 // ----------------------------------------------------------------------------
54 contract ERC20Interface 
55 {
56     
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66     
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // Contract function to receive approval and execute function in one call
72 //
73 // Borrowed from MiniMeToken
74 // ----------------------------------------------------------------------------
75 contract ApproveAndCallFallBack 
76 {
77     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned 
85 {
86     
87     address public owner;
88     address public newOwner;
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92     function Owned() public 
93     {
94         owner = msg.sender;
95     }
96 
97     modifier onlyOwner 
98     {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     function transferOwnership(address _newOwner) public onlyOwner 
104     {
105         newOwner = _newOwner;
106     }
107     
108     function acceptOwnership() public 
109     {
110         require(msg.sender == newOwner);
111         OwnershipTransferred(owner, newOwner);
112         owner = newOwner;
113         newOwner = address(0);
114     }
115     
116 }
117 
118 
119 // ----------------------------------------------------------------------------
120 // CPTL Classic ERC20 Token, with the addition of symbol, name and decimals and an
121 // initial fixed supply
122 // ----------------------------------------------------------------------------
123 contract CapitalCoin is ERC20Interface, Owned 
124 {
125     
126     using SafeMath for uint;
127 
128     string public symbol;
129     string public  name;
130     uint8 public decimals;
131     uint public _totalSupply;
132 
133     mapping(address => uint) balances;
134     mapping(address => mapping(address => uint)) allowed;
135 
136 
137     // ------------------------------------------------------------------------
138     // Constructor
139     // ------------------------------------------------------------------------
140     function CapitalCoin() public 
141     {
142         symbol = "CPTL";
143         name = "Capital Coin";
144         decimals = 8;
145         _totalSupply = 5000000000 * 10**uint(decimals);
146         balances[owner] = _totalSupply;
147         Transfer(address(0), owner, _totalSupply);
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Total supply
153     // ------------------------------------------------------------------------
154     function totalSupply() public constant returns (uint) 
155     {
156         return _totalSupply  - balances[address(0)];
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account `tokenOwner`
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public constant returns (uint balance) 
164     {
165         return balances[tokenOwner];
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer the balance from token owner's account to `to` account
171     // - Owner's account must have sufficient balance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transfer(address to, uint tokens) public returns (bool success) 
175     {
176         balances[msg.sender] = balances[msg.sender].sub(tokens);
177         balances[to] = balances[to].add(tokens);
178         Transfer(msg.sender, to, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Token owner can approve for `spender` to transferFrom(...) `tokens`
185     // from the token owner's account
186     //
187     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
188     // recommends that there are no checks for the approval double-spend attack
189     // as this should be implemented in user interfaces 
190     // ------------------------------------------------------------------------
191     function approve(address spender, uint tokens) public returns (bool success) 
192     {
193         allowed[msg.sender][spender] = tokens;
194         Approval(msg.sender, spender, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Transfer `tokens` from the `from` account to the `to` account
201     // 
202     // The calling account must already have sufficient tokens approve(...)-d
203     // for spending from the `from` account and
204     // - From account must have sufficient balance to transfer
205     // - Spender must have sufficient allowance to transfer
206     // - 0 value transfers are allowed
207     // ------------------------------------------------------------------------
208     function transferFrom(address from, address to, uint tokens) public returns (bool success) 
209     {
210         balances[from] = balances[from].sub(tokens);
211         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
212         balances[to] = balances[to].add(tokens);
213         Transfer(from, to, tokens);
214         return true;
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Returns the amount of tokens approved by the owner that can be
220     // transferred to the spender's account
221     // ------------------------------------------------------------------------
222     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) 
223     {
224         return allowed[tokenOwner][spender];
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Token owner can approve for `spender` to transferFrom(...) `tokens`
230     // from the token owner's account. The `spender` contract function
231     // `receiveApproval(...)` is then executed
232     // ------------------------------------------------------------------------
233     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) 
234     {
235         allowed[msg.sender][spender] = tokens;
236         Approval(msg.sender, spender, tokens);
237         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
238         return true;
239     }
240 
241 
242     // ------------------------------------------------------------------------
243     // Don't accept ETH
244     // ------------------------------------------------------------------------
245     function () public payable
246     {
247         revert();
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Owner can transfer out any accidentally sent ERC20 tokens
253     // ------------------------------------------------------------------------
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) 
255     {
256         return ERC20Interface(tokenAddress).transfer(owner, tokens);
257     }
258     
259 }