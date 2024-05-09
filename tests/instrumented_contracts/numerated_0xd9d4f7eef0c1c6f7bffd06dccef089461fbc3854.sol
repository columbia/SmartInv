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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 
54   /**
55   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56   * reverts when dividing by zero.
57   */
58   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b != 0);
60     return a % b;
61   }
62 }
63 
64 // File: contracts/Lava.sol
65 
66 contract Lava {
67 
68   using SafeMath for uint;
69 
70   struct Rand {
71       address submitter;
72       uint value;
73   }
74 
75   struct PredUnit {
76       address submitter;
77       uint value;
78   }
79 
80   event receivedRand(address indexed _from, uint _value);
81   event receivedPred(address indexed _from, uint[] _window);
82   event requestedRand(address indexed _from, uint _value); // who requested a value and the value they received
83 
84   uint MAXRAND = 100; // all rands, cyclical array
85   uint RANDPRICE = 857 wei;
86   uint RANDDEPOSIT = 1 wei;
87   uint PREDWAGER = 1 wei;
88   uint CURRIDX = 1; // current index in rands
89   uint nWinners = 0;
90   bool predPeat = false; // true if preders paid out >= once but can still win again if submitRand() has not been called since, else false
91 
92   mapping(uint => Rand) private rands; // cyclical array
93   mapping(uint => bool) public randExists; // true if random number exists at index in cyclical array, else false
94   mapping(uint => PredUnit) public winners; // winning PredUnits
95   mapping(uint => PredUnit[]) public arrIdx2predUnitArr; // all predictions per each index in cyclical array
96   mapping(uint => bool) public arrIdx2lost; // true if rander at index lost to a preder, else false (default false)
97 
98   constructor () public payable {
99     for (uint i=0; i<MAXRAND; i++) {
100       randExists[i] = false;
101       arrIdx2lost[i] = false;
102     }
103     rands[0] = Rand({submitter: address(this), value: 0});
104     arrIdx2lost[0] = true;
105   }
106 
107   function submitRand(uint _value) public payable {
108     // √ create Rand struct
109     // √ add new Rand struct to rands
110     // √ register/ledger deposit
111     require(msg.value >= RANDDEPOSIT);
112     require(_value >= 1); // min support
113     require(_value <= 65536); // max support
114     Rand memory newRand = Rand({
115       submitter: msg.sender,
116       value: _value
117     });
118     if (!arrIdx2lost[CURRIDX]) { rands[CURRIDX].submitter.transfer(RANDDEPOSIT); } // return deposit rander being booted from cyclical array
119     rands[CURRIDX] = newRand;
120     arrIdx2lost[CURRIDX] = false;
121     randExists[CURRIDX] = true;
122     if (predPeat) { delete arrIdx2predUnitArr[CURRIDX]; } // reset array
123     predPeat = false;
124     CURRIDX = (CURRIDX.add(1)).mod(MAXRAND);
125     emit receivedRand(msg.sender, _value);
126   }
127 
128   function submitPredWindow(uint[] _guess) public payable {
129     // √ create accessible PredUnits
130     // √ create accessible PredWindow
131     // √ add to preds
132     // √ register/ledger deposit
133     require(msg.value >= PREDWAGER.mul(_guess.length)); // 1 wager per prediction
134     require(_guess.length <= MAXRAND);
135     uint outputIdx = wrapSub(CURRIDX, 1, MAXRAND);
136     for (uint i=0; i<_guess.length; i++) {
137       PredUnit memory newUnit = PredUnit({
138         submitter: msg.sender,
139         value: _guess[i]
140       });
141       arrIdx2predUnitArr[(i+outputIdx) % MAXRAND].push(newUnit);
142     }
143     emit receivedPred(msg.sender, _guess);
144   }
145 
146   function requestRand() public payable returns (uint) {
147     // √ register/ledger payment
148     // √ initiates auditing process (was there a correct prediction)
149     // √ sends payments to appropriate players (rander recency or preder relative wager)
150     // √ returns rand from timeline of most current timestamp
151     require(msg.value >= RANDPRICE);
152     uint outputIdx = wrapSub(CURRIDX, 1, MAXRAND);
153     uint idx;
154     uint val;
155     uint i;
156     uint reward;
157     if (predPeat) {
158         reward = RANDPRICE.div(nWinners);
159         for (i=0; i<nWinners; i++) { winners[i].submitter.transfer(reward); } // pay winning preders
160     } else {
161         nWinners = 0;
162         for (i=0; i<arrIdx2predUnitArr[outputIdx].length; i++) {
163           if (arrIdx2predUnitArr[outputIdx][i].value == rands[outputIdx].value) {
164             winners[i] = arrIdx2predUnitArr[outputIdx][i]; // enumerate winning PredUnits
165             nWinners++;
166           }
167         }
168         if (nWinners > 0) { // at least one preder wins
169           if (arrIdx2lost[outputIdx]) { reward = RANDPRICE.div(nWinners); } // if random number was predicted already or if constructor is rander
170           else { reward = PREDWAGER.add(RANDPRICE.div(nWinners)); } // if random number was not predicted already
171           for (i=0; i<nWinners; i++) { winners[i].submitter.transfer(reward); } // pay winning preders
172           winners[0].submitter.transfer(address(this).balance); // send pot to first correct preder
173           for (i=0; i<MAXRAND; i++) { arrIdx2lost[i] = true; } // all randers suffer
174           predPeat = true;
175         } else { // a single rander won, all recent randers get paid from earliest to last
176           idx = wrapSub(outputIdx, 0, MAXRAND);
177           rands[idx].submitter.transfer(RANDPRICE.div(4)); // extra winnings for the rander to submit the actual requested random number
178           for (i=0; i<MAXRAND; i++) {
179             idx = wrapSub(outputIdx, i, MAXRAND);
180             val = i.add(2);
181             if (randExists[idx]) { rands[idx].submitter.transfer(RANDPRICE.div(val.mul(val))); }
182           }
183         }
184     }
185     emit requestedRand(msg.sender, rands[outputIdx].value);
186     return rands[outputIdx].value;
187   }
188 
189   function wrapSub(uint a, uint b, uint c) public pure returns(uint) { return uint(int(a) - int(b)).mod(c); } // computes (a-b)%c
190 
191   function () public payable {}
192 }