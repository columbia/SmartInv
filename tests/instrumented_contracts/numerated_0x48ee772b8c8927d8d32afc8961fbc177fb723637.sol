1 pragma solidity ^0.4.11;
2 contract SafeMath {
3     
4     /*
5     standard uint256 functions
6      */
7 
8     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
9         assert((z = x + y) >= x);
10     }
11 
12     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
13         assert((z = x - y) <= x);
14     }
15 
16     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
17         assert((z = x * y) >= x);
18     }
19 
20     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
21         z = x / y;
22     }
23 
24     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
25         return x <= y ? x : y;
26     }
27     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
28         return x >= y ? x : y;
29     }
30 
31     /*
32     uint128 functions (h is for half)
33      */
34 
35 
36     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
37         assert((z = x + y) >= x);
38     }
39 
40     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
41         assert((z = x - y) <= x);
42     }
43 
44     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
45         assert((z = x * y) >= x);
46     }
47 
48     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
49         z = x / y;
50     }
51 
52     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
53         return x <= y ? x : y;
54     }
55     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
56         return x >= y ? x : y;
57     }
58 
59 
60     /*
61     int256 functions
62      */
63 
64     function imin(int256 x, int256 y) constant internal returns (int256 z) {
65         return x <= y ? x : y;
66     }
67     function imax(int256 x, int256 y) constant internal returns (int256 z) {
68         return x >= y ? x : y;
69     }
70 
71     /*
72     WAD math
73      */
74 
75     uint128 constant WAD = 10 ** 18;
76 
77     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
78         return hadd(x, y);
79     }
80 
81     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
82         return hsub(x, y);
83     }
84 
85     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
86         z = cast((uint256(x) * y + WAD / 2) / WAD);
87     }
88 
89     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
90         z = cast((uint256(x) * WAD + y / 2) / y);
91     }
92 
93     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
94         return hmin(x, y);
95     }
96     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
97         return hmax(x, y);
98     }
99 
100     /*
101     RAY math
102      */
103 
104     uint128 constant RAY = 10 ** 27;
105 
106     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
107         return hadd(x, y);
108     }
109 
110     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
111         return hsub(x, y);
112     }
113 
114     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
115         z = cast((uint256(x) * y + RAY / 2) / RAY);
116     }
117 
118     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
119         z = cast((uint256(x) * RAY + y / 2) / y);
120     }
121 
122     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
123         // This famous algorithm is called "exponentiation by squaring"
124         // and calculates x^n with x as fixed-point and n as regular unsigned.
125         //
126         // It's O(log n), instead of O(n) for naive repeated multiplication.
127         //
128         // These facts are why it works:
129         //
130         //  If n is even, then x^n = (x^2)^(n/2).
131         //  If n is odd,  then x^n = x * x^(n-1),
132         //   and applying the equation for even x gives
133         //    x^n = x * (x^2)^((n-1) / 2).
134         //
135         //  Also, EVM division is flooring and
136         //    floor[(n-1) / 2] = floor[n / 2].
137 
138         z = n % 2 != 0 ? x : RAY;
139 
140         for (n /= 2; n != 0; n /= 2) {
141             x = rmul(x, x);
142 
143             if (n % 2 != 0) {
144                 z = rmul(z, x);
145             }
146         }
147     }
148 
149     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
150         return hmin(x, y);
151     }
152     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
153         return hmax(x, y);
154     }
155 
156     function cast(uint256 x) constant internal returns (uint128 z) {
157         assert((z = uint128(x)) == x);
158     }
159 
160 }
161 
162 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
163 ///  later changed
164 contract Owned {
165     /// @dev `owner` is the only address that can call a function with this
166     /// modifier
167     modifier onlyOwner() {
168         require(msg.sender == owner) ;
169         _;
170     }
171 
172     address public owner;
173 
174     /// @notice The Constructor assigns the message sender to be `owner`
175     function Owned() {
176         owner = msg.sender;
177     }
178 
179     address public newOwner;
180 
181     /// @notice `owner` can step down and assign some other address to this role
182     /// @param _newOwner The address of the new owner. 0x0 can be used to create
183     ///  an unowned neutral vault, however that cannot be undone
184     function changeOwner(address _newOwner) onlyOwner {
185         newOwner = _newOwner;
186     }
187 
188     function acceptOwnership() {
189         if (msg.sender == newOwner) {
190             owner = newOwner;
191         }
192     }
193 }
194 
195 contract Contribution is SafeMath, Owned {
196     uint256 public constant MIN_FUND = (0.01 ether);
197     uint256 public constant CRAWDSALE_START_DAY = 1;
198     uint256 public constant CRAWDSALE_END_DAY = 7;
199 
200     uint256 public dayCycle = 24 hours;
201     uint256 public fundingStartTime = 0;
202     address public ethFundDeposit = 0;
203     address public investorDeposit = 0;
204     bool public isFinalize = false;
205     bool public isPause = false;
206     mapping (uint => uint) public dailyTotals; //total eth per day
207     mapping (uint => mapping (address => uint)) public userBuys; // otal eth per day per user
208     uint256 public totalContributedETH = 0; //total eth of 7 days
209 
210     // events
211     event LogBuy (uint window, address user, uint amount);
212     event LogCreate (address ethFundDeposit, address investorDeposit, uint fundingStartTime, uint dayCycle);
213     event LogFinalize (uint finalizeTime);
214     event LogPause (uint finalizeTime, bool pause);
215 
216     function Contribution (address _ethFundDeposit, address _investorDeposit, uint256 _fundingStartTime, uint256 _dayCycle)  {
217         require( now < _fundingStartTime );
218         require( _ethFundDeposit != address(0) );
219 
220         fundingStartTime = _fundingStartTime;
221         dayCycle = _dayCycle;
222         ethFundDeposit = _ethFundDeposit;
223         investorDeposit = _investorDeposit;
224         LogCreate(_ethFundDeposit, _investorDeposit, _fundingStartTime,_dayCycle);
225     }
226 
227     //crawdsale entry
228     function () payable {  
229         require(!isPause);
230         require(!isFinalize);
231         require( msg.value >= MIN_FUND ); //eth >= 0.01 at least
232 
233         ethFundDeposit.transfer(msg.value);
234         buy(today(), msg.sender, msg.value);
235     }
236 
237     function importExchangeSale(uint256 day, address _exchangeAddr, uint _amount) onlyOwner {
238         buy(day, _exchangeAddr, _amount);
239     }
240 
241     function buy(uint256 day, address _addr, uint256 _amount) internal {
242         require( day >= CRAWDSALE_START_DAY && day <= CRAWDSALE_END_DAY ); 
243 
244         //record user's buy amount
245         userBuys[day][_addr] += _amount;
246         dailyTotals[day] += _amount;
247         totalContributedETH += _amount;
248 
249         LogBuy(day, _addr, _amount);
250     }
251 
252     function kill() onlyOwner {
253         selfdestruct(owner);
254     }
255 
256     function pause(bool _isPause) onlyOwner {
257         isPause = _isPause;
258         LogPause(now,_isPause);
259     }
260 
261     function finalize() onlyOwner {
262         isFinalize = true;
263         LogFinalize(now);
264     }
265 
266     function today() constant returns (uint) {
267         return sub(now, fundingStartTime) / dayCycle + 1;
268     }
269 }