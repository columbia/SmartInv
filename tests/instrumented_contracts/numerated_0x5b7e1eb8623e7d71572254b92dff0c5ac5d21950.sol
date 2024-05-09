1 pragma solidity ^0.4.22;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() internal {
8     }
9 
10     // validates an address - currently only checks that it isn't null
11     modifier validAddress(address _address) {
12         require(_address != 0x0);
13         _;
14     }
15 
16     // verifies that the address is different than this contract address
17     modifier notThis(address _address) {
18         require(_address != address(this));
19         _;
20     }
21 
22     // Overflow protected math functions
23 
24     /**
25         @dev returns the sum of _x and _y, asserts if the calculation overflows
26 
27         @param _x   value 1
28         @param _y   value 2
29 
30         @return sum
31     */
32     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
33         uint256 z = _x + _y;
34         assert(z >= _x);
35         return z;
36     }
37 
38     /**
39         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
40 
41         @param _x   minuend
42         @param _y   subtrahend
43 
44         @return difference
45     */
46     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
47         assert(_x >= _y);
48         return _x - _y;
49     }
50 
51     /**
52         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
53 
54         @param _x   factor 1
55         @param _y   factor 2
56 
57         @return product
58     */
59     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         uint256 z = _x * _y;
61         assert(_x == 0 || z / _x == _y);
62         return z;
63     }
64 }
65 
66 /*
67     ERC20 Standard Token interface
68 */
69 contract IERC20Token {
70     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
71     function name() public constant returns (string) { name; }
72     function symbol() public constant returns (string) { symbol; }
73     function decimals() public constant returns (uint8) { decimals; }
74     function totalSupply() public constant returns (uint256) { totalSupply; }
75     function balanceOf(address _owner) public constant returns (uint256 balance);
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
77 
78     function transfer(address _to, uint256 _value) public returns (bool success);
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
80     function approve(address _spender, uint256 _value) public returns (bool success);
81 }
82 
83 
84 /*
85     Owned contract interface
86 */
87 contract IOwned {
88     // this function isn't abstract since the compiler emits automatically generated getter functions as external
89     function owner() public constant returns (address) { owner; }
90 
91     function transferOwnership(address _newOwner) public;
92     function acceptOwnership() public;
93 }
94 
95 /*
96     Provides support and utilities for contract ownership
97 */
98 contract Owned is IOwned {
99     address public owner;
100     address public newOwner;
101 
102     event OwnerUpdate(address _prevOwner, address _newOwner);
103 
104     /**
105         @dev constructor
106     */
107     function Owned() public {
108         owner = msg.sender;
109     }
110 
111     // allows execution by the owner only
112     modifier ownerOnly {
113         assert(msg.sender == owner);
114         _;
115     }
116 
117     /**
118         @dev allows transferring the contract ownership
119         the new owner still needs to accept the transfer
120         can only be called by the contract owner
121 
122         @param _newOwner    new contract owner
123     */
124     function transferOwnership(address _newOwner) public ownerOnly {
125         require(_newOwner != owner);
126         newOwner = _newOwner;
127     }
128 
129     /**
130         @dev used by a new owner to accept an ownership transfer
131     */
132     function acceptOwnership() public {
133         require(msg.sender == newOwner);
134         OwnerUpdate(owner, newOwner);
135         owner = newOwner;
136         newOwner = 0x0;
137     }
138 }
139 
140 contract YooStop is Owned{
141 
142     bool public stopped = true;
143 
144     modifier stoppable {
145         assert (!stopped);
146         _;
147     }
148     function stop() public ownerOnly{
149         stopped = true;
150     }
151     function start() public ownerOnly{
152         stopped = false;
153     }
154 
155 }
156 
157 
158 contract YoobaICO is  Owned,YooStop,Utils {
159     IERC20Token public yoobaTokenAddress;
160     uint256 public startICOTime = 0;  
161     uint256 public endICOTime = 0;  
162     uint256 public leftICOTokens = 0;
163     uint256 public tatalEthFromBuyer = 0;
164     uint256 public daysnumber = 0;
165     mapping (address => uint256) public pendingBalanceMap;
166     mapping (address => uint256) public totalBuyMap;
167     mapping (address => uint256) public totalBuyerETHMap;
168     mapping (uint256 => uint256) public daySellMap;
169     mapping (address => uint256) public withdrawYOOMap;
170     uint256 internal milestone1 = 4000000000000000000000000000;
171     uint256 internal milestone2 = 2500000000000000000000000000;
172        uint256 internal dayLimit = 300000000000000000000000000;
173     bool internal hasInitLeftICOTokens = false;
174 
175 
176 
177     /**
178         @dev constructor
179         
180     */
181     function YoobaICO(IERC20Token _yoobaTokenAddress) public{
182          yoobaTokenAddress = _yoobaTokenAddress;
183     }
184     
185 
186     function startICO(uint256 _startICOTime,uint256 _endICOTime) public ownerOnly {
187         startICOTime = _startICOTime;
188         endICOTime = _endICOTime;
189     }
190     
191     function initLeftICOTokens() public ownerOnly{
192         require(!hasInitLeftICOTokens);
193        leftICOTokens = yoobaTokenAddress.balanceOf(this);
194        hasInitLeftICOTokens = true;
195     }
196     function setLeftICOTokens(uint256 left) public ownerOnly {
197         leftICOTokens = left;
198     }
199     function setDaySellAmount(uint256 _dayNum,uint256 _sellAmount) public ownerOnly {
200         daySellMap[_dayNum] = _sellAmount;
201     }
202     
203     function withdrawTo(address _to, uint256 _amount) public ownerOnly notThis(_to)
204     {   
205         require(_amount <= this.balance);
206         _to.transfer(_amount); // send the amount to the target account
207     }
208     
209     function withdrawERC20TokenTo(IERC20Token _token, address _to, uint256 _amount)
210         public
211         ownerOnly
212         validAddress(_token)
213         validAddress(_to)
214         notThis(_to)
215     {
216         assert(_token.transfer(_to, _amount));
217 
218     }
219     
220     function withdrawToBuyer(IERC20Token _token,address[] _to)  public ownerOnly {
221         require(_to.length > 0  && _to.length < 10000);
222         for(uint16 i = 0; i < _to.length ;i++){
223             if(pendingBalanceMap[_to[i]] > 0){
224                 assert(_token.transfer(_to[i],pendingBalanceMap[_to[i]])); 
225                 withdrawYOOMap[_to[i]] = safeAdd(withdrawYOOMap[_to[i]],pendingBalanceMap[_to[i]]);
226                 pendingBalanceMap[_to[i]] = 0;
227             }
228          
229         }
230     }
231     
232       function withdrawToBuyer(IERC20Token _token, address _to, uint256 _amount)
233         public
234         ownerOnly
235         validAddress(_token)
236         validAddress(_to)
237         notThis(_to)
238     {
239         assert(_token.transfer(_to, _amount));
240         withdrawYOOMap[_to] = safeAdd(withdrawYOOMap[_to],_amount);
241         pendingBalanceMap[_to] = safeSub(pendingBalanceMap[_to],_amount);
242 
243     }
244     
245     function refund(address[] _to) public ownerOnly{
246         require(_to.length > 0  && _to.length < 10000 );
247         for(uint16 i = 0; i < _to.length ;i++){
248             if(pendingBalanceMap[_to[i]] > 0 && withdrawYOOMap[_to[i]] == 0 && totalBuyerETHMap[_to[i]] > 0 && totalBuyMap[_to[i]] > 0){
249                  if(totalBuyerETHMap[_to[i]] <= this.balance){
250                 _to[i].transfer(totalBuyerETHMap[_to[i]]); 
251                 tatalEthFromBuyer = tatalEthFromBuyer - totalBuyerETHMap[_to[i]];
252                 leftICOTokens = leftICOTokens + pendingBalanceMap[_to[i]];
253                 totalBuyerETHMap[_to[i]] = 0;
254                 pendingBalanceMap[_to[i]] = 0; 
255                 totalBuyMap[_to[i]] = 0;
256               
257                  }
258             }
259          
260         }
261     }
262   
263     function buyToken() internal
264     {
265         require(!stopped && now >= startICOTime && now <= endICOTime );
266         require(msg.value >= 0.1 ether && msg.value <= 100 ether);
267         
268         uint256  dayNum = ((now - startICOTime) / 1 days) + 1;
269         daysnumber = dayNum;
270          assert(daySellMap[dayNum] <= dayLimit);
271          uint256 amount = 0;
272         if(now < (startICOTime + 1 weeks) && leftICOTokens > milestone1){
273                
274                 if(msg.value * 320000 <= (leftICOTokens - milestone1))
275                 { 
276                      amount = msg.value * 320000;
277                 }else{
278                    uint256 priceOneEther1 =  (leftICOTokens - milestone1)/320000;
279                      amount = (msg.value - priceOneEther1) * 250000 + priceOneEther1 * 320000;
280                 }
281         }else{
282            if(leftICOTokens > milestone2){
283                 if(msg.value * 250000 <= (leftICOTokens - milestone2))
284                 {
285                    amount = msg.value * 250000;
286                 }else{
287                    uint256 priceOneEther2 =  (leftICOTokens - milestone2)/250000;
288                    amount = (msg.value - priceOneEther2) * 180000 + priceOneEther2 * 250000;
289                 }
290             }else{
291                assert(msg.value * 180000 <= leftICOTokens);
292             if((leftICOTokens - msg.value * 180000) < 18000 && msg.value * 180000 <= 100 * 180000 * (10 ** 18)){
293                   amount = leftICOTokens;
294             }else{
295                  amount = msg.value * 180000;
296             }
297             }
298         }
299            if(amount >= 18000 * (10 ** 18) && amount <= 320000 * 100 * (10 ** 18)){
300               leftICOTokens = safeSub(leftICOTokens,amount);
301               pendingBalanceMap[msg.sender] = safeAdd(pendingBalanceMap[msg.sender], amount);
302               totalBuyMap[msg.sender] = safeAdd(totalBuyMap[msg.sender], amount);
303               daySellMap[dayNum] += amount;
304               totalBuyerETHMap[msg.sender] = safeAdd(totalBuyerETHMap[msg.sender],msg.value);
305               tatalEthFromBuyer += msg.value;
306               return;
307           }else{
308                revert();
309           }
310     }
311 
312     function() public payable stoppable {
313         buyToken();
314     }
315 }