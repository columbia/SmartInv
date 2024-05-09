1 pragma solidity 0.4.23;
2 
3 contract ERC20Interface {
4 
5     function totalSupply() public constant returns (uint);
6 
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8 
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10 
11     function transfer(address to, uint tokens) public returns (bool success);
12 
13     function approve(address spender, uint tokens) public returns (bool success);
14 
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16 
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19 
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 
22 }
23 
24 contract AirSwapExchangeI {
25     function fill(address makerAddress, uint makerAmount, address makerToken,
26                   address takerAddress, uint takerAmount, address takerToken,
27                   uint256 expiration, uint256 nonce, uint8 v, bytes32 r, bytes32 s) payable;
28 }
29 
30 contract KyberNetworkI {
31     function trade(
32         address src,
33         uint srcAmount,
34         address dest,
35         address destAddress,
36         uint maxDestAmount,
37         uint minConversionRate,
38         address walletId
39     )
40         public
41         payable
42         returns(uint);
43 }
44 
45 contract EtherDelta {
46     function deposit() payable;
47     function withdraw(uint amount);
48     function depositToken(address token, uint amount);
49     function withdrawToken(address token, uint amount);
50     function balanceOf(address token, address user) constant returns (uint);
51     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount);
52     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);
53 }
54 
55 contract BancorConverterI {
56     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn)
57         public
58         payable
59         returns (uint256);
60 }
61 
62 /*
63  * Dexter connects up EtherDelta, Kyber, Airswap, Bancor so trades can be proxied and a fee levied.
64  * The purpose of this is to backfill the sell side of order books so there is always some form of liqudity available.
65  *
66  * This contract was written by Arctek, for Bamboo Relay.
67  */
68 contract Dexter {
69     address public owner;
70     uint256 public takerFee;
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     function () public payable {
77         // need this for ED withdrawals
78     }
79 
80     function kill() public {
81         require(msg.sender == owner);
82 
83         selfdestruct(msg.sender);
84     }
85 
86     function setFee(uint256 _takerFee) public returns (bool success) {
87         require(owner == msg.sender);
88         require(takerFee != _takerFee);
89 
90         takerFee = _takerFee;
91 
92         return true;
93     }
94 
95     function setOwner(address _owner) public returns (bool success) {
96         require(owner == msg.sender);
97         require(owner != _owner);
98 
99         owner = _owner;
100 
101         return true;
102     }
103 
104     function withdraw() public returns (bool success) {
105         require(owner == msg.sender);
106         require(address(this).balance > 0);
107 
108         msg.sender.transfer(address(this).balance);
109 
110         return true;
111     }
112 
113     function withdrawTokens(ERC20Interface erc20) public returns (bool success) {
114         require(owner == msg.sender);
115         
116         uint256 balance = erc20.balanceOf(this);
117 
118         // Sanity check in case the contract does not do this
119         require(balance > 0);
120 
121         require(erc20.transfer(msg.sender, balance));
122 
123         return true;
124     }
125 
126     // In case it needs to proxy later in the future
127     function approve(ERC20Interface erc20, address spender, uint tokens) public returns (bool success) {
128         require(owner == msg.sender);
129 
130         require(erc20.approve(spender, tokens));
131 
132         return true;
133     }
134 
135     function tradeAirswap(
136         address makerAddress, 
137         uint makerAmount, 
138         address makerToken,
139         uint256 expirationFinalAmount, 
140         uint256 nonceFee, 
141         uint8 v, 
142         bytes32 r, 
143         bytes32 s
144     ) 
145         payable
146         returns (bool success)
147     {
148         // Fill the order, always ETH, since we can't withdraw from the user unless authorized
149         AirSwapExchangeI(0x8fd3121013A07C57f0D69646E86E7a4880b467b7).fill.value(msg.value)(
150             makerAddress, 
151             makerAmount, 
152             makerToken, 
153             0x28b7d7B7608296E0Ee3d77C242F1F3ac571723E7, 
154             msg.value, 
155             address(0),
156             expirationFinalAmount, 
157             nonceFee, 
158             v, 
159             r, 
160             s
161         );
162 
163         if (takerFee > 0) {
164             nonceFee = (makerAmount * takerFee) / (1 ether);
165 
166             expirationFinalAmount = makerAmount - nonceFee;//;
167         }
168         else {
169             expirationFinalAmount = makerAmount;
170         }
171 
172         require(ERC20Interface(makerToken).transferFrom(0x28b7d7B7608296E0Ee3d77C242F1F3ac571723E7, msg.sender, expirationFinalAmount));
173 
174         return true;
175     }
176 
177     function tradeKyber(
178         address dest,
179         uint256 maxDestAmount,
180         uint256 minConversionRate,
181         address walletId
182     )
183         public
184         payable
185         returns (bool success)
186     {
187         uint256 actualDestAmount = KyberNetworkI(0x964F35fAe36d75B1e72770e244F6595B68508CF5).trade.value(msg.value)(
188             0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee, // eth token in kyber
189             msg.value,
190             dest, 
191             this,
192             maxDestAmount,
193             minConversionRate,
194             walletId
195         );
196 
197         uint256 transferAmount;
198 
199         if (takerFee > 0) {
200             uint256 fee = (actualDestAmount * takerFee) / (1 ether);
201 
202             transferAmount = actualDestAmount - fee;
203         }
204         else {
205             transferAmount = actualDestAmount;
206         }
207 
208         require(ERC20Interface(dest).transfer(msg.sender, transferAmount));
209 
210         return true;
211     }
212 
213     function widthdrawEtherDelta(uint256 amount) public returns (bool success) {
214         // withdraw dust
215         EtherDelta etherDelta = EtherDelta(0x8d12A197cB00D4747a1fe03395095ce2A5CC6819);
216 
217         etherDelta.withdraw(amount);
218 
219         return true;
220     }
221 
222     //ed trade
223     function tradeEtherDelta(
224         address tokenGet, 
225         uint256 amountGetFee,
226         address tokenGive,
227         uint256 amountGive, 
228         uint256 expiresFinalAmount, 
229         uint256 nonce, 
230         address user, 
231         uint8 v, 
232         bytes32 r, 
233         bytes32 s, 
234         uint256 amount,
235         uint256 withdrawAmount
236     )
237         public
238         payable
239         returns (bool success)
240     {
241         EtherDelta etherDelta = EtherDelta(0x8d12A197cB00D4747a1fe03395095ce2A5CC6819);
242 
243         // deposit
244         etherDelta.deposit.value(msg.value)();
245 
246         // trade throws if it can't match
247         etherDelta.trade(
248             tokenGet, 
249             amountGetFee, 
250             tokenGive, 
251             amountGive,
252             expiresFinalAmount, 
253             nonce, 
254             user,
255             v, 
256             r, 
257             s, 
258             amount
259         );
260 
261         etherDelta.withdrawToken(tokenGive, withdrawAmount);
262 
263         if (takerFee > 0) {
264             // amountGetFee
265             amountGetFee = (withdrawAmount * takerFee) / (1 ether);
266 
267             expiresFinalAmount = withdrawAmount - amountGetFee;
268         }
269         else {
270             expiresFinalAmount = withdrawAmount;
271         }
272 
273         require(ERC20Interface(tokenGive).transfer(msg.sender, expiresFinalAmount) != false);
274 
275         return true;
276     }
277 
278     function tradeBancor(address[] _path, uint256 _amount, uint256 _minReturn, address _token)
279         public
280         payable
281         returns (bool success)
282     {
283         uint256 actualAmount = BancorConverterI(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29).quickConvert.value(msg.value)(
284             _path,
285             _amount,
286             _minReturn
287         );
288 
289         uint256 transferAmount;
290 
291         if (takerFee > 0) {
292             uint256 fee = (actualAmount * takerFee) / (1 ether);
293 
294             transferAmount = actualAmount - fee;
295         }
296         else {
297             transferAmount = actualAmount;
298         }
299 
300         require(ERC20Interface(_token).transfer(msg.sender, transferAmount));
301 
302         return true;
303     }
304 }