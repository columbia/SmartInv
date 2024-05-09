1 pragma solidity 0.4.24;
2 
3 contract MassSender {
4     mapping (uint32 => bool) processedTransactions;
5 
6     function bulkTransferFrom(
7         ERC20 token,
8         uint32[] payment_ids,
9         address[] receivers,
10         uint256[] transfers
11     ) external {
12         require(payment_ids.length == receivers.length);
13         require(payment_ids.length == transfers.length);
14 
15         for (uint i = 0; i < receivers.length; i++) {
16             if (!processedTransactions[payment_ids[i]]) {
17                 require(token.transferFrom(msg.sender, receivers[i], transfers[i]));
18 
19                 processedTransactions[payment_ids[i]] = true;
20             }
21         }
22     }
23 }
24 
25 contract ERC20Basic {
26     function totalSupply() public view returns (uint256);
27     function balanceOf(address who) public view returns (uint256);
28     function transfer(address to, uint256 value) public returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 contract ERC20 is ERC20Basic {
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }