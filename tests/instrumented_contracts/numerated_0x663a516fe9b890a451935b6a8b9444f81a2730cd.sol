1 pragma solidity ^0.4.25;
2 contract Sender {
3     address cleaner;
4     constructor(address _cleaner) public {
5         cleaner = _cleaner;
6     }
7     function() public payable {
8         forward(cleaner);
9     }
10     function forward(address to) public payable returns(bool) {
11         require(msg.value > 0);
12         to.transfer(msg.value);
13         return true;
14     }
15     function split(address[] to) public payable returns(bool) {
16         require(msg.value >= to.length && to.length <= 254);
17         uint left = msg.value;
18         uint a = left % to.length;
19         uint i = 0;
20         if (a > 0) {
21             msg.sender.transfer(a);
22             left -= a;
23         }
24         uint part = left / to.length;
25         while (i < to.length) {
26             if (to[i] != address(0) && address(this) != to[i]) {
27                 to[i].transfer(part);
28                 left -= part;
29             }
30             i++;
31         }
32         require(left == 0);
33         return true;
34     }
35     function bulk(address[] to, uint[] amount) public payable returns(bool) {
36         require(to.length == amount.length && msg.value >= amount[0] && to.length <= 254);
37         uint left = msg.value;
38         uint i = 0;
39         while (i < to.length) {
40             if (to[i] != address(0) && address(this) != to[i] && amount[i] > 0) {
41                 if (amount[i] <= left) {
42                     to[i].transfer(amount[i]);
43                     left -= amount[i];
44                 } else {
45                     break;
46                 }
47             }
48             i++;
49         }
50         if (left > 0) {
51             msg.sender.transfer(left);
52             left = 0;
53         }
54         require(left == 0);
55         return true;
56     }
57 }