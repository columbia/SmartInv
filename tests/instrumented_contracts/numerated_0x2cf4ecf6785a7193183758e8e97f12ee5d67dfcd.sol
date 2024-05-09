1 pragma solidity ^0.4.24;
2 
3 // win 122%, bet 0.05 ETH, gas limit 200000
4 
5 contract Geniuz {
6     address public promo = msg.sender;
7     uint public depositValue = 0.05 ether;
8     uint public placeCount = 5;
9     uint public winPercent = 122;
10     uint public win = depositValue * winPercent / 100;
11     address[] public places;
12     uint private seed;
13     
14     // returns a pseudo-random number
15     function random(uint lessThan) internal returns (uint) {
16         return uint(sha256(abi.encodePacked(
17             blockhash(block.number - places.length - 1),
18             msg.sender,
19             seed += block.difficulty
20         ))) % lessThan;
21     }
22     
23     function() external payable {
24         require(msg.sender == tx.origin);
25         require(msg.value == depositValue);
26         places.push(msg.sender);
27         if (places.length == placeCount) {
28             uint loser = random(placeCount);
29             for (uint i = 0; i < placeCount; i++) {
30                 if (i != loser) {
31                     places[i].send(win);
32                 }
33             }
34             promo.transfer(address(this).balance);
35             delete places;
36         }
37     }
38 }