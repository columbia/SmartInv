1 pragma solidity ^0.5.7;
2 
3 /**
4  * Copy right (c) Donex UG (haftungsbeschraenkt)
5  * All rights reserved
6  * Version 0.2.1 (BETA)
7  */
8 
9 contract Freebies
10 {
11 
12     address owner;
13     address payable public masterAddress;
14 
15     uint public deadline;
16     mapping(address => bool) gotFreebie;
17     mapping(address => bool) isMakerWithFreebiePermission;
18     mapping(address => address) makersDerivative;
19     uint public freebie;
20     uint8 public maxNumberOfFreebies;
21     uint8 public numberOfGivenFreebies;
22 
23     modifier onlyByOwner() {
24         require(msg.sender ==  owner);
25         _;
26     }
27 
28     modifier deadlineExceeded() {
29         require(now > deadline);
30         _;
31     }
32 
33     constructor (address payable _masterAddress, uint8 _maxNumberOfFreebies, uint _deadline)
34         payable
35         public
36     {
37         owner = msg.sender;
38         maxNumberOfFreebies = _maxNumberOfFreebies;
39         freebie = msg.value / maxNumberOfFreebies;
40         numberOfGivenFreebies = 0;
41         deadline = _deadline;
42         masterAddress = _masterAddress;
43     }
44 
45     /**
46      * @notice The aim is to create a derivative and find someone to buy the counter position
47      * @param long Decide if you want to be in the long or short position of your contract
48      * @param dueDate Set a due date of your contract. Make sure this is supported by us. Use OD.exchange to avoid conflicts here.
49      * @param strikePrice Choose a strike price which will be used at due date for calculation of your payout. Make sure that the format is correct. Use OD.exchange to avoid mistakes.
50      */
51     function createContractWithFreebie (
52         bool long,
53         uint256 dueDate,
54         uint256 strikePrice
55     )
56         payable
57         public
58     {
59         // New derivative must be created before deadline exceeded
60         require(now < deadline);
61 
62         // Only once per maker address
63         require(!isMakerWithFreebiePermission[msg.sender]);
64         isMakerWithFreebiePermission[msg.sender] = true;
65 
66         // Only first customers get freebie
67         numberOfGivenFreebies += 1;
68         require(numberOfGivenFreebies <= maxNumberOfFreebies);
69 
70         Master master = Master(masterAddress);
71 
72         // Create new derivative from factory
73         address newConditionalPayment = master.createConditionalPayment.value(msg.value)
74         (
75             msg.sender,
76             long,
77             dueDate,
78             strikePrice
79         );
80 
81         // Attribute derivative to maker
82         makersDerivative[msg.sender] = newConditionalPayment;
83     }
84 
85     /**
86      *  @notice Withdraw the freebie after creation of derivative and finding counter party
87      */
88     function withdrawFreebie ()
89         public
90     {
91         // Maker needs to have permission
92         require(isMakerWithFreebiePermission[msg.sender]);
93 
94         // Only one withdraw per maker
95         require(!gotFreebie[msg.sender]);
96         gotFreebie[msg.sender] = true;
97 
98         ConditionalPayment conditionalPayment = ConditionalPayment(makersDerivative[msg.sender]);
99 
100         // Derivative needs to have at least one taker
101         require(conditionalPayment.countCounterparties() > 0);
102 
103         msg.sender.transfer(freebie);
104     }
105 
106     /**
107      * @notice Owner can kick unsuccessful makers who did not succeed to find a taker before the deadline
108      */
109     function kick (address unsuccessfulMaker)
110         public
111         onlyByOwner
112         deadlineExceeded
113     {
114         ConditionalPayment conditionalPayment = ConditionalPayment(makersDerivative[unsuccessfulMaker]);
115 
116         // Unsuccessful criterium
117         require(conditionalPayment.countCounterparties() == 0);
118 
119         // Disqualify maker from freebie
120         isMakerWithFreebiePermission[unsuccessfulMaker] = false;
121 
122         // Freebie can be given to new maker
123         require(numberOfGivenFreebies > 0);
124         numberOfGivenFreebies -= 1;
125     }
126 
127     function withdrawUnusedFreebies ()
128         public
129         onlyByOwner
130         deadlineExceeded
131     {
132         msg.sender.transfer((maxNumberOfFreebies - numberOfGivenFreebies)*freebie);
133     }
134 
135 }
136 
137 
138 interface Master {
139 
140   function createConditionalPayment
141   (
142       address payable,
143       bool,
144       uint256,
145       uint256
146   )
147       payable
148       external
149       returns(address newDerivativeAddress);
150 
151 }
152 
153 interface ConditionalPayment {
154 
155   function countCounterparties() external returns(uint8);
156 
157 }