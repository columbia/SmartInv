1 pragma solidity ^0.4.25;
2 
3 
4 contract Fast50plus {
5     //Address for marketing expences
6     address constant private MARKETING = 0x82770c9dE54e316a9eba378516A3314Bc17FAcbe;
7     //Percent for marketing expences
8     uint constant public MARKETING_PERCENT = 8;
9     uint constant public MAX_PERCENT = 110;
10     
11     struct Deposit {
12         address depositor; 
13         uint128 deposit;  
14         uint128 expect;   
15     }
16 
17     Deposit[] private queue;  
18     uint public currentReceiverIndex = 0;
19     
20     function () public payable {
21         if(msg.value > 0){
22             
23             require(gasleft() >= 220000);
24             require(msg.value <= 7.5 ether);
25             
26             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MAX_PERCENT/100)));
27             uint promo = msg.value*MARKETING_PERCENT/100;
28             MARKETING.transfer(promo);
29             pay();
30         }
31     }
32     
33     function pay() private {
34         //Try to send all the money on contract to the first investors in line
35         uint128 money = uint128(address(this).balance);
36 
37         //We will do cycle on the queue
38         for(uint i=0; i<queue.length; i++){
39 
40             uint idx = currentReceiverIndex + i; 
41 
42             Deposit storage dep = queue[idx]; 
43             if(money >= dep.expect){  
44                 dep.depositor.transfer(dep.expect);
45                 money -= dep.expect;   
46                 delete queue[idx];
47             }else{
48                 dep.depositor.transfer(money); 
49                 dep.expect -= money;      
50                 break;                    
51             }
52 
53             if(gasleft() <= 50000)         
54                 break;                    
55         }
56 
57         currentReceiverIndex += i;
58     }
59    
60     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
61         Deposit storage dep = queue[idx];
62         return (dep.depositor, dep.deposit, dep.expect);
63     }
64    
65     function getDepositsCount(address depositor) public view returns (uint) {
66         uint c = 0;
67         for(uint i=currentReceiverIndex; i<queue.length; ++i){
68             if(queue[i].depositor == depositor)
69                 c++;
70         }
71         return c;
72     }
73     
74     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
75         uint c = getDepositsCount(depositor);
76 
77         idxs = new uint[](c);
78         deposits = new uint128[](c);
79         expects = new uint128[](c);
80 
81         if(c > 0) {
82             uint j = 0;
83             for(uint i=currentReceiverIndex; i<queue.length; ++i){
84                 Deposit storage dep = queue[i];
85                 if(dep.depositor == depositor){
86                     idxs[j] = i;
87                     deposits[j] = dep.deposit;
88                     expects[j] = dep.expect;
89                     j++;
90                 }
91             }
92         }
93     }
94     
95     function getQueueLength() public view returns (uint) {
96         return queue.length - currentReceiverIndex;
97     }
98 
99 }