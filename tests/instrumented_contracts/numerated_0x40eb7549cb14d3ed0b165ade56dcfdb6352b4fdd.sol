1 pragma solidity ^0.4.11;
2 contract Ownable {
3   address public owner;
4   function Ownable() {
5     owner = 0x587c04e40346171dE18341fc9027395c3FdA83ab;
6   }
7   modifier onlyOwner() {
8     if (msg.sender != owner) {
9       throw;
10     }
11     _;
12   }
13   function transferOwnership(address newOwner) onlyOwner {
14     if (newOwner != address(0)) {
15       owner = newOwner;
16     }
17   }
18 
19 }
20 contract Token{
21   function transfer(address to, uint value) returns (bool);
22 }
23 contract SendLove is Ownable {
24     function multisend(address _tokenAddr, address[] _to, uint256[] _value)
25     returns (bool _success) {
26         assert(_to.length == _value.length);
27         assert(_to.length <= 150);
28         // loop through to addresses and send value
29         for (uint8 i = 0; i < _to.length; i++) {
30                 assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);
31             }
32             return true;
33         }
34 }