1 contract TossMyCoin {
2 
3   uint fee;
4   uint public balance = 0;
5   uint  balanceLimit = 0;
6   address public owner;
7   uint public active = 1;
8   uint FirstRun = 1;
9 
10   modifier onlyowner { if (msg.sender == owner) _ }
11 
12 
13   function TossMyCoin() {
14     owner = msg.sender;
15   }
16 
17   function() {
18     enter();
19   }
20   
21   function enter() {
22   
23   if(active ==0){
24   msg.sender.send(msg.value);
25   return;
26   }
27   
28   if(FirstRun == 1){
29   balance = msg.value;
30   FirstRun = 0;
31   }
32   
33     if(msg.value < 10 finney){
34         msg.sender.send(msg.value);
35         return;
36     }
37 
38     uint amount;
39 	uint reward;
40     fee = msg.value / 10;
41     owner.send(fee);
42     fee = 0;
43     amount = msg.value * 9 / 10;
44 	
45     balanceLimit = balance * 8 / 10;
46     if (amount > balanceLimit){
47         msg.sender.send(amount - balanceLimit);
48         amount = balanceLimit;
49     }
50 
51     var toss = uint(sha3(msg.gas)) + uint(sha3(block.timestamp));
52         
53     if (toss % 2 == 0){
54     balance = balance + amount ;  
55     } 
56     else{
57 	reward = amount * 2;
58     msg.sender.send(reward);	
59     }
60 
61 
62   }
63 
64   function kill(){
65   if(msg.sender == owner) {
66   active = 0;
67   suicide(owner);
68   
69   }
70   }
71   function setOwner(address _owner) onlyowner {
72       owner = _owner;
73   }
74 }