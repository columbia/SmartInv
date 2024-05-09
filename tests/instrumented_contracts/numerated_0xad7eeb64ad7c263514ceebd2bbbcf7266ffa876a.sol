1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     function Ownable() public {
8         owner = 0xdfFdB58ff200Db2DE93225B4beD921Ab452Ee231;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     event OwnershipTransferred(address indexed from, address indexed to);
17     
18 
19     function transferOwnership(address _newOwner) public onlyOwner {
20         require(_newOwner != address(0));
21         OwnershipTransferred(owner, _newOwner);
22         owner = _newOwner;
23     }
24 }
25 
26 
27 contract TokenTransferInterface {
28     function transfer(address _to, uint256 _value) public;
29 }
30 
31 
32 contract AirDrop is Ownable {
33 
34     TokenTransferInterface public constant token = TokenTransferInterface(0xd7e108b5e41cbde25461ba095cef7d4c2159a060);
35 
36     function multiValueAirDrop(address[] _addrs, uint256[] _values) public onlyOwner {
37 	    require(_addrs.length == _values.length && _addrs.length <= 100);
38         for (uint i = 0; i < _addrs.length; i++) {
39             if (_addrs[i] != 0x0 && _values[i] > 0) {
40                 token.transfer(_addrs[i], _values[i] * (10 ** 18));  
41             }
42         }
43     }
44 
45     function singleValueAirDrop(address[] _addrs, uint256 _value) public onlyOwner {
46 	    require(_addrs.length <= 100 && _value > 0);
47         for (uint i = 0; i < _addrs.length; i++) {
48             if (_addrs[i] != 0x0) {
49                 token.transfer(_addrs[i], _value * (10 ** 18));
50             }
51         }
52     }
53 }