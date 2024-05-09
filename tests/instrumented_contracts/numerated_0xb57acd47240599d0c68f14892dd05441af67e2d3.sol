1 contract SimpleLotto {
2     int public playCount = 0;
3     int public playCount1;
4     address public owner = msg.sender;
5     mapping (address => uint) public players;
6     My public aloha;
7 
8   struct My {
9     string a;
10     int b;
11   }
12 
13     modifier onlyBy(address _account) {
14         if (msg.sender != _account)
15             throw;
16         _
17     }
18     
19     function SimpleLotto() {
20         playCount1 = 42;
21     }
22     
23     event Sent(address from, address to, int amount);
24     
25     function play(address receiver, uint amount) returns (uint){
26         playCount++;
27         playCount1++;
28         Sent(owner, receiver, playCount);
29         players[receiver] += amount;
30         
31         aloha.a = "hi";
32         aloha.b = playCount1;
33         
34         return msg.value;
35     } 
36 
37     function terminate() { 
38         if (msg.sender == owner)
39             suicide(owner); 
40     }
41     
42     function terminateAlt() onlyBy(owner) { 
43             suicide(owner); 
44     }
45 }