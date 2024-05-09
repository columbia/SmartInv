1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 /**
39  * @title Pausable
40  * @dev Base contract which allows children to implement an emergency stop mechanism.
41  */
42 contract Pausable is Ownable {
43   event Pause();
44   event Unpause();
45 
46   bool public paused = false;
47 
48 
49   /**
50    * @dev Modifier to make a function callable only when the contract is not paused.
51    */
52   modifier whenNotPaused() {
53     require(!paused);
54     _;
55   }
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is paused.
59    */
60   modifier whenPaused() {
61     require(paused);
62     _;
63   }
64 
65   /**
66    * @dev called by the owner to pause, triggers stopped state
67    */
68   function pause() onlyOwner whenNotPaused public {
69     paused = true;
70     Pause();
71   }
72 
73   /**
74    * @dev called by the owner to unpause, returns to normal state
75    */
76   function unpause() onlyOwner whenPaused public {
77     paused = false;
78     Unpause();
79   }
80 }
81 
82 contract SkinPresale is Pausable {
83 
84     // Record number of packages each account buy
85     mapping (address => uint256) public accountToBoughtNum;
86 
87     // Total number of packages for presale
88     uint256 public totalSupplyForPresale = 10000;
89 
90     // Number of packages each account can buy
91     uint256 public accountBuyLimit = 100;
92 
93     // Remaining packages for presale
94     uint256 public remainPackage = 10000;
95 
96     // Event
97     event BuyPresale(address account);
98 
99     function buyPresale() payable external whenNotPaused {
100         address account = msg.sender;
101 
102         // Check account limit
103         require(accountToBoughtNum[account] + 1 < accountBuyLimit);
104 
105         // Check total presale limit
106         require(remainPackage > 0);
107 
108         // Check enough money
109         uint256 price = 20 finney + (10000 - remainPackage) / 500 * 10 finney;
110         require(msg.value >= price);
111 
112         // Perform purchase
113         accountToBoughtNum[account] += 1;
114         remainPackage -= 1;
115 
116         // Fire event
117         BuyPresale(account);
118     }
119 
120     function withdrawETH() external onlyOwner {
121         owner.transfer(this.balance);
122     }
123 
124 }