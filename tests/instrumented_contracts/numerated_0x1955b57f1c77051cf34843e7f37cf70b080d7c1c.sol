1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity-1.4/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/zeppelin-solidity-1.4/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts/BRDLockup.sol
83 
84 /**
85  * Contract BRDLockup keeps track of a vesting schedule for pre-sold tokens.
86  * Pre-sold tokens are rewarded up to `numIntervals` times separated by an
87  * `interval` of time. An equal amount of tokens (`allocation` divided by `numIntervals`)
88  * is marked for reward each `interval`.
89  *
90  * The owner of the contract will call processInterval() which will
91  * update the allocation state. The owner of the contract should then
92  * read the allocation data and reward the beneficiaries.
93  */
94 contract BRDLockup is Ownable {
95   using SafeMath for uint256;
96 
97   // Allocation stores info about how many tokens to reward a beneficiary account
98   struct Allocation {
99     address beneficiary;      // account to receive rewards
100     uint256 allocation;       // total allocated tokens
101     uint256 remainingBalance; // remaining balance after the current interval
102     uint256 currentInterval;  // the current interval for the given reward
103     uint256 currentReward;    // amount to be rewarded during the current interval
104   }
105 
106   // the allocation state
107   Allocation[] public allocations;
108 
109   // the date at which allocations begin unlocking
110   uint256 public unlockDate;
111 
112   // the current unlock interval
113   uint256 public currentInterval;
114 
115   // the interval at which allocations will be rewarded
116   uint256 public intervalDuration;
117 
118   // the number of total reward intervals, zero indexed
119   uint256 public numIntervals;
120 
121   event Lock(address indexed _to, uint256 _amount);
122 
123   event Unlock(address indexed _to, uint256 _amount);
124 
125   // constructor
126   // @param _crowdsaleEndDate - the date the crowdsale ends
127   function BRDLockup(uint256 _crowdsaleEndDate, uint256 _numIntervals, uint256 _intervalDuration)  public {
128     unlockDate = _crowdsaleEndDate;
129     numIntervals = _numIntervals;
130     intervalDuration = _intervalDuration;
131     currentInterval = 0;
132   }
133 
134   // update the allocation storage remaining balances
135   function processInterval() onlyOwner public returns (bool _shouldProcessRewards) {
136     // ensure the time interval is correct
137     bool _correctInterval = now >= unlockDate && now.sub(unlockDate) > currentInterval.mul(intervalDuration);
138     bool _validInterval = currentInterval < numIntervals;
139     if (!_correctInterval || !_validInterval)
140       return false;
141 
142     // advance the current interval
143     currentInterval = currentInterval.add(1);
144 
145     // number of iterations to read all allocations
146     uint _allocationsIndex = allocations.length;
147 
148     // loop through every allocation
149     for (uint _i = 0; _i < _allocationsIndex; _i++) {
150       // the current reward for the allocation at index `i`
151       uint256 _amountToReward;
152 
153       // if we are at the last interval, the reward amount is the entire remaining balance
154       if (currentInterval == numIntervals) {
155         _amountToReward = allocations[_i].remainingBalance;
156       } else {
157         // otherwise the reward amount is the total allocation divided by the number of intervals
158         _amountToReward = allocations[_i].allocation.div(numIntervals);
159       }
160       // update the allocation storage
161       allocations[_i].currentReward = _amountToReward;
162     }
163 
164     return true;
165   }
166 
167   // the total number of allocations
168   function numAllocations() constant public returns (uint) {
169     return allocations.length;
170   }
171 
172   // the amount allocated for beneficiary at `_index`
173   function allocationAmount(uint _index) constant public returns (uint256) {
174     return allocations[_index].allocation;
175   }
176 
177   // reward the beneficiary at `_index`
178   function unlock(uint _index) onlyOwner public returns (bool _shouldReward, address _beneficiary, uint256 _rewardAmount) {
179     // ensure the beneficiary is not rewarded twice during the same interval
180     if (allocations[_index].currentInterval < currentInterval) {
181       // record the currentInterval so the above check is useful
182       allocations[_index].currentInterval = currentInterval;
183       // subtract the reward from their remaining balance
184       allocations[_index].remainingBalance = allocations[_index].remainingBalance.sub(allocations[_index].currentReward);
185       // emit event
186       Unlock(allocations[_index].beneficiary, allocations[_index].currentReward);
187       // return value
188       _shouldReward = true;
189     } else {
190       // return value
191       _shouldReward = false;
192     }
193 
194     // return values
195     _rewardAmount = allocations[_index].currentReward;
196     _beneficiary = allocations[_index].beneficiary;
197   }
198 
199   // add a new allocation to the lockup
200   function pushAllocation(address _beneficiary, uint256 _numTokens) onlyOwner public {
201     require(now < unlockDate);
202     allocations.push(
203       Allocation(
204         _beneficiary,
205         _numTokens,
206         _numTokens,
207         0,
208         0
209       )
210     );
211     Lock(_beneficiary, _numTokens);
212   }
213 }