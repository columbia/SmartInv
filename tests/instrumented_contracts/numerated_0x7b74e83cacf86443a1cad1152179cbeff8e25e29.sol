1 pragma solidity ^0.4.17;
2 
3 contract RaiseFundsForACause {
4 
5     // Base definitions
6     address public owner;
7     address public receiver;
8     string public cause;
9     uint256 public expirationInSeconds;
10     bool public hasBeenClaimed;
11     uint256 public timeStarted;
12 
13     // Dynamic data
14     uint256 public minimumAmountRequired;
15     uint256 public numPayments;
16     uint256 public totalAmountRaised;
17     mapping(address => uint256) donationData;
18 
19     function RaiseFundsForACause(address beneficiary, string message, uint256 secondsUntilExpiration)
20         public
21     {
22         require(beneficiary != 0x0);
23         require(secondsUntilExpiration > 0);
24 
25         owner = msg.sender;
26         receiver = beneficiary;
27         cause = message;
28         expirationInSeconds = secondsUntilExpiration;
29         hasBeenClaimed = false;
30 
31         minimumAmountRequired = 0;
32         numPayments = 0;
33         totalAmountRaised = 0;
34         timeStarted = block.timestamp;
35     }
36 
37     function ()
38         public
39     {
40         throw;
41     }
42 
43     function donate()
44         public
45         payable
46     {
47         require(msg.sender != receiver);
48         require(block.timestamp < (timeStarted + expirationInSeconds));
49         require(msg.value > 0);
50         require(minimumAmountRequired != 0);
51         require(hasBeenClaimed == false);
52 
53         assert(donationData[msg.sender] + msg.value >= donationData[msg.sender]);
54         assert(totalAmountRaised + msg.value >= totalAmountRaised);
55         assert(numPayments + 1 >= numPayments);
56 
57         donationData[msg.sender] += msg.value;
58         totalAmountRaised += msg.value;
59         numPayments += 1;
60     }
61 
62     // Note: can only be set once
63     function receiverSetAmountRequired(uint256 minimum)
64         public
65     {
66         require(msg.sender == receiver);
67         require(minimumAmountRequired == 0);
68         require(minimum > 0);
69 
70         minimumAmountRequired = minimum;
71     }
72 
73     function receiverWithdraw()
74         public
75     {
76         require(msg.sender == receiver);
77         require(totalAmountRaised >= minimumAmountRequired);
78         require(this.balance > 0);
79         require(block.timestamp < (timeStarted + expirationInSeconds));
80         require(hasBeenClaimed == false);
81 
82         hasBeenClaimed = true;
83         receiver.transfer(this.balance);
84         // Expecting transfer to throw on error
85         // assert(this.balance == 0);
86     }
87 
88     function withdraw()
89         public
90     {
91         require(donationData[msg.sender] > 0);
92         require(block.timestamp > (timeStarted + expirationInSeconds));
93         require(hasBeenClaimed == false);
94 
95         var value = donationData[msg.sender];
96         donationData[msg.sender] = 0;
97         msg.sender.transfer(value);
98         // Expecting transfer to throw on error
99         // assert(donationData[donor] == 0);
100     }
101 
102     function currentTotalExcess()
103         public
104         constant returns (uint256)
105     {
106         if (totalAmountRaised > minimumAmountRequired) {
107             return totalAmountRaised - minimumAmountRequired;
108         }
109         else {
110             return 0;
111         }
112     }
113 
114     function expirationTimestamp()
115         public
116         constant returns (uint256)
117     {
118         assert((timeStarted + expirationInSeconds) >= timeStarted);
119         return (timeStarted + expirationInSeconds);
120     }
121 }