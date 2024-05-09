1 pragma solidity ^0.4.16;
2 interface TokenERC20{
3     function transfer(address _to, uint256 _value) public;
4 }
5 contract locksdc2{
6 
7     address sdcContractAddr = 0xe85ed250e3d91fde61bf32e22c54f04754e695c5;
8     address sdcMainAcc = 0xe7DbCcA8183cb7d67bCFb3DA687Ce7325779c02f;
9     TokenERC20 sdcCon = TokenERC20(sdcContractAddr);
10     struct accountInputSdc {
11         address account;
12         uint sdc;
13         uint locktime;
14         uint createttime;
15     }
16     
17     struct accountOutputSdc {
18         address account;
19         uint256 sdc;
20         uint createttime;
21     }
22     
23     struct accoutInputOutputSdcLog{
24         address account;
25         uint256 sdc;
26         uint locktime;
27         bool isIn;
28         uint createttime;
29     }
30     
31     mapping(address=>accountInputSdc[]) public accountInputSdcs;
32     mapping(address=>accountOutputSdc[]) public accountOutputSdcs;
33     mapping(address=>accoutInputOutputSdcLog[]) public accoutInputOutputSdcLogs;
34     mapping(address=>uint) public unlockSdc;
35     
36     event lockLogs(address indexed _controller,address indexed _user,uint256 _sdc,uint _locktime,bool _islock);
37     
38     function inSdcForAdmin(address _address,uint256 _sdc,uint _locktime) public returns (bool b)   {
39         require(msg.sender == sdcMainAcc);
40         accountInputSdcs[_address].push(accountInputSdc(_address,_sdc,_locktime,now));
41         lockLogs(msg.sender,_address,_sdc,_locktime,true);
42         accoutInputOutputSdcLogs[_address].push(accoutInputOutputSdcLog(_address,_sdc,_locktime,true,now));
43         return true;
44     }
45     
46     function outSdcForUser(uint256 _sdc) public returns(bool b){
47         for(uint i=0;i<accountInputSdcs[msg.sender].length;i++){
48             if(now >= accountInputSdcs[msg.sender][i].locktime){
49                 unlockSdc[msg.sender] = unlockSdc[msg.sender]+accountInputSdcs[msg.sender][i].sdc;
50                 accountInputSdcs[msg.sender][i] = accountInputSdc(msg.sender,0,999999999999,now);
51             }
52         }
53         require(unlockSdc[msg.sender]>=_sdc);
54         sdcCon.transfer(msg.sender,_sdc);   
55         unlockSdc[msg.sender] = unlockSdc[msg.sender]-_sdc;
56         lockLogs(msg.sender,msg.sender,_sdc,now,false);
57         accountOutputSdcs[msg.sender].push(accountOutputSdc(msg.sender,_sdc,now));
58         accoutInputOutputSdcLogs[msg.sender].push(accoutInputOutputSdcLog(msg.sender,_sdc,999999999999,false,now));
59         return true;
60     }
61 
62    function nowInSeconds() constant public returns (uint){
63         return now;
64     }
65     
66     function getAccountInputSdcslength() constant public returns(uint b){
67         return accountInputSdcs[msg.sender].length;
68     }
69     function getAccountOutputSdcslength() constant public returns(uint b){
70         return accountOutputSdcs[msg.sender].length;
71     }
72     function getLockSdc() constant public returns(uint b){
73         uint tmpLockSdc = 0;
74         for(uint i=0;i<accountInputSdcs[msg.sender].length;i++){
75             if(now < accountInputSdcs[msg.sender][i].locktime){
76                 tmpLockSdc = tmpLockSdc + accountInputSdcs[msg.sender][i].sdc;
77             }
78         }
79         return tmpLockSdc;
80     }
81     function getUnlockSdc() constant public returns(uint b){
82         uint tmpUnlockSdc = unlockSdc[msg.sender];
83         for(uint i=0;i<accountInputSdcs[msg.sender].length;i++){
84             if(now >= accountInputSdcs[msg.sender][i].locktime){
85                 tmpUnlockSdc = tmpUnlockSdc + accountInputSdcs[msg.sender][i].sdc;
86             }
87         }
88         return tmpUnlockSdc;
89     }
90     function insetMoney() public returns(bool b){
91         for(uint i=0;i<accountInputSdcs[msg.sender].length;i++){
92             if(now >= accountInputSdcs[msg.sender][i].locktime){
93                 unlockSdc[msg.sender] = unlockSdc[msg.sender]+accountInputSdcs[msg.sender][i].sdc;
94                 accountInputSdcs[msg.sender][i] = accountInputSdc(msg.sender,0,999999999999,now);
95             }
96         }
97         return true;
98     }
99     
100     function() payable { }
101 }