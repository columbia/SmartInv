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
54         address c = 0xac2BD14654BBf22F9d8f20c7b3a70e376d3436B4; // set Kitten Coin contract address
55         kittenContract = KittenCoin(c); 
56         dropNumber = 1;
57         kittensDroppedToTheWorld = 0;
58         kittensRemainingToDrop = 0;
59         basicReward = 50000000000; // set initial basic reward to 500 Kitten Coins
60         holderReward = 50000000000; // set initial holder reward to 500 Kitten Coins
61         holderAmount = 5000000000000; // set initial hold amount to 50000 Kitten Coins for extra reward
62         donatorReward[0]=[1,10000000000]; // set initial donator reward to 100 Kitten Coins from 1 wei
63         donatorReward[1]=[1000000000000000,100000000000]; // set initial donator reward to 1000 Kitten Coins from 0.001 ETH
64         donatorReward[2]=[10000000000000000,500000000000]; // set initial donator reward to 5000 Kitten Coins from 0.01 ETH
65         donatorRewardLevels = 3;
66         totalDropTransactions = 0;
67     }
68     
69     
70     // Drop some wonderful cutest Kitten Coins to sender every time contract is called without function
71     function() payable {
72         require (participants[msg.sender] < dropNumber && kittensRemainingToDrop > basicReward);
73         uint256 tokensIssued = basicReward;
74         // Send extra Kitten Coins bonus if participant is donating Ether
75         if (msg.value > donatorReward[0][0])
76             tokensIssued += donatorBonus(msg.value);
77         // Send extra Kitten Coins bonus if participant holds at least holderAmount
78         if (kittenContract.balanceOf(msg.sender) >= holderAmount)
79             tokensIssued += holderReward;
80         // Check if number of Kitten Coins to issue is higher than coins remaining for airdrop (last transaction of airdrop)
81         if (tokensIssued > kittensRemainingToDrop)
82             tokensIssued = kittensRemainingToDrop;
83         
84         // Give away these so cute Kitten Coins to contributor
85         kittenContract.transfer(msg.sender, tokensIssued);
86         participants[msg.sender] = dropNumber;
87         kittensRemainingToDrop -= tokensIssued;
88         kittensDroppedToTheWorld += tokensIssued;
89         totalDropTransactions += 1;
90     }
91     
92     
93     function participant(address part) public constant returns (uint8 participationCount) {
94         return participants[part];
95     }
96     
97     
98     // Increase the airdrop count to allow sweet humans asking for more beautiful Kitten Coins
99     function setDropNumber(uint8 dropN) public onlyOwner {
100         dropNumber = dropN;
101         kittensRemainingToDrop = kittenContract.balanceOf(this);
102     }
103     
104     
105     // Define amount of Kitten Coins to hold in order to get holder reward
106     function setHolderAmount(uint256 amount) public onlyOwner {
107         holderAmount = amount;
108     }
109     
110     
111     // Define how many wonderful Kitten Coins will be issued for participating the selfdrop : basic and holder reward
112     function setRewards(uint256 basic, uint256 holder) public onlyOwner {
113         basicReward = basic;
114         holderReward = holder;
115     }
116     
117     // Define how many wonderful Kitten Coins will be issued for donators participating the selfdrop
118     function setDonatorReward(uint8 index, uint256[] values, uint8 levels) public onlyOwner {
119         donatorReward[index] = values;
120         donatorRewardLevels = levels;
121     }
122     
123     // Sends all ETH contributions to lovely kitten owner
124     function withdrawAll() public onlyOwner {
125         owner.transfer(this.balance);
126     }
127     
128     
129     // Sends all remaining Kitten Coins to owner, just in case of emergency
130     function withdrawKittenCoins() public onlyOwner {
131         kittenContract.transfer(owner, kittenContract.balanceOf(this));
132         kittensRemainingToDrop = 0;
133     }
134     
135     
136     // Sends all other tokens that would have been sent to owner (why people do that? We don't meow)
137     function withdrawToken(address token) public onlyOwner {
138         Token(token).transfer(owner, Token(token).balanceOf(this));
139     }
140     
141     
142     // Update number of Kitten Coins remaining for drop, just in case it is needed
143     function updateKittenCoinsRemainingToDrop() public {
144         kittensRemainingToDrop = kittenContract.balanceOf(this);
145     }
146     
147     
148     // Defines donator bonus to receive
149     function donatorBonus(uint256 amount) public returns (uint256) {
150         for(uint8 i = 1; i < donatorRewardLevels; i++) {
151             if(amount < donatorReward[i][0])
152                 return (donatorReward[i-1][1]);
153         }
154         return (donatorReward[i-1][1]);
155     }
156     
157 }