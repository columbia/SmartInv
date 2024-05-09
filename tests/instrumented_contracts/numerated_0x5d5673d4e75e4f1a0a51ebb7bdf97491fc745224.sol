1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Math
55  * @dev Assorted math operations
56  */
57 library Math {
58   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
59     return a >= b ? a : b;
60   }
61 
62   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
63     return a < b ? a : b;
64   }
65 
66   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
67     return a >= b ? a : b;
68   }
69 
70   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
71     return a < b ? a : b;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * See https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender)
93     public view returns (uint256);
94 
95   function transferFrom(address from, address to, uint256 value)
96     public returns (bool);
97 
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 /// @title BibBom Token Holding Incentive Program
107 /// @author TranTho - <thoff@bigbom.com>.
108 /// For more information, please visit https://bigbom.com.
109 contract BBOHoldingContract {
110     using SafeMath for uint;
111     using Math for uint;
112    
113     // During the first 60 days of deployment, this contract opens for deposit of BBO.
114     uint public constant DEPOSIT_PERIOD             = 60 days; // = 2 months
115 
116     // 18 months after deposit, user can withdrawal all or part of his/her BBO with bonus.
117     // The bonus is this contract's initial BBO balance.
118     uint public constant WITHDRAWAL_DELAY           = 360 days; // = 1 year 
119 
120     // Send 0.001ETH per 10000 BBO partial withdrawal, or 0 for a once-for-all withdrawal.
121     // All ETH will be returned.
122     uint public constant WITHDRAWAL_SCALE           = 1E7; // 1ETH for withdrawal of 10,000,000 BBO.
123 
124     // Ower can drain all remaining BBO after 3 years.
125     uint public constant DRAIN_DELAY                = 720 days; // = 2 years.
126     
127     address public bboTokenAddress  = 0x0;
128     address public owner            = 0x0;
129 
130     uint public bboDeposited        = 0;
131     uint public depositStartTime    = 0;
132     uint public depositStopTime     = 0;
133 
134     struct Record {
135         uint bboAmount;
136         uint timestamp;
137     }
138 
139     mapping (address => Record) records;
140     
141     /* 
142      * EVENTS
143      */
144 
145     /// Emitted when program starts.
146     event Started(uint _time);
147 
148     /// Emitted when all BBO are drained.
149     event Drained(uint _bboAmount);
150 
151     /// Emitted for each sucuessful deposit.
152     uint public depositId = 0;
153     event Deposit(uint _depositId, address indexed _addr, uint _bboAmount);
154 
155     /// Emitted for each sucuessful deposit.
156     uint public withdrawId = 0;
157     event Withdrawal(uint _withdrawId, address indexed _addr, uint _bboAmount);
158 
159     /// @dev Initialize the contract
160     /// @param _bboTokenAddress BBO ERC20 token address
161     constructor (address _bboTokenAddress, address _owner) public {
162         require(_bboTokenAddress != address(0));
163         require(_owner != address(0));
164 
165         bboTokenAddress = _bboTokenAddress;
166         owner = _owner;
167     }
168 
169     /*
170      * PUBLIC FUNCTIONS
171      */
172 
173     /// @dev start the program.
174     function start() public {
175         require(msg.sender == owner);
176         require(depositStartTime == 0);
177 
178         depositStartTime = now;
179         depositStopTime  = depositStartTime + DEPOSIT_PERIOD;
180 
181         emit Started(depositStartTime);
182     }
183 
184 
185     /// @dev drain BBO.
186     function drain() public {
187         require(msg.sender == owner);
188         require(depositStartTime > 0 && now >= depositStartTime + DRAIN_DELAY);
189 
190         uint balance = bboBalance();
191         require(balance > 0);
192 
193         require(ERC20(bboTokenAddress).transfer(owner, balance));
194 
195         emit Drained(balance);
196     }
197 
198     function () payable {
199         require(depositStartTime > 0);
200 
201         if (now >= depositStartTime && now <= depositStopTime) {
202             depositBBO();
203         } else if (now > depositStopTime){
204             withdrawBBO();
205         } else {
206             revert();
207         }
208     }
209 
210     /// @return Current BBO balance.
211     function bboBalance() public constant returns (uint) {
212         return ERC20(bboTokenAddress).balanceOf(address(this));
213     }
214     function holdBalance() public constant returns (uint) {
215         return records[msg.sender].bboAmount;
216     }
217     function lastDeposit() public constant returns (uint) {
218         return records[msg.sender].timestamp;
219     }
220     /// @dev Deposit BBO.
221     function depositBBO() payable {
222         require(depositStartTime > 0);
223         require(msg.value == 0);
224         require(now >= depositStartTime && now <= depositStopTime);
225         
226         ERC20 bboToken = ERC20(bboTokenAddress);
227         uint bboAmount = bboToken
228             .balanceOf(msg.sender)
229             .min256(bboToken.allowance(msg.sender, address(this)));
230 
231         if(bboAmount > 0){
232             require(bboToken.transferFrom(msg.sender, address(this), bboAmount));
233             Record storage record = records[msg.sender];
234             record.bboAmount = record.bboAmount.add(bboAmount);
235             record.timestamp = now;
236             records[msg.sender] = record;
237 
238             bboDeposited = bboDeposited.add(bboAmount);
239             emit Deposit(depositId++, msg.sender, bboAmount);
240         }
241     }
242 
243     /// @dev Withdrawal BBO.
244     function withdrawBBO() payable {
245         require(depositStartTime > 0);
246         require(bboDeposited > 0);
247 
248         Record storage record = records[msg.sender];
249         require(now >= record.timestamp + WITHDRAWAL_DELAY);
250         require(record.bboAmount > 0);
251 
252         uint bboWithdrawalBase = record.bboAmount;
253         if (msg.value > 0) {
254             bboWithdrawalBase = bboWithdrawalBase
255                 .min256(msg.value.mul(WITHDRAWAL_SCALE));
256         }
257 
258         uint bboBonus = getBonus(bboWithdrawalBase);
259         uint balance = bboBalance();
260         uint bboAmount = balance.min256(bboWithdrawalBase + bboBonus);
261         
262         bboDeposited = bboDeposited.sub(bboWithdrawalBase);
263         record.bboAmount = record.bboAmount.sub(bboWithdrawalBase);
264 
265         if (record.bboAmount == 0) {
266             delete records[msg.sender];
267         } else {
268             records[msg.sender] = record;
269         }
270 
271         emit Withdrawal(withdrawId++, msg.sender, bboAmount);
272 
273         require(ERC20(bboTokenAddress).transfer(msg.sender, bboAmount));
274         if (msg.value > 0) {
275             msg.sender.transfer(msg.value);
276         }
277     }
278 
279     function getBonus(uint _bboWithdrawalBase) constant returns (uint) {
280         return internalCalculateBonus(bboBalance() - bboDeposited,bboDeposited, _bboWithdrawalBase);
281     }
282 
283     function internalCalculateBonus(uint _totalBonusRemaining, uint _bboDeposited, uint _bboWithdrawalBase) constant returns (uint) {
284         require(_bboDeposited > 0);
285         require(_totalBonusRemaining >= 0);
286 
287         // The bonus is non-linear function to incentivize later withdrawal.
288         // bonus = _totalBonusRemaining * power(_bboWithdrawalBase/_bboDeposited, 1.0625)
289         return _totalBonusRemaining
290             .mul(_bboWithdrawalBase.mul(sqrt(sqrt(sqrt(sqrt(_bboWithdrawalBase))))))
291             .div(_bboDeposited.mul(sqrt(sqrt(sqrt(sqrt(_bboDeposited))))));
292     }
293 
294     function sqrt(uint x) internal constant returns (uint) {
295         uint y = x;
296         while (true) {
297             uint z = (y + (x / y)) / 2;
298             uint w = (z + (x / z)) / 2;
299             if (w == y) {
300                 if (w < y) return w;
301                 else return y;
302             }
303             y = w;
304         }
305     }
306 }