1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title Decentralized Token Fund
5 * @author lanyuhang https://github.com/spacelan/DTF
6 */
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
35 contract ERC20 {
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
48 contract Kyber {
49     function getExpectedRate(
50         ERC20 src, 
51         ERC20 dest, 
52         uint srcQty
53     ) public view returns (uint, uint);
54     function trade(
55         ERC20 src,
56         uint srcAmount,
57         ERC20 dest,
58         address destAddress,
59         uint maxDestAmount,
60         uint minConversionRate,
61         address walletId
62     ) public payable returns(uint);
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
97 // ERC20 Token, with the addition of symbol, name and decimals
98 // Receives ETH and generates tokens
99 // ----------------------------------------------------------------------------
100 contract DTF1 is ERC20, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     Kyber public kyber;
107     ERC20 public knc;
108     ERC20 public dai;
109     ERC20 public ieth;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor() public {
119         symbol = "DTF1";
120         name = "Decentralized Token Fund";
121         decimals = 18;
122         _totalSupply = 0;
123         balances[owner] = _totalSupply;
124         kyber = Kyber(0x964F35fAe36d75B1e72770e244F6595B68508CF5);
125         knc = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
126         dai = ERC20(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
127         ieth = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
128         // knc.approve(kyber, 2**255);
129         // dai.approve(kyber, 2**255);
130         emit Transfer(address(0), owner, _totalSupply);
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Total supply
136     // ------------------------------------------------------------------------
137     function totalSupply() public constant returns (uint) {
138         return _totalSupply;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Get the token balance for account `tokenOwner`
144     // ------------------------------------------------------------------------
145     function balanceOf(address tokenOwner) public constant returns (uint balance) {
146         return balances[tokenOwner];
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Transfer the balance from token owner's account to `to` account
152     // - Owner's account must have sufficient balance to transfer
153     // - 0 value transfers are allowed
154     // ------------------------------------------------------------------------
155     function transfer(address to, uint tokens) public returns (bool success) {
156         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         if (to == address(0)) {
159             // uint kncCount = kyber.trade(knc, tokens, ieth, address(this), 2**256 - 1, 1, 0);
160             // uint daiCount = kyber.trade(dai, tokens, ieth, address(this), 2**256 - 1, 1, 0);
161             // uint totalCount = safeAdd(kncCount, daiCount);
162             // msg.sender.transfer(totalCount);
163             knc.transfer(msg.sender, tokens);
164             dai.transfer(msg.sender, tokens);
165             _totalSupply = safeSub(_totalSupply, tokens);
166         }
167         emit Transfer(msg.sender, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for `spender` to transferFrom(...) `tokens`
174     // from the token owner's account
175     //
176     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
177     // recommends that there are no checks for the approval double-spend attack
178     // as this should be implemented in user interfaces 
179     // ------------------------------------------------------------------------
180     function approve(address spender, uint tokens) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Transfer `tokens` from the `from` account to the `to` account
189     // 
190     // The calling account must already have sufficient tokens approve(...)-d
191     // for spending from the `from` account and
192     // - From account must have sufficient balance to transfer
193     // - Spender must have sufficient allowance to transfer
194     // - 0 value transfers are allowed
195     // ------------------------------------------------------------------------
196     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
197         balances[from] = safeSub(balances[from], tokens);
198         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
199         balances[to] = safeAdd(balances[to], tokens);
200         emit Transfer(from, to, tokens);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Returns the amount of tokens approved by the owner that can be
207     // transferred to the spender's account
208     // ------------------------------------------------------------------------
209     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
210         return allowed[tokenOwner][spender];
211     }
212 
213 
214     function () public payable {
215         require(msg.value > 0);
216         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, msg.value);
217         (uint daiExpectedPrice,) = kyber.getExpectedRate(ieth, dai, msg.value);
218         uint tmp = safeAdd(kncExpectedPrice, daiExpectedPrice);
219         uint kncCost = safeDiv(safeMul(daiExpectedPrice, msg.value), tmp);
220         uint daiCost = safeDiv(safeMul(kncExpectedPrice, msg.value), tmp);
221         uint kncCount = kyber.trade.value(kncCost)(ieth, kncCost, knc, address(this), 2**256 - 1, 1, 0);
222         uint daiCount = kyber.trade.value(daiCost)(ieth, daiCost, dai, address(this), 2**256 - 1, 1, 0);
223         uint totalCount = 0;
224         if (kncCount < daiCount) {
225             totalCount = kncCount;
226         } else {
227             totalCount = daiCount;
228         }
229         require(totalCount > 0);
230         balances[msg.sender] = safeAdd(balances[msg.sender], totalCount);
231         _totalSupply = safeAdd(_totalSupply, totalCount);
232         emit Transfer(address(0), msg.sender, totalCount);
233     }
234 
235     function getExpectedRate(uint value) public view returns (uint, uint, uint, uint) {
236         require(value > 0);
237         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, value);
238         (uint daiExpectedPrice,) = kyber.getExpectedRate(ieth, dai, value);
239         uint totalExpectedPrice = safeDiv(safeMul(kncExpectedPrice, daiExpectedPrice), safeAdd(kncExpectedPrice, daiExpectedPrice));
240         uint totalExpectedCount = safeDiv(safeMul(value, totalExpectedPrice), 1 ether);
241         return (kncExpectedPrice, daiExpectedPrice, totalExpectedPrice, totalExpectedCount);
242     }
243 
244 
245     // ------------------------------------------------------------------------
246     // Owner can transfer out any accidentally sent ERC20 tokens
247     // ------------------------------------------------------------------------
248     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
249         return ERC20(tokenAddress).transfer(owner, tokens);
250     }
251 
252     function withdrawETH(uint value) public onlyOwner returns (bool success) {
253         owner.transfer(value);
254         return true;
255     }
256 
257     function depositETH() public payable returns (bool success) {
258         return true;
259     }
260 }