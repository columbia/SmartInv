1 pragma solidity ^0.4.12;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract StandardToken is Token {
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {
18      
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28 
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             Transfer(_from, _to, _value);
34             return true;
35         } else { return false; }
36     }
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41 
42     function approve(address _spender, uint256 _value) returns (bool success) {
43         allowed[msg.sender][_spender] = _value;
44         Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     uint256 public totalSupply;
55 }
56 
57 contract MCTOKEN is StandardToken {
58 
59     function () {
60         throw;
61     }
62 
63 
64     string public name;                   //fancy name: eg Simon Bucks
65     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
66     string public symbol;                 //An identifier: eg SBX
67     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
68 
69 
70     function MCTOKEN(
71         ) {
72         balances[msg.sender] = 40000000000000000;               // Give the creator all initial tokens (100000 for example)
73         totalSupply = 40000000000000000;                        // Update total supply (100000 for example)
74         name = "Minecraft Token";                                   // Set the name for display purposes
75         decimals = 8;                            // Amount of decimals for display purposes
76         symbol = "MCⓉ";                               // Set the symbol for display purposes
77     }
78 
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82 
83         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
84         return true;
85     }
86 }