1 pragma solidity ^0.4.21;
2 
3 /* Functions from Lemon Token main contract to be used by sale contract */
4 contract LemonToken {
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
38 contract LemonSelfDrop1 is Ownable {
39     LemonToken public LemonContract;
40     uint8 public dropNumber;
41     uint256 public LemonsDroppedToTheWorld;
42     uint256 public LemonsRemainingToDrop;
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
53     function LemonSelfDrop1 () {
54         address c = 0x2089899d03607b2192afb2567874a3f287f2f1e4; 
55         LemonContract = LemonToken(c); 
56         dropNumber = 1;
57         LemonsDroppedToTheWorld = 0;
58         LemonsRemainingToDrop = 0;
59         basicReward = 500;
60        donatorRewardLevels = 1;
61         totalDropTransactions = 0;
62     }
63     
64     
65     // Drop some wonderful cutest Lemon Token to sender every time contract is called without function
66     function() payable {
67         require (participants[msg.sender] < dropNumber && LemonsRemainingToDrop > basicReward);
68         uint256 tokensIssued = basicReward;
69         // Send extra Lemon token bonus if participant is donating Ether
70         if (msg.value > donatorReward[0][0])
71             tokensIssued += donatorBonus(msg.value);
72         // Send extra Lemon token bonus if participant holds at least holderAmount
73         if (LemonContract.balanceOf(msg.sender) >= holderAmount)
74             tokensIssued += holderReward;
75         // Check if number of Kitten Coins to issue is higher than coins remaining for airdrop (last transaction of airdrop)
76         if (tokensIssued > LemonsRemainingToDrop)
77             tokensIssued = LemonsRemainingToDrop;
78         
79         // Give away these so cute Kitten Coins to contributor
80         LemonContract.transfer(msg.sender, tokensIssued);
81         participants[msg.sender] = dropNumber;
82         LemonsRemainingToDrop -= tokensIssued;
83         LemonsDroppedToTheWorld += tokensIssued;
84         totalDropTransactions += 1;
85     }
86     
87     
88     function participant(address part) public constant returns (uint8 participationCount) {
89         return participants[part];
90     }
91     
92     
93     // Increase the airdrop count to allow sweet humans asking for more beautiful Kitten Coins
94     function setDropNumber(uint8 dropN) public onlyOwner {
95         dropNumber = dropN;
96         LemonsRemainingToDrop = LemonContract.balanceOf(this);
97     }
98     
99     
100     function setHolderAmount(uint256 amount) public onlyOwner {
101         holderAmount = amount;
102     }
103     
104     
105     function setRewards(uint256 basic, uint256 holder) public onlyOwner {
106         basicReward = basic;
107         holderReward = holder;
108     }
109     
110     function setDonatorReward(uint8 index, uint256[] values, uint8 levels) public onlyOwner {
111         donatorReward[index] = values;
112         donatorRewardLevels = levels;
113     }
114     
115     function withdrawAll() public onlyOwner {
116         owner.transfer(this.balance);
117     }
118     
119     
120     function withdrawKittenCoins() public onlyOwner {
121         LemonContract.transfer(owner, LemonContract.balanceOf(this));
122         LemonsRemainingToDrop = 0;
123     }
124     
125     
126     // Sends all other tokens that would have been sent to owner (why people do that? We don't meow)
127     function withdrawToken(address token) public onlyOwner {
128         Token(token).transfer(owner, Token(token).balanceOf(this));
129     }
130     
131     
132     function updateKittenCoinsRemainingToDrop() public {
133         LemonsRemainingToDrop = LemonContract.balanceOf(this);
134     }
135     
136     
137     // Defines donator bonus to receive
138     function donatorBonus(uint256 amount) public returns (uint256) {
139         for(uint8 i = 1; i < donatorRewardLevels; i++) {
140             if(amount < donatorReward[i][0])
141                 return (donatorReward[i-1][1]);
142         }
143         return (donatorReward[i-1][1]);
144     }
145     
146 }