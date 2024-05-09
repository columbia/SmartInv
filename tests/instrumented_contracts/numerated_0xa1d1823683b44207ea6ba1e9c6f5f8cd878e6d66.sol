1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface ERC20Interface {
4     function transfer(address _to, uint256 _value) external returns (bool success);
5     function balanceOf(address _owner) external view returns (uint256 balance);
6 }
7 
8 contract SimpleWallet {
9 
10     function flushTokens(address _tokenContractAddress,address _collectorAddress) public  {
11         ERC20Interface instance = ERC20Interface(_tokenContractAddress);
12         address forwarderAddress = address(this);
13         uint256 forwarderBalance = instance.balanceOf(forwarderAddress);
14         if (forwarderBalance == 0) {
15             return;
16         }
17         require(instance.transfer(_collectorAddress, forwarderBalance));
18 
19     }
20     
21 }