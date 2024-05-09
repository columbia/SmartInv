1 // Presale interface
2 
3 pragma solidity ^0.4.16;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract Presale {
36   using SafeMath for uint256;
37 
38   mapping (address => uint256) public balances;
39 
40   // Minimum amount of wei required for presale to be successful.  If not successful, refunds are provided.
41   uint256 public minGoal;
42   // Maximum amount of wei for presale to raise.
43   uint256 public maxGoal;
44   // The epoch unix timestamp of when the presale starts
45   uint256 public startTime;
46   // The epoch unix timestamp of when the presale ends
47   uint256 public endTime;
48   // The wallet address that the funds will be sent to
49   address public projectWallet;
50 
51   uint256 private totalRaised;
52 
53   function Presale(
54     uint256 _minGoal,
55     uint256 _maxGoal,
56     uint256 _startTime,
57     uint256 _endTime,
58     address _projectWallet
59   )
60   {
61     require(_minGoal > 0);
62     require(_endTime > _startTime);
63     require(_projectWallet != address(0x0));
64     require(_maxGoal > _minGoal);
65 
66     minGoal = _minGoal;
67     maxGoal = _maxGoal;
68     startTime = _startTime;
69     endTime = _endTime;
70     projectWallet = _projectWallet;
71   }
72 
73   function transferToProjectWallet() {
74     // only allow transfers if there is balance
75     require(this.balance > 0);
76     // only allow transfers if minimum goal is met
77     require(totalRaised >= minGoal);
78     if(!projectWallet.send(this.balance)) {
79       revert();
80     }
81   }
82 
83   function refund() {
84     // only allow refund if the presale has ended
85     require(now > endTime);
86     // only allow refund if the minGoal has not been reached
87     require(totalRaised < minGoal);
88     // only allow refund during a 60 day window after presale ends
89     require(now < (endTime + 60 days));
90     uint256 amount = balances[msg.sender];
91     // only allow refund if investor has invested
92     require(amount > 0);
93     // after refunding, zero out balance
94     balances[msg.sender] = 0;
95     if (!msg.sender.send(amount)) {
96       revert();
97     }
98   }
99 
100   function transferRemaining() {
101     // only allow transfer if presale has failed
102     require(totalRaised < minGoal);
103     // only allow transfer after refund window has passed
104     require(now >= (endTime + 60 days));
105     // only allow transfer if there is remaining balance
106     require(this.balance > 0);
107     projectWallet.transfer(this.balance);
108   }
109 
110   function () payable {
111     // only allow payments greater than 0
112     require(msg.value > 0);
113     // only allow payments after presale has started
114     require(now >= startTime);
115     // only allow payments before presale has ended
116     require(now <= endTime);
117     // only allow payments if the maxGoal has not been reached
118     require(totalRaised < maxGoal);
119 
120     // If this investment should cause the max to be achieved
121     // Then it should only accept up to the max goal
122     // And refund the remaining
123     if (totalRaised.add(msg.value) > maxGoal) {
124       var refundAmount = totalRaised + msg.value - maxGoal;
125       if (!msg.sender.send(refundAmount)) {
126         revert();
127       }
128       var raised = maxGoal - totalRaised;
129       balances[msg.sender] = balances[msg.sender].add(raised);
130       totalRaised = totalRaised.add(raised);
131     } else {
132       // if all checks pass, then add amount to balance of the sender
133       balances[msg.sender] = balances[msg.sender].add(msg.value);
134       totalRaised = totalRaised.add(msg.value);
135     }
136   }
137 }
138 
139 contract OpenMoneyPresale is Presale {
140   function OpenMoneyPresale() Presale(83.33 ether,
141                                       2000 ether,
142                                       1505649600,
143                                       1505995200,
144                                       address(0x2a00BFd8379786ADfEbb6f2F59011535a4f8d4E4))
145                                       {}
146 
147 }