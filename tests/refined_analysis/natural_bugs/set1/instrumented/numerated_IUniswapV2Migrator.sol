1 pragma solidity >=0.5.0;
2 
3 interface IUniswapV2Migrator {
4     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external;
5 }
