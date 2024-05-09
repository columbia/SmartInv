1 pragma solidity ^0.4.18;
2 
3 /**
4 * Send 0.00025 to guess a random number from 0-9. Winner gets 80% of the pot.
5 * 20% goes to the house. Note: house is supplying the initial pot so cry me a 
6 * river.
7 */
8 
9 
10 contract LuckyNumber {
11 
12     address owner;
13     bool contractIsAlive = true;
14     uint8 winningNumber; 
15     uint commitTime = 60;
16     uint nonce = 1;
17     
18     mapping (address => uint8) addressToGuess;
19     mapping (address => uint) addressToTimeStamp;
20     
21     
22     //modifier requiring contract to be live. Set bool to false to kill contract
23     modifier live() 
24     {
25         require(contractIsAlive);
26         _;
27     }
28 
29     // The constructor. 
30     function LuckyNumber() public { 
31         owner = msg.sender;
32     }
33     
34 
35     //Used for the owner to add money to the pot. 
36     function addBalance() public payable live {
37     }
38     
39 
40     //explicit getter for "balance"
41     function getBalance() view external returns (uint) {
42         return this.balance;
43     }
44     
45     //getter for contractIsAlive
46     function getStatus() view external returns (bool) {
47         return contractIsAlive;
48     }
49 
50     //allows the owner to abort the contract and retrieve all funds
51     function kill() 
52     external 
53     live 
54     { 
55         if (msg.sender == owner) {        
56             owner.transfer(this.balance);
57             contractIsAlive = false;
58             }
59     }
60 
61     /**
62      * Pay 0.00025 eth to map your address to a guess. Sets time when guess can be checked
63      */
64     function takeAGuess(uint8 _myGuess) 
65     public 
66     payable
67     live 
68     {
69         require(msg.value == 0.00025 ether);
70         addressToGuess[msg.sender] = _myGuess;
71         addressToTimeStamp[msg.sender] = now+commitTime;
72     }
73     
74     
75     /**
76      * Call to check your guess and claim reward. Call will fail if guess was set 
77      * less than 60 seconds ago. Random number is generated and compared to the 
78      * user guess. If the numbers match, user recieves 80% of the pot and the 
79      * remainder is returned to the owner. Finally, the users guess is reset to 
80      * invalid number
81      */
82     function checkGuess()
83     public
84     live
85     {
86         require(now>addressToTimeStamp[msg.sender]);
87         winningNumber = uint8(keccak256(now, owner, block.coinbase, block.difficulty, nonce)) % 10;
88         nonce = uint(keccak256(now)) % 10000;
89         uint8 userGuess = addressToGuess[msg.sender];
90         if (userGuess == winningNumber) {
91             msg.sender.transfer((this.balance*8)/10);
92             owner.transfer(this.balance);
93         }
94         
95         addressToGuess[msg.sender] = 16;
96         addressToTimeStamp[msg.sender] = 1;
97        
98         
99     }
100 
101 
102 }//end of contract