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
36 /**
37  * Interface for the standard token.
38  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39  */
40 interface EIP20Token {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool success);
44   function transferFrom(address from, address to, uint256 value) public returns (bool success);
45   function approve(address spender, uint256 value) public returns (bool success);
46   function allowance(address owner, address spender) public view returns (uint256 remaining);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 
52 // The owner of this contract should be an externally owned account
53 contract WibsonInvestment is Ownable {
54 
55   // Address of the target contract
56   address public investment_address = 0x62Ef732Ec9BAB90070f4ac4e065Ce1CC090D909f;
57   // Major partner address
58   address public major_partner_address = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;
59   // Minor partner address
60   address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;
61   // Gas used for transfers.
62   uint public gas = 1000;
63 
64   // Payments to this contract require a bit of gas. 100k should be enough.
65   function() payable public {
66     execute_transfer(msg.value);
67   }
68 
69   // Transfer some funds to the target investment address.
70   function execute_transfer(uint transfer_amount) internal {
71     // Target address receives 10/11 of the amount.
72     // We add 1 wei to the quotient to ensure the rounded up value gets sent.
73     uint target_amount = (transfer_amount * 10 / 11) + 1;
74     // Send the target amount
75     require(investment_address.call.gas(gas).value(target_amount)());
76 
77     uint leftover = transfer_amount - target_amount;
78     // Major fee is 60% * value = (6 / 10) * value
79     uint major_fee = leftover * 6 / 10;
80     // The minor fee is 40% * value = (4 / 10) * value
81     // However, we send it as the rest of the received ether.
82     uint minor_fee = leftover - major_fee;
83 
84     // Send the major fee
85     require(major_partner_address.call.gas(gas).value(major_fee)());
86     // Send the minor fee
87     require(minor_partner_address.call.gas(gas).value(minor_fee)());
88   }
89 
90   // Sets the amount of gas allowed to investors
91   function set_transfer_gas(uint transfer_gas) public onlyOwner {
92     gas = transfer_gas;
93   }
94 
95   // We can use this function to move unwanted tokens in the contract
96   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
97     token.approve(dest, value);
98   }
99 
100 }