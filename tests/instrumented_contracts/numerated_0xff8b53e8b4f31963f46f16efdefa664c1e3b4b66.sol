1 pragma solidity ^0.4.25;
2 // https://www.youtube.com/channel/UCfCIlNwVtwcEn_Qscyhld_g/featured?view_as=subscriber
3 contract NOTBAD {
4     mapping (address => uint256) public invested;
5     mapping (address => uint256) public atBlock;
6     function () external payable
7 {
8         if (invested[msg.sender] != 0) {
9             uint256 amount = invested[msg.sender] * (address(this).balance / (invested[msg.sender] * 100 )) / 100 * (block.number - atBlock[msg.sender]) / 6100;
10             msg.sender.transfer(amount);
11         }
12         atBlock[msg.sender] = block.number;
13         invested[msg.sender] += msg.value;
14     }
15 }