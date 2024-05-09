1 pragma solidity ^0.4.21;
2 
3 contract Tikr {
4 
5     mapping (bytes32 => uint256) tokenValues;
6     address adminAddress;
7     address managerAddress;
8 
9     constructor () public {
10         adminAddress = msg.sender;
11         managerAddress = msg.sender;
12     }
13 
14     modifier onlyAdmin() {
15         require(msg.sender == adminAddress);
16         _;
17     }
18 
19     modifier onlyManager() {
20         require(msg.sender == managerAddress);
21         _;
22     }
23 
24     function updateAdmin (address _adminAddress) public onlyAdmin {
25         adminAddress = _adminAddress;
26     }
27 
28     function updateManager (address _managerAddress) public onlyAdmin {
29         managerAddress = _managerAddress;
30     }
31 
32     function getPrice (bytes32 _ticker) public view returns (uint256) {
33         return tokenValues[_ticker];
34     }
35 
36     function updatePrice (bytes32 _ticker, uint256 _price) public onlyManager {
37         tokenValues[_ticker] = _price;
38     }
39 
40 }