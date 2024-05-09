1 pragma solidity ^0.4.23;
2 
3 contract Token{
4   function transfer(address to, uint value) returns (bool);
5 }
6 
7 contract Indorser {
8     function multisend(address _tokenAddr, address[] _to, uint256[] _value)
9     returns (bool _success) {
10         assert(_to.length == _value.length);
11         assert(_to.length <= 150);
12         // loop through to addresses and send value
13         for (uint8 i = 0; i < _to.length; i++) {
14                 assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);
15             }
16             return true;
17         }
18 }