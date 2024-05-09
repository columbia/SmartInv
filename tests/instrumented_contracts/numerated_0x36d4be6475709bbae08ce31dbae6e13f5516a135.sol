1 pragma solidity ^0.4.21;
2 contract BurnTok {
3     function () payable public{
4     }
5 	function BurnToken (address _tokenaddress, uint256 _value) public {
6         require(_tokenaddress.call(bytes4(keccak256("burn(uint256)")), _value));
7     }
8 }