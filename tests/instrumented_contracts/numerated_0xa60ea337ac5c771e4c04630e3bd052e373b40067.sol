1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 //! Fundraiser contract. Just records who sent what.
34 //! By Parity Technologies, 2017.
35 //! Released under the Apache Licence 2.
36 //! Modified by the Musereum.
37 
38 
39 
40 
41 
42 /// Will accept Ether "contributions" and records each both as a log and in a
43 /// queryable records.
44 contract Fundraiser {
45     using SafeMath for uint;
46 
47     // How much is enough?
48     uint public constant dust = 100 finney;
49 
50     // Special addresses:
51     //  administrator can halt/unhalt/kill/adjustRate;
52     //  treasury receives all the funds
53     address public admin;
54     address public treasury;
55 
56     // Begin and end block for the fundraising period
57     //uint public beginBlock;
58     //uint public endBlock;
59 
60     // Number of wei per btc
61     uint public weiPerBtc;
62 
63     // Default number of etm per btc
64     uint public EtmPerBtc;
65 
66     // Are contributions abnormally halted?
67     bool public isHalted = false;
68 
69     // The `records` mapping maps musereum addresses to the amount of ETM.
70     mapping (address => uint) public records;
71 
72     // The total amount of ether raised
73     uint public totalWei = 0;
74     // The total amount of ETM suggested for allocation
75     uint public totalETM = 0;
76     // The number of donation
77     uint public numDonations = 0;
78 
79     /// Constructor. `_admin` has the ability to pause the
80     /// contribution period and, eventually, kill this contract. `_treasury`
81     /// receives all funds. `_beginBlock` and `_endBlock` define the begin and
82     /// end of the period. `_weiPerBtc` is the ratio of ETM to ether.
83     function Fundraiser(
84         address _admin,
85         address _treasury,
86         //uint _beginBlock,
87         //uint _endBlock,
88         uint _weiPerBtc,
89         uint _EtmPerBtc
90     ) {
91         require(_weiPerBtc > 0);
92         require(_EtmPerBtc > 0);
93 
94         admin = _admin;
95         treasury = _treasury;
96         //beginBlock = _beginBlock;
97         //endBlock = _endBlock;
98 
99         weiPerBtc = _weiPerBtc;
100         EtmPerBtc = _EtmPerBtc;
101     }
102 
103     // Can only be called by admin.
104     modifier only_admin { require(msg.sender == admin); _; }
105     // Can only be called by prior to the period.
106     //modifier only_before_period { require(block.number < beginBlock); _; }
107     // Can only be called during the period when not halted.
108     modifier only_during_period { require(/*block.number >= beginBlock || block.number < endBlock && */!isHalted); _; }
109     // Can only be called during the period when halted.
110     modifier only_during_halted_period { require(/*block.number >= beginBlock || block.number < endBlock && */isHalted); _; }
111     // Can only be called after the period.
112     //modifier only_after_period { require(block.number >= endBlock); _; }
113     // The value of the message must be sufficiently large to not be considered dust.
114     modifier is_not_dust { require(msg.value >= dust); _; }
115 
116     /// Some contribution `amount` received from `recipient` at rate of `currentRate` with emergency return of `returnAddr`.
117     event Received(address indexed recipient, address returnAddr, uint weiAmount, uint currentRate);
118     /// Period halted abnormally.
119     event Halted();
120     /// Period restarted after abnormal halt.
121     event Unhalted();
122     event RateChanged(uint newRate);
123 
124     // Is the fundraiser active?
125     function isActive() public constant returns (bool active) {
126         return (/*block.number >= beginBlock && block.number < endBlock && */ !isHalted);
127     }
128 
129     /// Receive a contribution for a donor musereum address.
130     function donate(address _donor, address _returnAddress, bytes4 checksum) public payable only_during_period is_not_dust {
131         // checksum is the first 4 bytes of the sha3 of the xor of the bytes32 versions of the musereum address and the return address
132         require( bytes4(sha3( bytes32(_donor)^bytes32(_returnAddress) )) == checksum );
133 
134         // forward the funds to the treasure
135         require( treasury.send(msg.value) );
136 
137         // calculate the number of ETM at the current rate
138         uint weiPerETM = weiPerBtc.div(EtmPerBtc);
139         uint ETM = msg.value.div(weiPerETM);
140 
141         // update the donor details
142         records[_donor] = records[_donor].add(ETM);
143 
144         // update the totals
145         totalWei = totalWei.add(msg.value);
146         totalETM = totalETM.add(ETM);
147         numDonations = numDonations.add(1);
148 
149         Received(_donor, _returnAddress, msg.value, weiPerETM);
150     }
151 
152     /// Adjust the weiPerBtc rate
153     function adjustRate(uint newRate) public only_admin {
154         weiPerBtc = newRate;
155         RateChanged(newRate);
156     }
157 
158     /// Halt the contribution period. Any attempt at contributing will fail.
159     function halt() public only_admin only_during_period {
160         isHalted = true;
161         Halted();
162     }
163 
164     /// Unhalt the contribution period.
165     function unhalt() public only_admin only_during_halted_period {
166         isHalted = false;
167         Unhalted();
168     }
169 
170     /// Kill this contract.
171     function kill() public only_admin /*only_after_period*/ {
172         suicide(treasury);
173     }
174 }