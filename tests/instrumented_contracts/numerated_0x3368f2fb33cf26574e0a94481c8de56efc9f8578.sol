1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4     function placesLeft() external view returns (uint256);
5 }
6 
7 contract AntiCryptoman_Prize {
8     
9     address payable targetAddress = 0x1Ef48854c57126085c2C9615329ED71fe159E390; // mainnet
10 
11     address payable private owner;
12     
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     constructor() public payable {
19         owner = msg.sender;
20     }
21     
22     function ping(bool _toOwner) public payable onlyOwner {
23         TargetInterface target = TargetInterface(targetAddress);
24         uint256 placesLeft = target.placesLeft();
25         
26         require(placesLeft == 10);
27         
28         uint256 betSize = 0.05 ether;
29 
30         for (uint256 ourBetIndex = 0; ourBetIndex < 10; ourBetIndex++) {
31             (bool success, bytes memory data) = targetAddress.call.value(betSize)("");
32             require(success);
33             data;
34         }
35         
36         if (_toOwner) {
37             owner.transfer(address(this).balance);
38         }
39     }
40     
41     function grabPrize(bool _toOwner) public onlyOwner {
42         (bool success, bytes memory data) = targetAddress.call("");
43         success;
44         data;
45 
46         if (_toOwner) {
47             owner.transfer(address(this).balance);
48         }
49     }
50     
51     function withdraw() public onlyOwner {
52         owner.transfer(address(this).balance);
53     }    
54     
55     function kill() public onlyOwner {
56         selfdestruct(owner);
57     }    
58     
59     function () external payable {
60     }
61     
62 }