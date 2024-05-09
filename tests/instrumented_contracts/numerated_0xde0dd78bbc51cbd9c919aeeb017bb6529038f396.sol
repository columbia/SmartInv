1 pragma solidity ^0.4.16;
2 
3 contract Token {
4 
5   
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
13 
14     function approve(address _spender, uint256 _value) returns (bool success) {}
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20     
21 }
22 
23 
24 
25 contract StandardToken is Token {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         if (balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
38             balances[_to] += _value;
39             balances[_from] -= _value;
40             allowed[_from][msg.sender] -= _value;
41             Transfer(_from, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function balanceOf(address _owner) constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function approve(address _spender, uint256 _value) returns (bool success) {
51         allowed[msg.sender][_spender] = _value;
52         Approval(msg.sender, _spender, _value);
53         return true;
54     }
55 
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
57       return allowed[_owner][_spender];
58     }
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 }
64 
65 
66 contract ERC20Token is StandardToken {
67 
68     function () {
69         
70         revert();
71     }
72 
73     string public name;                   //optional
74     uint8 public decimals;                //optional
75     string public symbol;                 //Optional
76     string public version = 'H1.0';       //Optional
77 
78 
79 //this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
80 
81     function ERC20Token(
82         ) {
83         balances[msg.sender] = 100000000000000000000000000;               // Initial S.
84         totalSupply = 100000000000000000000000000;                        // total supply 
85         name = "ClinicR";                                   // Set the name 
86         decimals = 18;                            // Amount of decimals 
87         symbol = "CLNR";                               // Symbol
88     }
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93 
94         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
95         return true;
96     }
97 }