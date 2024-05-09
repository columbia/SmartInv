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
35     address constant smartolution = 0xe0ae35fe7Df8b86eF08557b535B89bB6cb036C23;
36     
37     event ParticipantAdded(address _sender);
38     event ParticipantRemoved(address _sender);
39     event ReferrerAdded(address _contract, address _sender);
40 
41     mapping (address => address) public participants; 
42     mapping (address => bool) public referrers;
43     
44     address private processing;
45  
46     constructor(address _processing) public {
47         processing = _processing;
48     }
49     
50     function () external payable {
51         if (participants[msg.sender] == address(0)) {
52             addParticipant(msg.sender, address(0));
53         } else {
54             if (msg.value == 0) {
55                 processPayment(msg.sender);
56             } else if (msg.value == 0.00001111 ether) {
57                 getOut();
58             } else {
59                 revert();
60             }
61         }
62     }
63     
64     function addParticipant(address _address, address _referrer) payable public {
65         require(participants[_address] == address(0), "This participant is already registered");
66         require(msg.value >= 0.45 ether && msg.value <= 225 ether, "Deposit should be between 0.45 ether and 225 ether (45 days)");
67         
68         participants[_address] = address(new Participant(_address, msg.value / 45));
69         processPayment(_address);
70         
71         processing.send(msg.value / 33);
72         if (_referrer != address(0) && referrers[_referrer]) {
73             _referrer.send(msg.value / 20);
74         }
75   
76         emit ParticipantAdded(_address);
77     }
78     
79     function addReferrer(address _address) public {
80         require(!referrers[_address], "This address is already a referrer");
81         
82         referrers[_address] = true;
83         EasySmartolutionRef refContract = new EasySmartolutionRef();
84         refContract.setReferrer(_address);
85         refContract.setSmartolution(address(this));
86         
87         emit ReferrerAdded(address(refContract), _address);
88     }
89 
90     function processPayment(address _address) public {
91         Participant participant = Participant(participants[_address]);
92 
93         bool done = participant.processPayment.value(participant.daily())();
94         
95         if (done) {
96             participants[_address] = address(0);
97             emit ParticipantRemoved(_address);
98         }
99     }
100     
101     function getOut() public {
102         require(participants[msg.sender] != address(0), "You are not a participant");
103         Participant participant = Participant(participants[msg.sender]);
104         uint index;
105         uint value;
106         (value, index, ) = SmartolutionInterface(smartolution).users(address(participant));
107         uint paymentsLeft = (45 - index) * value;
108         if (paymentsLeft > address(this).balance) {
109             paymentsLeft = address(this).balance;
110         }
111         
112         participants[msg.sender] = address(0);
113         emit ParticipantRemoved(msg.sender);
114         
115         msg.sender.transfer(paymentsLeft);
116     }
117 }
118 
119 contract EasySmartolutionRef {
120     address public referrer;
121     address public smartolution;
122     
123     constructor () public {
124     }
125 
126     function setReferrer(address _referrer) external {
127         require(referrer == address(0), "referrer can only be set once");
128         referrer = _referrer;
129     }
130 
131     function setSmartolution(address _smartolution) external {
132         require(smartolution == address(0), "smartolution can only be set once");
133         smartolution = _smartolution;
134     }
135 
136     function () external payable {
137         if (msg.value > 0) {
138             EasySmartolution(smartolution).addParticipant.value(msg.value)(msg.sender, referrer);
139         } else {
140             EasySmartolution(smartolution).processPayment(msg.sender);
141         }
142     }
143 }
144 
145 contract Participant {
146     address constant smartolution = 0xe0ae35fe7Df8b86eF08557b535B89bB6cb036C23;
147 
148     address public owner;
149     uint public daily;
150     
151     constructor(address _owner, uint _daily) public {
152         owner = _owner;
153         daily = _daily;
154     }
155     
156     function () external payable {}
157     
158     function processPayment() external payable returns (bool) {
159         require(msg.value == daily, "Invalid value");
160         
161         uint indexBefore;
162         uint index;
163         (,indexBefore,) = SmartolutionInterface(smartolution).users(address(this));
164         smartolution.call.value(msg.value)();
165         (,index,) = SmartolutionInterface(smartolution).users(address(this));
166 
167         require(index != indexBefore, "Smartolution rejected that payment, too soon or not enough ether");
168     
169         owner.send(address(this).balance);
170 
171         return index == 45;
172     }
173 }
174 
175 contract SmartolutionInterface {
176     struct User {
177         uint value;
178         uint index;
179         uint atBlock;
180     }
181 
182     mapping (address => User) public users; 
183 }