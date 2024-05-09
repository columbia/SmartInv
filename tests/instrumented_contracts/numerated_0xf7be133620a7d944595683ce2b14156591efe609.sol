1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'AGAINST' token contract
5 //
6 // Symbol      : AGAINST
7 // Name        : AGAINST Coin
8 // Description : Fully Decentralized Currency
9 // Total supply: 1000000000000
10 // Decimals    : 18
11 //
12 // (c) AGAINST Devs - MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         emit OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract againstCoin is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     string public description;
104     uint8 public decimals;
105     uint public _totalSupply;
106     bool mainNet = true;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;	
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         symbol = "AGAINST";
117         name = "AGAINST Coin";
118         description = "Fully Decentralized Currency";
119         decimals = 18;
120         _totalSupply = 1000000000000*(10**18);
121         if (mainNet) {
122           balances[0x4d717d48BB24Af867B5efC91b282264Aae83cFa6] = _totalSupply;
123           emit Transfer(address(0), 0x4d717d48BB24Af867B5efC91b282264Aae83cFa6, _totalSupply);
124         } else {
125           balances[0x9522b4A0a36470E7D8cAe732b6e5BCC5944875cF] = _totalSupply; // ropsten
126           emit Transfer(address(0), 0x9522b4A0a36470E7D8cAe732b6e5BCC5944875cF, _totalSupply); //ropsten
127         }
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public constant returns (uint) {
135         return _totalSupply  - balances[address(0)];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account tokenOwner
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 	
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to to account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         emit Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for spender to transferFrom(...) tokens
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces 
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer tokens from the from account to the to account
178     // 
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the from account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = safeSub(balances[from], tokens);
187         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
188         balances[to] = safeAdd(balances[to], tokens);
189         emit Transfer(from, to, tokens);	
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for spender to transferFrom(...) tokens
205     // from the token owner's account. The spender contract function
206     // receiveApproval(...) is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         emit Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Don't accept ETH
218     // ------------------------------------------------------------------------
219     function () public payable {
220         revert();
221     }
222 
223 
224 
225     // ------------------------------------------------------------------------
226     // Owner can transfer out any accidentally sent ERC20 tokens
227     // ------------------------------------------------------------------------
228     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
229         return ERC20Interface(tokenAddress).transfer(owner, tokens);
230     }
231 }