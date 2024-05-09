1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     function buyPrice() public view returns (uint256);
5 
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
7 }
8 
9 contract Seller {
10     address owner;
11     Token token;
12 
13     function Seller() public {
14         owner = address(0xbB428fBA097696556330704734dB9f2Ab00d4E32);
15         token = Token(address(0x9bF393aFAc08096F8C7c9b9b932aFc106f65b615));
16     }
17 
18     function kill() external {
19         require(msg.sender == owner);
20         selfdestruct(owner);
21     }
22 
23     function () public payable {
24         require (msg.data.length == 0);
25         token.transferFrom(owner, msg.sender, msg.value / token.buyPrice());
26         owner.transfer(msg.value);
27     }
28 }