1 pragma solidity ^0.4.4;
2 
3 // mainnet: 0x629bfba9fd3d71cfe883bbb625c865072e301805
4 
5 contract ERC223Token {
6   function transfer(address _from, uint _value, bytes _data) public;
7 }
8 
9 contract Operations {
10 
11   mapping (address => uint) public balances;
12   mapping (address => bytes32) public activeCall;
13 
14   // remember who was call recipient based on callHash
15   mapping (bytes32 => address) public recipientsMap;
16 
17   mapping (address => uint) public endCallRequestDate;
18 
19   uint endCallRequestDelay = 1 hours;
20 
21   ERC223Token public exy;
22 
23   function Operations() public {
24     exy = ERC223Token(0xFA74F89A6d4a918167C51132614BbBE193Ee8c22);
25   }
26 
27   // falback for EXY deposits
28   function tokenFallback(address _from, uint _value, bytes _data) public {
29     balances[_from] += _value;
30   }
31 
32   function withdraw(uint value) public {
33     // dont allow to withdraw any balance if user have active call
34     require(activeCall[msg.sender] == 0x0);
35 
36     uint balance = balances[msg.sender];
37 
38     // requested value cant be greater than balance
39     require(value <= balance);
40 
41     balances[msg.sender] -= value;
42     bytes memory empty;
43     exy.transfer(msg.sender, value, empty);
44   }
45 
46   function startCall(uint timestamp, uint8 _v, bytes32 _r, bytes32 _s) public {
47     // address caller == ecrecover(...)
48     address recipient = msg.sender;
49     bytes32 callHash = keccak256('Experty.io startCall:', recipient, timestamp);
50     address caller = ecrecover(callHash, _v, _r, _s);
51 
52     // caller cant start more than 1 call
53     require(activeCall[caller] == 0x0);
54 
55     // save callHash for this caller
56     activeCall[caller] = callHash;
57     recipientsMap[callHash] = recipient;
58 
59     // clean endCallRequestDate for this address
60     // if it was set before
61     endCallRequestDate[caller] = 0;
62   }
63 
64   function endCall(bytes32 callHash, uint amount, uint8 _v, bytes32 _r, bytes32 _s) public {
65     // get recipient from map using callHash
66     address recipient = recipientsMap[callHash];
67 
68     // only recipient can push this transaction
69     require(recipient == msg.sender);
70 
71     bytes32 endHash = keccak256('Experty.io endCall:', recipient, callHash, amount);
72     address caller = ecrecover(endHash, _v, _r, _s);
73 
74     // check if call hash was created by caller
75     require(activeCall[caller] == callHash);
76 
77     uint maxAmount = amount;
78     if (maxAmount > balances[caller]) {
79       maxAmount = balances[caller];
80     }
81 
82     // remove recipient address from map
83     recipientsMap[callHash] = 0x0;
84     // clean callHash from caller map
85     activeCall[caller] = 0x0;
86 
87     settlePayment(caller, msg.sender, maxAmount);
88   }
89 
90   // end call can be requested by caller
91   // if recipient did not published it
92   function requestEndCall() public {
93     // only caller can request end his call
94     require(activeCall[msg.sender] != 0x0);
95 
96     // save current timestamp
97     endCallRequestDate[msg.sender] = block.timestamp;
98   }
99 
100   // endCall can be called by caller only if he requested
101   // endCall more than endCallRequestDelay ago
102   function forceEndCall() public {
103     // only caller can request end his call
104     require(activeCall[msg.sender] != 0x0);
105     // endCallRequestDate needs to be set
106     require(endCallRequestDate[msg.sender] != 0);
107     require(endCallRequestDate[msg.sender] + endCallRequestDelay < block.timestamp);
108 
109     endCallRequestDate[msg.sender] = 0;
110 
111     // remove recipient address from map
112     recipientsMap[activeCall[msg.sender]] = 0x0;
113     // clean callHash from caller map
114     activeCall[msg.sender] = 0x0;
115   }
116 
117   function settlePayment(address sender, address recipient, uint value) private {
118     balances[sender] -= value;
119     balances[recipient] += value;
120   }
121 
122 }