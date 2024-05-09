1 pragma solidity ^0.4.25;
2 
3 /**
4  * Smartolution.org!
5  *
6  * Hey, 
7  * 
8  * You know the rules of ponzi already,
9  * but let me briefly explain how this one works ;)
10  * 
11  * This is your personal 45 days magic piggy bank!
12  * 
13  * 1. Send fixed amount of ether every 24 hours (5900 blocks).
14  * 2. With every new transaction collect exponentially greater return!
15  * 3. Keep sending the same amount of ether! (can't trick the code, bro)
16  * 4. Don't send too often (early transactions will be rejected, uh oh)
17  * 5. Don't be late, you won't loose your %, but who wants to be the last?
18  *  
19  * Play by the rules and save up to 170%!
20  *
21  * Gas limit: 150 000 (only the first time, average ~ 50 000)
22  * Gas price: https://ethgasstation.info/
23  *
24  */
25 contract Smartolution {
26 
27     struct User {
28         uint value;
29         uint index;
30         uint atBlock;
31     }
32 
33     mapping (address => User) public users;
34     
35     uint public total;
36     uint public advertisement;
37     uint public team;
38    
39     address public teamAddress;
40     address public advertisementAddress;
41 
42     constructor(address _advertisementAddress, address _teamAddress) public {
43         advertisementAddress = _advertisementAddress;
44         teamAddress = _teamAddress;
45     }
46 
47     function () public payable {
48         require(msg.value == 0.00001111 ether || (msg.value >= 0.01 ether && msg.value <= 5 ether), "Min: 0.01 ether, Max: 5 ether, Exit: 0.00001111 eth");
49 
50         User storage user = users[msg.sender]; // this is you
51 
52         if (msg.value != 0.00001111 ether) {
53             total += msg.value;                 // total 
54             advertisement += msg.value / 30;    // 3.3% advertisement
55             team += msg.value / 200;            // 0.5% team
56             
57             if (user.value == 0) { 
58                 user.value = msg.value;
59                 user.atBlock = block.number;
60                 user.index = 1;     
61             } else {
62                 require(block.number - user.atBlock >= 5900, "Too soon, try again later");
63 
64                 uint idx = ++user.index;
65                 uint amount = msg.value > user.value ? user.value : msg.value;
66                 
67                 if (idx == 45) {
68                     user.value = 0; // game over for you, my friend!
69                 } else {
70                     // if you are late for more than 4 hours (984 blocks)
71                     // then next deposit/payment will be delayed accordingly
72                     if (block.number - user.atBlock - 5900 < 984) { 
73                         user.atBlock += 5900;
74                     } else {
75                         user.atBlock = block.number - 984;
76                     }
77                 }
78 
79                 // sprinkle that with some magic numbers and voila
80                 msg.sender.transfer(amount * idx * idx * (24400 - 500 * amount / 1 ether) / 10000000);
81             }
82         } else {
83             require(user.index <= 10, "It's too late to request a refund at this point");
84 
85             msg.sender.transfer(user.index * user.value * 70 / 100);
86             user.value = 0;
87         }
88         
89     }
90 
91     /**
92      * This one is easy, claim reserved ether for the team or advertisement
93      */ 
94     function claim(uint amount) public {
95         if (msg.sender == advertisementAddress) {
96             require(amount > 0 && amount <= advertisement, "Can't claim more than was reserved");
97 
98             advertisement -= amount;
99             msg.sender.transfer(amount);
100         } else 
101         if (msg.sender == teamAddress) {
102             require(amount > 0 && amount <= team, "Can't claim more than was reserved");
103 
104             team -= amount;
105             msg.sender.transfer(amount);
106         }
107     }
108 }