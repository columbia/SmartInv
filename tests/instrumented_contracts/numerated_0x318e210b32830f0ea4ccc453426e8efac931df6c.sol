1 pragma solidity ^0.4.24;
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
53 contract PeaqPurchase is Ownable {
54 
55   // Address of the target contract
56   address public purchase_address = 0x24e57d774b9E2Aa4A4fbeC08C66817DcF1dAd2CF;
57   // Additional gas used for transfers. This is added to the standard 2300 gas for value transfers.
58   uint public gas = 1000;
59 
60   // Payments to this contract require a bit of gas. 100k should be enough.
61   function() payable public {
62     execute_transfer(msg.value);
63   }
64 
65   // Transfer some funds to the target purchase address.
66   function execute_transfer(uint transfer_amount) internal {
67     // Send the entirety of the received amount
68     transfer_with_extra_gas(purchase_address, transfer_amount);
69   }
70 
71   // Transfer with additional gas.
72   function transfer_with_extra_gas(address destination, uint transfer_amount) internal {
73     require(destination.call.gas(gas).value(transfer_amount)());
74   }
75 
76   // Sets the amount of additional gas allowed to addresses called
77   // @dev This allows transfers to multisigs that use more than 2300 gas in their fallback function.
78   function set_transfer_gas(uint transfer_gas) public onlyOwner {
79     gas = transfer_gas;
80   }
81 
82   // We can use this function to move unwanted tokens in the contract
83   function approve_unwanted_tokens(EIP20Token token, address dest, uint value) public onlyOwner {
84     token.approve(dest, value);
85   }
86 
87   // This contract is designed to have no balance.
88   // However, we include this function to avoid stuck value by some unknown mishap.
89   function emergency_withdraw() public onlyOwner {
90     transfer_with_extra_gas(msg.sender, address(this).balance);
91   }
92 
93 }