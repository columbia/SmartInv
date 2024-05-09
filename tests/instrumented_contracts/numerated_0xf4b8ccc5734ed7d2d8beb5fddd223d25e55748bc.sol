1 pragma solidity ^0.4.14;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function add(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a + b;
17     assert(c >= a);
18     return c;
19   }
20 }
21 
22 contract Ownable {
23   address public owner;
24 
25   function Ownable() {
26     owner = msg.sender;
27   }
28 
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 }
34 
35 contract PariMutuel is Ownable {
36   using SafeMath for uint256;
37 
38   enum Outcome { Mayweather, McGregor }
39   enum State { PreEvent, DuringEvent, PostEvent, Refunding }
40 
41   event BetPlaced(address indexed bettor, uint256 amount, Outcome outcome);
42   event StateChanged(State _state);
43   event WinningOutcomeDeclared(Outcome outcome);
44   event Withdrawal(address indexed bettor, uint256 amount);
45 
46   uint256 public constant percentRake = 2;
47   uint256 public constant minBetAmount = 0.01 ether;
48   uint8 public constant numberOfOutcomes = 2; // need this until Solidity allows Outcome.length
49 
50   Outcome public winningOutcome;
51   State public state;
52 
53   mapping(uint8 => mapping(address => uint256)) balancesForOutcome;
54   mapping(uint8 => uint256) public totalForOutcome;
55 
56   bool public hasWithdrawnRake;
57   mapping(address => bool) refunded;
58 
59   function PariMutuel() {
60     state = State.PreEvent;
61   }
62 
63   modifier requireState(State _state) {
64     require(state == _state);
65     _;
66   }
67 
68   function bet(Outcome outcome) external payable requireState(State.PreEvent) {
69     require(msg.value >= minBetAmount);
70     balancesForOutcome[uint8(outcome)][msg.sender] = balancesForOutcome[uint8(outcome)][msg.sender].add(msg.value);
71     totalForOutcome[uint8(outcome)] = totalForOutcome[uint8(outcome)].add(msg.value);
72     BetPlaced(msg.sender, msg.value, outcome);
73   }
74 
75   function totalWagered() public constant returns (uint256) {
76     uint256 total = 0;
77     for (uint8 i = 0; i < numberOfOutcomes; i++) {
78       total = total.add(totalForOutcome[i]);
79     }
80     return total;
81   }
82 
83   function totalRake() public constant returns (uint256) {
84     return totalWagered().mul(percentRake) / 100;
85   }
86 
87   function totalPrizePool() public constant returns (uint256) {
88     return totalWagered().sub(totalRake());
89   }
90 
91   function totalWageredForAddress(address _address) public constant returns (uint256) {
92     uint256 total = 0;
93     for (uint8 i = 0; i < numberOfOutcomes; i++) {
94       total = total.add(balancesForOutcome[i][_address]);
95     }
96     return total;
97   }
98 
99   // THERE MIGHT BE ROUNDING ERRORS
100   // BUT THIS IS JUST FOR DISPLAY ANYWAYS
101   // e.g. totalPrizePool = 2.97, risk = 2.5
102   // we return 1.18 when really it should be 1.19
103   function decimalOddsForOutcome(Outcome outcome) external constant returns (uint256 integer, uint256 fractional) {
104     uint256 toWin = totalPrizePool();
105     uint256 risk = totalForOutcome[uint8(outcome)];
106     uint256 remainder = toWin % risk;
107     return (toWin / risk, (remainder * 100) / risk);
108   }
109 
110   function payoutForWagerAndOutcome(uint256 wager, Outcome outcome) public constant returns (uint256) {
111     return totalPrizePool().mul(wager) / totalForOutcome[uint8(outcome)];
112   }
113 
114   function startEvent() external onlyOwner requireState(State.PreEvent) {
115     state = State.DuringEvent;
116     StateChanged(state);
117   }
118 
119   function declareWinningOutcome(Outcome outcome) external onlyOwner requireState(State.DuringEvent) {
120     state = State.PostEvent;
121     StateChanged(state);
122     winningOutcome = outcome;
123     WinningOutcomeDeclared(outcome);
124   }
125 
126   // if there's a draw or a bug in the contract
127   function refundEverybody() external onlyOwner {
128     state = State.Refunding;
129     StateChanged(state);
130   }
131 
132   function getRefunded() external requireState(State.Refunding) {
133     require(!refunded[msg.sender]);
134     refunded[msg.sender] = true;
135     msg.sender.transfer(totalWageredForAddress(msg.sender));
136   }
137 
138   function withdrawRake() external onlyOwner requireState(State.PostEvent) {
139     require(!hasWithdrawnRake);
140     hasWithdrawnRake = true;
141     owner.transfer(totalRake());
142   }
143 
144   function withdrawWinnings() external requireState(State.PostEvent) {
145     uint256 wager = balancesForOutcome[uint8(winningOutcome)][msg.sender];
146     require(wager > 0);
147     uint256 winnings = payoutForWagerAndOutcome(wager, winningOutcome);
148     balancesForOutcome[uint8(winningOutcome)][msg.sender] = 0;
149     msg.sender.transfer(winnings);
150     Withdrawal(msg.sender, winnings);
151   }
152 }