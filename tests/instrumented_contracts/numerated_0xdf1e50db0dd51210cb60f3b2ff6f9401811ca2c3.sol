1 pragma solidity ^0.4.23;
2 
3 contract SloadTest {
4     uint256[] public buffer;
5     
6     function readAll() external returns (uint256 sum) {
7         sum = 0;
8         uint256 length = buffer.length;
9         for (uint256 i = 0; i < length; i++) {
10             sum += buffer[i];
11         }
12         return sum;
13     }
14     
15     function write() external {
16         buffer.push(buffer.length);
17     }
18     
19     function getLength() public view returns (uint256) {
20         return buffer.length;
21     }
22 }