1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 contract TXOtoken {
45     function transfer(address to, uint256 value) public returns (bool);
46 }
47 
48 contract GetsBurned {
49 
50     function () payable {
51     }
52 
53     function BurnMe () public {
54         // Selfdestruct and send eth to self,
55         selfdestruct(address(this));
56     }
57 }
58 
59 /**
60  * @title TREON token sale
61  * @dev This contract receives money. Redirects money to the wallet. Verifies the correctness of transactions.
62  * @dev Does not produce tokens. All tokens are sent manually, after approval.
63  */
64 contract TXOsaleTwo is Ownable {
65 
66     event ReceiveEther(address indexed from, uint256 value);
67 
68     TXOtoken public token = TXOtoken(0xe3e0CfBb19D46DC6909C6830bfb25107f8bE5Cb7);
69 
70     bool public goalAchieved = false;
71 
72     address public constant wallet = 0x8dA7477d56c90CF2C5b78f36F9E39395ADb2Ae63;
73     //  Thursday, 17-Jul-18 00:00:00 UTC
74     uint public  constant saleStart = 1531785600;
75     // Monday, 31-Dec-18 23:59:59 UTC
76     uint public constant saleEnd = 1546300799;
77 
78     function TXOsaleTwo() public {
79 
80     }
81 
82     /**
83     * @dev fallback function
84     */
85     function() public payable {
86         require(now >= saleStart && now <= saleEnd);
87         require(!goalAchieved);
88         require(msg.value >= 0.1 ether);
89         require(msg.value <= 65 ether);
90         wallet.transfer(msg.value);
91         emit ReceiveEther(msg.sender, msg.value);
92     }
93 
94     /**
95      * @dev The owner can suspend the sale if the HardCap has been achieved.
96      */
97     function setGoalAchieved(bool _goalAchieved) public onlyOwner {
98         goalAchieved = _goalAchieved;
99     }
100 
101     function burnToken(uint256 value) public onlyOwner{
102         GetsBurned burnContract = new GetsBurned();
103         token.transfer(burnContract,  value);
104         burnContract.BurnMe();
105     }
106 }