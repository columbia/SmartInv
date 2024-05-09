1 pragma solidity ^0.4.24;
2 
3 contract Forwarder {
4     string public name = "Forwarder";
5     address private currentCorpBank_;
6     bool needsBank_ = true;
7     
8     constructor() 
9         public
10     {
11         //constructor does nothing.
12     }
13     
14     function()
15         public
16         payable
17     {
18         // done so that if any one tries to dump eth into this contract, we can
19         // just forward it to corp bank.
20         if (currentCorpBank_ != address(0))
21             currentCorpBank_.transfer(msg.value);
22     }
23     
24     function deposit()
25         public 
26         payable
27         returns(bool)
28     {
29         require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");
30         require(needsBank_ == false, "Forwarder Deposit failed - no registered bank");
31         currentCorpBank_.transfer(msg.value);
32         return(true);
33     }
34 
35     function withdraw()
36         public
37         payable
38     {
39         require(msg.sender == currentCorpBank_);
40         currentCorpBank_.transfer(address(this).balance);
41     }
42 
43     function setup(address _firstCorpBank)
44         external
45     {
46         require(needsBank_ == true, "Forwarder setup failed - corp bank already registered");
47         currentCorpBank_ = _firstCorpBank;
48         needsBank_ = false;
49     }
50 }