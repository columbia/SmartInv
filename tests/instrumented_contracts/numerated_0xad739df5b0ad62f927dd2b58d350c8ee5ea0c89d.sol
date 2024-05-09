1 pragma solidity ^0.4.19;
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
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() internal {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to. 
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     owner = newOwner;
37   }
38 
39 }
40 
41 // The owner of this contract should be an externally owned account
42 contract TariInvestment is Ownable {
43 
44   // Address of the target contract
45   address public investment_address = 0x33eFC5120D99a63bdF990013ECaBbd6c900803CE;
46   // Major partner address
47   address public major_partner_address = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;
48   // Minor partner address
49   address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;
50   // Gas used for transfers.
51   uint public gas = 3000;
52 
53   // Payments to this contract require a bit of gas. 100k should be enough.
54   function() payable public {
55     execute_transfer(msg.value);
56   }
57 
58   // Transfer some funds to the target investment address.
59   function execute_transfer(uint transfer_amount) internal {
60     // Major fee is 1,50% = 15 / 1000
61     uint major_fee = transfer_amount * 15 / 1000;
62     // Minor fee is 1% = 10 / 1000
63     uint minor_fee = transfer_amount * 10 / 1000;
64 
65     require(major_partner_address.call.gas(gas).value(major_fee)());
66     require(minor_partner_address.call.gas(gas).value(minor_fee)());
67 
68     // Send the rest
69     require(investment_address.call.gas(gas).value(transfer_amount - major_fee - minor_fee)());
70   }
71 
72     // Sets the amount of gas allowed to investors
73   function set_transfer_gas(uint transfer_gas) public onlyOwner {
74     gas = transfer_gas;
75   }
76 
77 }