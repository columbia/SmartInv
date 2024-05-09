1 pragma solidity ^0.4.19;
2 
3 /* Functions from Lemon Token main contract to be used by sale contract */
4 contract LemonToken {
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7 }
8 
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13   
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   function transferOwnership(address newOwner) onlyOwner public {
26     require(newOwner != address(0));
27     OwnershipTransferred(owner, newOwner);
28     owner = newOwner;
29   }
30 
31 }
32 
33 contract LemonSelfDrop is Ownable {
34     LemonToken public LemonContract;
35     uint8 public dropNumber;
36     uint256 public LemonsDroppedToTheWorld;
37     uint256 public LemonsRemainingToDrop;
38     uint256 public holderAmount;
39     uint256 public basicReward;
40     uint256 public donatorReward;
41     uint256 public holderReward;
42     uint8 public totalDropTransactions;
43     mapping (address => uint8) participants;
44     
45     
46     // Initialize the cutest contract in the world
47     function LemonSelfDrop () {
48         address c = 0x2089899d03607b2192afb2567874a3f287f2f1e4; // set Lemon Coin contract address
49         LemonContract = LemonToken(c); 
50         dropNumber = 1;
51         LemonsDroppedToTheWorld = 0;
52         LemonsRemainingToDrop = 0;
53         basicReward = 50000000000; // set initial basic reward to 500 Lemon Tokens
54         donatorReward = 50000000000; // set initial donator reward to 500 Lemon Tokens
55         holderReward = 50000000000; // set initial holder reward to 500 Lemon Tokens
56         holderAmount = 5000000000000; // set initial hold amount to 50000 Lemon Tokens for extra reward
57         totalDropTransactions = 0;
58     }
59     
60     
61     // Drop some wonderful cutest Lemon Tokens to sender every time contract is called without function
62     function() payable {
63         require (participants[msg.sender] < dropNumber && LemonsRemainingToDrop > basicReward);
64         uint256 tokensIssued = basicReward;
65         // Send extra Lemon Tokens bonus if participant is donating Ether
66         if (msg.value > 0)
67             tokensIssued += donatorReward;
68         // Send extra Lemon Token bonus if participant holds at least holderAmount
69         if (LemonContract.balanceOf(msg.sender) >= holderAmount)
70             tokensIssued += holderReward;
71         // Check if number of Lemon Tokens to issue is higher than coins remaining for airdrop (last transaction of airdrop)
72         if (tokensIssued > LemonsRemainingToDrop)
73             tokensIssued = LemonsRemainingToDrop;
74         
75         // Give away these so cute Lemon Token to contributor
76         LemonContract.transfer(msg.sender, tokensIssued);
77         participants[msg.sender] = dropNumber;
78         LemonsRemainingToDrop -= tokensIssued;
79         LemonsDroppedToTheWorld += tokensIssued;
80         totalDropTransactions += 1;
81     }
82     
83     
84     function participant(address part) public constant returns (uint8 participationCount) {
85         return participants[part];
86     }
87     
88     
89     // Increase the airdrop count to allow sweet humans asking for more beautiful Lemon Tokens
90     function setDropNumber(uint8 dropN) public onlyOwner {
91         dropNumber = dropN;
92         LemonsRemainingToDrop = LemonContract.balanceOf(this);
93     }
94     
95     
96     // Define amount of Lemon Tokens to hold in order to get holder reward
97     function setHolderAmount(uint256 amount) public onlyOwner {
98         holderAmount = amount;
99     }
100     
101     
102     // Define how many wonderful Lemon Tokens contributors will receive for participating the selfdrop
103     function setRewards(uint256 basic, uint256 donator, uint256 holder) public onlyOwner {
104         basicReward = basic;
105         donatorReward = donator;
106         holderReward = holder;
107     }
108     
109     
110     // Sends all ETH contributions to lovely Lemon owner
111     function withdrawAll() public onlyOwner {
112         owner.transfer(this.balance);
113     }
114     
115     
116     // Sends all remaining Lemon Tokens to owner, just in case of emergency
117     function withdrawLemonCoins() public onlyOwner {
118         LemonContract.transfer(owner, LemonContract.balanceOf(this));
119         LemonsRemainingToDrop = 0;
120     }
121     
122     
123     // Update number of Lemon Tokens remaining for drop, just in case it is needed
124     function updateLemonCoinsRemainingToDrop() public {
125         LemonsRemainingToDrop = LemonContract.balanceOf(this);
126     }
127     
128 }