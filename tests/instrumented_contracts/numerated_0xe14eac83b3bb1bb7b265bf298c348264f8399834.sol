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
53 contract HubTokenPurchase is Ownable {
54 
55   // Address of the target contract
56   address public purchase_address = 0xcc04AF825eEf340e99710D4366e3021F8d82F42A;
57   // Major partner address
58   address public major_partner_address = 0x212286e36Ae998FAd27b627EB326107B3aF1FeD4;
59   // Minor partner address
60   address public minor_partner_address = 0x515962688858eD980EB2Db2b6fA2802D9f620C6d;
61   // Additional gas used for transfers.
62   uint public gas = 1000;
63 
64   // Payments to this contract require a bit of gas. 100k should be enough.
65   function() payable public {
66     execute_transfer(msg.value);
67   }
68 
69   // Transfer some funds to the target purchase address.
70   function execute_transfer(uint transfer_amount) internal {
71     // Major fee is 1.4 for each 1035
72     uint major_fee = transfer_amount * 21 / 1035;
73     // Minor fee is 2.1 for each 1035
74     uint minor_fee = transfer_amount * 14 / 1035;
75 
76     require(major_partner_address.call.gas(gas).value(major_fee)());
77     require(minor_partner_address.call.gas(gas).value(minor_fee)());
78 
79     // Send the rest
80     uint purchase_amount = transfer_amount - major_fee - minor_fee;
81     require(purchase_address.call.gas(gas).value(purchase_amount)());
82   }
83 
84   // Sets the amount of additional gas allowed to addresses called
85   // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.
86   //  
87   function set_transfer_gas(uint transfer_gas) public onlyOwner {
88     gas = transfer_gas;
89   }
90 
91   // We can use this function to move unwanted tokens in the contract
92   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
93     token.approve(dest, value);
94   }
95 
96   // This contract is designed to have no balance.
97   // However, we include this function to avoid stuck value by some unknown mishap.
98   function emergency_withdraw() public onlyOwner {
99     require(msg.sender.call.gas(gas).value(address(this).balance)());
100   }
101 
102 }