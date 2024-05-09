1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4   function transfer(address to, uint256 value) public returns (bool);
5 }
6 
7 /**
8  * @title Airdrop contract used to perform bulk transfers within a single transaction.
9  */
10 contract Airdrop {
11   address _owner;
12 
13   modifier ownerOnly {
14     if (_owner == msg.sender) _;
15   }
16 
17   function Airdrop() public {
18     _owner = msg.sender;
19   }
20 
21   function transferOwnership(address newOwner) public ownerOnly {
22     _owner = newOwner;
23   }
24 
25   /**
26    * @dev Perform the airdrop. Restricted to no more than 300 accounts in a single transactions
27    * @notice More than 300 accounts will exceed gas block limit. It is recommended to perform
28    * batches using no more than 250 accounts as the actual gas cost is dependent on the
29    * tokenContractAddress's implementation of transfer())
30    *
31    * @param tokenContractAddress The address of the token contract being transfered.
32    * @param recipients Array of accounts receiving tokens.
33    * @param amounts Array of amount of tokens to be transferred. Index of amounts lines up with
34    *                the index of recipients.
35    */
36   function drop(address tokenContractAddress, address[] recipients, uint256[] amounts) public ownerOnly {
37     require(tokenContractAddress != 0x0);
38     require(recipients.length == amounts.length);
39     require(recipients.length <= 300);
40 
41     ERC20 tokenContract = ERC20(tokenContractAddress);
42 
43     for (uint8 i = 0; i < recipients.length; i++) {
44       tokenContract.transfer(recipients[i], amounts[i]);
45     }
46   }
47 }