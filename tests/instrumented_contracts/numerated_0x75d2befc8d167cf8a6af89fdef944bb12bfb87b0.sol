1 pragma solidity >=0.5.3 <0.6.0;
2 
3 
4 contract TronRegister {
5     event RegisterAdd(address indexed ethAddress, address indexed tronAddress);
6 
7     mapping(address => address) private ethToTronMapping;
8 
9     function put(address _tronAddress) external {
10         address ethAddress = msg.sender;
11         require(ethToTronMapping[ethAddress] == address(0), "address already bound");
12         ethToTronMapping[ethAddress] = _tronAddress;
13         emit RegisterAdd(ethAddress, _tronAddress);
14     }
15 
16     function get(address _ethAddress) public view returns (address _tronAddress) {
17         return ethToTronMapping[_ethAddress];
18     }
19 }