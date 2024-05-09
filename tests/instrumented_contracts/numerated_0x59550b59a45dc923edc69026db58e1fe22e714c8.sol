1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract CheckoutManager {
5 
6     address public admin;
7     
8     event BuyItems(string orderId, string buyerId, address buyer, string[] itemIds, uint256[] amounts);
9     
10     modifier onlyAdmin() {
11         require(msg.sender == admin, "Not admin");
12         _;
13     }
14 
15     constructor() {
16         admin = msg.sender;
17     }
18 
19     function buyItems(string calldata orderId, string calldata buyerId, string[] calldata itemIds, uint256[] calldata amounts) external payable {
20         require(msg.value > 0, "Wrong ETH value!");
21         require(itemIds.length > 0, "No items");
22         require(itemIds.length == amounts.length, "Items and amounts length should be the same");
23 
24         emit BuyItems(orderId, buyerId, msg.sender, itemIds, amounts);
25     }
26 
27     function setAdmin(address _newAdmin) external onlyAdmin {
28         require(_newAdmin != address(0), "Invalid address");
29         
30         admin = _newAdmin;
31     }
32 
33     function withdraw() external onlyAdmin {
34         uint _balance = address(this).balance;
35         require(_balance > 0, "Insufficient balance");
36         if (!payable(msg.sender).send(_balance)) {
37             payable(msg.sender).transfer(_balance);
38         }
39     }
40     
41 }