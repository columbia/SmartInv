1 pragma solidity ^0.4.14;
2 
3 contract DSMath {
4     
5     /*
6     standard uint256 functions
7      */
8 
9     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
10         assert((z = x + y) >= x);
11     }
12 
13     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
14         assert((z = x - y) <= x);
15     }
16 
17     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         assert((z = x * y) >= x);
19     }
20 
21     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
22         z = x / y;
23     }
24 
25     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
26         return x <= y ? x : y;
27     }
28     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         return x >= y ? x : y;
30     }
31 
32     /*
33     uint128 functions (h is for half)
34      */
35 
36 
37     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
38         assert((z = x + y) >= x);
39     }
40 
41     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
42         assert((z = x - y) <= x);
43     }
44 
45     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
46         assert((z = x * y) >= x);
47     }
48 
49     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
50         z = x / y;
51     }
52 
53     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
54         return x <= y ? x : y;
55     }
56     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
57         return x >= y ? x : y;
58     }
59 
60 
61     /*
62     int256 functions
63      */
64 
65     function imin(int256 x, int256 y) constant internal returns (int256 z) {
66         return x <= y ? x : y;
67     }
68     function imax(int256 x, int256 y) constant internal returns (int256 z) {
69         return x >= y ? x : y;
70     }
71 
72     /*
73     WAD math
74      */
75 
76     uint128 constant WAD = 10 ** 18;
77 
78     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
79         return hadd(x, y);
80     }
81 
82     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
83         return hsub(x, y);
84     }
85 
86     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
87         z = cast((uint256(x) * y + WAD / 2) / WAD);
88     }
89 
90     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
91         z = cast((uint256(x) * WAD + y / 2) / y);
92     }
93 
94     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
95         return hmin(x, y);
96     }
97     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
98         return hmax(x, y);
99     }
100 
101     /*
102     RAY math
103      */
104 
105     uint128 constant RAY = 10 ** 27;
106 
107     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
108         return hadd(x, y);
109     }
110 
111     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
112         return hsub(x, y);
113     }
114 
115     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
116         z = cast((uint256(x) * y + RAY / 2) / RAY);
117     }
118 
119     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
120         z = cast((uint256(x) * RAY + y / 2) / y);
121     }
122 
123     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
124         // This famous algorithm is called "exponentiation by squaring"
125         // and calculates x^n with x as fixed-point and n as regular unsigned.
126         //
127         // It's O(log n), instead of O(n) for naive repeated multiplication.
128         //
129         // These facts are why it works:
130         //
131         //  If n is even, then x^n = (x^2)^(n/2).
132         //  If n is odd,  then x^n = x * x^(n-1),
133         //   and applying the equation for even x gives
134         //    x^n = x * (x^2)^((n-1) / 2).
135         //
136         //  Also, EVM division is flooring and
137         //    floor[(n-1) / 2] = floor[n / 2].
138 
139         z = n % 2 != 0 ? x : RAY;
140 
141         for (n /= 2; n != 0; n /= 2) {
142             x = rmul(x, x);
143 
144             if (n % 2 != 0) {
145                 z = rmul(z, x);
146             }
147         }
148     }
149 
150     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
151         return hmin(x, y);
152     }
153     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
154         return hmax(x, y);
155     }
156 
157     function cast(uint256 x) constant internal returns (uint128 z) {
158         assert((z = uint128(x)) == x);
159     }
160 
161 }
162 
163 contract Owned
164 {
165     address public owner;
166     
167     function Owned()
168     {
169         owner = msg.sender;
170     }
171     
172     modifier onlyOwner()
173     {
174         if (msg.sender != owner) revert();
175         _;
176     }
177 }
178 
179 contract ProspectorsCrowdsale is Owned, DSMath
180 {
181     ProspectorsGoldToken public token;
182     address public dev_multisig; //multisignature wallet to collect funds
183     
184     uint public total_raised; //crowdsale total funds raised
185     uint public contributors_count = 0; //crowdsale total funds raised
186     
187     uint public constant start_time = 1502377200; //crowdsale start time - August 10, 15:00 UTC
188     uint public constant end_time = 1505055600; //crowdsale end time - Septempber 10, 15:00 UTC
189     uint public constant bonus_amount = 10000000 * 10**18; //amount of tokens by bonus price
190     uint public constant start_amount = 60000000 * 10**18; //tokens amount allocated for crowdsale
191     uint public constant price =  0.0005 * 10**18; //standart token price in ETH 
192     uint public constant bonus_price = 0.0004 * 10**18; //bonus token price in ETH
193     uint public constant goal = 2000 ether; //soft crowdsale cap. If not reached funds will be returned
194     bool private closed = false; //can be true after end_time or when all tokens sold
195     
196     mapping(address => uint) funded; //needed to save amounts of ETH for refund
197     
198     modifier in_time //allows send eth only when crowdsale is active
199     {
200         if (time() < start_time || time() > end_time)  revert();
201         _;
202     }
203 
204     function is_success() public constant returns (bool)
205     {
206         return closed == true && total_raised >= goal;
207     }
208     
209     function time() public constant returns (uint)
210     {
211         return block.timestamp;
212     }
213     
214     function my_token_balance() public constant returns (uint)
215     {
216         return token.balanceOf(this);
217     }
218     
219     //tokens amount available by bonus price
220     function available_with_bonus() public constant returns (uint)
221     {
222         return my_token_balance() >=  min_balance_for_bonus() ? 
223                 my_token_balance() - min_balance_for_bonus() 
224                 : 
225                 0;
226     }
227     
228     function available_without_bonus() private constant returns (uint)
229     {
230         return min(my_token_balance(),  min_balance_for_bonus());
231     }
232     
233     function min_balance_for_bonus() private constant returns (uint)
234     {
235         return start_amount - bonus_amount;
236     }
237     
238     //prevent send less than 0.01 ETH
239     modifier has_value
240     {
241         if (msg.value < 0.01 ether) revert();
242         _;
243     }
244 
245     function init(address _token_address, address _dev_multisig) onlyOwner
246     {
247         if (address(0) != address(token)) revert();
248         token = ProspectorsGoldToken(_token_address);
249         dev_multisig = _dev_multisig;
250     }
251     
252     //main contribute function
253     function participate() in_time has_value private {
254         if (my_token_balance() == 0 || closed == true) revert();
255 
256         var remains = msg.value;
257         
258          //calculate tokens amount by bonus price
259         var can_with_bonus = wdiv(cast(remains), cast(bonus_price));
260         var buy_amount = cast(min(can_with_bonus, available_with_bonus()));
261         remains = sub(remains, wmul(buy_amount, cast(bonus_price)));
262         
263         if (buy_amount < can_with_bonus) //calculate tokens amount by standart price if tokens with bonus don't cover eth amount
264         {
265             var can_without_bonus = wdiv(cast(remains), cast(price));
266             var buy_without_bonus = cast(min(can_without_bonus, available_without_bonus()));
267             remains = sub(remains, wmul(buy_without_bonus, cast(price)));
268             buy_amount = hadd(buy_amount, buy_without_bonus);
269         }
270 
271         if (remains > 0) revert();
272 
273         total_raised = add(total_raised, msg.value);
274         if (funded[msg.sender] == 0) contributors_count++;
275         funded[msg.sender] = add(funded[msg.sender], msg.value);
276 
277         token.transfer(msg.sender, buy_amount); //transfer tokens to participant
278     }
279     
280     function refund() //allows get eth back if min goal not reached
281     {
282         if (total_raised >= goal || closed == false) revert();
283         var amount = funded[msg.sender];
284         if (amount > 0)
285         {
286             funded[msg.sender] = 0;
287             msg.sender.transfer(amount);
288         }
289     }
290     
291     function closeCrowdsale() //close crowdsale. this action unlocks refunds or token transfers
292     {
293         if (closed == false && time() > start_time && (time() > end_time || my_token_balance() == 0))
294         {
295             closed = true;
296             if (is_success())
297             {
298                 token.unlock(); //unlock token transfers
299                 if (my_token_balance() > 0)
300                 {
301                     token.transfer(0xb1, my_token_balance()); //move not saled tokens to game balance
302                 }
303             }
304         }
305         else
306         {
307             revert();
308         }
309     }
310     
311     function collect() //collect eth by devs if min goal reached
312     {
313         if (total_raised < goal) revert();
314         dev_multisig.transfer(this.balance);
315     }
316 
317     function () payable external 
318     {
319         participate();
320     }
321     
322     //allows destroy this whithin 180 days after crowdsale ends
323     function destroy() onlyOwner
324     {
325         if (time() > end_time + 180 days)
326         {
327             selfdestruct(dev_multisig);
328         }
329     }
330 }
331 
332 contract ProspectorsGoldToken {
333     function balanceOf( address who ) constant returns (uint value);
334     function transfer( address to, uint value) returns (bool ok);
335     function unlock() returns (bool ok);
336 }