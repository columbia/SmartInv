1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     if (a == 0) {
48       return 0;
49     }
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   function totalSupply() public view returns (uint256);
90   function balanceOf(address who) public view returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 
96 contract KcashVesting is Ownable {
97   using SafeMath for uint256;
98 
99   address public teamWallet;
100   address public earlyWallet;
101   address public institutionWallet;
102   
103   uint256 public teamTimeLock = 1000 days;
104   uint256 public earlyTimeLock = 5 * 30 days;
105   uint256 public institutionTimeLock = 50 * 30 days;
106   
107   //amount of allocation
108   uint256 public teamAllocation = 15 * (10 ** 7) * (10 ** 18);
109   uint256 public earlyAllocation = 5 * (10 ** 7) * (10 ** 18);
110   uint256 public institutionAllocation = 15 * (10 ** 7) * (10 ** 18);
111   
112   uint256 public totalAllocation = 35 * (10 ** 7) * (10 ** 18);
113   
114   uint256 public teamStageSetting = 34;
115   uint256 public earlyStageSetting = 5;
116   uint256 public institutionStageSetting = 50;
117   ERC20Basic public token;
118   //token start time
119   uint256 public start;
120   //lock start time
121   uint256 public lockStartTime; 
122    /** Reserve allocations */
123     mapping(address => uint256) public allocations;
124     
125     mapping(address => uint256) public stageSettings;
126     
127     mapping(address => uint256) public timeLockDurations;
128 
129     /** How many tokens each reserve wallet has claimed */
130     mapping(address => uint256) public releasedAmounts;
131     
132     modifier onlyReserveWallets {
133         require(allocations[msg.sender] > 0);
134         _;
135     }
136     function KcashVesting(ERC20Basic _token,
137                           address _teamWallet,
138                           address _earlyWallet,
139                           address _institutionWallet,
140                           uint256 _start,
141                           uint256 _lockTime)public{
142         require(_start > 0);
143         require(_lockTime > 0);
144         require(_start.add(_lockTime) > 0);
145         require(_teamWallet != address(0));
146         require(_earlyWallet != address(0));
147         require(_institutionWallet != address(0));
148         
149         token = _token;
150         teamWallet = _teamWallet;
151         earlyWallet = _earlyWallet;
152         institutionWallet = _institutionWallet;
153         start = _start;
154         lockStartTime = start.add(_lockTime);
155     }
156     
157     function allocateToken() onlyOwner public{
158         require(block.timestamp > lockStartTime);
159         //only claim  once
160         require(allocations[teamWallet] == 0);
161         require(token.balanceOf(address(this)) >= totalAllocation);
162         
163         allocations[teamWallet] = teamAllocation;
164         allocations[earlyWallet] = earlyAllocation;
165         allocations[institutionWallet] = institutionAllocation;
166         
167         stageSettings[teamWallet] = teamStageSetting;
168         stageSettings[earlyWallet] = earlyStageSetting;
169         stageSettings[institutionWallet] = institutionStageSetting;
170         
171         timeLockDurations[teamWallet] = teamTimeLock;
172         timeLockDurations[earlyWallet] = earlyTimeLock;
173         timeLockDurations[institutionWallet] = institutionTimeLock;
174     }
175     function releaseToken() onlyReserveWallets public{
176         uint256 totalUnlocked = unlockAmount();
177         require(totalUnlocked <= allocations[msg.sender]);
178         require(releasedAmounts[msg.sender] < totalUnlocked);
179         uint256 payment = totalUnlocked.sub(releasedAmounts[msg.sender]);
180         
181         releasedAmounts[msg.sender] = totalUnlocked;
182         require(token.transfer(msg.sender, payment));
183     }
184     function unlockAmount() public view onlyReserveWallets returns(uint256){
185         uint256 stage = vestStage();
186         uint256 totalUnlocked = stage.mul(allocations[msg.sender]).div(stageSettings[msg.sender]);
187         return totalUnlocked;
188     }
189     
190     function vestStage() public view onlyReserveWallets returns(uint256){
191         uint256 vestingMonths = timeLockDurations[msg.sender].div(stageSettings[msg.sender]);
192         uint256 stage = (block.timestamp.sub(lockStartTime)).div(vestingMonths);
193         
194         if(stage > stageSettings[msg.sender]){
195             stage = stageSettings[msg.sender];
196         }
197         return stage;
198     }
199 }