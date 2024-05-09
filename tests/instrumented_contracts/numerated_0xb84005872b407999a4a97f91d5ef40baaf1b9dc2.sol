1 pragma solidity ^0.4.4;
2 
3 
4 contract TestToken {
5 
6     string public constant name = "Test Network Token";
7     string public constant symbol = "TNT";
8     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
9 
10     uint256 public constant tokenCreationRate = 1000;
11 
12     // The current total token supply.
13     uint256 totalTokens;
14     
15     address owner;
16     uint256 public startMark;
17     uint256 public endMark;
18 
19     mapping (address => uint256) balances;
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Refund(address indexed _from, uint256 _value);
23         
24     function TestToken(address _owner, uint256 _startMark, uint256 _endMark) {
25         owner = _owner;
26         startMark = _startMark;
27         endMark = _endMark;
28     }
29 
30     // Transfer tokens from sender's account to provided account address.
31     function transfer(address _to, uint256 _value) returns (bool) {
32         var senderBalance = balances[msg.sender];
33         if (senderBalance >= _value && _value > 0) {
34             senderBalance -= _value;
35             balances[msg.sender] = senderBalance;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         }
40 
41         return false;
42     }
43 
44     // Transfer tokens from sender's account to provided account address.
45     function privilegedTransfer(address _from, address _to, uint256 _value) returns (bool) {
46         if (msg.sender != owner) throw;
47     
48         var srcBalance = balances[_from];
49         
50         if (srcBalance >= _value && _value > 0) {
51             srcBalance -= _value;
52             balances[_from] = srcBalance;
53             balances[_to] += _value;
54             Transfer(_from, _to, _value);
55             
56             return true;
57         }
58 
59         return false;
60         
61     }
62 
63     function totalSupply() external constant returns (uint256) {
64         return totalTokens;
65     }
66 
67     function balanceOf(address _owner) external constant returns (uint256) {
68         return balances[_owner];
69     }
70 
71     function fund() payable external {
72         // Do not allow creating 0 tokens.
73         if (msg.value == 0) throw;
74 
75         var numTokens = msg.value * tokenCreationRate;
76 
77         totalTokens += numTokens;
78 
79         // Assign new tokens to the sender
80         balances[msg.sender] += numTokens;
81 
82         // Log token creation event
83         Transfer(0x0, msg.sender, numTokens);
84     }
85 
86     // Test redfunding
87     function refund() external {
88         var tokenValue = balances[msg.sender];
89         if (tokenValue == 0) throw;
90         balances[msg.sender] = 0;
91         totalTokens -= tokenValue;
92 
93         var ethValue = tokenValue / tokenCreationRate;
94         Refund(msg.sender, ethValue);
95 
96         if (!msg.sender.send(ethValue)) throw;
97     }
98     
99     function kill() {
100         if(msg.sender != owner) throw;
101         
102         selfdestruct(msg.sender);
103     }
104 }