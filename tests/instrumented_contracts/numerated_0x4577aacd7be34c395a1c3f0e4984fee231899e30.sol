1 pragma solidity ^0.4.25;
2 
3 contract Sinocbot {
4 
5     function batchTransfer(address _tokenAddress, address[] _receivers, uint256[] _values) public {
6 
7         require(_receivers.length == _values.length && _receivers.length >= 1);
8         bytes4 methodId = bytes4(keccak256("transferFrom(address,address,uint256)"));
9         for(uint256 i = 0 ; i < _receivers.length; i++){
10             if(!_tokenAddress.call(methodId, msg.sender, _receivers[i], _values[i])) {
11                 revert();
12             }
13         }
14     }
15 }