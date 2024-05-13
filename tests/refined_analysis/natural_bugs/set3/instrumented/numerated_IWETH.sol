1 pragma solidity >=0.6.0 <0.8.0;
2 
3 interface IWETH {
4     function deposit() external payable;
5     function transfer(address to, uint value) external returns (bool);
6     function withdraw(uint) external;
7 }