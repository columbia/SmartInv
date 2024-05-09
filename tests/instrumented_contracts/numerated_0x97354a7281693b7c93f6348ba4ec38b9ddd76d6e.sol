1 pragma solidity ^0.4.24;
2 
3 interface ProForwarderInterface {
4     function deposit(address _addr) external payable returns (bool);
5     function migrationReceiver_setup() external returns (bool);
6 }
7 
8 contract ProForwarder {
9     string public name = "ProForwarder";
10     ProForwarderInterface private currentCorpBank_;
11     address private newCorpBank_;
12     bool needsBank_ = true;
13     
14     constructor() public {
15         //constructor does nothing.
16     }
17     
18     function() public payable {
19         // done so that if any one tries to dump eth into this contract, we can
20         // just forward it to corp bank.
21         currentCorpBank_.deposit.value(address(this).balance)(address(currentCorpBank_));
22     }
23     
24     function deposit() public payable returns(bool) {
25         require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");
26         require(needsBank_ == false, "Forwarder Deposit failed - no registered bank");
27         if (currentCorpBank_.deposit.value(msg.value)(msg.sender) == true)
28             return(true);
29         else
30             return(false);
31     }
32 
33     function status() public view returns(address, address, bool) {
34         return(address(currentCorpBank_), address(newCorpBank_), needsBank_);
35     }
36 
37     function startMigration(address _newCorpBank) external returns(bool) {
38         // make sure this is coming from current corp bank
39         require(msg.sender == address(currentCorpBank_), "Forwarder startMigration failed - msg.sender must be current corp bank");
40         
41         // communicate with the new corp bank and make sure it has the forwarder 
42         // registered 
43         if(ProForwarderInterface(_newCorpBank).migrationReceiver_setup() == true)
44         {
45             // save our new corp bank address
46             newCorpBank_ = _newCorpBank;
47             return (true);
48         } else 
49             return (false);
50     }
51     
52     function cancelMigration() external returns(bool) {
53         // make sure this is coming from the current corp bank (also lets us know 
54         // that current corp bank has not been killed)
55         require(msg.sender == address(currentCorpBank_), "Forwarder cancelMigration failed - msg.sender must be current corp bank");
56         
57         // erase stored new corp bank address;
58         newCorpBank_ = address(0x0);
59         
60         return (true);
61     }
62     
63     function finishMigration() external returns(bool) {
64         // make sure its coming from new corp bank
65         require(msg.sender == newCorpBank_, "Forwarder finishMigration failed - msg.sender must be new corp bank");
66 
67         // update corp bank address        
68         currentCorpBank_ = (ProForwarderInterface(newCorpBank_));
69         
70         // erase new corp bank address
71         newCorpBank_ = address(0x0);
72         
73         return (true);
74     }
75 
76     // this only runs once ever
77     function setup(address _firstCorpBank) external {
78         require(needsBank_ == true, "Forwarder setup failed - corp bank already registered");
79         currentCorpBank_ = ProForwarderInterface(_firstCorpBank);
80         needsBank_ = false;
81     }
82 }