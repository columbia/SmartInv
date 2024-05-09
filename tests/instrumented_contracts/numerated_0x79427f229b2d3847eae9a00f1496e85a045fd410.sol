1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20 {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 contract Kyber {
45     function getExpectedRate(
46         ERC20 src, 
47         ERC20 dest, 
48         uint srcQty
49     ) public view returns (uint, uint);
50     function trade(
51         ERC20 src,
52         uint srcAmount,
53         ERC20 dest,
54         address destAddress,
55         uint maxDestAmount,
56         uint minConversionRate,
57         address walletId
58     ) public payable returns(uint);
59 } 
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals
94 // Receives ETH and generates tokens
95 // ----------------------------------------------------------------------------
96 contract DTF is ERC20, Owned, SafeMath {
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint public _totalSupply;
101 
102     uint public KNCBalance;
103     uint public OMGBalance;
104 
105     Kyber public kyber;
106     ERC20 public knc;
107     ERC20 public omg;
108     ERC20 public ieth;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "DTF";
119         name = "Decentralized Token Fund";
120         decimals = 18;
121         _totalSupply = 0;
122         balances[owner] = _totalSupply;
123         KNCBalance = 0;
124         OMGBalance = 0;
125         kyber = Kyber(0x964F35fAe36d75B1e72770e244F6595B68508CF5);
126         knc = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
127         omg = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
128         ieth = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
129         // knc.approve(kyber, 2**255);
130         // omg.approve(kyber, 2**255);
131         emit Transfer(address(0), owner, _totalSupply);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint) {
139         return _totalSupply;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account `tokenOwner`
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public constant returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to `to` account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         if (to == address(0)) {
160             // uint kncCount = kyber.trade(knc, tokens, ieth, address(this), 2**256 - 1, 1, 0);
161             // uint omgCount = kyber.trade(omg, tokens, ieth, address(this), 2**256 - 1, 1, 0);
162             // uint totalCount = safeAdd(kncCount, omgCount);
163             // msg.sender.transfer(totalCount);
164             knc.transfer(msg.sender, tokens);
165             omg.transfer(msg.sender, tokens);
166             _totalSupply = safeSub(_totalSupply, tokens);
167         }
168         emit Transfer(msg.sender, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Token owner can approve for `spender` to transferFrom(...) `tokens`
175     // from the token owner's account
176     //
177     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
178     // recommends that there are no checks for the approval double-spend attack
179     // as this should be implemented in user interfaces 
180     // ------------------------------------------------------------------------
181     function approve(address spender, uint tokens) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Transfer `tokens` from the `from` account to the `to` account
190     // 
191     // The calling account must already have sufficient tokens approve(...)-d
192     // for spending from the `from` account and
193     // - From account must have sufficient balance to transfer
194     // - Spender must have sufficient allowance to transfer
195     // - 0 value transfers are allowed
196     // ------------------------------------------------------------------------
197     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
198         balances[from] = safeSub(balances[from], tokens);
199         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
200         balances[to] = safeAdd(balances[to], tokens);
201         emit Transfer(from, to, tokens);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Returns the amount of tokens approved by the owner that can be
208     // transferred to the spender's account
209     // ------------------------------------------------------------------------
210     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
211         return allowed[tokenOwner][spender];
212     }
213 
214 
215     function () public payable {
216         require(msg.value > 0);
217         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, msg.value);
218         (uint omgExpectedPrice,) = kyber.getExpectedRate(ieth, omg, msg.value);
219         uint tmp = safeAdd(kncExpectedPrice, omgExpectedPrice);
220         uint kncCost = safeDiv(safeMul(omgExpectedPrice, msg.value), tmp);
221         uint omgCost = safeDiv(safeMul(kncExpectedPrice, msg.value), tmp);
222         uint kncCount = kyber.trade.value(kncCost)(ieth, kncCost, knc, address(this), 2**256 - 1, 1, 0);
223         uint omgCount = kyber.trade.value(omgCost)(ieth, omgCost, omg, address(this), 2**256 - 1, 1, 0);
224         uint totalCount = 0;
225         if (kncCount < omgCount) {
226             totalCount = kncCount;
227         } else {
228             totalCount = omgCount;
229         }
230         require(totalCount > 0);
231         balances[msg.sender] = safeAdd(balances[msg.sender], totalCount);
232         _totalSupply = safeAdd(_totalSupply, totalCount);
233         emit Transfer(address(0), msg.sender, totalCount);
234     }
235 
236     function getExpectedRate(uint value) public view returns (uint, uint, uint, uint) {
237         require(value > 0);
238         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, value);
239         (uint omgExpectedPrice,) = kyber.getExpectedRate(ieth, omg, value);
240         uint totalExpectedPrice = safeDiv(safeMul(kncExpectedPrice, omgExpectedPrice), safeAdd(kncExpectedPrice, omgExpectedPrice));
241         uint totalExpectedCount = safeDiv(safeMul(value, totalExpectedPrice), 1 ether);
242         return (kncExpectedPrice, omgExpectedPrice, totalExpectedPrice, totalExpectedCount);
243     }
244 
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20(tokenAddress).transfer(owner, tokens);
251     }
252 
253     function withdrawETH(uint value) public onlyOwner returns (bool success) {
254         owner.transfer(value);
255         return true;
256     }
257 
258     function depositETH() public payable returns (bool success) {
259         return true;
260     }
261 }