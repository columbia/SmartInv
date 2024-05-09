1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() public constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) public constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) public returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract StandardToken is Token {
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24   
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34   
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) public constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     uint256 public totalSupply;
61 }
62 
63 contract PlendsToken is StandardToken {
64 
65     function () public {
66 
67         throw;
68     }
69 
70     string public name;                   
71     uint8 public decimals;                
72     string public symbol;                 
73     string public version = 'H1.0';       
74 
75     function PlendsToken() public {
76         balances[msg.sender] = 800000000;               
77         totalSupply = 800000000;                        
78         name = "PlendsToken";                      
79         decimals = 0;                              
80         symbol = "PLNS";                           
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86 
87         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
88         return true;
89     }
90 }