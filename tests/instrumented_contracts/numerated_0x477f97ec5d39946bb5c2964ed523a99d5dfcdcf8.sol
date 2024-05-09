1 pragma solidity ^0.4.18;
2 /**
3 * @dev EtherLands PreSale contract.
4 *
5 */
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 contract PreSale is Ownable {
48     uint256 constant public INCREASE_RATE = 700000000000000;
49     uint256 constant public START_TIME = 1520972971;
50     uint256 constant public END_TIME =   1552508971;
51 
52     uint256 public landsSold;
53     mapping (address => uint32) public lands;
54 
55     bool private paused = false; 
56 
57     function PreSale() payable public {
58     }
59 
60     event landsPurchased(address indexed purchaser, uint256 value, uint32 quantity);
61     
62     event landsRedeemed(address indexed sender, uint256 lands);
63 
64     function bulkPurchageLand() payable public {
65         require(now > START_TIME);
66         require(now < END_TIME);
67         require(paused == false);
68         require(msg.value >= (landPriceCurrent() * 5));
69         lands[msg.sender] = lands[msg.sender] + 5;
70         landsSold = landsSold + 5;
71         landsPurchased(msg.sender, msg.value, 5);
72     }
73     
74     function purchaseLand() payable public {
75         require(now > START_TIME);
76         require(now < END_TIME);
77         require(paused == false);
78         require(msg.value >= landPriceCurrent());
79 
80         lands[msg.sender] = lands[msg.sender] + 1;
81         landsSold = landsSold + 1;
82         
83         landsPurchased(msg.sender, msg.value, 1);
84     }
85     
86     function redeemLand(address targetUser) public onlyOwner returns(uint256) {
87         require(paused == false);
88         require(lands[targetUser] > 0);
89 
90         landsRedeemed(targetUser, lands[targetUser]);
91 
92         uint256 userlands = lands[targetUser];
93         lands[targetUser] = 0;
94         return userlands;
95     }
96 
97     function landPriceCurrent() view public returns(uint256) {
98         return (landsSold + 1) * INCREASE_RATE;
99     }
100      
101     function landPricePrevious() view public returns(uint256) {
102         return (landsSold) * INCREASE_RATE;
103     }
104 
105     function withdrawal() onlyOwner public {
106         owner.transfer(this.balance);
107     }
108 
109     function pause() onlyOwner public {
110         paused = true;
111     }
112     
113     function resume() onlyOwner public {
114         paused = false;
115     }
116 
117     function isPaused () onlyOwner public view returns(bool) {
118         return paused;
119     }
120 }