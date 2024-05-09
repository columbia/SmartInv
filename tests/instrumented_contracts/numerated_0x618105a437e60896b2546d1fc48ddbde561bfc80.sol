1 pragma solidity 0.4.19;
2 
3 contract carnitaAsada{
4     address addressManager; // Oscar Angel Cardenas
5     address  bitsoAddress; //address to pay carnitaAsada
6     carnita [] carnitas; //array of carnitas
7     uint256 lastCarnita; //index of last carnita
8     bool public halted = false; // flag for emergency stop or start
9     uint256 currentPeople; // current max number of people who can participate
10     uint256 priceCarnita; // current price of carnita
11     uint toPaycarnita; // amount will pay to the carnita 
12     
13     struct carnita{
14         uint256 maxPeople; //max quantity of participants
15         bool active; // flag to see if is still active
16         uint256 raised; //amount of eth raised
17         uint256 min; //minimun eth to participate
18         address[] participants; //list of participants
19         
20     }
21     
22     function carnitaAsada(address _manager, address _bitso) public{
23         addressManager= _manager;
24         bitsoAddress= _bitso;
25         lastCarnita=0;
26         priceCarnita= 0.015 ether;
27         currentPeople= 8;
28         toPaycarnita=0.012 ether;
29         
30         //first carnitaAsada
31         carnita memory temp;
32         temp.maxPeople=currentPeople;
33         temp.active=true;
34         temp.raised=0;
35         temp.min=priceCarnita;
36         carnitas.push(temp);
37        
38     }
39     
40     // only manager can do this action
41     modifier onlyManager() {
42         require(msg.sender ==  addressManager);
43         _;
44     }
45     // Checks if Contract is running and has not been stopped
46     modifier onContractRunning() {
47         require( halted == false);
48         _;
49     }
50     // Checks if Contract was stopped or deadline is reached
51     modifier onContractStopped() {
52       require( halted == true);
53         _;
54     }
55 
56    
57     //generate a random number
58     function rand() internal constant returns (uint32 res){
59         return uint32(block.number^now)%uint32(carnitas[lastCarnita].participants.length);
60     }
61     
62     //recover funds in case of error
63     function recoverAllEth() onlyManager public {
64         addressManager.transfer(this.balance);
65     }
66     
67     /*
68     *   Emergency Stop or Contract.
69     *
70     */
71 
72     function  halt() onlyManager  onContractRunning public{
73          halted = true;
74     }
75 
76     function  unhalt() onlyManager onContractStopped public {
77         halted = false;
78     }
79     
80     //change manager
81     function newManager(address _newManager) onlyManager public{
82         addressManager= _newManager;
83     }
84     //see the current manager
85     function getManager() public constant returns (address _manager){
86         return addressManager;
87     }
88     //change bitsoAddress
89     function newBitsoAddress(address _newAddress) onlyManager public{
90         addressManager= _newAddress;
91     }
92     //see the current manager
93     function getBitsoAddress() public constant returns (address _bitsoAddress){
94         return bitsoAddress;
95     }
96     // see the current price of carnita
97     function getPrice() public constant returns(uint256 _price){
98         return priceCarnita;
99     }
100     
101    // Change current price of carnita
102     function setPrice(uint256 _newPriceCarnita) onlyManager public{
103         priceCarnita=_newPriceCarnita;
104         carnitas[lastCarnita].min=priceCarnita;
105     }
106     
107     // see the current price to Paycarnita
108     function getPaycarnita() public constant returns(uint256 _Paycarnita){
109         return toPaycarnita;
110     }
111     
112    // Change current price of Paycarnita
113     function setPaycarnita(uint256 _newPaycarnita) onlyManager public{
114         toPaycarnita=_newPaycarnita;
115     }
116     
117     // see the current max participants
118     function getMaxParticipants() public constant returns(uint256 _max){
119         return currentPeople;
120     }
121     // Change current minimun of max participants
122     function setMaxParticipants(uint256 _newMax) onlyManager public{
123         currentPeople=_newMax;
124         carnitas[lastCarnita].maxPeople=currentPeople;
125     }
126     
127    
128     //check the number of current participants
129     function seeCurrentParticipants()public constant returns(uint256 _participants){
130         return carnitas[lastCarnita].participants.length;
131     }
132     // add new participant
133     function addParticipant(address _buyer, uint256 _value) internal {
134         require(_value == priceCarnita || _buyer== addressManager);
135         /*if (carnitas[lastCarnita].maxPeople == carnitas[lastCarnita].participants.length){
136             newCarnita();
137         }*///this no works because is created when the payCarnita function is called
138         carnitas[lastCarnita].participants.push(_buyer);
139         carnitas[lastCarnita].raised+=_value;
140         if(carnitas[lastCarnita].maxPeople == carnitas[lastCarnita].participants.length){
141             halted = true;
142         }
143         
144     }
145     //generate new carnitaAsada
146     function newCarnita() internal{
147         carnitas[lastCarnita].active=false;
148         carnita memory temp;
149         temp.maxPeople=currentPeople;
150         temp.active=true;
151         temp.raised=0;
152         temp.min=priceCarnita;
153         carnitas.push(temp);
154         lastCarnita+=1;
155     }
156     
157     //pay the carnitaAsada
158     
159     function payCarnita(uint256 _gasUsed, uint256 _bill) onlyManager public{
160         uint256 winner = uint256(rand());// define a random winner
161         addressManager.transfer(_gasUsed); //pay the gas to the Manager
162         
163         //to pay the bill could be toPaycarnita variable or set by manager
164         if(_bill>0){
165             bitsoAddress.transfer(carnitas[lastCarnita].participants.length*_bill);
166         }else{
167         bitsoAddress.transfer(carnitas[lastCarnita].participants.length*toPaycarnita);
168         }
169         
170         carnitas[lastCarnita].participants[winner].transfer(this.balance);//send money to the winner
171         halted=false;//activate the Contract again
172         newCarnita(); //create new carnita
173         
174     }
175     
176     /*
177      *  default fall back function      
178      */
179     function () onContractRunning payable  public {
180                  addParticipant(msg.sender, msg.value);           
181             }
182     
183     
184     
185     
186     
187     
188 }