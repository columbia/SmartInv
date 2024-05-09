1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     using SafeMath for uint256;
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             //balances[msg.sender] -= _value;
19             balances[msg.sender] = balances[msg.sender].sub(_value);
20             //balances[_to] += _value;
21             balances[_to] = balances[_to].add(_value);
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26     
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29             //balances[_to] += _value;
30             balances[_to] =balances[_to].add(_value);
31             //balances[_from] -= _value;
32             balances[_from] =balances[_from].sub(_value);
33             //allowed[_from][msg.sender] -= _value;
34             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
35 
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40     
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     uint256 public totalSupply;
58 }
59 
60 
61 /***
62  *  Contract name
63  * */
64  contract MicroFinanceCoin is StandardToken {
65 
66     function () {
67         throw;
68     }
69     string public name = 'MicroFinance Coin';                  
70     uint8 public decimals = 18;                
71     string public symbol = 'MFC';               
72     string public version = 'V2.0';      
73 
74     function MicroFinanceCoin(
75         ) {
76         balances[msg.sender] = 20000000000000000000000000;
77         totalSupply = 99999997000000000000000000;                      
78         name = "MicroFinance Coin";                                   
79         decimals = 18;                            
80         symbol = "MFC";                              
81     }
82 
83     /* Approves and then calls the receiving contract */
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87 
88         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
89         return true;
90     }
91 }
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
98     uint256 c = a * b; 
99     assert(a == 0 || c / a == b);
100     return c;
101   }
102 
103   function div(uint256 a, uint256 b) internal constant returns (uint256) {
104     uint256 c = a / b;
105     return c;
106   }
107 
108   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint256 a, uint256 b) internal constant returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }