1 pragma solidity 0.4.25;
2 contract testabi {
3     uint c;
4     function tinhtong(uint a, uint b) public {
5         c = a+b;
6     } 
7     function ketqua() public view returns (uint) {
8         return c;
9     }
10 }