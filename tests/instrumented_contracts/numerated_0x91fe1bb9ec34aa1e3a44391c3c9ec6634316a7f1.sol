1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------
7 // Safe maths
8 // ----------------------------------------------------------------------------
9 contract SafeMath {
10     function safeAdd(uint a, uint b) internal pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) internal pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) internal pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) internal pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // ERC Token Standard #20 Interface
31 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
32 // ----------------------------------------------------------------------------
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 //
49 // Borrowed from MiniMeToken
50 // ----------------------------------------------------------------------------
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Owned contract
58 // ----------------------------------------------------------------------------
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and assisted
88 // token transfers
89 // ----------------------------------------------------------------------------
90 contract FantomToken is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95     uint public startDate;
96     uint public bonusEnds;
97     uint public endDate;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function FantomToken() public {
107         symbol = "FTM";
108         name = "Fantom Token";
109         decimals = 18;
110 		 _totalSupply = 3175000000000000000000000000;
111         bonusEnds = now + 1 weeks;
112         endDate = now + 7 weeks;    
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     //
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the `from` account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = safeSub(balances[from], tokens);
171         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for `spender` to transferFrom(...) `tokens`
189     // from the token owner's account. The `spender` contract function
190     // `receiveApproval(...)` is then executed
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199   
200     function () public payable {
201         require(now >= startDate && now <= endDate);
202         uint tokens;
203         if (now <= bonusEnds) {
204             tokens = msg.value * 15000;
205         } else {
206             tokens = msg.value * 15000;
207         }
208         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
209         _totalSupply = safeAdd(_totalSupply, tokens);
210         Transfer(address(0), msg.sender, tokens);
211         owner.transfer(msg.value);
212     }
213 
214 
215 
216     // ------------------------------------------------------------------------
217     // Owner can transfer out any accidentally sent ERC20 tokens
218     // ------------------------------------------------------------------------
219     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
220         return ERC20Interface(tokenAddress).transfer(owner, tokens);
221     }
222 }