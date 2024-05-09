1 /* 
2 @INATOKEN DEVELOPMENT TEAM
3 @COPYRIGHT 2018
4  */
5  
6  pragma solidity ^0.4.4;
7 
8 contract Token {
9     function totalSupply() constant returns (uint256 supply) {}
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 contract ERC20Token is Token {
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32       
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     uint256 public totalSupply;
59 }
60 
61 
62 contract INAToken is ERC20Token {
63     uint price = 0.0000000000000005 ether;
64     address owner = msg.sender;
65     string public name;                   
66     uint8 public decimals;                
67     string public symbol;                
68     string public version = 'H0.1';       
69     
70 
71   function() public payable {
72     require( msg.value > 0 );
73     uint toMint = msg.value/price;
74     balances[msg.sender] += toMint;
75     balances[owner] -= toMint;
76     emit Transfer(0, msg.sender, toMint);
77     withdraw();
78    }
79    
80    function withdraw() public {
81     address myAddress = this;
82     uint256 etherBalance = myAddress.balance;
83     owner.transfer(etherBalance);
84 }
85 
86     function INAToken(
87          ) {
88         balances[msg.sender] = 50000000000e8;               
89         totalSupply = 50000000000e8;                      
90         name = "INATOKEN";                                   
91         decimals = 8;                            
92         symbol = "INA";                               
93     }
94 
95    
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
100         return true;
101     }
102 }