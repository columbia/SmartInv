1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 contract Draw is Ownable {
50 
51     address[9] private players;
52     address public last_winner;
53     uint public draw_number;
54     uint public slots_left;
55     uint private MAX_PLAYERS = players.length;
56     uint private counter = 0;
57     uint private t0 = now;
58     uint private tdelta;
59     uint private index;
60     uint private owner_balance = 0 finney;
61 
62     function Draw() public {
63         initGame();
64         draw_number = 1;
65         last_winner = address(0);
66     }
67 
68     function initGame() internal {
69         counter = 0;
70         slots_left = MAX_PLAYERS;
71         draw_number++;
72         for (uint i = 0; i < players.length; i++) {
73             players[i] = address(0);
74         }
75     }
76 
77     function () external payable {
78         for (uint i = 0; i < players.length; i++) {
79             require(players[i] != msg.sender);
80         }
81         joinGame();
82     }
83 
84     function joinGame() public payable {
85         require(msg.sender != owner);
86         require(msg.value == 100 finney);
87         require(counter < MAX_PLAYERS);
88 
89         players[counter] = msg.sender;
90         counter++;
91         slots_left = MAX_PLAYERS - counter;
92 
93         if (counter >= MAX_PLAYERS) {
94             last_winner = endGame();
95         }
96     }
97 
98     function endGame() internal returns (address winner) {
99         require(this.balance - owner_balance >= 900 finney);
100         tdelta = now - t0;
101         index = uint(tdelta % MAX_PLAYERS);
102         t0 = now;
103         winner = players[index];
104         initGame();
105         winner.transfer(855 finney);
106         owner_balance = owner_balance + 45 finney;
107     }
108 
109     function getBalance() public view onlyOwner returns (uint) {
110         return owner_balance;
111     }
112 
113     function withdrawlBalance() public onlyOwner {
114         msg.sender.transfer(owner_balance);
115         owner_balance = 0;
116     }
117 
118 }