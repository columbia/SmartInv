1 pragma solidity ^0.4.13;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15   
16     function transfer(address _to, uint256 _value) returns (bool success) {
17       if (balances[msg.sender] >= _value && _value > 0) {
18         balances[msg.sender] -= _value;
19         balances[_to] += _value;
20         Transfer(msg.sender, _to, _value);
21         return true;
22       } else {
23         return false;
24       }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29         balances[_to] += _value;
30         balances[_from] -= _value;
31         allowed[_from][msg.sender] -= _value;
32         Transfer(_from, _to, _value);
33         return true;
34       } else {
35         return false;
36       }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55 }
56 
57 contract TokenSafe {
58   mapping (uint256 => uint256) allocations;
59   mapping (address => bool) isAddressInclude;
60   uint256 public unlockTimeLine;
61   uint256 public constant firstTimeLine = 1514044800;
62   uint256 public constant secondTimeLine = 1521820800;
63   uint256 public constant thirdTimeLine = 1529769600;
64   address public originalContract;
65   uint256 public constant exponent = 10**8;
66   uint256 public constant limitAmount = 1500000000*exponent;
67   uint256 public balance = 1500000000*exponent;
68   
69 
70   function TokenSafe(address _originalContract) {
71     originalContract = _originalContract;
72     //init amount available for 1,3,6th month
73     //33.3%
74     allocations[1] = 333;
75     //66.6%
76     allocations[2] = 666;
77     //100%
78     allocations[3] = 1000;
79     
80     isAddressInclude[0xd3d45cd6210f9fa061a46406b5472d76a43dafd5] = true;
81     isAddressInclude[0xb94a75e6fd07bfba543930a500e1648c2e8c9622] = true;
82     isAddressInclude[0x59c582aefb682e0f32c9274a6cd1c2aa45353a1f] = true;
83   }
84 
85   function unlock() external{
86     require(now > firstTimeLine); //prevent untimely call
87     require(isAddressInclude[msg.sender] == true); //prevent address unauthorized
88     
89     if(now >= firstTimeLine){
90         unlockTimeLine = 1;
91     }
92     if(now >= secondTimeLine){
93         unlockTimeLine = 2;
94     }
95     if (now >= thirdTimeLine){
96         unlockTimeLine = 3;
97     }
98     
99     uint256 balanceShouldRest = limitAmount - limitAmount * allocations[unlockTimeLine] / 1000;
100     uint256 canWithdrawAmount = balance - balanceShouldRest;
101     
102     require(canWithdrawAmount > 0);
103     
104     if (!StandardToken(originalContract).transfer(msg.sender, canWithdrawAmount )){
105         //failed
106         revert();
107     }
108     
109     //success
110     balance = balance - canWithdrawAmount;
111     
112   }
113 
114 }