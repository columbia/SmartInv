1 pragma solidity ^0.4.20;
2 
3 contract Vault {
4     mapping (address=>uint256) public eth_stored;
5     address public owner;
6     address public client_wallet;
7     address public primary_wallet;
8     
9     constructor (address main_wallet, address other_wallet) public {
10         owner = msg.sender;
11         primary_wallet = main_wallet;
12         client_wallet = other_wallet;
13     }
14     
15     event Contribution (address investor, uint256 eth_paid);
16     
17     function () public payable {
18         eth_stored[msg.sender] += msg.value;
19         emit Contribution(msg.sender, msg.value);
20         uint256 client_share = msg.value*3/10;
21         uint256 our_share = msg.value - client_share;
22         client_wallet.transfer(client_share);
23         primary_wallet.transfer(our_share);
24     }
25 }