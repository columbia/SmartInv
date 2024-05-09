1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /** 
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   constructor() internal {
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
41   function totalSupply() external view returns (uint256);
42   function balanceOf(address who) external view returns (uint256);
43   function transfer(address to, uint256 value) external returns (bool success);
44   function transferFrom(address from, address to, uint256 value) external returns (bool success);
45   function approve(address spender, uint256 value) external returns (bool success);
46   function allowance(address owner, address spender) external view returns (uint256 remaining);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 
52 // The owner of this contract should be an externally owned account
53 contract Wibson2Purchase is Ownable {
54 
55   // Address of the target contract
56   address public purchase_address = 0x40AF356665E9E067139D6c0d135be2B607e01Ab3;
57   // First partner address
58   address public first_partner_address = 0xeAf654f12F33939f765F0Ef3006563A196A1a569;
59   // Second partner address
60   address public second_partner_address = 0x1B78C30171A45CA627889356cf74f77d872682c2;
61   // Additional gas used for transfers. This is added to the standard 2300 gas for value transfers.
62   uint public gas = 1000;
63 
64   // Payments to this contract require a bit of gas. 100k should be enough.
65   function() payable public {
66     execute_transfer(msg.value);
67   }
68 
69   // Transfer some funds to the target purchase address.
70   function execute_transfer(uint transfer_amount) internal {
71     // First partner fee is 2.5 for each 100
72     uint first_fee = transfer_amount * 25 / 1000;
73     // Second partner fee is 2.5 for each 100
74     uint second_fee = transfer_amount * 25 / 1000;
75 
76     transfer_with_extra_gas(first_partner_address, first_fee);
77     transfer_with_extra_gas(second_partner_address, second_fee);
78 
79     // Send the rest
80     uint purchase_amount = transfer_amount - first_fee - second_fee;
81     transfer_with_extra_gas(purchase_address, purchase_amount);
82   }
83 
84   // Transfer with additional gas.
85   function transfer_with_extra_gas(address destination, uint transfer_amount) internal {
86     require(destination.call.gas(gas).value(transfer_amount)());
87   }
88 
89   // Sets the amount of additional gas allowed to addresses called
90   // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.
91   function set_transfer_gas(uint transfer_gas) public onlyOwner {
92     gas = transfer_gas;
93   }
94 
95   // We can use this function to move unwanted tokens in the contract
96   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
97     token.approve(dest, value);
98   }
99 
100   // This contract is designed to have no balance.
101   // However, we include this function to avoid stuck value by some unknown mishap.
102   function emergency_withdraw() public onlyOwner {
103     transfer_with_extra_gas(msg.sender, address(this).balance);
104   }
105 
106 }