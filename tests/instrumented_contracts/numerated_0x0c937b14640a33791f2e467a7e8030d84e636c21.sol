1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'BMX' 'BitMaxSH Token' contract
5 //
6 // Symbol      : BMSH
7 // Name        : BitMaxSH Token
8 // Total supply: 10,000,000
9 // Decimals    : 2
10 //
11 // (c) Stefan Nagies / BitMaxPro 2019. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // BitMaxPro ERC20 Token, with the addition of symbol, name and decimals
97 // ----------------------------------------------------------------------------
98 contract BitMaxSHToken is ERC20Interface, Owned {
99     using SafeMath for uint;
100 
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     constructor() public {
114         symbol = "BMSH";
115         name = "BitMaxSH Token";
116         decimals = 2;
117         _totalSupply = 10000000 * 10**uint(decimals);
118         balances[owner] = _totalSupply;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public view returns (uint) {
127         return _totalSupply.sub(balances[address(0)]);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public view returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = balances[msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for `spender` to transferFrom(...) `tokens`
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces 
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         balances[from] = balances[from].sub(tokens);
178         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Token owner can approve for `spender` to transferFrom(...) `tokens`
196     // from the token owner's account. The `spender` contract function
197     // `receiveApproval(...)` is then executed
198     // ------------------------------------------------------------------------
199     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
200         allowed[msg.sender][spender] = tokens;
201         emit Approval(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Don't accept ETH
209     // ------------------------------------------------------------------------
210     function () public payable {
211         revert();
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Owner can transfer out any accidentally sent ERC20 tokens
217     // ------------------------------------------------------------------------
218     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 }