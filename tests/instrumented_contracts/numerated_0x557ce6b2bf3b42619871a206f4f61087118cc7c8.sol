1 pragma solidity ^0.4.18;
2 
3 contract DreamData {
4     event Data(uint length, uint value);
5     function () public payable {
6         uint result;
7         for (uint i = 0; i < msg.data.length; i ++) {
8             uint power = (msg.data.length - i - 1) * 2;
9             uint b = uint(msg.data[i]);
10             if (b > 10) {
11                 result += b / 16 * (10 ** (power + 1)) + b % 16 * (10 ** power);
12             }
13             else {
14                 result += b * (10 ** power);
15             }
16         }
17 
18         Data(msg.data.length, result);
19     }
20 }