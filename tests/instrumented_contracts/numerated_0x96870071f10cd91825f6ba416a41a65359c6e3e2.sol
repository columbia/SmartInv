1 pragma solidity 0.5.6;
2 
3 contract A {
4     uint256 private number;
5     
6     function getNumber() public view returns (uint256) {
7         return number;
8     }
9 }
10 
11 contract B {
12     function newA() public returns(address) {
13         A newInstance = new A();
14         return address(newInstance);
15     }
16 }