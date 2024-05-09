1 pragma solidity ^0.4.20;
2 interface token { function transfer(address _to, uint _value) public; }
3 
4 contract XMTCandy {
5     function () payable public {
6         msg.sender.transfer(msg.value);
7         token(0xE5C943Efd21eF0103d7ac6C4d7386E73090a11af).transfer(msg.sender, 10000000000000000000000);
8     }
9 }