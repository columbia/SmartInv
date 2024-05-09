1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.13;
4 
5 contract Token {
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
13 
14     function approve(address _spender, uint256 _value) returns (bool success);
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 }
61 
62 contract IPchainStandardToken is StandardToken {
63 
64     function () {
65         //if ether is sent to this address, send it back.
66 		return;
67     }
68 
69     string public version = 'I0.1';       //IPchainToken 0.1 standard. Just an arbitrary versioning scheme.
70     string public name;                   //fancy name: eg Simon Bucks
71     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
72     string public symbol;                 //An identifier: eg SBX
73 
74     function IPchainStandardToken(
75         uint256 initialSupply,
76         string tokenName,
77         uint8 decimalUnits,
78         string tokenSymbol
79         ) {
80         balances[msg.sender] = initialSupply;               // Give the creator all initial tokens
81         totalSupply = initialSupply;                        // Update total supply
82         name = tokenName;                                   // Set the name for display purposes
83         decimals = decimalUnits;                            // Amount of decimals for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     /* Approves and then calls the receiving contract */
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { 
93         		return false;
94         	 }
95         return true;
96     }
97 }