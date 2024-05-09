1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /** 
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() internal {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner. 
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to. 
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));
31     owner = newOwner;
32   }
33 
34 }
35 
36 // The owner of this contract should be an externally owned account
37 contract TariInvestment is Ownable {
38 
39   // Address of the target contract
40   address public investment_address = 0x62Ef732Ec9BAB90070f4ac4e065Ce1CC090D909f;
41   // Major partner address
42   address public major_partner_address = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;
43   // Minor partner address
44   address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;
45   // Gas used for transfers.
46   uint public gas = 3000;
47 
48   // Payments to this contract require a bit of gas. 100k should be enough.
49   function() payable public {
50     execute_transfer(msg.value);
51   }
52 
53   // Transfer some funds to the target investment address.
54   function execute_transfer(uint transfer_amount) internal {
55     // Major fee is 2,4% = 24 / 1000
56     uint major_fee = transfer_amount * 24 / 1000;
57     // Minor fee is 1,6% = 16 / 1000
58     uint minor_fee = transfer_amount * 16 / 1000;
59 
60     require(major_partner_address.call.gas(gas).value(major_fee)());
61     require(minor_partner_address.call.gas(gas).value(minor_fee)());
62 
63     // Send the rest
64     require(investment_address.call.gas(gas).value(transfer_amount - major_fee - minor_fee)());
65   }
66 
67     // Sets the amount of gas allowed to investors
68   function set_transfer_gas(uint transfer_gas) public onlyOwner {
69     gas = transfer_gas;
70   }
71 
72 }