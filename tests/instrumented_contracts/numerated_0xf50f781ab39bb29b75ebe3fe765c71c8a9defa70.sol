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
78   // allows user to withdraw his balance
79   function withdraw() public {
80     uint amount = balances[msg.sender];
81     // zero the pending refund before sending to prevent re-entrancy attacks
82     balances[msg.sender] = 0;
83     msg.sender.transfer(amount);
84   }
85   // deposits ETH to a user's account
86   function deposit(address account, uint amount) public {
87     // deposit the amount to the user's account
88     balances[account] += amount;
89     // let the bot know something was deposited
90     Deposited(account, amount, balances[account], now);
91   }
92   // accepts the membership payment by moving eth from the user's account
93   // to the owner's account
94   function acceptMembership(address account, Membership membership, uint discount, address reseller, uint comission) public onlyBot {
95     // get the price for the membership they selected minus any discounts for special promotions
96     uint price = getMembershipPrice(membership) - discount;
97     // make sure they have enough balance to pay for it
98     require(balances[account] >= price);
99     // remove the payment from the user's account
100     balances[account] -= price;
101     // if this comes from a reseller
102     if (reseller != 0x0) {
103       // give the reseller his comission
104       balances[reseller] += comission;
105       // and put the rest in the signalsociety account
106       balances[owner] += price - comission;
107     } else {
108       // otherwise put it all in the signalsociety account
109       balances[owner] += price;
110     }    
111     // let the bot know the membership was paid
112     MembershipPaid(account, membership, now);
113   }
114   // default function.  Called when a user sends ETH to the contract.
115   // deposits the eth to their bank account
116   function () public payable {
117     deposit(msg.sender, msg.value);
118   }
119 }