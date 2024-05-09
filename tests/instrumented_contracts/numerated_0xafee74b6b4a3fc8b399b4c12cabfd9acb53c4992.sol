1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   function transferFrom(address from, address to, uint256 value) public returns (bool);
5 }
6 
7 
8 contract MultiSender {
9   function tokenFallback(address /*_from*/, uint _value, bytes /*_data*/) public {
10     require(false);
11   }
12 
13   function multisendToken(address tokAddress, address[] _dests, uint256[] _amounts) public {
14     ERC20 tok = ERC20(tokAddress);
15     for (uint i = 0; i < _dests.length; i++){
16         tok.transferFrom(msg.sender, _dests[i], _amounts[i]);
17     }
18   }
19 
20   function multisendEth(address[] _dests, uint256[] _amounts) public payable {
21     for (uint i = 0; i < _dests.length; i++){
22         _dests[i].transfer(_amounts[i]);
23     }
24     require(this.balance == 0);
25   }
26 }