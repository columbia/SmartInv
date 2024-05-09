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
53 contract HumanProtocolInvestment is Ownable {
54 
55   // Address of the target contract
56   address public investment_address = 0x55704E8Cb15AF1054e21a7a59Fb0CBDa6Bd044B7;
57   // Major partner address
58   address public major_partner_address = 0x5a89D9f1C382CaAa66Ee045aeb8510F1205bC8bf;
59   // Minor partner address
60   address public minor_partner_address = 0xC787C3f6F75D7195361b64318CE019f90507f806;
61   // Third partner address
62   address public third_partner_address = 0xDa2cEa3DbaC30835D162Df11D21Ac6Cbf355aC9F;
63   // Additional gas used for transfers.
64   uint public gas = 1000;
65 
66   // Payments to this contract require a bit of gas. 100k should be enough.
67   function() payable public {
68     execute_transfer(msg.value);
69   }
70 
71   // Transfer some funds to the target investment address.
72   function execute_transfer(uint transfer_amount) internal {
73     // Major fee is 30% * (1/11) * value = 3 * value / (10 * 11)
74     uint major_fee = transfer_amount * 3 / (10 * 11);
75     // Minor fee is 20% * (1/11) * value = 2 * value / (10 * 11)
76     uint minor_fee = transfer_amount * 2 / (10 * 11);
77     // Third fee is 50% * (1/11) * value = 5 * value / (10 * 11)
78     uint third_fee = transfer_amount * 5 / (10 * 11);
79 
80     require(major_partner_address.call.gas(gas).value(major_fee)());
81     require(minor_partner_address.call.gas(gas).value(minor_fee)());
82     require(third_partner_address.call.gas(gas).value(third_fee)());
83 
84     // Send the rest
85     uint investment_amount = transfer_amount - major_fee - minor_fee - third_fee;
86     require(investment_address.call.gas(gas).value(investment_amount)());
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