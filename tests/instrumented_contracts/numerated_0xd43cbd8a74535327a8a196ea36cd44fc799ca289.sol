1 contract SimpleLotto {
2     int playCount = 0;
3     address owner = msg.sender;
4     mapping (address => uint) public players;
5 
6     modifier onlyBy(address _account) {
7         if (msg.sender != _account)
8             throw;
9         _
10     }
11     
12     event Sent(address from, address to, int amount);
13     
14     function play(address receiver, uint amount) external constant returns (int playCount){
15         playCount++;
16       Sent(owner, receiver, playCount);
17       players[receiver] += amount;
18       return playCount;
19     } 
20     
21     function play1(address receiver, uint amount) external  returns (int playCount){
22         playCount++;
23       Sent(owner, receiver, playCount);
24       players[receiver] += amount;
25       return playCount;
26     } 
27     
28     function play2(address receiver, uint amount) public returns (int playCount){
29         playCount++;
30         Sent(owner, receiver, playCount);
31         players[receiver] += amount;
32         return playCount;
33     } 
34     
35         function play4(address receiver, uint amount) returns (int playCount){
36         playCount++;
37         Sent(owner, receiver, playCount);
38         players[receiver] += amount;
39         return playCount;
40     } 
41 
42     function terminate() { 
43         if (msg.sender == owner)
44             suicide(owner); 
45     }
46     
47     function terminateAlt() onlyBy(owner) { 
48             suicide(owner); 
49     }
50 }