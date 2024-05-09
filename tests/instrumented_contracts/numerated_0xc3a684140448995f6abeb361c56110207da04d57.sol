1 pragma solidity ^0.4.17;
2 
3 /*
4 -----------------------------------
5 Signals Society Membership Contract
6 -----------------------------------
7 */
8 
9 /**
10  * @title Ownable
11  * @dev Ownership functionality
12  */
13 contract Ownable {
14   address public owner;
15   address public bot;
16   // constructor, sets original owner address
17   function Ownable() public {
18     owner = msg.sender;
19   }
20   // modifier to restruct function use to the owner
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }    
25   // modifier to restruct function use to the bot
26   modifier onlyBot() {
27     require(msg.sender == bot);
28     _;
29   }
30   // lets owner change his address
31   function changeOwner(address addr) public onlyOwner {
32       owner = addr;
33   }
34   // lets owner change the bot's address    
35   function changeBot(address addr) public onlyOwner {
36       bot = addr;
37   }
38   // allows destruction of contract only if balance is empty
39   function kill() public onlyOwner {
40 		require(this.balance == 0);
41 		selfdestruct(owner);
42 	}
43 }
44 
45  /**
46  * @title Memberships
47  * @dev anages membership prices
48  */
49 contract Memberships is Ownable {
50   // enumerates memberships (0, 1, 2)
51   enum Membership { Day, Month, Lifetime }
52   // holds the prices for the memberships
53   mapping (uint => uint) internal prices;
54   // returns the price for a single membership
55   function getMembershipPrice(Membership membership) public view returns(uint) {
56     return prices[uint(membership)];
57   }
58   // lets the owner set the price for a single membership
59   function setMembershipPrice(Membership membership, uint amount) public onlyOwner {    
60 		require(amount > 0);
61     prices[uint(membership)] = amount;
62   }
63 }
64 
65  /**
66  * @title MembSignalsSociety Contract
67  */
68 contract SignalsSociety is Ownable, Memberships {
69 
70   // lets the bot know a deposit was made
71   event Deposited(address account, uint amount, uint balance, uint timestamp);
72   // lets the bot know a membership was paid
73   event MembershipPaid(address account, Membership membership, uint timestamp);
74 
75   // store the amount of ETH deposited by each account.
76   mapping (address => uint) public balances;
77 
78   // deposits ETH to a user's account
79   function deposit(address account, uint amount) public {
80     // deposit the amount to the user's account
81     balances[account] += amount;
82     // let the bot know something was deposited
83     Deposited(account, amount, balances[account], now);
84   }
85   // accepts the membership payment by moving eth from the user's account
86   // to the owner's account
87   function acceptMembership(address account, Membership membership, uint discount, address reseller, uint comission) public onlyBot {
88     // get the price for the membership they selected minus any discounts for special promotions
89     uint price = getMembershipPrice(membership) - discount;
90     // make sure they have enough balance to pay for it
91     require(balances[account] >= price);
92     // remove the payment from the user's account
93     balances[account] -= price;
94     // if this comes from a reseller
95     if (reseller != 0x0) {
96       // send the reseller his comission
97       reseller.transfer(comission);
98       // sent SS the rest
99       owner.transfer(price - comission);
100     } else {
101       // otherwise send it all to ss
102       owner.transfer(price);
103     }    
104     // let the bot know the membership was paid
105     MembershipPaid(account, membership, now);
106   }
107   // default function.  Called when a user sends ETH to the contract.
108   // deposits the eth to their bank account
109   function () public payable {
110     deposit(msg.sender, msg.value);
111   }
112 }