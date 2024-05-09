1 pragma solidity ^0.5.8;
2 
3 /**
4  * Copy right (c) Donex UG (haftungsbeschraenkt)
5  * All rights reserved
6  * Version 0.2.1 (BETA)
7  */
8 
9 contract Bounty {
10 
11     address payable public masterAddress;
12     mapping(address => bool) bountyPermission;
13     uint public bounty;
14     mapping(address => bool) gotBounty;
15 
16     uint8 public maxNumberOfBounties;
17     uint8 public numberOfGivenBounties;
18 
19     mapping(address => address) creatorsConditionalPaymentAddress;
20 
21     address owner;
22     uint public deadline;
23 
24     modifier onlyByOwner ()
25     {
26         require(msg.sender ==  owner);
27         _;
28     }
29 
30     modifier deadlineExceeded ()
31     {
32         require(now > deadline);
33         _;
34     }
35 
36     constructor (
37         address payable _masterAddress,
38         uint8 _maxNumberOfBounties,
39         uint _deadline
40     )
41         payable
42         public
43     {
44         owner = msg.sender;
45         deadline = _deadline;
46         numberOfGivenBounties = 0;
47         maxNumberOfBounties = _maxNumberOfBounties;
48         bounty = msg.value / maxNumberOfBounties;
49         masterAddress = _masterAddress;
50     }
51 
52     /**
53      * @notice The aim is to create a conditional payment and find someone to buy the counter position
54      *
55      * Parameters to forward to master contract:
56      * @param long .. Decide if you want to be in the long or short position of your contract.
57      * @param dueDate .. Set a due date of your contract. Make sure this is supported by us. Use OD.exchange to avoid conflicts here.
58      * @param strikePrice .. Choose a strike price which will be used at due date for calculation of your payout. Make sure that the format is correct. Use OD.exchange to avoid mistakes.
59      */
60     function createContractWithBounty (
61         bool long,
62         uint256 dueDate,
63         uint256 strikePrice
64     )
65         payable
66         public
67     {
68         // New conditional payment must be created before deadline exceeded
69         require(now < deadline);
70 
71         // Only once per creator address
72         require(!bountyPermission[msg.sender]);
73         bountyPermission[msg.sender] = true;
74 
75         // Only first customers can get bounty
76         numberOfGivenBounties += 1;
77         require(numberOfGivenBounties <= maxNumberOfBounties);
78 
79         // Create new conditional payment in master contract:
80         Master master = Master(masterAddress);
81         address newConditionalPayment = master.createConditionalPayment.value(msg.value)(
82             msg.sender,
83             long,
84             dueDate,
85             strikePrice
86         );
87 
88         // Attribute conditional payment to creator
89         creatorsConditionalPaymentAddress[msg.sender] = newConditionalPayment;
90     }
91 
92     /**
93      *  @notice Withdraw the bounty after creation of conditional payment and finding counter party
94      */
95     function withdrawBounty ()
96         public
97     {
98         // Creator needs to have permission
99         require(bountyPermission[msg.sender]);
100         bountyPermission[msg.sender] = false;
101 
102         // Only one withdraw per creator
103         require(!gotBounty[msg.sender]);
104         gotBounty[msg.sender] = true;
105 
106         ConditionalPayment conditionalPayment = ConditionalPayment(creatorsConditionalPaymentAddress[msg.sender]);
107 
108         // Conditional payment needs to have at least one counter party
109         require(conditionalPayment.countCounterparties() > 0);
110 
111         msg.sender.transfer(bounty);
112     }
113 
114     /**
115      * @notice Owner can withdraw bounty permission if creators did not succeed to find a taker before the deadline
116      */
117     function withdrawPermission (address unsuccessfulCreator)
118         public
119         onlyByOwner
120         deadlineExceeded
121     {
122         // Unsuccessful criterium
123         ConditionalPayment conditionalPayment = ConditionalPayment(creatorsConditionalPaymentAddress[unsuccessfulCreator]);
124         require(conditionalPayment.countCounterparties() == 0);
125 
126         // Disqualify creator from bounty
127         bountyPermission[unsuccessfulCreator] = false;
128         creatorsConditionalPaymentAddress[msg.sender] = 0x0000000000000000000000000000000000000000;
129 
130         numberOfGivenBounties -= 1;
131     }
132 
133     function withdrawUnusedBounties ()
134         public
135         onlyByOwner
136         deadlineExceeded
137     {
138         msg.sender.transfer((maxNumberOfBounties - numberOfGivenBounties)*bounty);
139     }
140 
141 }
142 
143 
144 interface Master {
145 
146     function createConditionalPayment (
147         address payable,
148         bool,
149         uint256,
150         uint256
151     )
152         payable
153         external
154         returns(address newDerivativeAddress);
155 
156 }
157 
158 interface ConditionalPayment {
159 
160     function countCounterparties () external returns(uint8);
161 
162 }