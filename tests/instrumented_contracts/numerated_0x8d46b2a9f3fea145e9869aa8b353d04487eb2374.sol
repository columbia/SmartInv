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
53 contract OlyseumPurchase is Ownable {
54 
55   // Address of the target contract
56   address public purchase_address = 0x04A1af06961E8FAFb82bF656e135B67C130EF240;
57   // Major partner address
58   address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;
59   // Minor partner address
60   address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;
61   // Third partner address
62   address public third_partner_address = 0x70d496dA196c522ee0269855B1bC8E92D1D5589b;
63   // Additional gas used for transfers.
64   uint public gas = 1000;
65 
66   // Payments to this contract require a bit of gas. 100k should be enough.
67   function() payable public {
68     execute_transfer(msg.value);
69   }
70 
71   // Transfer some funds to the target purchase address.
72   function execute_transfer(uint transfer_amount) internal {
73     // Major fee is amount*15/10/105
74     uint major_fee = transfer_amount * 15 / 10 / 105;
75     // Minor fee is amount/105
76     uint minor_fee = transfer_amount / 105;
77     // Third fee is amount*25/10/105
78     uint third_fee = transfer_amount * 25 / 10 / 105;
79 
80     require(major_partner_address.call.gas(gas).value(major_fee)());
81     require(minor_partner_address.call.gas(gas).value(minor_fee)());
82     require(third_partner_address.call.gas(gas).value(third_fee)());
83 
84     // Send the rest
85     uint purchase_amount = transfer_amount - major_fee - minor_fee - third_fee;
86     require(purchase_address.call.gas(gas).value(purchase_amount)());
87   }
88 
89   // Sets the amount of additional gas allowed to addresses called
90   // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.
91   //  
92   function set_transfer_gas(uint transfer_gas) public onlyOwner {
93     gas = transfer_gas;
94   }
95 
96   // We can use this function to move unwanted tokens in the contract
97   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
98     token.approve(dest, value);
99   }
100 
101   // This contract is designed to have no balance.
102   // However, we include this function to avoid stuck value by some unknown mishap.
103   function emergency_withdraw() public onlyOwner {
104     require(msg.sender.call.gas(gas).value(this.balance)());
105   }
106 
107 }