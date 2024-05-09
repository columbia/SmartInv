1 pragma solidity ^0.4.18;
2 
3 contract ParentContract
4 {
5      function totalSupply() constant returns(uint256 supply)
6      {
7 
8      }
9      function balanceOf(address _owner) constant returns(uint256 balance)
10      {
11 
12      }
13      function transfer(address _to,uint256 _value) constant  
14 returns(bool success)
15      {
16 
17      }
18      function transferFrom(address _from,address _to,uint256 _value)  
19 constant returns(bool success)
20      {
21 
22      }
23      function approve(address _spender,uint256 _value) constant  
24 returns(bool success)
25      {
26 
27      }
28      function allowance(address _owner,address _spender) constant  
29 returns(uint256 remaining)
30      {
31 
32      }
33      event Transfer(address indexed _from,address indexed _to,uint256 _value);
34      event Approval(address indexed _owner,address indexed  
35 _spender,uint256 _value);
36 }
37 
38 contract ChildContract is ParentContract
39 {
40      mapping (address => uint256 )balances;
41      mapping (address => mapping (address => uint256 ))allowed;
42      uint256 public totalSupply;
43      function transfer(address _to,uint256 _value) constant  
44 returns(bool success)
45      {
46          if(balances[msg.sender]>=_value && _value>0)
47          {
48              balances[msg.sender]-=_value;
49              balances[_to]+=_value;
50              Transfer(msg.sender,_to,_value);
51              return true;
52          }else{
53              return false;
54              }
55      }
56 
57      function transferFrom(address _from,address _to,uint256 _value)  
58 constant returns(bool success)
59      {
60          if(balances[_from]>=_value &&  
61 allowed[_from][msg.sender]>=_value && _value>0)
62          {
63              balances[_from]-=_value;
64              balances[_to]+=_value;
65              allowed[_from][msg.sender] -=_value;
66              Transfer(_from,_to,_value);
67              return true;
68          }else{
69              return false;
70              }
71      }
72      function balanceOf(address _owner) constant returns(uint256 balance)
73      {
74          return balances[_owner];
75      }
76      function approve(address _spender,uint256 _value) constant  
77 returns(bool success)
78      {
79        allowed[msg.sender][_spender] -=_value;
80        Approval(msg.sender,_spender,_value);
81        return true;
82      }
83      function allowance(address _owner,address _spender) constant  
84 returns(uint256 remaining)
85      {
86          return allowed[_owner][_spender];
87      }
88 }
89 contract GenerateTokenContract is ChildContract
90 {
91      string public name;
92      uint8 public decimals;
93      string public symbol;
94      string public version="HFS.1.0";
95      uint256 public unitsOneEthCanBuy;
96      uint256 public totalEthInWei;
97      address public fundsWallet;
98 
99      function GenerateTokenContract()
100      {
101          balances[msg.sender]=800000000000000000000000000;
102          totalSupply=800000000000000000000000000;
103          name="HASH FOREX SINGAPORE";
104          decimals=18;
105          symbol="HFS";
106          unitsOneEthCanBuy=11150;
107          fundsWallet=msg.sender;
108      }
109      function () payable
110      {
111          totalEthInWei=totalEthInWei+msg.value;
112          uint256 amount=msg.value*unitsOneEthCanBuy;
113          if(balances[fundsWallet]<amount)
114          {
115              return;
116          }
117          balances[fundsWallet]=balances[fundsWallet]-amount;
118          balances[msg.sender]=balances[msg.sender]+amount;
119          Transfer(fundsWallet,msg.sender,amount);
120          fundsWallet.transfer(msg.value);
121      }
122 
123      function approveAndCall(address _spender,uint256 _value,bytes  
124 _extraData)returns(bool success)
125      {
126          allowed[msg.sender][_spender]=_value;
127          Approval(msg.sender,_spender,_value);
128           
129 if(!_spender.call(bytes4(bytes32(sha3("reciveApproval(address,uint256,address,bytes)"))),msg.sender,_value,this,_extraData))
130          {
131              throw;
132          }
133          return true;
134      }
135 }