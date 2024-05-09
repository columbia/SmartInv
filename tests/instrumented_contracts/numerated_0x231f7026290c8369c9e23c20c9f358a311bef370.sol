1 pragma solidity ^0.4.18;
2 
3 contract OneXMachine {
4 
5   // Address of the contract creator
6   address public contractOwner;
7 
8   // FIFO queue
9   BuyIn[] public buyIns;
10 
11   // The current BuyIn queue index
12   uint256 public index;
13 
14   // Total invested for entire contract
15   uint256 public contractTotalInvested;
16 
17   // Total invested for a given address
18   mapping (address => uint256) public totalInvested;
19 
20   // Total value for a given address
21   mapping (address => uint256) public totalValue;
22 
23   // Total paid out for a given address
24   mapping (address => uint256) public totalPaidOut;
25 
26   struct BuyIn {
27     uint256 value;
28     address owner;
29   }
30 
31   modifier onlyContractOwner() {
32     require(msg.sender == contractOwner);
33     _;
34   }
35 
36   function OneXMachine() public {
37     contractOwner = msg.sender;
38   }
39 
40   function purchase() public payable {
41     // I don't want no scrub
42     require(msg.value >= 0.01 ether);
43 
44     // Take a 5% fee
45     uint256 value = SafeMath.div(SafeMath.mul(msg.value, 95), 100);
46 
47     // 1.25x multiplier
48     uint256 valueMultiplied = SafeMath.div(SafeMath.mul(msg.value, 100), 100);
49 
50     contractTotalInvested += msg.value;
51     totalInvested[msg.sender] += msg.value;
52 
53     while (index < buyIns.length && value > 0) {
54       BuyIn storage buyIn = buyIns[index];
55 
56       if (value < buyIn.value) {
57         buyIn.owner.transfer(value);
58         totalPaidOut[buyIn.owner] += value;
59         totalValue[buyIn.owner] -= value;
60         buyIn.value -= value;
61         value = 0;
62       } else {
63         buyIn.owner.transfer(buyIn.value);
64         totalPaidOut[buyIn.owner] += buyIn.value;
65         totalValue[buyIn.owner] -= buyIn.value;
66         value -= buyIn.value;
67         buyIn.value = 0;
68         index++;
69       }
70     }
71 
72     // if buyins have been exhausted, return the remaining
73     // funds back to the investor
74     if (value > 0) {
75       msg.sender.transfer(value);
76       valueMultiplied -= value;
77       totalPaidOut[msg.sender] += value;
78     }
79 
80     totalValue[msg.sender] += valueMultiplied;
81 
82     buyIns.push(BuyIn({
83       value: valueMultiplied,
84       owner: msg.sender
85     }));
86   }
87 
88   function payout() public onlyContractOwner {
89     contractOwner.transfer(this.balance);
90   }
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }