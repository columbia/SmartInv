1 pragma solidity >=0.6.0 <0.8.0;
2 
3 import "../openzeppelin/contracts/token/ERC1155/IERC1155.sol";
4 
5 interface IMonoXPool is IERC1155 {
6     function mint (address account, uint256 id, uint256 amount) external;
7 
8     function burn (address account, uint256 id, uint256 amount) external;
9 
10     function totalSupplyOf(uint256 pid) external view returns (uint256);
11 
12     function depositWETH(uint256 amount) external;
13 
14     function withdrawWETH(uint256 amount) external;
15 
16     function safeTransferETH(address to, uint amount) external;
17 
18     function safeTransferERC20Token(address token, address to, uint256 amount) external;
19 
20     function getWETHAddr() external view returns (address);
21 }