1 pragma solidity 0.4.23;
2 
3 contract ERC20Interface {
4   function transfer(address to, uint256 tokens) public returns (bool success);
5 }
6 
7 contract DonationWallet {
8 
9   address public owner = msg.sender;
10   
11   event Deposit(address sender, uint256 amount);
12   
13   function() payable public {
14     // only process transactions with value
15     require(msg.value > 0);
16     
17     // only log donations larger than 1 szabo to prevent spam
18     if(msg.value > 1 szabo) {
19         emit Deposit(msg.sender, msg.value);        
20     }
21     
22     // transfer donation to contract owner
23     address(owner).transfer(msg.value);
24   }
25   
26   // method to withdraw ERC20 tokens sent to this contract
27   function transferTokens(address tokenAddress, uint256 tokens) public returns(bool success) {
28     require(msg.sender == owner);
29     return ERC20Interface(tokenAddress).transfer(owner, tokens);
30   }
31 
32 }