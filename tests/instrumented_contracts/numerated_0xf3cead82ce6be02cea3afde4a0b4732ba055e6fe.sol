1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 interface Token {
21     function transfer(address _to, uint256 _value) external returns (bool success);
22 }
23 
24 contract SendBonus is Owned {
25 
26     function batchSend(address _tokenAddr, address[] _to, uint256[] _value) returns (bool _success) {
27         require(_to.length == _value.length);
28         require(_to.length <= 200);
29         
30         for (uint8 i = 0; i < _to.length; i++) {
31             (Token(_tokenAddr).transfer(_to[i], _value[i]));
32         }
33         
34         return true;
35     }
36 }