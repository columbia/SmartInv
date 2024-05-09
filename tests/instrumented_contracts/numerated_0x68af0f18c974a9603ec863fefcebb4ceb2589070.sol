1 pragma solidity ^0.4.24;
2 
3 contract PIGGYBANK
4 {
5     
6     bytes32 hashPwd;
7     
8     bool isclosed = false;
9     
10     uint cashOutTime;
11     
12     address sender;
13     
14     address myadress;
15  
16     
17     
18     function CashOut(bytes pass) external payable
19     {
20         if(hashPwd == keccak256(pass) && now>cashOutTime)
21         {
22             msg.sender.transfer(this.balance);
23         }
24     }
25     
26     function CashOut() public payable
27     {
28         if(msg.sender==myadress && now>cashOutTime)
29         {
30             msg.sender.transfer(this.balance);
31         }
32     }
33     
34     
35 
36  
37     function DebugHash(bytes pass) public pure returns (bytes32) {return keccak256(pass);}
38     
39     function SetPwd(bytes32 hash) public payable
40     {
41         if( (!isclosed&&(msg.value>1 ether)) || hashPwd==0x00)
42         {
43             hashPwd = hash;
44             sender = msg.sender;
45             cashOutTime = now;
46         }
47     }
48     
49     function SetcashOutTime(uint date) public
50     {
51         if(msg.sender==sender)
52         {
53             cashOutTime = date;
54         }
55     }
56     
57     function Setmyadress(address _myadress) public
58     {
59         if(msg.sender==sender)
60         {
61             myadress = _myadress;
62         }
63     }
64     
65     function PwdHasBeenSet(bytes32 hash) public
66     {
67         if(hash==hashPwd&&msg.sender==sender)
68         {
69            isclosed=true;
70         }
71     }
72     
73     function() public payable{}
74     
75 }