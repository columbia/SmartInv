1 pragma solidity 0.4.18;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath64 {
67   function mul(uint64 a, uint64 b) internal constant returns (uint64) {
68     uint64 c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function div(uint64 a, uint64 b) internal constant returns (uint64) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint64 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint64 a, uint64 b) internal constant returns (uint64) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint64 a, uint64 b) internal constant returns (uint64) {
86     uint64 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 /**
94  * @title VestingERC20
95  * @dev VestingERC20 is a contract for managing vesting of ERC20 Token.
96  * @dev The tokens are unlocked continuously to the vester.
97  * @dev The contract host the tokens that are locked for the vester.
98  */
99 contract VestingERC20 {
100     using SafeMath for uint256;
101     using SafeMath64 for uint64;
102 
103     struct Grant {
104         uint256 vestedAmount;
105         uint64 startTime;
106         uint64 cliffTime;
107         uint64 endTime;
108         uint256 withdrawnAmount;
109     }
110 
111     // list of the grants (token => granter => vester => Grant).
112     mapping(address => mapping(address => mapping(address => Grant))) public grantPerTokenGranterVester;
113 
114     // Ledger of the tokens hodled (this not a typo ;) ) in this contract (token => user => balance).
115     mapping(address => mapping(address => uint256)) private balancePerPersonPerToken;
116 
117 
118     event NewGrant(address granter, address vester, address token, uint256 vestedAmount, uint64 startTime, uint64 cliffTime, uint64 endTime);
119     event GrantRevoked(address granter, address vester, address token);
120     event Deposit(address token, address granter, uint amount, uint balance);
121     event TokenReleased(address token, address granter, address vester, uint amount);
122     event Withdraw(address token, address user, uint amount);
123 
124     /**
125      * @dev Create a vesting to an ethereum address.
126      *
127      * If there is not enough tokens available on the contract, an exception is thrown.
128      *
129      * @param _token The ERC20 token contract address.
130      * @param _vester The address where the token will be sent.
131      * @param _vestedAmount The amount of tokens to be sent during the vesting period.
132      * @param _startTime The time when the vesting starts.
133      * @param _grantPeriod The period of the grant in sec.
134      * @param _cliffPeriod The period in sec during which time the tokens cannot be withraw.
135      */
136     function createVesting(
137         address _token, 
138         address _vester,  
139         uint256 _vestedAmount,
140         uint64 _startTime,
141         uint64 _grantPeriod,
142         uint64 _cliffPeriod) 
143         external
144     {
145         require(_token != 0);
146         require(_vester != 0);
147         require(_cliffPeriod <= _grantPeriod);
148         require(_vestedAmount != 0);
149         require(_grantPeriod==0 || _vestedAmount * _grantPeriod >= _vestedAmount); // no overflow allow here! (to make getBalanceVestingInternal safe).
150 
151         // verify that there is not already a grant between the addresses for this specific contract.
152         require(grantPerTokenGranterVester[_token][msg.sender][_vester].vestedAmount==0);
153 
154         var cliffTime = _startTime.add(_cliffPeriod);
155         var endTime = _startTime.add(_grantPeriod);
156 
157         grantPerTokenGranterVester[_token][msg.sender][_vester] = Grant(_vestedAmount, _startTime, cliffTime, endTime, 0);
158 
159         // update the balance
160         balancePerPersonPerToken[_token][msg.sender] = balancePerPersonPerToken[_token][msg.sender].sub(_vestedAmount);
161 
162         NewGrant(msg.sender, _vester, _token, _vestedAmount, _startTime, cliffTime, endTime);
163     }
164 
165     /**
166      * @dev Revoke a vesting
167      *
168      * The vesting is deleted and the tokens already released are sent to the vester.
169      *
170      * @param _token The address of the token.
171      * @param _vester The address of the vester.
172      */
173     function revokeVesting(address _token, address _vester) 
174         external
175     {
176         require(_token != 0);
177         require(_vester != 0);
178 
179         Grant storage _grant = grantPerTokenGranterVester[_token][msg.sender][_vester];
180 
181         // verify if the grant exists
182         require(_grant.vestedAmount!=0);
183 
184         // send token available
185         sendTokenReleasedToBalanceInternal(_token, msg.sender, _vester);
186 
187         // unlock the tokens reserved for this grant
188         balancePerPersonPerToken[_token][msg.sender] = 
189             balancePerPersonPerToken[_token][msg.sender].add(
190                 _grant.vestedAmount.sub(_grant.withdrawnAmount)
191             );
192 
193         // delete the grants
194         delete grantPerTokenGranterVester[_token][msg.sender][_vester];
195 
196         GrantRevoked(msg.sender, _vester, _token);
197     }
198 
199     /**
200      * @dev Send the released token to the user balance and eventually withdraw
201      *
202      * Put the tokens released to the user balance.
203      * If _doWithdraw is true, send the whole balance to the user.
204 
205      * @param _token The address of the token.
206      * @param _granter The address of the granter.
207      * @param _doWithdraw bool, true to withdraw in the same time.
208      */
209     function releaseGrant(address _token, address _granter, bool _doWithdraw) 
210         external
211     {
212         // send token to the vester
213         sendTokenReleasedToBalanceInternal(_token, _granter, msg.sender);
214 
215         if(_doWithdraw) {
216             withdraw(_token);           
217         }
218 
219         // delete grant if fully withdrawn
220         Grant storage _grant = grantPerTokenGranterVester[_token][_granter][msg.sender];
221         if(_grant.vestedAmount == _grant.withdrawnAmount) 
222         {
223             delete grantPerTokenGranterVester[_token][_granter][msg.sender];
224         }
225     }
226 
227     /**
228      * @dev Withdraw tokens avaibable
229      *
230      * The tokens are sent to msg.sender and his balancePerPersonPerToken is updated to zero.
231      * If there is the token transfer fail, the transaction is revert.
232      *
233      * @param _token The address of the token.
234      */
235     function withdraw(address _token) 
236         public
237     {
238         uint amountToSend = balancePerPersonPerToken[_token][msg.sender];
239         balancePerPersonPerToken[_token][msg.sender] = 0;
240         Withdraw(_token, msg.sender, amountToSend);
241         require(ERC20(_token).transfer(msg.sender, amountToSend));
242     }
243 
244     /**
245      * @dev Send the token released to the balance address
246      *
247      * The token released for the address are sent and his withdrawnAmount are updated.
248      * If there is nothing the send, return false.
249      * 
250      * @param _token The address of the token.
251      * @param _granter The address of the granter.
252      * @param _vester The address of the vester.
253      * @return true if tokens have been sent.
254      */
255     function sendTokenReleasedToBalanceInternal(address _token, address _granter, address _vester) 
256         internal
257     {
258         Grant storage _grant = grantPerTokenGranterVester[_token][_granter][_vester];
259         uint256 amountToSend = getBalanceVestingInternal(_grant);
260 
261         // update withdrawnAmount
262         _grant.withdrawnAmount = _grant.withdrawnAmount.add(amountToSend);
263 
264         TokenReleased(_token, _granter, _vester, amountToSend);
265 
266         // send tokens to the vester's balance
267         balancePerPersonPerToken[_token][_vester] = balancePerPersonPerToken[_token][_vester].add(amountToSend); 
268     }
269 
270     /**
271      * @dev Calculate the amount of tokens released for a grant
272      * 
273      * @param _grant Grant information.
274      * @return the number of tokens released.
275      */
276     function getBalanceVestingInternal(Grant _grant)
277         internal
278         constant
279         returns(uint256)
280     {
281         if(now < _grant.cliffTime) 
282         {
283             // the grant didn't start 
284             return 0;
285         }
286         else if(now >= _grant.endTime)
287         {
288             // after the end of the grant release everything
289             return _grant.vestedAmount.sub(_grant.withdrawnAmount);
290         }
291         else
292         {
293             //  token available = vestedAmount * (now - startTime) / (endTime - startTime)  - withdrawnAmount
294             //  => in other words : (number_of_token_granted_per_second * second_since_grant_started) - amount_already_withdraw
295             return _grant.vestedAmount.mul( 
296                         now.sub(_grant.startTime)
297                     ).div(
298                         _grant.endTime.sub(_grant.startTime) 
299                     ).sub(_grant.withdrawnAmount);
300         }
301     }
302 
303     /**
304      * @dev Get the amount of tokens released for a vesting
305      * 
306      * @param _token The address of the token.
307      * @param _granter The address of the granter.
308      * @param _vester The address of the vester.
309      * @return the number of tokens available.
310      */
311     function getVestingBalance(address _token, address _granter, address _vester) 
312         external
313         constant 
314         returns(uint256) 
315     {
316         Grant memory _grant = grantPerTokenGranterVester[_token][_granter][_vester];
317         return getBalanceVestingInternal(_grant);
318     }
319 
320     /**
321      * @dev Get the token balance of the contract
322      * 
323      * @param _token The address of the token.
324      * @param _user The address of the user.
325      * @return the balance of tokens on the contract for _user.
326      */
327     function getContractBalance(address _token, address _user) 
328         external
329         constant 
330         returns(uint256) 
331     {
332         return balancePerPersonPerToken[_token][_user];
333     }
334 
335     /**
336      * @dev Make a deposit of tokens on the contract
337      *
338      * Before using this function the user needs to do a token allowance from the user to the contract.
339      *
340      * @param _token The address of the token.
341      * @param _amount Amount of token to deposit.
342      * 
343      * @return the balance of tokens on the contract for msg.sender.
344      */
345     function deposit(address _token, uint256 _amount) 
346         external
347         returns(uint256) 
348     {
349         require(_token!=0);
350         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
351         balancePerPersonPerToken[_token][msg.sender] = balancePerPersonPerToken[_token][msg.sender].add(_amount);
352         Deposit(_token, msg.sender, _amount, balancePerPersonPerToken[_token][msg.sender]);
353 
354         return balancePerPersonPerToken[_token][msg.sender];
355     }
356 }