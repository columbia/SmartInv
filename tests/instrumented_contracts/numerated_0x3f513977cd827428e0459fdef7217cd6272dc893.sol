1 pragma solidity ^0.4.21;
2 
3 /* Functions from Kitten Coin main contract to be used by sale contract */
4 contract KittenCoin {
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7 }
8 
9 contract Token {
10     function balanceOf(address who) public constant returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18   
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   function transferOwnership(address newOwner) onlyOwner public {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract KittenSelfDrop2 is Ownable {
39     KittenCoin public kittenContract;
40     uint8 public dropNumber;
41     uint256 public kittensDroppedToTheWorld;
42     uint256 public kittensRemainingToDrop;
43     uint256 public holderAmount;
44     uint256 public basicReward;
45     uint256 public holderReward;
46     mapping (uint8 => uint256[]) donatorReward;
47     uint8 donatorRewardLevels;
48     uint8 public totalDropTransactions;
49     mapping (address => uint8) participants;
50     
51     
52     // Initialize the cutest contract in the world
53     function KittenSelfDrop2 () {
54         address c = 0x2089899d03607b2192afb2567874a3f287f2f1e4
55 ; // set Kitten Coin contract address
56         kittenContract = KittenCoin(c); 
57         dropNumber = 1;
58         kittensDroppedToTheWorld = 0;
59         kittensRemainingToDrop = 0;
60         basicReward = 500; // set initial basic reward to 500 Kitten Coins
61         holderReward = 5; // set initial holder reward to 500 Kitten Coins
62         holderAmount = 5000000000000; // set initial hold amount to 50000 Kitten Coins for extra reward
63         donatorReward[0]=[1,1]; // set initial donator reward to 100 Kitten Coins from 1 wei
64         donatorReward[1]=[1000000000000000,1000]; // set initial donator reward to 1000 Kitten Coins from 0.001 ETH
65         donatorReward[2]=[10000000000000000,5000]; // set initial donator reward to 5000 Kitten Coins from 0.01 ETH
66         donatorRewardLevels = 3;
67         totalDropTransactions = 0;
68     }
69     
70     
71     // Drop some wonderful cutest Kitten Coins to sender every time contract is called without function
72     function() payable {
73         require (participants[msg.sender] < dropNumber && kittensRemainingToDrop > basicReward);
74         uint256 tokensIssued = basicReward;
75         // Send extra Kitten Coins bonus if participant is donating Ether
76         if (msg.value > donatorReward[0][0])
77             tokensIssued += donatorBonus(msg.value);
78         // Send extra Kitten Coins bonus if participant holds at least holderAmount
79         if (kittenContract.balanceOf(msg.sender) >= holderAmount)
80             tokensIssued += holderReward;
81         // Check if number of Kitten Coins to issue is higher than coins remaining for airdrop (last transaction of airdrop)
82         if (tokensIssued > kittensRemainingToDrop)
83             tokensIssued = kittensRemainingToDrop;
84         
85         // Give away these so cute Kitten Coins to contributor
86         kittenContract.transfer(msg.sender, tokensIssued);
87         participants[msg.sender] = dropNumber;
88         kittensRemainingToDrop -= tokensIssued;
89         kittensDroppedToTheWorld += tokensIssued;
90         totalDropTransactions += 1;
91     }
92     
93     
94     function participant(address part) public constant returns (uint8 participationCount) {
95         return participants[part];
96     }
97     
98     
99     // Increase the airdrop count to allow sweet humans asking for more beautiful Kitten Coins
100     function setDropNumber(uint8 dropN) public onlyOwner {
101         dropNumber = dropN;
102         kittensRemainingToDrop = kittenContract.balanceOf(this);
103     }
104     
105     
106     // Define amount of Kitten Coins to hold in order to get holder reward
107     function setHolderAmount(uint256 amount) public onlyOwner {
108         holderAmount = amount;
109     }
110     
111     
112     // Define how many wonderful Kitten Coins will be issued for participating the selfdrop : basic and holder reward
113     function setRewards(uint256 basic, uint256 holder) public onlyOwner {
114         basicReward = basic;
115         holderReward = holder;
116     }
117     
118     // Define how many wonderful Kitten Coins will be issued for donators participating the selfdrop
119     function setDonatorReward(uint8 index, uint256[] values, uint8 levels) public onlyOwner {
120         donatorReward[index] = values;
121         donatorRewardLevels = levels;
122     }
123     
124     // Sends all ETH contributions to lovely kitten owner
125     function withdrawAll() public onlyOwner {
126         owner.transfer(this.balance);
127     }
128     
129     
130     // Sends all remaining Kitten Coins to owner, just in case of emergency
131     function withdrawKittenCoins() public onlyOwner {
132         kittenContract.transfer(owner, kittenContract.balanceOf(this));
133         kittensRemainingToDrop = 0;
134     }
135     
136     
137     // Sends all other tokens that would have been sent to owner (why people do that? We don't meow)
138     function withdrawToken(address token) public onlyOwner {
139         Token(token).transfer(owner, Token(token).balanceOf(this));
140     }
141     
142     
143     // Update number of Kitten Coins remaining for drop, just in case it is needed
144     function updateKittenCoinsRemainingToDrop() public {
145         kittensRemainingToDrop = kittenContract.balanceOf(this);
146     }
147     
148     
149     // Defines donator bonus to receive
150     function donatorBonus(uint256 amount) public returns (uint256) {
151         for(uint8 i = 1; i < donatorRewardLevels; i++) {
152             if(amount < donatorReward[i][0])
153                 return (donatorReward[i-1][1]);
154         }
155         return (donatorReward[i-1][1]);
156     }
157     
158 }