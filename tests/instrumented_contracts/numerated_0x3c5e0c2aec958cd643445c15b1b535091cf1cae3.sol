1 pragma solidity ^0.4.25;
2 
3 /* Real Estate Token . Жетоны недвижимости
4  █ REAL ESTATE BLOCKCHAIN INNOVATIONS █ БЛОКЧЕЙН НЕДВИЖИМОСТИ ИННОВАЦИИ █
5  
6  Long-term and short-term investments █ Долгосрочные и краткосрочные инвестиции
7  Benefits from 10% to 200%            █ Преимущества от 10% до 200%
8  Invest in the ETH blockchain         █ Инвестируйте в блокчейн ETH
9  Can be withdrawn at any time         █ Может быть отозван в любое время
10  
11  How to invest? █ Как инвестировать?
12  
13  Send minimum 0.01 ETH to Smart Contract █ Отправьте не менее 0,01 ETH на Smart Contract
14  
15  You have invested 0.01 ETH and got a Real Estate Token (RET) of 20,000
16  Вы вложили 0,01 ETH и получили жетон недвижимости (RET) в размере 20 000
17  
18 How to withdraw?
19 Send 0 ETH to Contract after you get 20,000 RET
20 
21 Как снять?
22 Отправьте 0 ETH на контракт после получения 20 000 RET
23 
24 Where is the office located? █ Где находится офис?
25 
26 REAL is an initiative of Real Estate Token Pte. Ltd. UEN 201720446Z	
27 REAL является инициативой Real Estate Token Pte. Ltd. UEN 201720446Z
28  
29 
30 
31 
32 contract Multiplier {
33     //Address for promo expences
34     address constant private PROMO = 0x0000000000000000000000000000000000000000;
35     //Percent for promo expences
36     uint constant public PROMO_PERCENT = 7; //6 for advertizing, 1 for techsupport
37     //How many percent for your deposit to be multiplied
38     uint constant public MULTIPLIER = 121;
39 
40     //The deposit structure holds all the info about the deposit made
41     struct Deposit {
42         address depositor; //The depositor address
43         uint128 deposit;   //The deposit amount
44         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
45     }
46 
47     Deposit[] private queue;  //The queue
48     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
49 
50     //This function receives all the deposits
51     //stores them and make immediate payouts
52     function () public payable {
53         if(msg.value > 0){
54             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
55             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
56 
57             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
58             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
59 
60             //Send some promo to enable this contract to leave long-long time
61             uint promo = msg.value*PROMO_PERCENT/100;
62             PROMO.send(promo);
63 
64             //Pay to first investors in line
65             pay();
66         }
67     }
68 
69     //Used to pay to current investors
70     //Each new transaction processes 1 - 4+ investors in the head of queue 
71     //depending on balance and gas left
72     function pay() private {
73         //Try to send all the money on contract to the first investors in line
74         uint128 money = uint128(address(this).balance);
75 
76         //We will do cycle on the queue
77         for(uint i=0; i<queue.length; i++){
78 
79             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
80 
81             Deposit storage dep = queue[idx]; //get the info of the first investor
82 
83             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
84                 dep.depositor.send(dep.expect); //Send money to him
85                 money -= dep.expect;            //update money left
86 
87                 //this investor is fully paid, so remove him
88                 delete queue[idx];
89             }else{
90                 //Here we don't have enough money so partially pay to investor
91                 dep.depositor.send(money); //Send to him everything we have
92                 dep.expect -= money;       //Update the expected amount
93                 break;                     //Exit cycle
94             }
95 
96             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
97                 break;                     //The next investor will process the line further
98         }
99 
100         currentReceiverIndex += i; //Update the index of the current first investor
101     }
102 
103     //Get the deposit info by its index
104     //You can get deposit index from
105     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
106         Deposit storage dep = queue[idx];
107         return (dep.depositor, dep.deposit, dep.expect);
108     }
109 
110     //Get the count of deposits of specific investor
111     function getDepositsCount(address depositor) public view returns (uint) {
112         uint c = 0;
113         for(uint i=currentReceiverIndex; i<queue.length; ++i){
114             if(queue[i].depositor == depositor)
115                 c++;
116         }
117         return c;
118     }
119 
120     //Get all deposits (index, deposit, expect) of a specific investor
121     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
122         uint c = getDepositsCount(depositor);
123 
124         idxs = new uint[](c);
125         deposits = new uint128[](c);
126         expects = new uint128[](c);
127 
128         if(c > 0) {
129             uint j = 0;
130             for(uint i=currentReceiverIndex; i<queue.length; ++i){
131                 Deposit storage dep = queue[i];
132                 if(dep.depositor == depositor){
133                     idxs[j] = i;
134                     deposits[j] = dep.deposit;
135                     expects[j] = dep.expect;
136                     j++;
137                 }
138             }
139         }
140     }
141     
142     //Get current queue size
143     function getQueueLength() public view returns (uint) {
144         return queue.length - currentReceiverIndex;
145     }
146 
147 }
148 
149 */
150 
151 contract Token {
152 
153     
154     function totalSupply() constant returns (uint256 supply) {}
155 
156     
157     function balanceOf(address _owner) constant returns (uint256 balance) {}
158 
159     function transfer(address _to, uint256 _value) returns (bool success) {}
160 
161     
162     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
163 
164     
165     function approve(address _spender, uint256 _value) returns (bool success) {}
166 
167     
168     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
169 
170     event Transfer(address indexed _from, address indexed _to, uint256 _value);
171     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
172 
173 }
174 
175 contract StandardToken is Token {
176 
177     function transfer(address _to, uint256 _value) returns (bool success) {
178         //Default assumes totalSupply can't be over max (2^256 - 1).
179         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
180         //Replace the if with this one instead.
181         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
182         if (balances[msg.sender] >= _value && _value > 0) {
183             balances[msg.sender] -= _value;
184             balances[_to] += _value;
185             Transfer(msg.sender, _to, _value);
186             return true;
187         } else { return false; }
188     }
189 
190     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
191         //same as above. Replace this line with the following if you want to protect against wrapping uints.
192         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
193         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
194             balances[_to] += _value;
195             balances[_from] -= _value;
196             allowed[_from][msg.sender] -= _value;
197             Transfer(_from, _to, _value);
198             return true;
199         } else { return false; }
200     }
201 
202     function balanceOf(address _owner) constant returns (uint256 balance) {
203         return balances[_owner];
204     }
205 
206     function approve(address _spender, uint256 _value) returns (bool success) {
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
213       return allowed[_owner][_spender];
214     }
215 
216     mapping (address => uint256) balances;
217     mapping (address => mapping (address => uint256)) allowed;
218     uint256 public totalSupply;
219 }
220 
221 contract RealEstateToken is StandardToken { 
222     string public name;                   
223     uint8 public decimals;                
224     string public symbol;                 
225     string public version = 'H1.0'; 
226     uint256 public unitsOneEthCanBuy;     
227     uint256 public totalEthInWei;           
228     address public fundsWallet;          
229 
230     
231     function RealEstateToken() {
232         balances[msg.sender] = 201009982000000000000000000;               
233         name = "Real Estate Token";                                   
234         decimals = 18;                                              
235         symbol = "RET";                                             
236         unitsOneEthCanBuy = 2000000;                                      
237         fundsWallet = msg.sender;                                 
238     }
239 
240     function() payable{
241         totalEthInWei = totalEthInWei + msg.value;
242         uint256 amount = msg.value * unitsOneEthCanBuy;
243         if (balances[fundsWallet] < amount) {
244             return;
245         }
246 
247         balances[fundsWallet] = balances[fundsWallet] - amount;
248         balances[msg.sender] = balances[msg.sender] + amount;
249 
250         Transfer(fundsWallet, msg.sender, amount); 
251 
252         
253         fundsWallet.transfer(msg.value);                               
254     }
255 
256     
257     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
258         allowed[msg.sender][_spender] = _value;
259         Approval(msg.sender, _spender, _value);
260 
261         
262         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
263         return true;
264     }
265 }