1 pragma solidity ^0.4.24;
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract ERC20 {
55     uint public totalSupply;
56 
57     mapping(address => uint) balances;
58     mapping(address => mapping (address => uint)) allowed;
59 
60     function balanceOf(address _owner) view returns (uint);
61     function transfer(address _to, uint _value) returns (bool);
62     function transferFrom(address _from, address _to, uint _value) returns (bool);
63     function approve(address _spender, uint _value) returns (bool);
64     function allowance(address _owner, address _spender) view returns (uint);
65 
66     event Transfer(address indexed _from, address indexed _to, uint _value);
67     event Approval(address indexed _owner, address indexed _spender, uint _value);
68 
69 }
70 
71 contract Ownable {
72     address public owner;
73 
74     constructor() public {
75         owner = tx.origin;
76     }
77 
78     modifier onlyOwner() {
79         require(msg.sender == owner, 'ownership is required');
80         _;
81     }
82 }
83 
84 contract BaseTokenVesting is Ownable() {
85     using SafeMath for uint;
86 
87     address public beneficiary;
88     ERC20 public token;
89 
90     bool public vestingHasStarted;
91     uint public start;
92     uint public cliff;
93     uint public vestingPeriod;
94 
95     uint public released;
96 
97     event Released(uint _amount);
98 
99     constructor(
100 		address _benificiary,
101 		uint _cliff,
102 		uint _vestingPeriod,
103 		address _token
104 	) internal 
105 	{
106         require(_benificiary != address(0), 'can not send to zero-address');
107 
108         beneficiary = _benificiary;
109         cliff = _cliff;
110         vestingPeriod = _vestingPeriod;
111         token = ERC20(_token);
112     }
113 
114     function startVesting() public onlyOwner {
115         vestingHasStarted = true;
116         start = now;
117         cliff = cliff.add(start);
118     }
119 
120     function sendTokens(address _to, uint _amount) public onlyOwner {
121         require(vestingHasStarted == false, 'send tokens only if vesting has not been started');
122         require(token.transfer(_to, _amount), 'token.transfer has failed');
123     }
124 
125     function release() public;
126 
127     function releasableAmount() public view returns (uint _amount);
128 
129     function vestedAmount() public view returns (uint _amount);
130 }
131 
132 contract TokenVestingWithConstantPercent is BaseTokenVesting {
133 
134     uint public periodPercent;
135 
136     constructor(
137         address _benificiary,
138         uint _cliff,
139         uint _vestingPeriod,
140         address _tokenAddress,
141         uint _periodPercent
142     ) 
143         BaseTokenVesting(_benificiary, _cliff, _vestingPeriod, _tokenAddress)
144         public 
145     {
146         periodPercent = _periodPercent;
147     }
148 
149     function release() public {
150         require(vestingHasStarted, 'vesting has not started');
151         uint unreleased = releasableAmount();
152 
153         require(unreleased > 0, 'released amount has to be greter than zero');
154         require(token.transfer(beneficiary, unreleased), 'revert on transfer failure');
155         released = released.add(unreleased);
156         emit Released(unreleased);
157     }
158 
159 
160     function releasableAmount() public view returns (uint _amount) {
161         _amount = vestedAmount().sub(released);
162     }
163 
164     function vestedAmount() public view returns (uint _amount) {
165         uint currentBalance = token.balanceOf(this);
166         uint totalBalance = currentBalance.add(released);
167 
168         if (now < cliff || !vestingHasStarted) {
169             _amount = 0;
170         }
171         else if (now.sub(cliff).div(vestingPeriod).mul(periodPercent) > 100) {
172             _amount = totalBalance;
173         }
174         else {
175             _amount = totalBalance.mul(now.sub(cliff).div(vestingPeriod).mul(periodPercent)).div(100);
176         }
177     }
178 
179     
180 
181 }
182 
183 contract TokenVestingWithFloatingPercent is BaseTokenVesting {
184 	
185     uint[] public periodPercents;
186 
187     constructor(
188         address _benificiary,
189         uint _cliff,
190         uint _vestingPeriod,
191         address _tokenAddress,
192         uint[] _periodPercents
193     ) 
194         BaseTokenVesting(_benificiary, _cliff, _vestingPeriod, _tokenAddress)
195         public 
196     {
197         uint sum = 0;
198         for (uint i = 0; i < _periodPercents.length; i++) {
199             sum = sum.add(_periodPercents[i]);
200         }
201         require(sum == 100, 'percentage sum must be equal to 100');
202 
203         periodPercents = _periodPercents;
204     }
205 
206     function release() public {
207         require(vestingHasStarted, 'vesting has not started');
208         uint unreleased = releasableAmount();
209 
210         require(unreleased > 0, 'released amount has to be greter than zero');
211         require(token.transfer(beneficiary, unreleased), 'revert on transfer failure');
212         released = released.add(unreleased);
213         emit Released(unreleased);	
214     }
215 
216     function releasableAmount() public view returns (uint _amount) {
217         _amount = vestedAmount().sub(released);
218     }
219 
220     function vestedAmount() public view returns (uint _amount) {
221         uint currentBalance = token.balanceOf(this);
222         uint totalBalance = currentBalance.add(released);
223 
224         if (now < cliff || !vestingHasStarted) {
225             _amount = 0;
226         }
227         else {
228             uint _periodPercentsIndex = now.sub(cliff).div(vestingPeriod);
229             if (_periodPercentsIndex > periodPercents.length.sub(1)) {
230                 _amount = totalBalance;
231             }
232             else {
233                 if (_periodPercentsIndex >= 1) {
234                     uint totalPercent = 0;
235                     for (uint i = 0; i < _periodPercentsIndex - 1; i++) {
236                         totalPercent = totalPercent + periodPercents[i];
237                     }
238                     _amount = totalBalance.mul(totalPercent).div(100);
239                 }
240             }
241         }
242     }
243 
244 }
245 
246 contract TokenVestingFactory is Ownable() {
247     event VestingContractCreated(address indexed _creator, address indexed _contract);
248 
249     mapping(address => address) public investorToVesting;
250 
251     function createVestingContractWithConstantPercent(
252         address _benificiary,
253         uint _cliff,
254         uint _vestingPeriod,
255         address _tokenAddress,
256         uint _periodPercent
257 	)
258 	public
259     onlyOwner
260 	returns (address vestingContract)
261 	{		
262         vestingContract = new TokenVestingWithConstantPercent(
263 			_benificiary,
264 			_cliff,
265 			_vestingPeriod,
266 			_tokenAddress,
267 			_periodPercent
268         );
269         investorToVesting[_benificiary] = vestingContract;
270         emit VestingContractCreated(tx.origin, vestingContract);
271     }
272 
273     function createVestingContractWithFloatingPercent(
274         address _benificiary,
275         uint _cliff,
276         uint _vestingPeriod,
277         address _tokenAddress,
278         uint[] _periodPercents	
279 	)
280 	public
281     onlyOwner
282 	returns (address vestingContract) 
283 	{
284         vestingContract = new TokenVestingWithFloatingPercent(
285             _benificiary, 
286             _cliff,
287             _vestingPeriod,
288             _tokenAddress,
289             _periodPercents
290         );
291         investorToVesting[_benificiary] = vestingContract;
292         emit VestingContractCreated(tx.origin, vestingContract);
293     }
294 }