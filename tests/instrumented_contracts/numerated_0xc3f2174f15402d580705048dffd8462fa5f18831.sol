1 pragma solidity ^0.4.11;
2 
3 interface tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
4 
5 contract VKCoin {
6     mapping (address => uint256) public balanceOf;
7     
8     string public name = 'VKCoin';
9     string public symbol = 'VKC';
10     uint8 public decimals = 6;
11     
12     function transfer(address _to, uint256 _value) public {
13         balanceOf[msg.sender] -= _value;
14         balanceOf[_to] += _value;
15     }
16     
17     function VKCoin() public {
18         balanceOf[msg.sender] = 1000000000000000;                   // Amount of decimals for display purposes
19     }
20     
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 }