1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: contracts/Upcoin.sol
120 
121 contract Upcoin {
122     uint8 public decimals = 18;
123 
124     function isUpcoin() public pure returns (bool);
125     function transferOrigin(address _to, uint256 _value) public returns (bool);
126 }
127 
128 // File: contracts/Lottery.sol
129 
130 contract Lottery is Ownable {
131     using SafeMath for uint256;
132 
133     event LotteryFinished();
134     event Roll(address indexed participant, uint256 prize);
135 
136     struct Prize {
137         uint256 chance;
138         uint256 left;
139         uint256 min;
140         uint256 max;
141     }
142 
143     bool public lotteryFinished = false;
144 
145     uint256 private randomCount = 0;
146 
147     Prize[] private prizes;
148     Upcoin private upcoin;
149 
150 
151     modifier canRoll() {
152         require(!lotteryFinished, "Lottery already finished");
153         _;
154     }
155 
156     modifier hasPrizes() {
157         uint256 left = prizes[0].left;
158 
159         for (uint256 i = 1; i < prizes.length; i = i.add(1)) {
160             if (prizes[i].left > left) {
161                 left = prizes[i].left;
162             }
163         }
164 
165         require(left > 0, "No more prizes left");
166         _;
167     }
168 
169     modifier isUpcoin() {
170         require(address(upcoin) != address(0), "Token address must be not null");
171         require(upcoin.isUpcoin(), "Token must be Upcoin instance");
172         _;
173     }
174 
175     constructor(address _address) public {
176         upcoin = Upcoin(_address);
177 
178         prizes.push(Prize(2, 1, 500000, 500000));
179         prizes.push(Prize(4, 3, 12001, 75000));
180         prizes.push(Prize(6, 6, 5001, 12000));
181         prizes.push(Prize(10, 40, 3001, 5000));
182         prizes.push(Prize(15, 50, 1001, 3000));
183         prizes.push(Prize(18, 400, 501, 1000));
184         prizes.push(Prize(20, 500, 251, 500));
185         prizes.push(Prize(25, 29000, 100, 250));
186     }
187 
188     function finishLottery() public canRoll onlyOwner returns (bool) {
189         lotteryFinished = true;
190 
191         emit LotteryFinished();
192 
193         return true;
194     }
195 
196     function getRandomPrize() private returns (Prize) {
197         uint256 chance = randomMinMax(0, 100);
198 
199         uint256 index = 0;
200         uint256 percent = 0;
201 
202         while (prizes[index].left == 0) {
203             percent = percent.add(prizes[index].chance);
204 
205             index = index.add(1);
206         }
207 
208         Prize memory prize = prizes[index];
209 
210         uint256 start = index.add(1);
211 
212         if (start < prizes.length && chance > percent + prize.chance) {
213             percent = percent.add(prize.chance);
214 
215             for (uint256 i = start; i < prizes.length; i = i.add(1)) {
216                 prize.chance = prizes[i].chance;
217 
218                 if (prizes[i].left > 0 && chance <= percent + prize.chance) {
219                     prize = prizes[i];
220 
221                     index = i;
222 
223                     break;
224                 } else {
225                     percent = percent.add(prize.chance);
226                 }
227             }
228         }
229 
230         prize.left = prize.left.sub(1);
231 
232         prizes[index] = prize;
233 
234         return prize;
235     }
236 
237     function getRandomAmount(uint256 _min, uint256 _max) private returns (uint256) {
238         return randomMinMax(_min, _max) * 10 ** uint256(upcoin.decimals());
239     }
240 
241     function random() private returns (uint256) {
242         uint256 randomness = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), randomCount)));
243 
244         randomCount = randomCount.add(1);
245 
246         return randomness;
247     }
248 
249     function randomMinMax(uint256 _min, uint256 _max) private returns (uint256) {
250         if (_min == _max) {
251             return _max;
252         }
253 
254         if (_min > _max) {
255             (_min, _max) = (_max, _min);
256         }
257 
258         uint256 value = random() % _max;
259 
260         if (value < _min) {
261             value = _min + random() % (_max - _min);
262         }
263 
264         return value;
265     }
266 
267     function roll(address _address) public onlyOwner canRoll hasPrizes isUpcoin returns (bool) {
268         require(_address != address(0), "Participant address must be not null");
269 
270         Prize memory prize = getRandomPrize();
271 
272         uint256 amount = getRandomAmount(prize.min, prize.max);
273 
274         upcoin.transferOrigin(_address, amount);
275 
276         emit Roll(_address, amount);
277 
278         return true;
279     }
280 }