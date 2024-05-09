1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 /**
18  * @title SafeERC20
19  * @dev Wrappers around ERC20 operations that throw on failure.
20  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
21  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
22  */
23 library SafeERC20 {
24     function safeTransfer(ERC20 token, address to, uint256 value) internal {
25         require(token.transfer(to, value));
26     }
27 
28     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
29         require(token.transferFrom(from, to, value));
30     }
31 
32     function safeApprove(ERC20 token, address spender, uint256 value) internal {
33         require(token.approve(spender, value));
34     }
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43     /**
44     * @dev Multiplies two numbers, throws on overflow.
45     */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers, truncating the quotient.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         // uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return a / b;
67     }
68 
69     /**
70     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71     */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     /**
78     * @dev Adds two numbers, throws on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81         c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }
86 
87 /// @title Ownable
88 /// @dev The Ownable contract has an owner address, and provides basic
89 ///      authorization control functions, this simplifies the implementation of
90 ///      "user permissions".
91 contract Ownable {
92     address public owner;
93     address[] public managers;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /// @dev The Ownable constructor sets the original `owner` of the contract
98     ///      to the sender.
99     constructor() public {
100         owner = msg.sender;
101         managers.push(msg.sender);
102     }
103 
104     /// @dev Throws if called by any account other than the owner.
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     modifier onlyManager() {
111         require(isManager(msg.sender));
112         _;
113     }
114 
115     function isManager(address manager) view internal returns (bool ok) {
116         for (uint i = 0; i < managers.length; i++) {
117             if (managers[i] == manager) {
118                 return true;
119             }
120         }
121         return false;
122     }
123 
124     function addManager(address manager) onlyOwner public {
125         require(manager != 0x0);
126         require(!isManager(manager));
127         managers.push(manager);
128     }
129 
130     function removeManager(address manager) onlyOwner public {
131         require(manager != 0x0);
132         require(isManager(manager));
133         for (uint i = 0; i < managers.length; i++) {
134             if (managers[i] == manager) {
135                 managers[i] = managers[managers.length - 1];
136                 break;
137             }
138         }
139         managers.length -= 1;
140     }
141 
142     /// @dev Allows the current owner to transfer control of the contract to a
143     ///      newOwner.
144     /// @param newOwner The address to transfer ownership to.
145     function transferOwnership(address newOwner) onlyOwner public returns (bool success) {
146         require(newOwner != 0x0);
147         removeManager(owner);
148         addManager(newOwner);
149         emit OwnershipTransferred(owner, newOwner);
150         owner = newOwner;
151         return true;
152     }
153 }
154 
155 /**
156  * @title Destructible
157  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
158  */
159 contract Destructible is Ownable {
160 
161     constructor() public payable { }
162 
163     /**
164      * @dev Transfers the current balance to the owner and terminates the contract.
165      */
166     function destroy() onlyOwner public {
167         selfdestruct(owner);
168     }
169 
170     function destroyAndSend(address _recipient) onlyOwner public {
171         selfdestruct(_recipient);
172     }
173 }
174 
175 contract LooisCornerstoneHolder is Ownable, Destructible {
176     using SafeMath for uint256;
177     using SafeERC20 for ERC20;
178 
179     ERC20 public token;
180     bool public tokenInitialized;
181     bool public stopInvest;
182     uint256 public totalSupply;
183     uint256 public restSupply;
184     uint256 public releaseTime;
185     uint8 public releasedRoundCount;
186 
187     // release percent of each round
188     uint8 public firstRoundPercent;
189     uint8 public secondRoundPercent;
190     uint8 public thirdRoundPercent;
191     uint8 public fourthRoundPercent;
192 
193     address[] public investors;
194     mapping(address => uint256) public investorAmount;
195     mapping(address => uint256) public releasedAmount;
196 
197     event Release(address indexed _investor, uint256 indexed _value);
198 
199     modifier onlyTokenInitialized() {
200         require(tokenInitialized);
201         _;
202     }
203 
204     constructor(uint8 _firstRoundPercent, uint8 _secondRoundPercent, uint8 _thirdRoundPercent, uint8 _fourthRoundPercent) public {
205         require(_firstRoundPercent + _secondRoundPercent + _thirdRoundPercent + _fourthRoundPercent == 100);
206 
207         firstRoundPercent = _firstRoundPercent;
208         secondRoundPercent = _secondRoundPercent;
209         thirdRoundPercent = _thirdRoundPercent;
210         fourthRoundPercent = _fourthRoundPercent;
211         tokenInitialized = false;
212         stopInvest = false;
213         releasedRoundCount = 0;
214     }
215 
216     function initTokenAndReleaseTime(ERC20 _token, uint256 _releaseTime) onlyOwner public {
217         require(!tokenInitialized);
218         require(_releaseTime > block.timestamp);
219 
220         releaseTime = _releaseTime;
221         token = _token;
222         totalSupply = token.balanceOf(this);
223         restSupply = totalSupply;
224         tokenInitialized = true;
225     }
226 
227     function isInvestor(address _investor) view internal returns (bool ok) {
228         for (uint i = 0; i < investors.length; i++) {
229             if (investors[i] == _investor) {
230                 return true;
231             }
232         }
233         return false;
234     }
235 
236     function addInvestor(address _investor, uint256 _value) onlyManager onlyTokenInitialized public {
237         require(_investor != 0x0);
238         require(_value > 0);
239         require(!stopInvest);
240 
241         uint256 value = 10**18 * _value;
242         if (!isInvestor(_investor)) {
243             require(restSupply > value);
244 
245             investors.push(_investor);
246         } else {
247             require(restSupply + investorAmount[_investor] > value);
248 
249             restSupply = restSupply.add(investorAmount[_investor]);
250         }
251         restSupply = restSupply.sub(value);
252         investorAmount[_investor] = value;
253     }
254 
255     function removeInvestor(address _investor) onlyManager onlyTokenInitialized public {
256         require(_investor != 0x0);
257         require(!stopInvest);
258         require(isInvestor(_investor));
259 
260         for (uint i = 0; i < investors.length; i++) {
261             if (investors[i] == _investor) {
262                 investors[i] = investors[investors.length - 1];
263                 restSupply = restSupply.add(investorAmount[_investor]);
264                 investorAmount[_investor] = 0;
265                 break;
266             }
267         }
268         investors.length -= 1;
269     }
270 
271     function release() onlyManager onlyTokenInitialized public {
272         require(releasedRoundCount <= 3);
273         require(block.timestamp >= releaseTime);
274 
275         uint8 releasePercent;
276         if (releasedRoundCount == 0) {
277             releasePercent = firstRoundPercent;
278         } else if (releasedRoundCount == 1) {
279             releasePercent = secondRoundPercent;
280         } else if (releasedRoundCount == 2) {
281             releasePercent = thirdRoundPercent;
282         } else {
283             releasePercent = fourthRoundPercent;
284         }
285 
286         for (uint8 i = 0; i < investors.length; i++) {
287             address investor = investors[i];
288             uint256 amount = investorAmount[investor];
289             if (amount > 0) {
290                 uint256 releaseAmount = amount.div(100).mul(releasePercent);
291                 if (releasedAmount[investor].add(releaseAmount) > amount) {
292                     releaseAmount = amount.sub(releasedAmount[investor]);
293                 }
294                 token.safeTransfer(investor, releaseAmount);
295                 releasedAmount[investor] = releasedAmount[investor].add(releaseAmount);
296                 emit Release(investor, releaseAmount);
297             }
298         }
299         // Next release time is 30 days later.
300         releaseTime = releaseTime.add(60 * 60 * 24 * 30);
301         releasedRoundCount = releasedRoundCount + 1;
302         stopInvest = true;
303     }
304 
305     // if the balance of this contract is not empty, release all balance to the owner
306     function releaseRestBalance() onlyOwner onlyTokenInitialized public {
307         require(releasedRoundCount > 3);
308         uint256 balance = token.balanceOf(this);
309         require(balance > 0);
310 
311         token.safeTransfer(owner, balance);
312         emit Release(owner, balance);
313     }
314 
315     // if the balance of this contract is not empty, release all balance to a recipient
316     function releaseRestBalanceAndSend(address _recipient) onlyOwner onlyTokenInitialized public {
317         require(_recipient != 0x0);
318         require(releasedRoundCount > 3);
319         uint256 balance = token.balanceOf(this);
320         require(balance > 0);
321 
322         token.safeTransfer(_recipient, balance);
323         emit Release(_recipient, balance);
324     }
325 }