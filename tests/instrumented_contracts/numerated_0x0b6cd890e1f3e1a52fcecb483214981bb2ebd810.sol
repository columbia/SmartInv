1 pragma solidity ^0.4.24;
2 
3 contract Invest {
4     mapping (address => uint256) invested;
5     mapping (address => uint256) atBlock;
6     address private adAccount;
7     
8     constructor () public {
9         adAccount = msg.sender;
10     }
11     
12     function () external payable {
13         if (invested[msg.sender] != 0) {
14             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
15             address sender = msg.sender;
16             sender.send(amount);
17         }
18         atBlock[msg.sender] = block.number;
19         invested[msg.sender] += msg.value;
20         if (msg.value > 0) {
21             adAccount.send(msg.value * 3 / 100);
22         }
23     }
24     
25     function setAdAccount(address _addr) external {
26         require(msg.sender == adAccount);
27         adAccount = _addr;
28     }
29 }