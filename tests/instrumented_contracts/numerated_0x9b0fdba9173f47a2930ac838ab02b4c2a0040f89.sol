1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'WTT' 'WinTech Token' token contract
5 //
6 // Symbol       : WTT
7 // Name         : WinTech Token
8 // Total supply : 100,000,000.000000000000000000
9 // Decimals     : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC20 Token, with the addition of symbol, name and decimals and an
56 // initial fixed supply
57 // ----------------------------------------------------------------------------
58 contract WTToken is ERC20Interface {
59     using SafeMath for uint;
60 
61     struct UnlockRule {
62         uint time;
63         uint balance;
64     }
65 
66     string constant public symbol  = "WTT";
67     string constant public name    = "WinTech Token";
68     uint8 constant public decimals = 18;
69     uint _totalSupply              = 100000000e18;
70 
71     address crowdSale              = 0x6F76f25ac0D1fCc611dC605E85e57C5516480BD9;
72     address founder                = 0x316461dC8aFBFd31c4a11B7e0f1C7D26b8f8160f;
73     address team                   = 0xF204b3934d972DfcA1a5Bf990A9650d71008E28d;
74     address platform               = 0x66111e6338A5C06568325F845f4030e673f5aF88;
75 
76     uint constant crowdSaleTokens  = 48000000e18; // 48%
77     uint constant founderTokens    = 22000000e18; // 22%
78     uint constant teamTokens       = 18000000e18; // 18%
79     uint constant platformTokens   = 12000000e18; // 12%
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping(address => uint)) allowed;
83 
84     //  18000000e18 : 1571356800 - 2019-10-18 00:00:00 GMT+00:00
85     //  13500000e18 : 1602979200 - 2020-10-18 00:00:00 GMT+00:00
86     //   9000000e18 : 1634515200 - 2021-10-18 00:00:00 GMT+00:00
87     //   4500000e18 : 1666051200 - 2022-10-18 00:00:00 GMT+00:00
88     mapping(uint    => UnlockRule) public unlockRule;
89 
90 
91     // ------------------------------------------------------------------------
92     // Constructor
93     // ------------------------------------------------------------------------
94     constructor(uint time1, uint time2, uint time3, uint time4, uint bal1, uint bal2, uint bal3, uint bal4) public {
95 
96         unlockRule[1] = UnlockRule(time1, bal1);
97         unlockRule[2] = UnlockRule(time2, bal2);
98         unlockRule[3] = UnlockRule(time3, bal3);
99         unlockRule[4] = UnlockRule(time4, bal4);
100 
101         preSale(crowdSale, crowdSaleTokens);
102         preSale(founder,   founderTokens);
103         preSale(team,      teamTokens);
104         preSale(platform,  platformTokens);
105     }
106 
107 
108     function preSale(address _address, uint _amount) internal returns (bool) {
109         balances[_address] = _amount;
110         emit Transfer(address(0x0), _address, _amount);
111     }
112 
113 
114     function transferPermissions(address spender, uint tokens) internal constant returns (bool) {
115 
116         if (spender == team) {
117             uint bal = balances[team].sub(tokens);
118             if (bal < minimumBalance()) {
119                 return false;
120             }
121         }
122 
123         return true;
124     }
125 
126 
127     function minimumBalance() public view returns (uint) {
128         for (uint i = 1; i <= 4; ++i) {
129             if (now < unlockRule[i].time) {
130                 return unlockRule[i].balance;
131             }
132         }
133 
134         return 0;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Total supply
140     // ------------------------------------------------------------------------
141     function totalSupply() public constant returns (uint) {
142         return _totalSupply;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Get the token balance for account `tokenOwner`
148     // ------------------------------------------------------------------------
149     function balanceOf(address tokenOwner) public constant returns (uint balance) {
150         return balances[tokenOwner];
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer the balance from token owner's account to `to` account
156     // - Owner's account must have sufficient balance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transfer(address to, uint tokens) public returns (bool success) {
160         require(transferPermissions(msg.sender, tokens), "Lock Rule");
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to]         = balances[to].add(tokens);
163         emit Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for `spender` to transferFrom(...) `tokens`
170     // from the token owner's account
171     //
172     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
173     // recommends that there are no checks for the approval double-spend attack
174     // as this should be implemented in user interfaces
175     // ------------------------------------------------------------------------
176     function approve(address spender, uint tokens) public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178         emit Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer `tokens` from the `from` account to the `to` account
185     //
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the `from` account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // - 0 value transfers are allowed
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
193         require(transferPermissions(from, tokens), "Lock Rule");
194         balances[from]            = balances[from].sub(tokens);
195         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
196         balances[to]              = balances[to].add(tokens);
197         emit Transfer(from, to, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Returns the amount of tokens approved by the owner that can be
204     // transferred to the spender's account
205     // ------------------------------------------------------------------------
206     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
207         return allowed[tokenOwner][spender];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () public payable {
215         revert();
216     }
217 }