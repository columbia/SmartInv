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
53 contract MainframeInvestment is Ownable {
54 
55   // Address of the target contract
56   address public investment_address = 0x213E52B799bf99B2436EE492f7e2dFA184e790ab;
57   // Major partner address
58   address public major_partner_address = 0x8f0592bDCeE38774d93bC1fd2c97ee6540385356;
59   // Minor partner address
60   address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;
61   // Gas used for transfers.
62   uint public gas = 2000;
63 
64   // Payments to this contract require a bit of gas. 100k should be enough.
65   function() payable public {
66     execute_transfer(msg.value);
67   }
68 
69   // Transfer some funds to the target investment address.
70   function execute_transfer(uint transfer_amount) internal {
71     // Major fee is 60% * 20/420 * value = (6 * 20 / (10 * 420)) * value
72     uint major_fee = transfer_amount * 6 * 20 / (10 * 420);
73     // Minor fee is 40% * 20/420 * value = (4 * 20 / (10 * 420)) * value
74     uint minor_fee = transfer_amount * 4 * 20 / (10 * 420);
75 
76     require(major_partner_address.call.gas(gas).value(major_fee)());
77     require(minor_partner_address.call.gas(gas).value(minor_fee)());
78 
79     // Send the rest
80     require(investment_address.call.gas(gas).value(transfer_amount - major_fee - minor_fee)());
81   }
82 
83   // Sets the amount of gas allowed to investors
84   function set_transfer_gas(uint transfer_gas) public onlyOwner {
85     gas = transfer_gas;
86   }
87 
88   // We can use this function to move unwanted tokens in the contract
89   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
90     token.approve(dest, value);
91   }
92 
93 }