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
96 contract TestVesting is Ownable {
97   using SafeMath for uint256;
98 
99   address public teamWallet;
100  
101   
102   uint256 public teamTimeLock = 60 minutes;
103  
104   
105   //amount of allocation
106   uint256 public teamAllocation = 3 * (10 ** 1) * (10 ** 5);
107   
108   uint256 public totalAllocation = 3 * (10 ** 1) * (10 ** 5);
109   
110   uint256 public teamStageSetting = 6;
111   
112   ERC20Basic public token;
113   //token start time
114   uint256 public start;
115   //lock start time
116   uint256 public lockStartTime; 
117    /** Reserve allocations */
118     mapping(address => uint256) public allocations;
119     
120     mapping(address => uint256) public stageSettings;
121     
122     mapping(address => uint256) public timeLockDurations;
123 
124     /** How many tokens each reserve wallet has claimed */
125     mapping(address => uint256) public releasedAmounts;
126     
127     modifier onlyReserveWallets {
128         require(allocations[msg.sender] > 0);
129         _;
130     }
131     function TestVesting(ERC20Basic _token,
132                           address _teamWallet,
133                           uint256 _start,
134                           uint256 _lockTime)public{
135         require(_start > 0);
136         require(_lockTime > 0);
137         require(_start.add(_lockTime) > 0);
138         require(_teamWallet != address(0));
139         
140         token = _token;
141         teamWallet = _teamWallet;
142       
143         start = _start;
144         lockStartTime = start.add(_lockTime);
145     }
146     
147     function allocateToken() onlyOwner public{
148         require(block.timestamp > lockStartTime);
149         //only claim  once
150         require(allocations[teamWallet] == 0);
151         require(token.balanceOf(address(this)) >= totalAllocation);
152         
153         allocations[teamWallet] = teamAllocation;
154         
155         stageSettings[teamWallet] = teamStageSetting;
156        
157         timeLockDurations[teamWallet] = teamTimeLock;
158        
159     }
160     function releaseToken() onlyReserveWallets public{
161         uint256 totalUnlocked = unlockAmount();
162         require(totalUnlocked <= allocations[msg.sender]);
163         require(releasedAmounts[msg.sender] < totalUnlocked);
164         uint256 payment = totalUnlocked.sub(releasedAmounts[msg.sender]);
165         
166         releasedAmounts[msg.sender] = totalUnlocked;
167         require(token.transfer(msg.sender, payment));
168     }
169     function unlockAmount() public view onlyReserveWallets returns(uint256){
170         uint256 stage = vestStage();
171         uint256 totalUnlocked = stage.mul(allocations[msg.sender]).div(stageSettings[msg.sender]);
172         return totalUnlocked;
173     }
174     
175     function vestStage() public view onlyReserveWallets returns(uint256){
176         uint256 vestingMonths = timeLockDurations[msg.sender].div(stageSettings[msg.sender]);
177         uint256 stage = (block.timestamp.sub(lockStartTime)).div(vestingMonths);
178         
179         if(stage > stageSettings[msg.sender]){
180             stage = stageSettings[msg.sender];
181         }
182         return stage;
183     }
184 }