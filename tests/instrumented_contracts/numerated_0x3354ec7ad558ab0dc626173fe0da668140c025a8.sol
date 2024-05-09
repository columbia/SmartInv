1 //A BurnableOpenPaymet is instantiated with a specified payer and a commitThreshold.
2 //The recipient not set when the contract is instantiated.
3 
4 //The constructor is payable, so the contract can be instantiated with initial funds.
5 //Anyone can contribute to the payment at any time (the () function is payable).
6 
7 //All behavior of the contract is directed by the payer, but
8 //the payer can never directly recover the payment unless he becomes the recipient.
9 
10 //Anyone can become the recipient by contributing the commitThreshold.
11 //The recipient cannot change once it's been set.
12 
13 //The payer can at any time choose to burn or release to the recipient any amount of funds.
14 
15 pragma solidity ^0.4.1;
16 
17 contract BurnableOpenPayment {
18     address public payer;
19     address public recipient;
20     address public burnAddress = 0xdead;
21     string public payerString;
22     string public recipientString;
23     uint public commitThreshold;
24     
25     modifier onlyPayer() {
26         if (msg.sender != payer) throw;
27         _;
28     }
29     
30     modifier onlyRecipient() {
31         if (msg.sender != recipient) throw;
32         _;
33     }
34     
35     modifier onlyWithRecipient() {
36         if (recipient == address(0x0)) throw;
37         _;
38     }
39     
40     modifier onlyWithoutRecipient() {
41         if (recipient != address(0x0)) throw;
42         _;
43     }
44     
45     function () payable {}
46     
47     function BurnableOpenPayment(address _payer, uint _commitThreshold)
48     public
49     payable {
50         payer = _payer;
51         commitThreshold = _commitThreshold;
52     }
53     
54     function getPayer()
55     public returns (address) { return payer; }
56     
57     function getRecipient()
58     public returns (address) { return recipient; }
59     
60     function getCommitThreshold()
61     public returns (uint) { return commitThreshold; }
62     
63     function getPayerString()
64     public returns (string) { return payerString; }
65     
66     function getRecipientString()
67     public returns (string) { return recipientString; }
68     
69     function commit()
70     public
71     onlyWithoutRecipient()
72     payable
73     {
74         if (msg.value < commitThreshold) throw;
75         recipient = msg.sender;
76     }
77     
78     function burn(uint amount)
79     public
80     onlyPayer()
81     onlyWithRecipient()
82     returns (bool)
83     {
84         return burnAddress.send(amount);
85     }
86     
87     function release(uint amount)
88     public
89     onlyPayer()
90     onlyWithRecipient()
91     returns (bool)
92     {
93         return recipient.send(amount);
94     }
95     
96     function setPayerString(string _string)
97     public
98     onlyPayer()
99     {
100         payerString = _string;
101     }
102     
103     function setRecipientString(string _string)
104     public
105     onlyRecipient()
106     {
107         recipientString = _string;
108     }
109 }