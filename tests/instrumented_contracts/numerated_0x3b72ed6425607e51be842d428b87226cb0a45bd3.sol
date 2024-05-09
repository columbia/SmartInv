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
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract PreSale is Ownable {
45     uint256 constant public INCREASE_RATE = 350000000000000;
46     uint256 constant public START_TIME = 1514228838;
47     uint256 constant public END_TIME =   1524251238;
48 
49     uint256 public landsSold;
50     mapping (address => uint32) public lands;
51 
52     bool private paused = false; 
53 
54     function PreSale() payable public {
55     }
56 
57     event landsPurchased(address indexed purchaser, uint256 value, uint32 quantity);
58     
59     event landsRedeemed(address indexed sender, uint256 lands);
60 
61     function bulkPurchageLand() payable public {
62         require(now > START_TIME);
63         require(now < END_TIME);
64         require(paused == false);
65         require(msg.value >= (landPriceCurrent() * 5 + INCREASE_RATE * 10));
66         lands[msg.sender] = lands[msg.sender] + 5;
67         landsSold = landsSold + 5;
68         landsPurchased(msg.sender, msg.value, 5);
69     }
70     
71     function purchaseLand() payable public {
72         require(now > START_TIME);
73         require(now < END_TIME);
74         require(paused == false);
75         require(msg.value >= landPriceCurrent());
76 
77         lands[msg.sender] = lands[msg.sender] + 1;
78         landsSold = landsSold + 1;
79         
80         landsPurchased(msg.sender, msg.value, 1);
81     }
82     
83     function redeemLand(address targetUser) public onlyOwner returns(uint256) {
84         require(paused == false);
85         require(lands[targetUser] > 0);
86 
87         landsRedeemed(targetUser, lands[targetUser]);
88 
89         uint256 userlands = lands[targetUser];
90         lands[targetUser] = 0;
91         return userlands;
92     }
93 
94     function landPriceCurrent() view public returns(uint256) {
95         return (landsSold + 1) * INCREASE_RATE;
96     }
97      
98     function landPricePrevious() view public returns(uint256) {
99         return (landsSold) * INCREASE_RATE;
100     }
101 
102     function withdrawal() onlyOwner public {
103         owner.transfer(this.balance);
104     }
105 
106     function pause() onlyOwner public {
107         paused = true;
108     }
109     
110     function resume() onlyOwner public {
111         paused = false;
112     }
113 
114     function isPaused () onlyOwner public view returns(bool) {
115         return paused;
116     }
117 }