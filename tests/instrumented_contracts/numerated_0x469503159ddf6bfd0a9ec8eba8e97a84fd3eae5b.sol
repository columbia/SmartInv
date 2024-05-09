1 pragma solidity 0.5.11;
2 
3 
4 contract BulkSender {
5 
6     function distribute(address[] calldata addresses, uint256[] calldata amounts) payable external {
7         require(addresses.length > 0);
8         require(amounts.length == addresses.length);
9 
10         for (uint256 i; i < addresses.length; i++) {
11             uint256 value = amounts[i];
12             address _to = addresses[i];
13             require(value > 0);
14             address(uint160(_to)).transfer(value);
15         }
16     }
17 
18     function() external payable {
19         msg.sender.transfer(address(this).balance);
20     }
21 }