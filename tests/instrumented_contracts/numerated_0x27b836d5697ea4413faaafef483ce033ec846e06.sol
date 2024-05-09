1 pragma solidity ^0.4.11;
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
29 contract Crowdsale {
30   function buyTokens(address _recipient) payable;
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner {
60     if (newOwner != address(0)) {
61       owner = newOwner;
62     }
63   }
64 
65 }
66 
67 contract Preallocation is Ownable {
68     using SafeMath for uint;
69 
70     address public investor;
71     uint public maxBalance;
72 
73     enum States { Pending, Success, Fail }
74     States public state = States.Pending;
75 
76     event InvestorChanged(address from, address to);
77 
78     event FundsLoaded(uint value, address from);
79     event FundsRefunded(uint balance);
80 
81     event InvestmentSucceeded(uint value);
82     event InvestmentFailed();
83 
84 
85     function Preallocation(address _investor, uint _maxBalance) {
86         investor = _investor;
87         maxBalance = _maxBalance;
88     }
89 
90     function () payable {
91         if (this.balance > maxBalance) {
92           throw;
93         }
94         FundsLoaded(msg.value, msg.sender);
95     }
96 
97     function withdraw() onlyOwner notState(States.Success) {
98         uint bal = this.balance;
99         if (!investor.send(bal)) {
100             throw;
101         }
102 
103         FundsRefunded(bal);
104     }
105 
106     function setInvestor(address _investor) onlyOwner {
107         InvestorChanged(investor, _investor);
108         investor = _investor;
109     }
110 
111     function buyTokens(Crowdsale crowdsale) onlyOwner {
112         uint bal = Math.min256(this.balance, maxBalance);
113         crowdsale.buyTokens.value(bal)(investor);
114 
115         state = States.Success;
116         InvestmentSucceeded(bal);
117     }
118 
119     function setFailed() onlyOwner {
120       state = States.Fail;
121       InvestmentFailed();
122     }
123 
124     function stateIs(States _state) constant returns (bool) {
125         return state == _state;
126     }
127 
128     modifier onlyState(States _state) {
129         require (state == _state);
130         _;
131     }
132 
133     modifier notState(States _state) {
134         require (state != _state);
135         _;
136     }
137 }
138 
139 library Math {
140   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
141     return a >= b ? a : b;
142   }
143 
144   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
145     return a < b ? a : b;
146   }
147 
148   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
149     return a >= b ? a : b;
150   }
151 
152   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
153     return a < b ? a : b;
154   }
155 }