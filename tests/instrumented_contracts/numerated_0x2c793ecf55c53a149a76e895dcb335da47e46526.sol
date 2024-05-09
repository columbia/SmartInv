1 pragma solidity ^0.4.18;
2 
3 contract PasserBy {
4   address owner;
5   address vault;
6 
7   event PasserByTracker(address from, address to, uint256 amount);
8 
9   function PasserBy(address _vault) public {
10     require(_vault != address(0));
11     owner = msg.sender;
12     vault = _vault;
13   }
14 
15   function changeVault(address _newVault) public ownerOnly {
16     vault = _newVault;
17   }
18 
19   function () external payable {
20     require(msg.value > 0);
21     vault.transfer(msg.value);
22     emit PasserByTracker(msg.sender, vault, msg.value);
23   }
24 
25   modifier ownerOnly {
26     require(msg.sender == owner);
27     _;
28   }
29 }