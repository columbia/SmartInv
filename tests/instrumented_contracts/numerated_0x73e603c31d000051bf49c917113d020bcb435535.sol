1 pragma solidity ^0.4.4;
2 
3 contract ERC20Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 
22 contract Token is ERC20Token {
23 
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;
26     uint256 public totalSupply;
27 
28     function transfer(address _to, uint256 _value) returns (bool success) {
29             if (balances[msg.sender] >= _value && _value > 0) {
30                 balances[msg.sender] -= _value;
31                 balances[_to] += _value;
32                 Transfer(msg.sender, _to, _value);
33                 return true;
34             } else { return false; }
35         }
36 
37 
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
40                 balances[_to] += _value;
41                 balances[_from] -= _value;
42                 allowed[_from][msg.sender] -= _value;
43                 Transfer(_from, _to, _value);
44                 return true;
45             } else { return false; }
46         }
47 
48 
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50           return balances[_owner];
51       }
52 
53 
54       function approve(address _spender, uint256 _value) returns (bool success) {
55               allowed[msg.sender][_spender] = _value;
56               Approval(msg.sender, _spender, _value);
57               return true;
58           }
59 
60       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61               return allowed[_owner][_spender];
62           } // end of Token contract
63 
64 }
65 
66 
67 contract BitTeamToken is Token {
68 
69     function () {
70         //if ether is sent to this address, send it back.
71         throw;
72     }
73 
74     string public name;
75     uint8 public decimals;
76     string public symbol;
77 
78     function BitTeamToken() {
79         balances[msg.sender] = 100000000;    // creator gets all initial tokens
80         totalSupply = 100000000;             // total supply of token
81         name = "BIT TEAM TOKEN";               // name of token
82         decimals = 0;                  // amount of decimals
83         symbol = "BTT";                // symbol of token
84     }
85 
86     /* Approves and then calls the receiving contract */
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90 
91         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
92         return true;
93     }
94 }