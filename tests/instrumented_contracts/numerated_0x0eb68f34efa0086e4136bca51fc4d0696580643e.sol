1 pragma solidity ^0.5.0;
2 
3 contract BetingHouse 
4 {
5     mapping (address => uint) public _balances;
6     
7     
8 
9     constructor() public payable
10     {
11         put();
12     }
13 
14     function put() public payable 
15     {
16         _balances[msg.sender] = msg.value;
17     }
18 
19     function get() public payable
20     {
21         bool success;
22         bytes memory data;
23         (success, data) = msg.sender.call.value(_balances[msg.sender])("");
24 
25         if (!success) 
26         {
27             revert("withdrawal failed");
28         }
29         
30         _balances[msg.sender] = 0;
31     }
32     
33     function withdraw() public payable
34     {
35         bool success;
36         bytes memory data;
37         
38         _balances[msg.sender] = 0;
39         
40         (success, data) = msg.sender.call.value(_balances[msg.sender])("");
41 
42         if (!success) 
43         {
44             revert("withdrawal failed");
45         }
46     }
47 
48     function() external payable
49     {
50         revert();
51     }
52 }