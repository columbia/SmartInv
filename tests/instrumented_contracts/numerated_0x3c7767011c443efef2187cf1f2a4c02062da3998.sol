1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract CratePreSale is Ownable {
44     
45     // ------ STATE ------ 
46     uint256 constant public MAX_CRATES_TO_SELL = 3900; // Max no. of robot crates to ever be sold
47     uint256 constant public PRESALE_END_TIMESTAMP = 1518699600; // End date for the presale - no purchases can be made after this date - Midnight 16 Feb 2018 UTC
48 
49     uint256 public appreciationRateWei = 400000000000000;  
50     uint256 public currentPrice = appreciationRateWei; // initalise the price to the appreciation rate
51     uint32 public cratesSold;
52     
53     mapping (address => uint32) public userCrateCount; // store how many crates a user has bought
54     mapping (address => uint[]) public userToRobots; // store the DNA/robot information of bought crates
55     
56     // ------ EVENTS ------ 
57     event LogCratePurchase( 
58         address indexed _from,
59         uint256 _value,
60         uint32 _quantity
61         );
62 
63 
64     // ------ FUNCTIONS ------ 
65     function getPrice() view public returns (uint256) {
66         return currentPrice;
67     }
68 
69     function getRobotsForUser( address _user ) view public returns (uint[]) {
70         return userToRobots[_user];
71     }
72 
73     function incrementPrice() private { 
74         // Decrease the rate of increase of the crate price
75         // as the crates become more expensive
76         // to avoid runaway pricing
77         // (halving rate of increase at 0.1 ETH, 0.2 ETH, 0.3 ETH).
78         if ( currentPrice == 100000000000000000 ) {
79             appreciationRateWei = 200000000000000;
80         } else if ( currentPrice == 200000000000000000) {
81             appreciationRateWei = 100000000000000;
82         } else if (currentPrice == 300000000000000000) {
83             appreciationRateWei = 50000000000000;
84         }
85         currentPrice += appreciationRateWei;
86     }
87 
88     function purchaseCrate() payable public {
89         require(now < PRESALE_END_TIMESTAMP); // Check presale is still ongoing
90         require(cratesSold < MAX_CRATES_TO_SELL); // Check max crates sold is less than hard limit
91         require(msg.value >= currentPrice); // Check buyer sent sufficient funds to purchase
92         if (msg.value > currentPrice) { //overpaid, return excess
93             msg.sender.transfer(msg.value-currentPrice);
94         }
95         userCrateCount[msg.sender] += 1;
96         cratesSold++;
97         incrementPrice();
98         userToRobots[msg.sender].push(genRandom());
99         LogCratePurchase(msg.sender, msg.value, 1);
100 
101     }
102 
103     // ROBOT FORMAT
104     // [3 digits - RARITY][2 digits - PART] * 4 (4 parts)
105     // e.g. [140][20][218][04]
106     // Presale exclusives are encoded by extending the range of the part by 1
107     // ie lamborghini will be the 23rd body. If 23 (or a multiple of it) is generated, a lamborghini will be awarded.
108     //RARITY INFORMATION:
109     //All parts are of equal rarity, except for presale exclusives.
110     //A three-digit modifier precedes each part, denoting whether it is of type
111     //normal, rare shadow, or legendary gold.
112     //Shadow has a 10% chance of applying for the presale (2% in game)
113     //Gold has a 5% chance of applying for the presale (1% in game).
114     function genRandom() private view returns (uint) {
115         uint rand = uint(keccak256(block.blockhash(block.number-1)));
116         return uint(rand % (10 ** 20));
117     }
118 
119     //owner only withdrawal function for the presale
120     function withdraw() onlyOwner public {
121         owner.transfer(this.balance);
122     }
123 }