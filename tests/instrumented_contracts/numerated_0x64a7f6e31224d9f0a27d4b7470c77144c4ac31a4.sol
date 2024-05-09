1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Presale {
35   using SafeMath for uint256;
36 
37   mapping (address => uint256) public balances;
38 
39   // Minimum amount of wei required for presale to be successful.  If not successful, refunds are provided.
40   uint256 public minGoal;
41   // The epoch unix timestamp of when the presale starts
42   uint256 public startTime;
43   // The epoch unix timestamp of when the presale ends
44   uint256 public endTime;
45   // The wallet address that the funds will be sent to
46   address public projectWallet;
47 
48   uint256 private totalRaised;
49 
50   function Presale() {
51     minGoal = 83.33 ether;
52     startTime = 1505248886;
53     endTime = 1506841199;   // Sept 30, 2017 midnight PT
54     projectWallet = address(0x2a00BFd8379786ADfEbb6f2F59011535a4f8d4E4);
55   }
56 
57   function transferToProjectWallet() {
58     // only allow transfers if there is balance
59     require(this.balance > 0);
60     // only allow transfers if minimum goal is met
61     require(totalRaised >= minGoal);
62     if(!projectWallet.send(this.balance)) {
63       revert();
64     }
65   }
66 
67   function refund() {
68     // only allow refund if the presale has ended
69     require(now > endTime);
70     // only allow refund if the minGoal has not been reached
71     require(totalRaised < minGoal);
72     // only allow refund during a 60 day window after presale ends
73     require(now < (endTime + 60 days));
74     uint256 amount = balances[msg.sender];
75     // only allow refund if investor has invested
76     require(amount > 0);
77     // after refunding, zero out balance
78     balances[msg.sender] = 0;
79     msg.sender.transfer(amount);
80   }
81 
82   function transferRemaining() {
83     // only allow transfer if presale has failed
84     require(totalRaised < minGoal);
85     // only allow transfer after refund window has passed
86     require(now >= (endTime + 60 days));
87     // only allow transfer if there is remaining balance
88     require(this.balance > 0);
89     projectWallet.transfer(this.balance);
90   }
91 
92   function () payable {
93     // only allow payments greater than 0
94     require(msg.value > 0);
95     // only allow payments after presale has started
96     require(now >= startTime);
97     // only allow payments before presale has ended
98     require(now <= endTime);
99     // if all checks pass, then add amount to balance of the sender
100     balances[msg.sender] = balances[msg.sender].add(msg.value);
101     totalRaised = totalRaised.add(msg.value);
102   }
103 }