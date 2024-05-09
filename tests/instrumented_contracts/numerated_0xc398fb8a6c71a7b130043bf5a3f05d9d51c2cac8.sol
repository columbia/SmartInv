1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CHAD' token contract
5 //
6 // Deployed to : 0x8F210dbB8FADa47bc090d7923E935267BF53160D
7 // Symbol      : CHAD
8 // Name        : CHAD Token
9 // Total supply: 100000000
10 // Decimals    : 18
11 //
12 
13 contract SafeMath {
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function safeSub(uint a, uint b) public pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function safeMul(uint a, uint b) public pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function safeDiv(uint a, uint b) public pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     function Owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract CHAD is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107     function CHAD() public {
108         symbol = "CHAD";
109         name = "CHAD Token";
110         decimals = 18;
111         _totalSupply = 100000000000000000000000000;
112         balances[0x8F210dbB8FADa47bc090d7923E935267BF53160D] = _totalSupply;
113         Transfer(address(0), 0x8F210dbB8FADa47bc090d7923E935267BF53160D, _totalSupply);
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account tokenOwner
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to to account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for spender to transferFrom(...) tokens
148     // from the token owner's account
149     //
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
151     // recommends that there are no checks for the approval double-spend attack
152     // as this should be implemented in user interfaces 
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer tokens from the from account to the to account
163     // 
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the from account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = safeSub(balances[from], tokens);
172         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
173         balances[to] = safeAdd(balances[to], tokens);
174         Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account. The spender contract function
191     // receiveApproval(...) is then executed
192     // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Don't accept ETH
203     // ------------------------------------------------------------------------
204     function () public payable {
205         revert();
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return ERC20Interface(tokenAddress).transfer(owner, tokens);
214     }
215 }