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
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
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
43 contract PreSale is Ownable {
44     uint256 constant public INCREASE_RATE = 350000000000000;
45     uint256 constant public START_TIME = 1514228838;
46     uint256 constant public END_TIME =   1524251238;
47 
48     uint256 public eggsSold;
49     mapping (address => uint32) public eggs;
50 
51     bool private paused = false; 
52 
53     function PreSale() payable public {
54     }
55 
56     event EggsPurchased(address indexed purchaser, uint256 value, uint32 quantity);
57     
58     event EggsRedeemed(address indexed sender, uint256 eggs);
59 
60     function bulkPurchageEgg() payable public {
61         require(now > START_TIME);
62         require(now < END_TIME);
63         require(paused == false);
64         require(msg.value >= (eggPrice() * 5 + INCREASE_RATE * 10));
65         eggs[msg.sender] = eggs[msg.sender] + 5;
66         eggsSold = eggsSold + 5;
67         EggsPurchased(msg.sender, msg.value, 5);
68     }
69     
70     function purchaseEgg() payable public {
71         require(now > START_TIME);
72         require(now < END_TIME);
73         require(paused == false);
74         require(msg.value >= eggPrice());
75 
76         eggs[msg.sender] = eggs[msg.sender] + 1;
77         eggsSold = eggsSold + 1;
78         
79         EggsPurchased(msg.sender, msg.value, 1);
80     }
81     
82     function redeemEgg(address targetUser) public returns(uint256) {
83         require(paused == false);
84         require(eggs[targetUser] > 0);
85 
86         EggsRedeemed(targetUser, eggs[targetUser]);
87 
88         var userEggs = eggs[targetUser];
89         eggs[targetUser] = 0;
90         return userEggs;
91     }
92 
93     function eggPrice() view public returns(uint256) {
94         return (eggsSold + 1) * INCREASE_RATE;
95     }
96 
97     function withdrawal() onlyOwner public {
98         owner.transfer(this.balance);
99     }
100 
101     function pause() onlyOwner public {
102         paused = true;
103     }
104     
105     function resume() onlyOwner public {
106         paused = false;
107     }
108 
109     function isPaused () onlyOwner public view returns(bool) {
110         return paused;
111     }
112 }