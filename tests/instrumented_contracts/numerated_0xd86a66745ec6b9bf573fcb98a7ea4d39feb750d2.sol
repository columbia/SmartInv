1 pragma solidity ^0.4.18;
2 
3 //credit given to original creator of the cornfarm contract and the original taxman contract
4 //to view how many of a specific token you have in the contract use the userInventory option in MEW.
5 //First address box copy paste in your eth address.  Second address box is the contract address of the Ethercraft item you want to check.    
6 //WorkDone = # of that token you have in the farm contract * 10^18.
7 
8 
9 interface CornFarm
10 {
11     function buyObject(address _beneficiary) public payable;
12 }
13 
14 interface Corn
15 {
16     function transfer(address to, uint256 value) public returns (bool);
17 }
18 
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract FreeTaxManFarmer {
62     using SafeMath for uint256;
63     
64     bool private reentrancy_lock = false;
65 
66     struct tokenInv {
67       uint256 workDone;
68     }
69     
70     mapping(address => mapping(address => tokenInv)) public userInventory;
71     
72     modifier nonReentrant() {
73         require(!reentrancy_lock);
74         reentrancy_lock = true;
75         _;
76         reentrancy_lock = false;
77     }
78     
79     function pepFarm(address item_shop_address, address token_address, uint256 buy_amount) nonReentrant external {
80         for (uint8 i = 0; i < buy_amount; i++) {
81             CornFarm(item_shop_address).buyObject(this);
82         }
83         userInventory[msg.sender][token_address].workDone = userInventory[msg.sender][token_address].workDone.add(uint256(buy_amount * 10**18));
84     }
85     
86     function reapFarm(address token_address) nonReentrant external {
87         require(userInventory[msg.sender][token_address].workDone > 0);
88         Corn(token_address).transfer(msg.sender, userInventory[msg.sender][token_address].workDone);
89         userInventory[msg.sender][token_address].workDone = 0;
90     }
91 
92 }