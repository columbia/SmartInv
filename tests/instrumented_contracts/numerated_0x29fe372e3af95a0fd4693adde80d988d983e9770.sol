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
92   uint256 public gasReq; // require same gas every time in maker()
93 
94   event MatchmakerPrevails(address indexed matchmaster, address indexed matchmaker, uint256 sent, uint256 actual, uint256 winnings);
95   event MatchmasterPrevails(address indexed matchmaster, address indexed matchmaker, uint256 sent, uint256 actual, uint256 winnings);
96   event MatchmasterTakeover(address indexed matchmasterPrev, address indexed matchmasterNew, uint256 balanceNew);
97 
98   // can be funded at init if desired
99   function EthMatch(uint256 _startTime) public payable {
100     require(_startTime >= now);
101 
102     startTime = _startTime;
103     master = msg.sender; // initial
104     gasReq = 42000;
105   }
106 
107   // ensure proper state
108   modifier isValid(address _addr) {
109     require(_addr != 0x0);
110     require(!Lib.isContract(_addr)); // ban contracts
111     require(now >= startTime);
112 
113    _;
114   }
115 
116   // fallback function
117   // make a match
118   function () public payable {
119     maker(msg.sender);
120   }
121 
122   // make a match (and specify payout address)
123   function maker(address _addr) isValid(_addr) public payable {
124     require(msg.gas >= gasReq); // require same gas every time (overages auto-returned)
125 
126     uint256 weiPaid = msg.value;
127     require(weiPaid > 0);
128 
129     uint256 balPrev = this.balance.sub(weiPaid);
130 
131     if (balPrev == weiPaid) {
132       // maker wins
133       uint256 winnings = weiPaid.add(balPrev.div(2));
134       pay(_addr, winnings);
135       MatchmakerPrevails(master, _addr, weiPaid, balPrev, winnings);
136     } else {
137       // master wins
138       pay(master, weiPaid);
139       MatchmasterPrevails(master, _addr, weiPaid, balPrev, weiPaid);
140     }
141   }
142 
143   // send proceeds
144   function pay(address _addr, uint256 _amount) internal {
145     if (_amount == 0) {
146       return; // amount actually could be 0, e.g. initial funding or if balance is totally drained
147     }
148 
149     uint256 payout = _amount.mul(PAYOUT_PCT).div(100);
150     _addr.transfer(payout);
151 
152     uint256 remainder = _amount.sub(payout);
153     owner.transfer(remainder);
154   }
155 
156   // become the new master
157   function mastery() public payable {
158     mastery(msg.sender);
159   }
160 
161   // become the new master (and specify payout address)
162   function mastery(address _addr) isValid(_addr) public payable {
163     uint256 weiPaid = msg.value;
164     require(weiPaid >= MASTERY_THRESHOLD);
165 
166     uint256 balPrev = this.balance.sub(weiPaid);
167     require(balPrev < MASTERY_THRESHOLD);
168 
169     pay(master, balPrev);
170 
171     MatchmasterTakeover(master, _addr, weiPaid); // called before new master set
172 
173     master = _addr; // must be set after event logged
174   }
175 
176   // in case it ever needs to be updated for future Ethereum releases, etc
177   function setGasReq(uint256 _gasReq) onlyOwner external {
178     gasReq = _gasReq;
179   }
180 
181   // initial funding
182   function fund() onlyOwner external payable {
183     require(now < startTime); // otherwise can just call mastery()
184 
185     // it is possible that funds can be forced in via selfdestruct, so
186     // just ensure balance is enough, at least after receiving this call (msg.value)
187     require(this.balance >= MASTERY_THRESHOLD);
188   }
189 
190   // explicit balance getter
191   function getBalance() external constant returns (uint256) {
192     return this.balance;
193   }
194 
195 }
196 
197 library Lib {
198   // whether given address is a contract or not based on bytecode
199   function isContract(address addr) internal constant returns (bool) {
200     uint size;
201     assembly {
202       size := extcodesize(addr)
203     }
204     return (size > 1); // testing returned size "1" for non-contract accounts, so we're using that.
205   }
206 }