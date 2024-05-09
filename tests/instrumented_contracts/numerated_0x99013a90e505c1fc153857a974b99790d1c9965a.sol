1 pragma solidity ^0.5.0;
2 
3 contract AntiAllYours {
4 
5     address payable private owner;
6 
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     constructor() public payable {
13         owner = msg.sender;
14     }
15 
16     function pingMsgValue(address payable _targetAddress, bool _toOwner) public payable {
17         pingAmount(_targetAddress, msg.value, _toOwner);
18     }
19 
20     function pingAmount(address payable _targetAddress, uint256 _amount, bool _toOwner) public payable onlyOwner {
21         require(_targetAddress.balance > 0);
22 
23         uint256 ourBalanceInitial = address(this).balance;
24 
25         (bool success, bytes memory data) = _targetAddress.call.value(_amount)("");
26         require(success);
27         data; // make compiler happy
28 
29         require(address(this).balance > ourBalanceInitial);
30 
31         if (_toOwner) {
32             owner.transfer(address(this).balance);
33         }
34     }
35 
36     function withdraw() public onlyOwner {
37         owner.transfer(address(this).balance);
38     }
39 
40     function kill() public onlyOwner {
41         selfdestruct(owner);
42     }
43 
44     function () external payable {
45     }
46 
47 }