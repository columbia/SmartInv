1 pragma solidity ^0.4.17;
2 
3 /*
4 
5 Signals Society Membership Contract
6 -----------------------------------
7 
8 */
9 
10 /**
11  * Ownership functionality
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
45 /**
46  * Manages membership prices
47  */
48 contract Memberships is Ownable {
49   // enumerates memberships (0, 1, 2)
50   enum Membership { Day, Month, Lifetime }
51   // holds the prices for the memberships
52   mapping (uint => uint) internal prices;
53   // returns the price for a single membership
54   function getMembershipPrice(Membership membership) public view returns(uint) {
55     return prices[uint(membership)];
56   }
57   // lets the owner set the price for a single membership
58   function setMembershipPrice(Membership membership, uint amount) public onlyOwner {    
59 		require(amount > 0);
60     prices[uint(membership)] = amount;
61   }
62 }
63 
64 /**
65  * SignalsSociety Contract
66  */
67 contract SignalsSociety is Ownable, Memberships {
68   // lets the bot know a deposit was made
69   event Deposited(address account, uint amount, uint balance, uint timestamp);
70   // lets the bot know a membership was paid
71   event MembershipPaid(address account, Membership membership, uint timestamp);
72 
73   // store the amount of ETH deposited by each account.
74   mapping (address => uint) public balances;
75 
76   // allows user to withdraw his balance
77   function withdraw() public {
78     uint amount = balances[msg.sender];
79     // zero the pending refund before sending to prevent re-entrancy attacks
80     balances[msg.sender] = 0;
81     msg.sender.transfer(amount);
82   }
83   // deposits ETH to a user's account
84   function deposit(address account, uint amount) public {
85     // deposit the amount to the user's account
86     balances[account] += amount;
87     // let the bot know something was deposited
88     Deposited(account, amount, balances[account], now);
89   }
90   // accepts the membership payment by moving eth from the user's account
91   // to the owner's account
92   function acceptMembership(address account, Membership membership, uint discount) public onlyBot {
93     // get the price for the membership they selected minus any discounts for special promotions
94     var price = getMembershipPrice(membership) - discount;
95     // make sure they have enough balance to pay for it
96     require(balances[account] >= price);
97     // transfer the price to the contract owner account
98     balances[account] -= price;
99     balances[owner] += price;
100     // let the bot know the membershipt was paid
101     MembershipPaid(account, membership, now);
102   }
103   // default function.  Called when a user sends ETH to the contract.
104   // deposits the eth to their bank account
105   function () public payable {
106     deposit(msg.sender, msg.value);
107   }
108 }