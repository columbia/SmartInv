1 pragma solidity ^0.4.16;
2 
3 contract test
4 {
5     event AAA(address indexed sender, uint x);
6     
7     function aaa(bytes data) public
8     {
9         uint x = _bytesToUint(data);
10         AAA(msg.sender, x);
11     }
12     
13     function _bytesToUint(bytes data) internal view returns (uint) {
14         uint num = 0;
15         for(uint i = 0; i < data.length; i++) {
16             num += uint(data[i]);
17             if(i != data.length - 1)
18                 num *= 256;
19         }
20         return num;
21     }
22 }