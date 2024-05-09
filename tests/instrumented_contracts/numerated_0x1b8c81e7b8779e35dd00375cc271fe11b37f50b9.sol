1 pragma solidity ^0.5.0;
2 
3 interface IBancorNetwork {
4 	function getReturnByPath(address[] calldata _path, uint256 _amount) external view returns (uint256, uint256);
5 }
6 
7 contract BancorPathTest {
8 	IBancorNetwork bancorNetwork = IBancorNetwork(0x6690819Cb98c1211A8e38790d6cD48316Ed518Db);
9 
10 	function checkPath(address[] calldata _path, uint256 _amount) payable external returns(uint256, uint256) {
11 		require(msg.value == 1 wei);
12 		return bancorNetwork.getReturnByPath(_path, _amount);
13 	}
14 }