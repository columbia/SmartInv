1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Mining Capital Coin CPTL Extended ERC-20 Token
6 //
7 // Symbol      : CPTLX
8 // Name        : Capital Coin Extended
9 // Total supply: 50,000,000,000.000000000000000000
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
84 contract Owned {
85     
86     address public owner;
87     address public newOwner;
88 
89     event OwnershipTransferred(address indexed _from, address indexed _to);
90 
91     function Owned() public 
92     {
93         owner = msg.sender;
94     }
95 
96     modifier onlyOwner 
97     {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function transferOwnership(address _newOwner) public onlyOwner 
103     {
104         newOwner = _newOwner;
105     }
106     
107     function acceptOwnership() public 
108     {
109         require(msg.sender == newOwner);
110         OwnershipTransferred(owner, newOwner);
111         owner = newOwner;
112         newOwner = address(0);
113     }
114     
115 }
116 
117 
118 // ----------------------------------------------------------------------------
119 // CPTL Extended ERC20 Token, with the addition of symbol, name and decimals and an
120 // initial fixed supply
121 // ----------------------------------------------------------------------------
122 contract CapitalCoinExtended is ERC20Interface, Owned 
123 {
124     
125     using SafeMath for uint;
126 
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
139     function CapitalCoinExtended() public 
140     {
141         symbol = "CPTLX";
142         name = "Capital Coin Extended";
143         decimals = 8;
144         _totalSupply = 50000000000 * 10**uint(decimals); 
145         balances[owner] = _totalSupply;
146         Transfer(address(0), owner, _totalSupply);
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Total supply
152     // ------------------------------------------------------------------------
153     function totalSupply() public constant returns (uint) 
154     {
155         return _totalSupply - balances[address(0)];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Get the token balance for account `tokenOwner`
161     // ------------------------------------------------------------------------
162     function balanceOf(address tokenOwner) public constant returns (uint balance) 
163     {
164         return balances[tokenOwner];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer the balance from token owner's account to `to` account
170     // - Owner's account must have sufficient balance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transfer(address to, uint tokens) public returns (bool success) 
174     {
175         balances[msg.sender] = balances[msg.sender].sub(tokens);
176         balances[to] = balances[to].add(tokens);
177         Transfer(msg.sender, to, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Token owner can approve for `spender` to transferFrom(...) `tokens`
184     // from the token owner's account
185     //
186     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
187     // recommends that there are no checks for the approval double-spend attack
188     // as this should be implemented in user interfaces 
189     // ------------------------------------------------------------------------
190     function approve(address spender, uint tokens) public returns (bool success) 
191     {
192         allowed[msg.sender][spender] = tokens;
193         Approval(msg.sender, spender, tokens);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Transfer `tokens` from the `from` account to the `to` account
200     // 
201     // The calling account must already have sufficient tokens approve(...)-d
202     // for spending from the `from` account and
203     // - From account must have sufficient balance to transfer
204     // - Spender must have sufficient allowance to transfer
205     // - 0 value transfers are allowed
206     // ------------------------------------------------------------------------
207     function transferFrom(address from, address to, uint tokens) public returns (bool success) 
208     {
209         balances[from] = balances[from].sub(tokens);
210         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
211         balances[to] = balances[to].add(tokens);
212         Transfer(from, to, tokens);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Returns the amount of tokens approved by the owner that can be
219     // transferred to the spender's account
220     // ------------------------------------------------------------------------
221     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) 
222     {
223         return allowed[tokenOwner][spender];
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229     // from the token owner's account. The `spender` contract function
230     // `receiveApproval(...)` is then executed
231     // ------------------------------------------------------------------------
232     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) 
233     {
234         allowed[msg.sender][spender] = tokens;
235         Approval(msg.sender, spender, tokens);
236         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
237         return true;
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Don't accept ETH
243     // ------------------------------------------------------------------------
244     function () public payable
245     {
246         revert();
247     }
248 
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) 
254     {
255         return ERC20Interface(tokenAddress).transfer(owner, tokens);
256     }
257     
258 }