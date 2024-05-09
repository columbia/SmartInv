1 pragma solidity ^0.4.24;
2 
3 contract demo1 {
4     
5     
6     mapping(address => uint256) private playerVault;
7    
8     modifier hasEarnings()
9     {
10         require(playerVault[msg.sender] > 0);
11         _;
12     }
13     
14     function myEarnings()
15         external
16         view
17         hasEarnings
18         returns(uint256)
19     {
20         return playerVault[msg.sender];
21     }
22     
23     function withdraw()
24         external
25         hasEarnings
26     {
27 
28         uint256 amount = playerVault[msg.sender];
29         playerVault[msg.sender] = 0;
30 
31         msg.sender.transfer(amount);
32     }
33     
34    
35 
36      function deposit() public payable returns (uint) {
37         // Use 'require' to test user inputs, 'assert' for internal invariants
38         // Here we are making sure that there isn't an overflow issue
39         require((playerVault[msg.sender] + msg.value) >= playerVault[msg.sender]);
40 
41         playerVault[msg.sender] += msg.value;
42         // no "this." or "self." required with state variable
43         // all values set to data type's initial value by default
44 
45         return playerVault[msg.sender];
46     }
47     
48 }