1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'deflat' token contract
5 //
6 // Deployed to : 0x4d717d48BB24Af867B5efC91b282264Aae83cFa6
7 // Symbol      : DEFT
8 // Name        : DEFLAT Coin
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 //
13 // (c) DEFLAT Invest Devs - MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 contract SafeMath {
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function safeMul(uint a, uint b) public pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function safeDiv(uint a, uint b) public pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
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
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     constructor() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract deflatCoin is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
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
116         symbol = "DEFT";
117         name = "DEFLAT Coin";
118         decimals = 18;
119         _totalSupply = 1000000000*(10**18);
120         if (mainNet) {
121           balances[0x4d717d48BB24Af867B5efC91b282264Aae83cFa6] = _totalSupply;
122           emit Transfer(address(0), 0x4d717d48BB24Af867B5efC91b282264Aae83cFa6, _totalSupply);
123         } else {
124           balances[0x9522b4A0a36470E7D8cAe732b6e5BCC5944875cF] = _totalSupply; // ropsten
125           emit Transfer(address(0), 0x9522b4A0a36470E7D8cAe732b6e5BCC5944875cF, _totalSupply); //ropsten
126         }
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply  - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 	
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to to account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
154         balances[to] = safeAdd(balances[to], tokens);
155         emit Transfer(msg.sender, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Token owner can approve for spender to transferFrom(...) tokens
162     // from the token owner's account
163     //
164     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
165     // recommends that there are no checks for the approval double-spend attack
166     // as this should be implemented in user interfaces 
167     // ------------------------------------------------------------------------
168     function approve(address spender, uint tokens) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer tokens from the from account to the to account
177     // 
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the from account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
185         balances[from] = safeSub(balances[from], tokens);
186         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
187         balances[to] = safeAdd(balances[to], tokens);
188         emit Transfer(from, to, tokens);	
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for spender to transferFrom(...) tokens
204     // from the token owner's account. The spender contract function
205     // receiveApproval(...) is then executed
206     // ------------------------------------------------------------------------
207     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         emit Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Don't accept ETH
217     // ------------------------------------------------------------------------
218     function () public payable {
219         revert();
220     }
221 
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }