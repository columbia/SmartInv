1 pragma solidity ^0.4.20;
2 
3 contract Gladiethers
4 {
5     address public m_Owner;
6     address public partner;
7 
8     mapping (address => uint) public gladiatorToPower; // gladiator power
9     mapping (address => uint) public gladiatorToCooldown;
10     mapping(address => uint) public gladiatorToQueuePosition;
11     mapping(address => bool)  public trustedContracts;
12     uint public m_OwnerFees = 0;
13     address public kingGladiator;
14     address public oraclizeContract;
15     address[] public queue;
16     
17     bool started = false;
18 
19 
20     event fightEvent(address indexed g1,address indexed g2,uint random,uint fightPower,uint g1Power);
21     modifier OnlyOwnerAndContracts() {
22         require(msg.sender == m_Owner ||  trustedContracts[msg.sender]);
23         _;
24     }
25     function ChangeAddressTrust(address contract_address,bool trust_flag) public OnlyOwnerAndContracts() {
26         require(msg.sender != contract_address);
27         trustedContracts[contract_address] = trust_flag;
28     }
29     
30     function Gladiethers() public{
31         m_Owner = msg.sender;
32     }
33     
34     function setPartner(address contract_partner) public OnlyOwnerAndContracts(){
35         partner = contract_partner;
36     }
37     
38     function setOraclize(address contract_oraclize) public OnlyOwnerAndContracts(){
39         require(!started);
40         oraclizeContract = contract_oraclize;
41         started = true;
42     }
43 
44     function joinArena() public payable returns (bool){
45 
46         require( msg.value >= 10 finney );
47 
48         if(queue.length > gladiatorToQueuePosition[msg.sender]){
49 
50             if(queue[gladiatorToQueuePosition[msg.sender]] == msg.sender){
51                 gladiatorToPower[msg.sender] += msg.value;
52                 return false;
53             }
54         }
55         
56         enter(msg.sender);
57         return true;  
58 
59     }
60 
61     function enter(address gladiator) private{
62         gladiatorToCooldown[gladiator] = now + 1 days;
63         queue.push(gladiator);
64         gladiatorToQueuePosition[gladiator] = queue.length - 1;
65         gladiatorToPower[gladiator] += msg.value;
66     }
67 
68 
69     function remove(address gladiator) private returns(bool){
70         
71         if(queue.length > gladiatorToQueuePosition[gladiator]){
72 
73             if(queue[gladiatorToQueuePosition[gladiator]] == gladiator){ // is on the line ?
74             
75                 queue[gladiatorToQueuePosition[gladiator]] = queue[queue.length - 1];
76                 gladiatorToQueuePosition[queue[queue.length - 1]] = gladiatorToQueuePosition[gladiator];
77                 gladiatorToCooldown[gladiator] =  9999999999999; // indicative number to know when it is in battle
78                 delete queue[queue.length - 1];
79                 queue.length = queue.length - (1);
80                 return true;
81                 
82             }
83            
84         }
85         return false;
86         
87         
88     }
89 
90     function removeOrc(address _gladiator) public {
91         require(msg.sender == oraclizeContract);
92         remove(_gladiator);
93     }
94 
95     function setCooldown(address gladiator, uint cooldown) internal{
96         gladiatorToCooldown[gladiator] = cooldown;
97     }
98 
99     function getGladiatorPower(address gladiator) public view returns (uint){
100         return gladiatorToPower[gladiator];
101     }
102     
103     function getQueueLenght() public view returns (uint){
104         return queue.length;
105     }
106 
107     function fight(address gladiator1,string _result) public {
108 
109         require(msg.sender == oraclizeContract);
110         
111         // in a unlikely case of 3 guys in queue two of them scheduleFight and the last one withdraws and left the first fighter that enconters the queue empty becomes the kingGladiator
112         if(queue.length == 0){  
113             gladiatorToCooldown[gladiator1] = now + 1 days;
114             queue.push(gladiator1);
115             gladiatorToQueuePosition[gladiator1] = queue.length - 1;
116             kingGladiator = gladiator1;
117         }else{
118         
119             uint indexgladiator2 = uint(sha3(_result)) % queue.length; // this is an efficient way to get the uint out in the [0, maxRange] range
120             uint randomNumber = uint(sha3(_result)) % 1000;
121             address gladiator2 = queue[indexgladiator2];
122             
123             require(gladiatorToPower[gladiator1] >= 10 finney && gladiator1 != gladiator2);
124     
125             
126             uint g1chance = gladiatorToPower[gladiator1];
127             uint g2chance =  gladiatorToPower[gladiator2];
128             uint fightPower = SafeMath.add(g1chance,g2chance);
129     
130             g1chance = (g1chance*1000)/fightPower;
131     
132             if(g1chance <= 958){
133                 g1chance = SafeMath.add(g1chance,40);
134             }else{
135                 g1chance = 998;
136             }
137     
138             fightEvent( gladiator1, gladiator2,randomNumber,fightPower,gladiatorToPower[gladiator1]);
139             uint devFee;
140     
141             if(randomNumber <= g1chance ){ // Wins the Attacker
142                 devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator2],4),100);
143     
144                 gladiatorToPower[gladiator1] =  SafeMath.add( gladiatorToPower[gladiator1], SafeMath.sub(gladiatorToPower[gladiator2],devFee) );
145                 queue[gladiatorToQueuePosition[gladiator2]] = gladiator1;
146                 gladiatorToQueuePosition[gladiator1] = gladiatorToQueuePosition[gladiator2];
147                 gladiatorToPower[gladiator2] = 0;
148                 gladiatorToCooldown[gladiator1] = now + 1 days; // reset atacker cooldown
149     
150                 if(gladiatorToPower[gladiator1] > gladiatorToPower[kingGladiator] ){ // check if is the biggest guy in the arena
151                     kingGladiator = gladiator1;
152                 }
153     
154             }else{
155                 //Defender Wins
156                 devFee = SafeMath.div(SafeMath.mul(gladiatorToPower[gladiator1],4),100);
157     
158                 gladiatorToPower[gladiator2] = SafeMath.add( gladiatorToPower[gladiator2],SafeMath.sub(gladiatorToPower[gladiator1],devFee) );
159                 gladiatorToPower[gladiator1] = 0;
160     
161                 if(gladiatorToPower[gladiator2] > gladiatorToPower[kingGladiator] ){
162                     kingGladiator = gladiator2;
163                 }
164 
165         }
166 
167         
168         gladiatorToPower[kingGladiator] = SafeMath.add( gladiatorToPower[kingGladiator],SafeMath.div(devFee,4) ); // gives 1%      (4% dead gladiator / 4 )
169         m_OwnerFees = SafeMath.add( m_OwnerFees , SafeMath.sub(devFee,SafeMath.div(devFee,4)) ); // 4total - 1king  = 3%
170         }
171         
172         
173 
174     }
175 
176 
177     function withdraw(uint amount) public  returns (bool success){
178         address withdrawalAccount;
179         uint withdrawalAmount;
180 
181         // owner and partner can withdraw
182         if (msg.sender == m_Owner || msg.sender == partner ) {
183             withdrawalAccount = m_Owner;
184             withdrawalAmount = m_OwnerFees;
185             uint partnerFee = SafeMath.div(SafeMath.mul(withdrawalAmount,15),100);
186 
187             // set funds to 0
188             m_OwnerFees = 0;
189 
190             if (!m_Owner.send(SafeMath.sub(withdrawalAmount,partnerFee))) revert(); // send to owner
191             if (!partner.send(partnerFee)) revert(); // send to partner
192 
193             return true;
194         }else{
195 
196             withdrawalAccount = msg.sender;
197             withdrawalAmount = amount;
198 
199             // cooldown has been reached and the ammout i possible
200             if(gladiatorToCooldown[msg.sender] < now && gladiatorToPower[withdrawalAccount] >= withdrawalAmount){
201 
202                 gladiatorToPower[withdrawalAccount] = SafeMath.sub(gladiatorToPower[withdrawalAccount],withdrawalAmount);
203 
204                 // gladiator have to be removed from areana if the power is less then 0.01 eth
205                 if(gladiatorToPower[withdrawalAccount] < 10 finney){
206                     remove(msg.sender);
207                 }
208 
209             }else{
210                 return false;
211             }
212 
213         }
214 
215         if (withdrawalAmount == 0) revert();
216 
217         // send the funds
218         if (!msg.sender.send(withdrawalAmount)) revert();
219 
220 
221         return true;
222     }
223 
224 
225 }
226 
227 library SafeMath {
228 
229     /**
230     * @dev Multiplies two numbers, throws on overflow.
231     */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         if (a == 0) {
234             return 0;
235         }
236         uint256 c = a * b;
237         assert(c / a == b);
238         return c;
239     }
240 
241     /**
242     * @dev Integer division of two numbers, truncating the quotient.
243     */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         // assert(b > 0); // Solidity automatically throws when dividing by 0
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248         return c;
249     }
250 
251     /**
252     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
253     */
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         assert(b <= a);
256         return a - b;
257     }
258 
259     /**
260     * @dev Adds two numbers, throws on overflow.
261     */
262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
263         uint256 c = a + b;
264         assert(c >= a);
265         return c;
266     }
267 }