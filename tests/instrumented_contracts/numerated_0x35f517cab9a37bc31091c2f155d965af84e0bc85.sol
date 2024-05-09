1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address _who) public view returns (uint256);
109   function transfer(address _to, uint256 _value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 library SafeERC20 {
129   function safeTransfer(
130     ERC20Basic _token,
131     address _to,
132     uint256 _value
133   )
134     internal
135   {
136     require(_token.transfer(_to, _value));
137   }
138 
139   function safeTransferFrom(
140     ERC20 _token,
141     address _from,
142     address _to,
143     uint256 _value
144   )
145     internal
146   {
147     require(_token.transferFrom(_from, _to, _value));
148   }
149 
150   function safeApprove(
151     ERC20 _token,
152     address _spender,
153     uint256 _value
154   )
155     internal
156   {
157     require(_token.approve(_spender, _value));
158   }
159 }
160 
161 contract TokenContinuousDistribution is Ownable {
162     using SafeMath for uint256;
163     using SafeERC20 for ERC20Basic;
164 
165     event Released(ERC20Basic token, uint256 amount);
166 
167     // beneficiary of tokens after they are released
168     address public beneficiary;
169 
170     uint256 public cliff;
171     uint256 public start;
172     uint256 public endTime;
173     // 1 day = 86400 seconds
174     uint256 public secondsIn1Unit = 86400;
175     // 365 days * 5 = 1825 time units
176     uint256 public numberOfUnits = 1825;
177     // 86400 * 1825
178     uint256 public duration = 157680000;
179 
180     //1st interval gets 5/15*total balance allowed, 2nd gets 4/15*TBA, 3rd gets 3*TBA, 4th gets 2*TBA, 5th gets 1*TBA
181     uint256 numberOfPhases = 5;
182     // 15=5+4+3+2+1
183     uint256 slice = 15;
184 
185     mapping(address => uint256) public released;
186 
187     /**
188      * @dev Creates a continuous distribution contract that distributes its balance of any ERC20 token to the
189      * _beneficiary, gradually in a linear fashion until _start + _duration,
190      * where _duration is the result of secondsIn1Unit*numberOfUnits
191      * By then all of the balance will have distributed.
192      * @param _beneficiary address of the beneficiary to whom distributed tokens are transferred
193      * @param _start the time (as Unix time) at which point continuous distribution starts
194      * @param _cliff duration in seconds of the cliff in which tokens will begin to continuous-distribute
195      */
196     constructor(
197         address _beneficiary,
198         uint256 _start,
199         uint256 _cliff
200     )
201     public
202     {
203         require(_beneficiary != address(0), "Beneficiary address should NOT be null.");
204         require(_cliff <= duration, "Cliff should be less than or equal to duration (i.e. secondsIn1Unit.mul(numberOfUnits)).");
205         require((numberOfUnits % 5) == 0, "numberOfUnits should be a multiple of 5");
206 
207 
208         beneficiary = _beneficiary;
209         cliff = _start.add(_cliff);
210         start = _start;
211         endTime = _start.add(duration);
212     }
213 
214     /**
215      * @notice Transfers distributed tokens to beneficiary.
216      * @param token ERC20 token which is being distributed
217      */
218     function release(ERC20Basic token) public {
219         uint256 unreleased = releasableAmount(token);
220 
221         require(unreleased > 0, "Unreleased amount should be larger than 0.");
222 
223         released[token] = released[token].add(unreleased);
224 
225         token.safeTransfer(beneficiary, unreleased);
226 
227         emit Released(token, unreleased);
228     }
229 
230     /**
231      * @dev Calculates the amount that has already distributed but hasn't been released yet.
232      * @param token ERC20 token which is being distributed
233      */
234     function releasableAmount(ERC20Basic token) public view returns (uint256) {
235         return distributedAmount(token).sub(released[token]);
236     }
237 
238     /**
239      * @dev Calculates the amount that has already distributed.
240      * @param token ERC20 token which is being distributed
241      */
242     function distributedAmount(ERC20Basic token) public view returns (uint256) {
243         uint256 blockTimestamp = block.timestamp;
244         return distributedAmountWithBlockTimestamp(token, blockTimestamp);
245     }
246 
247 
248     function distributedAmountWithBlockTimestamp(ERC20Basic token, uint256 blockTimestamp) public view returns (uint256) {
249         uint256 currentBalance = token.balanceOf(this);
250         uint256 totalBalance = currentBalance.add(released[token]);
251 
252         if (blockTimestamp < cliff) {
253             return 0;
254         } else if (blockTimestamp >= endTime) {
255             return totalBalance;
256         } else {
257             uint256 unitsPassed = blockTimestamp.sub(start).div(secondsIn1Unit); // number of time unit passed, remember unit is usually 'day'
258             uint256 unitsIn1Phase = numberOfUnits.div(numberOfPhases); // remember unit is usually 'day'
259             uint256 unitsInThisPhase;
260             uint256 weight;
261 
262             if (unitsPassed < unitsIn1Phase) {
263                 weight = 5;
264                 unitsInThisPhase = unitsPassed;
265                 // delay division to last step to keep precision
266                 return unitsInThisPhase.mul(totalBalance).mul(weight).div(slice).div(unitsIn1Phase);
267             } else if (unitsPassed < unitsIn1Phase.mul(2)) {
268                 weight = 4;
269                 unitsInThisPhase = unitsPassed.sub(unitsIn1Phase);
270                 // "5" because we have everything in the previous phase 
271                 // and note div(slice) is moved to the end, (x+y).div(slice) => x.div(slice).add(y.div(slice))
272                 return totalBalance.mul(5).add(unitsInThisPhase.mul(totalBalance).mul(weight).div(unitsIn1Phase)).div(slice);
273             } else if (unitsPassed < unitsIn1Phase.mul(3)) {
274                 weight = 3;
275                 unitsInThisPhase = unitsPassed.sub(unitsIn1Phase.mul(2));
276                 // "9" because we have everything in the previous phase = 5+4
277                 // and note div(slice) is moved to the end, (x+y).div(slice) => x.div(slice).add(y.div(slice))
278                 return totalBalance.mul(9).add(unitsInThisPhase.mul(totalBalance).mul(weight).div(unitsIn1Phase)).div(slice);
279             } else if (unitsPassed < unitsIn1Phase.mul(4)) {
280                 weight = 2;
281                 unitsInThisPhase = unitsPassed.sub(unitsIn1Phase.mul(3));
282                 // "12" because we have everything in the previous phase = 5+4+3
283                 // and note div(slice) is moved to the end, (x+y).div(slice) => x.div(slice).add(y.div(slice))
284                 return totalBalance.mul(12).add(unitsInThisPhase.mul(totalBalance).mul(weight).div(unitsIn1Phase)).div(slice);
285             } else if (unitsPassed < unitsIn1Phase.mul(5)) {
286                 weight = 1;
287                 unitsInThisPhase = unitsPassed.sub(unitsIn1Phase.mul(4));
288                 // "14" because we have everything in the previous phase = 5+4+3+2
289                 // and note div(slice) is moved to the end, (x+y).div(slice) => x.div(slice).add(y.div(slice))
290                 return totalBalance.mul(14).add(unitsInThisPhase.mul(totalBalance).mul(weight).div(unitsIn1Phase)).div(slice);
291             }
292             require(blockTimestamp < endTime, "Block timestamp is expected to have not reached distribution endTime if the code even falls in here.");
293         }
294     }
295 }