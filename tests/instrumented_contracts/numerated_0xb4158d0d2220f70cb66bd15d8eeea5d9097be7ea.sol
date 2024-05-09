1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 // Time-locked wallet for Serenity advisors tokens
17 contract SerenityTeamAllocator {
18     // Address of team member to allocations mapping
19     mapping (address => uint256) allocations;
20 
21     ERC20Basic erc20_contract = ERC20Basic(0xBC7942054F77b82e8A71aCE170E4B00ebAe67eB6);
22     uint unlockedAt;
23     address owner;
24 
25     function SerenityTeamAllocator() {
26         unlockedAt = now + 11 * 30 days;
27         owner = msg.sender;
28 
29         allocations[0x4bA894C02BC92FC59573F1A4D0d82361AC3a6284] = 840497 ether;
30         allocations[0xA71703676002410fa62EE74052b991B1b5F6c891] = 133333 ether;
31         allocations[0x530f065d63FD73480e34da84E5aE1dfD6f77Aa73] = 66666 ether;
32         allocations[0xa33def7d09B1CE511f7d5675B2C374526fAB44c7] = 66666 ether;
33         allocations[0x11C6F9ccf49EBE938Dae82AE6c50a64eB5778dCC] = 40000 ether;
34         allocations[0x4296C27536553c59e57Fa8EA47913F5000311f03] = 66666 ether;
35     }
36 
37     // Unlock team member's tokens by transferring them to his address
38     function unlock() external {
39         require (now >= unlockedAt);
40 
41         var amount = allocations[msg.sender];
42         allocations[msg.sender] = 0;
43 
44         if (!erc20_contract.transfer(msg.sender, amount)) {
45             revert();
46         }
47     }
48 }