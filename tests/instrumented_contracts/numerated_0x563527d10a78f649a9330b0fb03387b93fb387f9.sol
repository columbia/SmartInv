1 pragma solidity ^0.4.0;
2 
3 contract Vionex {
4     
5     uint public constant _totalSupply = 10000000000000000;
6     
7     string public constant symbol = "VIOX";
8     string public constant name = "Vionex";
9     uint8 public constant decimals = 8;
10     
11     mapping(address => uint)balances;
12     mapping(address => mapping(address => uint)) approved;
13     
14     
15     uint supply;
16     
17     
18     //ERC20
19     
20     function Vionex() {
21         balances[msg.sender] = _totalSupply;
22     }
23     
24     function totalSupply() constant returns (uint totalSupply){
25         return supply;
26     }
27     
28     function balanceOf(address _owner) constant returns (uint balance){
29         return balances[_owner];
30     }
31     
32     function transfer(address _to, uint _value) returns (bool success){
33         
34         if(balances[msg.sender]>=_value && _value > 0){
35             
36             balances[msg.sender]-= _value;
37             balances[_to] += _value;
38             
39             // successful transaction
40             return true;
41         }
42         else{
43             // failed transaction
44             return false;
45         }
46     }
47     
48     
49     function approve(address _spender, uint _value) returns (bool success){
50         
51         if(balances[msg.sender]>=_value){
52             approved[msg.sender][_spender] = _value;
53             return true;
54         }
55         
56         return false;
57         
58     }
59     
60     function allowance(address _owner, address _spender) constant returns (uint remaining){
61         
62         return approved[_owner][_spender];
63         
64     }
65     
66     
67     function transferFrom(address _from, address _to, uint _value) returns (bool success){
68         
69         if(balances[_from]>=_value &&
70             approved[_from][msg.sender]>=_value &&
71             _value > 0){
72                
73                
74                 balances[_from] -= _value;
75                 approved[_from][msg.sender] -= _value;
76                 balances[_to] += _value;
77                 
78                 return true;
79             
80         }
81         else{
82             return false;
83         }
84     
85         
86     }
87     
88     // our own
89     function mint (uint numberOfCoins){
90         balances[msg.sender] += numberOfCoins;
91         supply += numberOfCoins;
92     }
93     
94     function getMyBalance() returns (uint){
95         return balances[msg.sender];
96     }
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100     
101 }