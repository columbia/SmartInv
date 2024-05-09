1 pragma solidity ^0.4.8;
2 //interfaces for correct compiling
3 contract IElectricQueue {
4      
5         function ElectricQueue();
6   
7       //external function that gives possibility to invest in queue or concret charger
8         function  investInQueue(address _from , uint _charger) payable  returns(bool success);
9     
10 
11       function   returnMoney(address _to) payable returns (bool success);
12 }
13 //contract
14 contract ProxyElectricQueue 
15 {
16     address public Owner = msg.sender;      
17     address public Manager;
18     IElectricQueue public ActualQueue; 
19        function setManager(address manager) external{
20              if (msg.sender != Owner) return ;
21              Manager = manager;
22         }
23     function changeActualQueue(address actualQueueAddress){
24     if (msg.sender != Owner && msg.sender != Manager) return ;
25         ActualQueue =IElectricQueue(actualQueueAddress);
26     }
27     
28     function investInCharger (uint chargerId) payable  {
29         if(msg.value < 1 ether){
30             if(!msg.sender.send(msg.value))
31                 throw;
32         } 
33         ActualQueue.investInQueue.value(msg.value)(msg.sender,chargerId);
34     }
35     function returnMoney() payable{
36         if(msg.value < 10 finney || msg.value > 1 ether){
37              if(!msg.sender.send(msg.value))
38                 throw;
39         }
40         ActualQueue.returnMoney.value(msg.value)(msg.sender);
41 
42     }
43     function ()  payable{
44         if(msg.value < 1 ether){
45            if(!msg.sender.send(msg.value))
46                 throw;
47         } 
48         ActualQueue.investInQueue.value(msg.value)(msg.sender,0);
49     }
50     
51 }