1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 contract SimpleTGE is Ownable {
73   using SafeMath for uint256;
74 
75   // start and end timestamps (both inclusive) when sale is open
76   uint256 public publicTGEStartBlockTimeStamp;
77 
78   uint256 public publicTGEEndBlockTimeStamp;
79 
80   // address where funds are collected
81   address public fundsWallet;
82 
83   // amount of raised money in wei
84   uint256 public weiRaised;
85 
86   // sale cap in wei
87   uint256 public totalCapInWei;
88 
89   // individual cap in wei
90   uint256 public individualCapInWei;
91 
92   // how long the TRS subscription is open after the TGE.
93   uint256 public TRSOffset = 5 days;
94 
95   mapping (address => bool) public whitelist;
96 
97   address[] public contributors;
98   struct Contribution {
99     bool hasVested;
100     uint256 weiContributed;
101   }
102 
103   mapping (address => Contribution)  public contributions;
104 
105   modifier whilePublicTGEIsActive() {
106     require(block.timestamp >= publicTGEStartBlockTimeStamp && block.timestamp <= publicTGEEndBlockTimeStamp);
107     _;
108   }
109 
110   modifier isWhitelisted() {
111     require(whitelist[msg.sender]);
112     _;
113   }
114 
115   function blacklistAddresses(address[] addrs) external onlyOwner returns(bool) {
116     require(addrs.length <= 100);
117     for (uint i = 0; i < addrs.length; i++) {
118       require(addrs[i] != address(0));
119       whitelist[addrs[i]] = false;
120     }
121     return true;
122   }
123 
124   function whitelistAddresses(address[] addrs) external onlyOwner returns(bool) {
125     require(addrs.length <= 100);
126     for (uint i = 0; i < addrs.length; i++) {
127       require(addrs[i] != address(0));
128       whitelist[addrs[i]] = true;
129     }
130     return true;
131   }
132 
133   /**
134    * @dev Transfer all Ether held by the contract to the address specified by owner.
135    */
136   function reclaimEther(address _beneficiary) external onlyOwner {
137     _beneficiary.transfer(this.balance);
138   }
139 
140   function SimpleTGE (
141     address _fundsWallet,
142     uint256 _publicTGEStartBlockTimeStamp,
143     uint256 _publicTGEEndBlockTimeStamp,
144     uint256 _individualCapInWei,
145     uint256 _totalCapInWei
146   ) public 
147   {
148     require(_publicTGEStartBlockTimeStamp >= block.timestamp);
149     require(_publicTGEEndBlockTimeStamp > _publicTGEStartBlockTimeStamp);
150     require(_fundsWallet != address(0));
151     require(_individualCapInWei > 0);
152     require(_individualCapInWei <= _totalCapInWei);
153     require(_totalCapInWei > 0);
154 
155     fundsWallet = _fundsWallet;
156     publicTGEStartBlockTimeStamp = _publicTGEStartBlockTimeStamp;
157     publicTGEEndBlockTimeStamp = _publicTGEEndBlockTimeStamp;
158     individualCapInWei = _individualCapInWei;
159     totalCapInWei = _totalCapInWei;
160   }
161 
162   // allows changing the individual cap.
163   function changeIndividualCapInWei(uint256 _individualCapInWei) onlyOwner external returns(bool) {
164       require(_individualCapInWei > 0);
165       require(_individualCapInWei < totalCapInWei);
166       individualCapInWei = _individualCapInWei;
167       return true;
168   }
169 
170   // low level token purchase function
171   function contribute(bool _vestingDecision) internal {
172     // validations
173     require(msg.sender != address(0));
174     require(msg.value != 0);
175     require(weiRaised.add(msg.value) <= totalCapInWei);
176     require(contributions[msg.sender].weiContributed.add(msg.value) <= individualCapInWei);
177     // if we have not received any WEI from this address until now, then we add this address to contributors list.
178     if (contributions[msg.sender].weiContributed == 0) {
179       contributors.push(msg.sender);
180     }
181     contributions[msg.sender].weiContributed = contributions[msg.sender].weiContributed.add(msg.value);
182     weiRaised = weiRaised.add(msg.value);
183     contributions[msg.sender].hasVested = _vestingDecision;
184     fundsWallet.transfer(msg.value);
185   }
186 
187   function contributeAndVest() external whilePublicTGEIsActive isWhitelisted payable {
188     contribute(true);
189   }
190 
191   function contributeWithoutVesting() public whilePublicTGEIsActive isWhitelisted payable {
192     contribute(false);
193   }
194 
195   // fallback function can be used to buy tokens
196   function () external payable {
197     contributeWithoutVesting();
198   }
199 
200   // Vesting logic
201   // The following cases are checked for _beneficiary's actions:
202   function vest(bool _vestingDecision) external isWhitelisted returns(bool) {
203     bool existingDecision = contributions[msg.sender].hasVested;
204     require(existingDecision != _vestingDecision);
205     require(block.timestamp >= publicTGEStartBlockTimeStamp);
206     require(contributions[msg.sender].weiContributed > 0);
207     // Ensure vesting cannot be done once TRS starts
208     if (block.timestamp > publicTGEEndBlockTimeStamp) {
209       require(block.timestamp.sub(publicTGEEndBlockTimeStamp) <= TRSOffset);
210     }
211     contributions[msg.sender].hasVested = _vestingDecision;
212     return true;
213   }
214 }