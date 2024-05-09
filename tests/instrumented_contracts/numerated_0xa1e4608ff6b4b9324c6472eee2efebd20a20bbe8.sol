1 pragma solidity ^0.4.19;
2 
3 /* Functions from Kitten Coin main contract to be used by sale contract */
4 contract KittenCoin {
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
33 contract KittenSelfDrop is Ownable {
34     KittenCoin public kittenContract;
35     uint8 public dropNumber;
36     uint256 public kittensDroppedToTheWorld;
37     uint256 public kittensRemainingToDrop;
38     uint256 public holderAmount;
39     uint256 public basicReward;
40     uint256 public donatorReward;
41     uint256 public holderReward;
42     uint8 public totalDropTransactions;
43     mapping (address => uint8) participants;
44     
45     
46     // Initialize the cutest contract in the world
47     function KittenSelfDrop () {
48         address c = 0xac2BD14654BBf22F9d8f20c7b3a70e376d3436B4; // set Kitten Coin contract address
49         kittenContract = KittenCoin(c); 
50         dropNumber = 1;
51         kittensDroppedToTheWorld = 0;
52         kittensRemainingToDrop = 0;
53         basicReward = 50000000000; // set initial basic reward to 500 Kitten Coins
54         donatorReward = 50000000000; // set initial donator reward to 500 Kitten Coins
55         holderReward = 50000000000; // set initial holder reward to 500 Kitten Coins
56         holderAmount = 5000000000000; // set initial hold amount to 50000 Kitten Coins for extra reward
57         totalDropTransactions = 0;
58     }
59     
60     
61     // Drop some wonderful cutest Kitten Coins to sender every time contract is called without function
62     function() payable {
63         require (participants[msg.sender] < dropNumber && kittensRemainingToDrop > basicReward);
64         uint256 tokensIssued = basicReward;
65         // Send extra Kitten Coins bonus if participant is donating Ether
66         if (msg.value > 0)
67             tokensIssued += donatorReward;
68         // Send extra Kitten Coins bonus if participant holds at least holderAmount
69         if (kittenContract.balanceOf(msg.sender) >= holderAmount)
70             tokensIssued += holderReward;
71         // Check if number of Kitten Coins to issue is higher than coins remaining for airdrop (last transaction of airdrop)
72         if (tokensIssued > kittensRemainingToDrop)
73             tokensIssued = kittensRemainingToDrop;
74         
75         // Give away these so cute Kitten Coins to contributor
76         kittenContract.transfer(msg.sender, tokensIssued);
77         participants[msg.sender] = dropNumber;
78         kittensRemainingToDrop -= tokensIssued;
79         kittensDroppedToTheWorld += tokensIssued;
80         totalDropTransactions += 1;
81     }
82     
83     
84     function participant(address part) public constant returns (uint8 participationCount) {
85         return participants[part];
86     }
87     
88     
89     // Increase the airdrop count to allow sweet humans asking for more beautiful Kitten Coins
90     function setDropNumber(uint8 dropN) public onlyOwner {
91         dropNumber = dropN;
92         kittensRemainingToDrop = kittenContract.balanceOf(this);
93     }
94     
95     
96     // Define amount of Kitten Coins to hold in order to get holder reward
97     function setHolderAmount(uint256 amount) public onlyOwner {
98         holderAmount = amount;
99     }
100     
101     
102     // Define how many wonderful Kitten Coins contributors will receive for participating the selfdrop
103     function setRewards(uint256 basic, uint256 donator, uint256 holder) public onlyOwner {
104         basicReward = basic;
105         donatorReward = donator;
106         holderReward = holder;
107     }
108     
109     
110     // Sends all ETH contributions to lovely kitten owner
111     function withdrawAll() public onlyOwner {
112         owner.transfer(this.balance);
113     }
114     
115     
116     // Sends all remaining Kitten Coins to owner, just in case of emergency
117     function withdrawKittenCoins() public onlyOwner {
118         kittenContract.transfer(owner, kittenContract.balanceOf(this));
119         kittensRemainingToDrop = 0;
120     }
121     
122     
123     // Update number of Kitten Coins remaining for drop, just in case it is needed
124     function updateKittenCoinsRemainingToDrop() public {
125         kittensRemainingToDrop = kittenContract.balanceOf(this);
126     }
127     
128 }