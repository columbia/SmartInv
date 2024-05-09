1 pragma solidity ^0.4.24;
2 
3 contract Bank {
4     string public name = "bank";
5     address public owner;
6     address public withdrawer;
7 
8     constructor()
9         public
10     {
11         owner = msg.sender;
12     }
13 
14     function()
15         public
16         payable
17     {
18         // do nothing
19     }
20 
21     function deposit(address _addr)
22         external
23         payable
24         returns (bool)
25     {
26         require(msg.value > 0, "Failed - zero deposits not allowed");
27         return (true);
28     }
29 
30     function migrationReceiver_setup()
31         external
32         returns (bool)
33     {
34         return (true);
35     }
36 
37     function setWithdrawer(address _withdrawer)
38         public
39         returns (bool)
40     {
41         require(msg.sender == owner);
42         withdrawer = _withdrawer;
43 
44         return (true);
45     }
46 
47     function withdraw()
48         public
49         returns (bool)
50     {
51         require(msg.sender == withdrawer);
52         withdrawer.transfer(address(this).balance);
53 
54         return (true);
55     }
56 
57     function getContractBalance()
58         public
59         view
60         returns (uint)
61     {
62         return (address(this).balance);
63     }
64 }