1 pragma solidity ^0.4.25;
2 
3 /*
4  * Website: smartolution.org
5  *
6  * Easiest way to participate in original Smartolution!
7  * This is not a separate project, all ether goes to the original contract!
8  * 0xe0ae35fe7Df8b86eF08557b535B89bB6cb036C23
9  * 
10  * Smartolution.org (0xe0ae35fe7Df8b86eF08557b535B89bB6cb036C23)
11  * requires you to send daily transactions for 44 days!
12  *
13  * This contract DOES IT FOR YOU!
14  *
15  * ONE transaction and AUTOMATIC PAYOUTS for 44 days! 
16  * 
17  * How it works?
18  * Easy! 
19  * Your first and only payment will be split into 45 equal parts
20  * and sent as an automatic daily payment to smartolution contract!
21  * Starting from the next day for 44 days you are going to recieve
22  * INCREASING PAYOUTS from original smartolution contract!
23  *
24  * NO NEED to send 0 ether transactions, FULLY AUTOMATED PAYROLL!
25  *
26  * Send any amount inbetween 0.45 and 225 ether!
27  *
28  * Minimum: 0.45 ether (0.01 ether daily) ~170% payout @ 45th day
29  * Maximum: 225 ehter (5 ether daily) ~155% payout @ 45th day
30  * Gas limit: 500 000
31  * Recommended gas price: https://ethgasstation.info/
32  * 
33  */
34 contract EasySmartolution {
35 
36     event ParticipantAdded(address _sender);
37     event ParticipantRemoved(address _sender);
38     event ReferrerAdded(address _contract, address _sender);
39 
40     mapping (address => address) public participants; 
41     mapping (address => bool) public referrers;
42     
43     address private processing;
44  
45     constructor(address _processing) public {
46         processing = _processing;
47     }
48     
49     function () external payable {
50         if (participants[msg.sender] == address(0)) {
51             addParticipant(msg.sender, address(0));
52         } else {
53             require(msg.value == 0, "0 ether to manually make a daily payment");
54 
55             processPayment(msg.sender);
56         }
57     }
58     
59     function addParticipant(address _address, address _referrer) payable public {
60         require(participants[_address] == address(0), "This participant is already registered");
61         require(msg.value >= 0.45 ether && msg.value <= 225 ether, "Deposit should be between 0.45 ether and 225 ether (45 days)");
62         
63         participants[_address] = address(new Participant(_address, msg.value / 45));
64         processPayment(_address);
65         
66         processing.send(msg.value / 20);
67         if (_referrer != address(0) && referrers[_referrer]) {
68             _referrer.send(msg.value / 20);
69         }
70   
71         emit ParticipantAdded(_address);
72     }
73     
74     function addReferrer(address _address) public {
75         require(!referrers[_address], "This address is already a referrer");
76         
77         referrers[_address] = true;
78         EasySmartolutionRef refContract = new EasySmartolutionRef(address(this));
79         refContract.setReferrer(_address);
80         emit ReferrerAdded(address(refContract), _address);
81     }
82 
83     function processPayment(address _address) public {
84         Participant participant = Participant(participants[_address]);
85 
86         bool done = participant.processPayment.value(participant.daily())();
87         
88         if (done) {
89             participants[_address] = address(0);
90             emit ParticipantRemoved(_address);
91         }
92     }
93 }
94 
95 contract EasySmartolutionRef {
96     address public referrer;
97     address public smartolution;
98     
99     constructor (address _smartolution) public {
100         smartolution = _smartolution;
101     }
102 
103     function setReferrer(address _referrer) external {
104         require(referrer == address(0), "referrer can only be set once");
105         referrer = _referrer;
106     }
107 
108     function () external payable {
109         if (msg.value > 0) {
110             EasySmartolution(smartolution).addParticipant.value(msg.value)(msg.sender, referrer);
111         } else {
112             EasySmartolution(smartolution).processPayment(msg.sender);
113         }
114     }
115 }
116 
117 contract Participant {
118     address constant smartolution = 0xe0ae35fe7Df8b86eF08557b535B89bB6cb036C23;
119 
120     address public owner;
121     uint public daily;
122     
123     constructor(address _owner, uint _daily) public {
124         owner = _owner;
125         daily = _daily;
126     }
127     
128     function () external payable {}
129     
130     function processPayment() external payable returns (bool) {
131         require(msg.value == daily, "Invalid value");
132         
133         uint indexBefore;
134         uint index;
135         (,indexBefore,) = SmartolutionInterface(smartolution).users(address(this));
136         smartolution.call.value(msg.value)();
137         (,index,) = SmartolutionInterface(smartolution).users(address(this));
138 
139         require(index != indexBefore, "Smartolution rejected that payment, too soon or not enough ether");
140     
141         owner.send(address(this).balance);
142 
143         return index == 45;
144     }
145 }
146 
147 contract SmartolutionInterface {
148     struct User {
149         uint value;
150         uint index;
151         uint atBlock;
152     }
153 
154     mapping (address => User) public users; 
155 }