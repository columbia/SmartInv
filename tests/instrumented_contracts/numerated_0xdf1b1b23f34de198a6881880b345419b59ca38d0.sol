1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
5 // ----------------------------------------------------------------------------
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 contract SafeMath {
12     function safeAdd(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // ERC Token Standard #20 Interface
33 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
34 // ----------------------------------------------------------------------------
35 contract ERC20Interface {
36     function totalSupply() public constant returns (uint);
37     function balanceOf(address tokenOwner) public constant returns (uint balance);
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Contract function to receive approval and execute function in one call
50 //
51 // Borrowed from MiniMeToken
52 // ----------------------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
68         owner = 0xD4b3c627364b9567C449d0E42979613881faaCc8;
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
92 contract ANY is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97     uint public startDate;
98     uint public bonusEnds;
99     uint public endDate;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     function ANY() public {
109         symbol = "ANY";
110         name = "Autonomy";
111         decimals = 8;
112         bonusEnds = now + 13 weeks;
113         endDate = now + 49 weeks;
114 
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account `tokenOwner`
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for `spender` to transferFrom(...) `tokens`
149     // from the token owner's account
150     //
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Transfer `tokens` from the `from` account to the `to` account
164     //
165     // The calling account must already have sufficient tokens approve(...)-d
166     // for spending from the `from` account and
167     // - From account must have sufficient balance to transfer
168     // - Spender must have sufficient allowance to transfer
169     // - 0 value transfers are allowed
170     // ------------------------------------------------------------------------
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = safeSub(balances[from], tokens);
173         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175         Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Token owner can approve for `spender` to transferFrom(...) `tokens`
191     // from the token owner's account. The `spender` contract function
192     // `receiveApproval(...)` is then executed
193     // ------------------------------------------------------------------------
194     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         Approval(msg.sender, spender, tokens);
197         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198         return true;
199     }
200 
201     // ------------------------------------------------------------------------
202     // 100 ICO Tokens per 1 ETH w/ 8 Decimals
203     // ------------------------------------------------------------------------
204     function () public payable {
205         require(now >= startDate && now <= endDate);
206         uint tokens;
207         if (now <= bonusEnds) {
208             tokens = msg.value * 150 / 10000000000;
209         } else {
210             tokens = msg.value * 100 / 10000000000;
211         }
212         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
213         _totalSupply = safeAdd(_totalSupply, tokens);
214         Transfer(address(0), msg.sender, tokens);
215         owner.transfer(msg.value);
216     }
217 
218 
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
224         return ERC20Interface(tokenAddress).transfer(owner, tokens);
225     }
226 }