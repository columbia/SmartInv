1 pragma solidity ^0.4.11;
2 
3 contract Token {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59 }
60 
61 contract HumanStandardToken is StandardToken {
62 
63     string public name;                   //fancy name: eg Simon Bucks
64     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
65     string public symbol;                 //An identifier: eg SBX
66     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
67 
68     function HumanStandardToken(
69         ) {
70         balances[msg.sender] = 150000000000000000000000000;               // Give the creator all initial tokens
71         totalSupply = 150000000000000000000000000;                        // Update total supply
72         name = "BiBaoToken";                                   // Set the name for display purposes
73         decimals = 18;                                        // 默认18位小数
74         symbol = "BBT";                               // Set the symbol for display purposes
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80 
81         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
82         return true;
83     }
84 }