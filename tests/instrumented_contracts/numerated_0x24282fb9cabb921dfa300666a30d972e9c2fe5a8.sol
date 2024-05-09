1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Identity Fund token
5 //
6 // Owner                : 0xdDbAdB75818f42C85AE7FB7355aEB9Bb91d664f9
7 // Contract name        : IdentityFundToken
8 // Symbol               : IDF
9 // Name                 : Identity Fund
10 // Decimals             : 18
11 // Max supply           : 100,000,000 // 100000000000000000000000000
12 // Tokens per 1 ETH     : 300
13 //
14 //
15 // (c) Identity Fund. The MIT Licence.
16 // ----------------------------------------------------------------------------
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     function Owned() public {
68         owner = 0xdDbAdB75818f42C85AE7FB7355aEB9Bb91d664f9;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79     function acceptOwnership() public {
80         require(msg.sender == newOwner);
81         OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and assisted
90 // token transfers
91 // ----------------------------------------------------------------------------
92 contract IdentityFundToken is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint256 public maxSupply;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function IdentityFundToken() public {
107         symbol = "IDF";
108         name = "Identity Fund";
109         decimals = 18;
110         maxSupply = 100000000000000000000000000; 
111 
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply;
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer the balance from token owner's account to `to` account
133     // - Owner's account must have sufficient balance to transfer
134     // - 0 value transfers are allowed
135     // ------------------------------------------------------------------------
136     function transfer(address to, uint tokens) public returns (bool success) {
137 
138         require(tokens <= balances[msg.sender]);
139         require(to != address(0));
140 
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for `spender` to transferFrom(...) `tokens`
150     // from the token owner's account
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces
155     // ------------------------------------------------------------------------
156     function approve(address spender, uint tokens) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         Approval(msg.sender, spender, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer `tokens` from the `from` account to the `to` account
165     //
166     // The calling account must already have sufficient tokens approve(...)-d
167     // for spending from the `from` account and
168     // - From account must have sufficient balance to transfer
169     // - Spender must have sufficient allowance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
173         balances[from] = safeSub(balances[from], tokens);
174         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         Transfer(from, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186         return allowed[tokenOwner][spender];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // 300 IDF Tokens per 1 ETH
192     // ------------------------------------------------------------------------
193     function () public payable {
194 
195         uint tokens;
196 
197         //token price
198         tokens = msg.value * 300;
199 
200         // maxSupply check
201         require(safeAdd(_totalSupply, tokens) < maxSupply);
202 
203         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
204         _totalSupply = safeAdd(_totalSupply, tokens);
205         Transfer(address(0), msg.sender, tokens);
206         owner.transfer(msg.value);
207     }
208 
209     function emitToSomeone(address to, uint256 tokens) public payable {
210 
211         require(to != address(0));
212 
213         require(msg.sender == owner);
214         // maxSupply check
215         require(safeAdd(_totalSupply, tokens) < maxSupply);
216 
217         if (msg.sender == owner) {
218             balances[to] = safeAdd(balances[to], tokens);
219             _totalSupply = safeAdd(_totalSupply, tokens);
220             Transfer(address(0), to, tokens);
221         }
222 
223     }
224 
225 
226     // ------------------------------------------------------------------------
227     // Owner can transfer out any accidentally sent ERC20 tokens
228     // ------------------------------------------------------------------------
229     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230         return ERC20Interface(tokenAddress).transfer(owner, tokens);
231     }
232 }