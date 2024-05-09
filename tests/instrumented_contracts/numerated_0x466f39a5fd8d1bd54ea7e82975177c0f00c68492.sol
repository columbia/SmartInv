1 contract SimpleLotto {
2     int public playCount = 0;
3     address public owner = msg.sender;
4     mapping (address => uint) public players;
5     Aggregate public aggregate;
6 
7   struct Aggregate {
8     uint msgValue;
9     uint gas;
10   }
11 
12     modifier onlyBy(address _account) {
13         if (msg.sender != _account)
14             throw;
15         _
16     }
17     
18     function SimpleLotto() {
19         playCount = 42;
20     }
21     
22     event Sent(address from, address to, int amount);
23     
24     function play(address receiver, uint amount) returns (uint){
25         playCount++;
26         Sent(owner, receiver, playCount);
27         players[receiver] += amount;
28         
29         aggregate.msgValue = msg.value;
30         aggregate.gas = msg.gas;
31         
32         return msg.value;
33     } 
34 
35     function terminate() { 
36         if (msg.sender == owner)
37             suicide(owner); 
38     }
39     
40     function terminateAlt() onlyBy(owner) { 
41             suicide(owner); 
42     }
43 }