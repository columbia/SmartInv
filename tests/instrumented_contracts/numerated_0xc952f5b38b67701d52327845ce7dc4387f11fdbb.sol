1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     function Ownable() public {
8         owner = 0x202abc6cf98863ee0126c182ca325a33a867acba;
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
20         require(_newOwner != 0x0);
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
34     address public constant MFTU = 0x05D412CE18F24040bB3Fa45CF2C69e506586D8e8;
35     address public constant CYFM = 0x3f06B5D78406cD97bdf10f5C420B241D32759c80;
36 
37     function airDrop(address _tokenAddress, address[] _addrs, uint256[] _values) public onlyOwner {
38     	require(_addrs.length == _values.length && _addrs.length <= 100);
39     	require(_tokenAddress == MFTU || _tokenAddress == CYFM);
40     	TokenTransferInterface token;
41     	if(_tokenAddress == MFTU) {
42     	    token = TokenTransferInterface(MFTU);
43     	} else {
44     	    token = TokenTransferInterface(CYFM);
45     	}
46         for (uint i = 0; i < _addrs.length; i++) {
47             if (_addrs[i] != 0x0 && _values[i] > 0) {
48                 token.transfer(_addrs[i], _values[i]);  
49             }
50         }
51     }
52 }