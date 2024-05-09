1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'EthimalFounderEggs' Founder Egg Sale Contract
5 // Deployed to : 0x1524Ee9e34bF12d58C7A15578cE0efD4D5A7f11E
6 // Symbol      : EGG
7 // Name        : EthimalFounderEggs Token
8 // Total supply: 100k
9 // Decimals    : 18
10 // (c) Author James Konkler. ETHimals. The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Safe math
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract EthimalFounderEggs is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100     uint public startDate;
101     uint public endDate;
102     uint256 public constant promoLimit = 2500;
103     uint256 public constant founderEggSupply = 100000000000000000000000; //100k founder egg limit
104     uint256 public promoCreated;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function EthimalFounderEggs() public {
114         symbol = "EGG";
115         name = "Ethimal Founder Egg";
116         decimals = 18;
117         startDate = now;
118         endDate = now + 20 weeks;
119 
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
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
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(msg.sender, to, tokens);
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
162         Approval(msg.sender, spender, tokens);
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
177         balances[from] = safeSub(balances[from], tokens);
178         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
179         balances[to] = safeAdd(balances[to], tokens);
180         Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
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
201         Approval(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
203         return true;
204     }
205 
206     // ------------------------------------------------------------------------
207     // 50 EGG 'Ethimal Founder Eggs' per 1 ETH
208     // ------------------------------------------------------------------------
209     function () public payable {
210         require(now >= startDate && now <= endDate);
211         require(_totalSupply < founderEggSupply); //Limit of 100k founder eggs to be sold
212         uint tokens;
213         tokens = msg.value * 50;
214         require(tokens + _totalSupply < founderEggSupply);
215         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
216         _totalSupply = safeAdd(_totalSupply, tokens);
217         Transfer(address(0), msg.sender, tokens);
218         owner.transfer(msg.value);
219     }
220 
221     // ------------------------------------------------------------------------
222     // Create 2500 Promo Eggs - Can only be called once.
223     // ------------------------------------------------------------------------
224     function createPromoEggs() onlyOwner returns (bool success) {
225       require(promoCreated < promoLimit);
226       balances[msg.sender] = safeAdd(balances[msg.sender], 2500000000000000000000);
227       _totalSupply = safeAdd(_totalSupply, 2500000000000000000000);
228       promoCreated = 2500;
229   }
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
235         return ERC20Interface(tokenAddress).transfer(owner, tokens);
236     }
237 }