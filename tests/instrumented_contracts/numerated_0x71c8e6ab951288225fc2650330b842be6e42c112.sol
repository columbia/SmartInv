1 pragma solidity ^0.4.17;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     function Ownable() public {
9         owner = 0x2d312d2a3cb2a7a48e900aA4559Ec068ab5b4B6D;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     event OwnershipTransferred(address indexed from, address indexed to);
18     
19 
20     function transferOwnership(address _newOwner) public onlyOwner {
21         require(_newOwner != 0x0);
22         OwnershipTransferred(owner, _newOwner);
23         owner = _newOwner;
24     }
25 }
26 
27 
28 contract TokenTransferInterface {
29     function transfer(address _to, uint256 _value) public;
30 }
31 
32 
33 contract AirDrop is Ownable {
34 
35     TokenTransferInterface public constant token = TokenTransferInterface(0xC8A0D57d5F24622813a1BEe07509287BFaA4A3bc);
36 
37     function multiValueAirDrop(address[] _addrs, uint256[] _values) public onlyOwner {
38 	require(_addrs.length == _values.length && _addrs.length <= 100);
39         for (uint i = 0; i < _addrs.length; i++) {
40             if (_addrs[i] != 0x0 && _values[i] > 0) {
41                 token.transfer(_addrs[i], _values[i] * (10 ** 18));  
42             }
43         }
44     }
45 
46     function singleValueAirDrop(address[] _addrs, uint256 _value) public onlyOwner {
47 	require(_addrs.length <= 100 && _value > 0);
48         for (uint i = 0; i < _addrs.length; i++) {
49             if (_addrs[i] != 0x0) {
50                 token.transfer(_addrs[i], _value * (10 ** 18));
51             }
52         }
53     }
54 }