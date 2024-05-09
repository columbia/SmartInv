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
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     emit Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     emit Unpause();
84   }
85 }
86 
87 contract PreSale is Pausable {
88     uint256 constant public INCREASE_RATE = 350000000000000; // 50c if ethereum is $700
89 
90     uint256 public eggsSold = 1987;
91     mapping (address => uint32) public eggs;
92 
93     function PreSale() payable public {
94     }
95 
96     event EggsPurchased(address indexed purchaser, uint256 value, uint32 quantity);
97     
98     event EggsRedeemed(address indexed sender, uint256 eggs);
99 
100     function bulkPurchageEgg() whenNotPaused payable public {
101         require(msg.value >= (eggPrice() * 5 + INCREASE_RATE * 10));
102         eggs[msg.sender] = eggs[msg.sender] + 5;
103         eggsSold = eggsSold + 5;
104         EggsPurchased(msg.sender, msg.value, 5);
105     }
106     
107     function purchaseEgg() whenNotPaused payable public {
108         require(msg.value >= eggPrice());
109 
110         eggs[msg.sender] = eggs[msg.sender] + 1;
111         eggsSold = eggsSold + 1;
112         
113         EggsPurchased(msg.sender, msg.value, 1);
114     }
115     
116     function redeemEgg(address targetUser) onlyOwner public returns(uint256) {
117         require(eggs[targetUser] > 0);
118 
119         EggsRedeemed(targetUser, eggs[targetUser]);
120 
121         var userEggs = eggs[targetUser];
122         eggs[targetUser] = 0;
123         return userEggs;
124     }
125 
126     function eggPrice() view public returns(uint256) {
127         return (eggsSold + 1) * INCREASE_RATE;
128     }
129 
130     function withdrawal() onlyOwner public {
131         owner.transfer(this.balance);
132     }
133 }