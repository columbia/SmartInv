1 pragma solidity ^0.4.12;
2 
3 // Reward Channel contract
4 
5 contract Name{
6     address public owner = msg.sender;
7     string public name;
8 
9     modifier onlyBy(address _account) { require(msg.sender == _account); _; }
10 
11 
12     function Name(string myName) public {
13       name = myName;
14     }
15 
16     function() payable public {}
17 
18     function withdraw() onlyBy(owner) public {
19       owner.transfer(this.balance);
20     }
21 
22     function destroy() onlyBy(owner) public{
23       selfdestruct(this);
24     }
25 }