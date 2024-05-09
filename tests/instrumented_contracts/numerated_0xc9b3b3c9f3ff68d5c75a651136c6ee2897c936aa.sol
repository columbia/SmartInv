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
100 contract DTF is ERC20, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     uint public KNCBalance;
107     uint public OMGBalance;
108 
109     Kyber public kyber;
110     ERC20 public knc;
111     ERC20 public omg;
112     ERC20 public ieth;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     constructor() public {
122         symbol = "DTF";
123         name = "Decentralized Token Fund";
124         decimals = 18;
125         _totalSupply = 0;
126         balances[owner] = _totalSupply;
127         KNCBalance = 0;
128         OMGBalance = 0;
129         kyber = Kyber(0x964F35fAe36d75B1e72770e244F6595B68508CF5);
130         knc = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
131         omg = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
132         ieth = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
133         // knc.approve(kyber, 2**255);
134         // omg.approve(kyber, 2**255);
135         emit Transfer(address(0), owner, _totalSupply);
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Total supply
141     // ------------------------------------------------------------------------
142     function totalSupply() public constant returns (uint) {
143         return _totalSupply;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Get the token balance for account `tokenOwner`
149     // ------------------------------------------------------------------------
150     function balanceOf(address tokenOwner) public constant returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer the balance from token owner's account to `to` account
157     // - Owner's account must have sufficient balance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transfer(address to, uint tokens) public returns (bool success) {
161         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
162         balances[to] = safeAdd(balances[to], tokens);
163         if (to == address(0)) {
164             // uint kncCount = kyber.trade(knc, tokens, ieth, address(this), 2**256 - 1, 1, 0);
165             // uint omgCount = kyber.trade(omg, tokens, ieth, address(this), 2**256 - 1, 1, 0);
166             // uint totalCount = safeAdd(kncCount, omgCount);
167             // msg.sender.transfer(totalCount);
168             knc.transfer(msg.sender, tokens);
169             omg.transfer(msg.sender, tokens);
170             _totalSupply = safeSub(_totalSupply, tokens);
171         }
172         emit Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Token owner can approve for `spender` to transferFrom(...) `tokens`
179     // from the token owner's account
180     //
181     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
182     // recommends that there are no checks for the approval double-spend attack
183     // as this should be implemented in user interfaces 
184     // ------------------------------------------------------------------------
185     function approve(address spender, uint tokens) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer `tokens` from the `from` account to the `to` account
194     // 
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the `from` account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
202         balances[from] = safeSub(balances[from], tokens);
203         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
204         balances[to] = safeAdd(balances[to], tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     function () public payable {
220         require(msg.value > 0);
221         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, msg.value);
222         (uint omgExpectedPrice,) = kyber.getExpectedRate(ieth, omg, msg.value);
223         uint tmp = safeAdd(kncExpectedPrice, omgExpectedPrice);
224         uint kncCost = safeDiv(safeMul(omgExpectedPrice, msg.value), tmp);
225         uint omgCost = safeDiv(safeMul(kncExpectedPrice, msg.value), tmp);
226         uint kncCount = kyber.trade.value(kncCost)(ieth, kncCost, knc, address(this), 2**256 - 1, 1, 0);
227         uint omgCount = kyber.trade.value(omgCost)(ieth, omgCost, omg, address(this), 2**256 - 1, 1, 0);
228         uint totalCount = 0;
229         if (kncCount < omgCount) {
230             totalCount = kncCount;
231         } else {
232             totalCount = omgCount;
233         }
234         require(totalCount > 0);
235         balances[msg.sender] = safeAdd(balances[msg.sender], totalCount);
236         _totalSupply = safeAdd(_totalSupply, totalCount);
237         emit Transfer(address(0), msg.sender, totalCount);
238     }
239 
240     function getExpectedRate(uint value) public view returns (uint, uint, uint, uint) {
241         require(value > 0);
242         (uint kncExpectedPrice,) = kyber.getExpectedRate(ieth, knc, value);
243         (uint omgExpectedPrice,) = kyber.getExpectedRate(ieth, omg, value);
244         uint totalExpectedPrice = safeDiv(safeMul(kncExpectedPrice, omgExpectedPrice), safeAdd(kncExpectedPrice, omgExpectedPrice));
245         uint totalExpectedCount = safeDiv(safeMul(value, totalExpectedPrice), 1 ether);
246         return (kncExpectedPrice, omgExpectedPrice, totalExpectedPrice, totalExpectedCount);
247     }
248 
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
254         return ERC20(tokenAddress).transfer(owner, tokens);
255     }
256 
257     function withdrawETH(uint value) public onlyOwner returns (bool success) {
258         owner.transfer(value);
259         return true;
260     }
261 
262     function depositETH() public payable returns (bool success) {
263         return true;
264     }
265 }