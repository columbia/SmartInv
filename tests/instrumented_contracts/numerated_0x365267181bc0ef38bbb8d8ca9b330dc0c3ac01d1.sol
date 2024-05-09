1 /* version metahash ETH multi sign wallet 0.1.5 RC */
2 pragma solidity ^0.4.18;
3 
4 contract mhethkeeper {
5 
6     /* contract settings */
7 
8     /* dynamic data section */
9     address public recipient;           /* recipient */
10     uint256 public amountToTransfer;        /* quantity */
11 
12 
13     /* static data section */
14     bool public isFinalized;            /* settings are finalized */
15     uint public minVotes;               /* minimum amount of votes */
16     uint public curVotes;               /* current amount of votes */
17     address public owner;               /* contract creator */
18     uint public mgrCount;               /* number of managers */
19     mapping (uint => bool) public mgrVotes;     /* managers votes */
20     mapping (uint => address) public mgrAddress; /* managers address */
21 
22     /* constructor */
23     function mhethkeeper() public{
24         owner = msg.sender;
25         isFinalized = false;
26         curVotes = 0;
27         mgrCount = 0;
28         minVotes = 2;
29     }
30 
31     /* add a wallet manager */
32     function AddManager(address _manager) public{
33         if (!isFinalized && (msg.sender == owner)){
34             mgrCount = mgrCount + 1;
35             mgrAddress[mgrCount] = _manager;
36             mgrVotes[mgrCount] = false;
37         } else {
38             revert();
39         }
40     }
41 
42     /* finalize settings */
43     function Finalize() public{
44         if (!isFinalized && (msg.sender == owner)){
45             isFinalized = true;
46         } else {
47             revert();
48         }
49     }
50 
51     /* set a new action and set a value of zero on a vote */
52     function SetAction(address _recipient, uint256 _amountToTransfer) public{
53         if (!isFinalized){
54             revert();
55         }
56 
57         if (IsManager(msg.sender)){
58             if (this.balance < _amountToTransfer){
59                 revert();
60             }
61             recipient = _recipient;
62             amountToTransfer = _amountToTransfer;
63             
64             for (uint i = 1; i <= mgrCount; i++) {
65                 mgrVotes[i] = false;
66             }
67             curVotes = 0;
68         } else {
69             revert();
70         }
71     }
72 
73     /* manager votes for the action */
74     function Approve(address _recipient, uint256 _amountToTransfer) public{
75         if (!isFinalized){
76             revert();
77         }
78         if (!((recipient == _recipient) && (amountToTransfer == _amountToTransfer))){
79             revert();
80         }
81 
82         for (uint i = 1; i <= mgrCount; i++) {
83             if (mgrAddress[i] == msg.sender){
84                 if (!mgrVotes[i]){
85                     mgrVotes[i] = true;
86                     curVotes = curVotes + 1;
87 
88                     if (curVotes >= minVotes){
89                         recipient.transfer(amountToTransfer);
90                         NullSettings();
91                     } 
92                 } else {
93                     revert();
94                 }
95             }
96         }
97     }
98 
99     /* set a default payable function */
100     function () public payable {}
101     
102     /* set default empty settings  */
103     function NullSettings() private{
104         recipient = address(0x0);
105         amountToTransfer = 0;
106         curVotes = 0;
107         for (uint i = 1; i <= mgrCount; i++) {
108             mgrVotes[i] = false;
109         }
110 
111     }
112 
113     /* check that the sender is a manager */
114     function IsManager(address _manager) private view returns(bool){
115         for (uint i = 1; i <= mgrCount; i++) {
116             if (mgrAddress[i] == _manager){
117                 return true;
118             }
119         }
120         return false;
121     }
122 }