1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC23ContractInterface {
67   function tokenFallback(address _from, uint256 _value, bytes _data) external;
68 }
69 
70 contract ERC23Contract is ERC23ContractInterface {
71 
72  /**
73   * @dev Reject all ERC23 compatible tokens
74   * param _from address that is transferring the tokens
75   * param _value amount of specified token
76   * param _data bytes data passed from the caller
77   */
78   function tokenFallback(address /*_from*/, uint256 /*_value*/, bytes /*_data*/) external {
79     revert();
80   }
81 
82 }
83 
84 contract EthMatch is Ownable, ERC23Contract {
85   using SafeMath for uint256;
86 
87   uint256 public constant MASTERY_THRESHOLD = 10 finney; // new master allowed if balance falls below this (10 finney == .01 ETH)
88   uint256 public constant PAYOUT_PCT = 95; // % to winner (rest to creator)
89 
90   uint256 public startTime; // start timestamp when matches may begin
91   address public master; // current Matchmaster
92   uint256 public gasReq; // only a var in case it ever needs to be updated for future Ethereum releases
93 
94   event MatchmakerPrevails(address indexed matchmaster, address indexed matchmaker, uint256 sent, uint256 actual, uint256 winnings);
95   event MatchmasterPrevails(address indexed matchmaster, address indexed matchmaker, uint256 sent, uint256 actual, uint256 winnings);
96   event MatchmasterTakeover(address indexed matchmasterPrev, address indexed matchmasterNew, uint256 balanceNew);
97 
98   function EthMatch(uint256 _startTime) public {
99     require(_startTime >= now);
100 
101     startTime = _startTime;
102     master = msg.sender; // initial
103     gasReq = 21000;
104   }
105 
106   // fallback function
107   // make a match
108   function () public payable {
109     maker(msg.sender);
110   }
111 
112   // make a match (and specify payout address)
113   function maker(address _payoutAddr) public payable {
114     require(this.balance > 0); // else we haven't started yet
115     require(msg.gas >= gasReq); // require same amount every time (overages auto-returned)
116 
117     require(now >= startTime);
118     require(_payoutAddr != 0x0);
119 
120     uint256 weiPaid = msg.value;
121     require(weiPaid > 0);
122 
123     uint256 balPrev = this.balance.sub(weiPaid);
124 
125     if (balPrev == weiPaid) {
126       // maker wins
127       uint256 winnings = weiPaid.add(balPrev.div(2));
128       pay(_payoutAddr, winnings);
129       MatchmakerPrevails(master, _payoutAddr, weiPaid, balPrev, winnings);
130     } else {
131       // master wins
132       pay(master, weiPaid);
133       MatchmasterPrevails(master, _payoutAddr, weiPaid, balPrev, weiPaid);
134     }
135   }
136 
137   // send proceeds
138   function pay(address _payoutAddr, uint256 _amount) internal {
139     require(_amount > 0);
140 
141     uint256 payout = _amount.mul(PAYOUT_PCT).div(100);
142     _payoutAddr.transfer(payout);
143 
144     uint256 remainder = _amount.sub(payout);
145     owner.transfer(remainder);
146   }
147 
148   // become the new master
149   function mastery() public payable {
150     mastery(msg.sender);
151   }
152 
153   // become the new master (and specify payout address)
154   function mastery(address _payoutAddr) public payable {
155     require(this.balance > 0); // else we haven't started yet
156     require(now >= startTime);
157     require(_payoutAddr != 0x0);
158 
159     uint256 weiPaid = msg.value;
160     require(weiPaid >= MASTERY_THRESHOLD);
161 
162     uint256 balPrev = this.balance.sub(weiPaid);
163     require(balPrev < MASTERY_THRESHOLD);
164 
165     pay(master, balPrev);
166 
167     MatchmasterTakeover(master, _payoutAddr, weiPaid); // called before new master set
168 
169     master = _payoutAddr; // set after event
170   }
171 
172   // in case it ever needs to be updated for future Ethereum releases
173   function setGasReq(uint256 _gasReq) onlyOwner external {
174     gasReq = _gasReq;
175   }
176 
177   // initial funding
178   function fund() onlyOwner external payable {
179     require(this.balance == msg.value); // ensures balance was 0 before this, i.e. uninitialized
180     require(msg.value >= MASTERY_THRESHOLD);
181   }
182 
183 }