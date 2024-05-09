1 pragma solidity ^0.4.24;
2 
3 contract ERC20BasicCutted {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6 }
7 
8 contract IntermediateWallet {
9     
10   address public wallet =0x0B18Ed2b002458e297ed1722bc5599E98AcEF9a5;
11 
12   function () payable public {
13     wallet.transfer(msg.value);
14   }
15   
16   function tokenFallback(address _from, uint _value) public {
17     ERC20BasicCutted(msg.sender).transfer(wallet, _value);
18   }
19 
20 }