1 pragma solidity ^0.4.19;
2 
3 /** GitHub repository: https://github.com/dggventures/syndicate/tree/master/tari */
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control 
8  * functions, this simplifies the implementation of "user permissions". 
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /** 
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() internal {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner. 
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract TariInvestment is Ownable {
44 
45   // These are addresses that shouldn't consume too much gas in their fallback functions if they are contracts.
46   // Address of the target contract
47   address public investmentAddress = 0x33eFC5120D99a63bdF990013ECaBbd6c900803CE;
48   // Major partner address
49   address public majorPartnerAddress = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;
50   // Minor partner address
51   address public minorPartnerAddress = 0xC787C3f6F75D7195361b64318CE019f90507f806;
52   // Record balances to allow refunding
53   mapping(address => uint) public balances;
54   // Total received. Used for refunding.
55   uint totalInvestment;
56   // Available refunds. Used for refunding.
57   uint availableRefunds;
58   // Deadline when refunding starts.
59   uint refundingDeadline;
60   // States: Open for investments - allows ether investments; transitions to Closed as soon as
61   //                                a transfer to the target investment address is made,
62   //         Closed for investments - only transfers to target investment address are allowed,
63   //         Refunding investments - any state can transition to refunding state
64   enum State{Open, Closed, Refunding}
65 
66 
67   State public state = State.Open;
68 
69   function TariInvestment() public {
70     refundingDeadline = now + 10 days;
71   }
72 
73   // Payments to this contract require a bit of gas. 100k should be enough.
74   function() payable public {
75     // Reject any value transfers once we have finished sending the balance to the target contract.
76     require(state == State.Open);
77     balances[msg.sender] += msg.value;
78     totalInvestment += msg.value;
79   }
80 
81   // Transfer some funds to the target investment address.
82   // It is expected of all addresses to allow low gas transferrals of ether.
83   function execute_transfer(uint transfer_amount) public onlyOwner {
84     // Close down investments. Transferral of funds shouldn't be possible during refunding.
85     State current_state = state;
86     if (current_state == State.Open)
87       state = State.Closed;
88     require(state == State.Closed);
89 
90     // Major fee is 1,50% = 15 / 1000
91     uint major_fee = transfer_amount * 15 / 1000;
92     // Minor fee is 1% = 10 / 1000
93     uint minor_fee = transfer_amount * 10 / 1000;
94     majorPartnerAddress.transfer(major_fee);
95     minorPartnerAddress.transfer(minor_fee);
96 
97     // Send the rest 
98     investmentAddress.transfer(transfer_amount - major_fee - minor_fee);
99   }
100 
101   // Convenience function to transfer all available balance.
102   function execute_transfer() public onlyOwner {
103     execute_transfer(this.balance);
104   }
105 
106   // Refund an investor when he sends a withdrawal transaction.
107   // Only available once refunds are enabled.
108   function withdraw() public {
109     if (state != State.Refunding) {
110       require(refundingDeadline <= now);
111       state = State.Refunding;
112       availableRefunds = this.balance;
113     }
114 
115     uint withdrawal = availableRefunds * balances[msg.sender] / totalInvestment;
116     balances[msg.sender] = 0;
117     msg.sender.transfer(withdrawal);
118   }
119 
120 }