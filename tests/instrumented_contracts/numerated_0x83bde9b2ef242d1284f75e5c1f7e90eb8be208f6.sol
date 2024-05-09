1 /*
2 
3  Copyright 2018 LuckChain Foundation LTD
4 
5  Licensed under the Apache License, Version 2.0 (the "License");
6  you may not use this file except in compliance with the License.
7  You may obtain a copy of the License at
8 
9  http://www.apache.org/licenses/LICENSE-2.0
10 
11  */
12 
13 pragma solidity 0.4.19;
14 
15 contract ERC20 {
16 
17     /// @return total amount of tokens
18     function totalSupply() constant returns (uint supply) {}
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) constant returns (uint balance) {}
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint _value) returns (bool success) {}
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint _value) returns (bool success) {}
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint _value);
49     event Approval(address indexed _owner, address indexed _spender, uint _value);
50 }
51 
52 contract TokenBase is ERC20 {
53 
54     function transfer(address _to, uint _value) returns (bool) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
57             balances[msg.sender] -= _value;
58             balances[_to] += _value;
59             Transfer(msg.sender, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function transferFrom(address _from, address _to, uint _value) returns (bool) {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint _value) returns (bool) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint) {
85         return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint) balances;
89     mapping (address => mapping (address => uint)) allowed;
90     uint public totalSupply;
91 }
92 
93 contract RegularToken is TokenBase {
94 
95     uint constant MAX_UINT = 2**256 - 1;
96 
97     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
98     /// @param _from Address to transfer from.
99     /// @param _to Address to transfer to.
100     /// @param _value Amount to transfer.
101     /// @return Success of transfer.
102     function transferFrom(address _from, address _to, uint _value)
103     public
104     returns (bool)
105     {
106         uint allowance = allowed[_from][msg.sender];
107         if (balances[_from] >= _value
108             && allowance >= _value
109             && balances[_to] + _value >= balances[_to]
110         ) {
111             balances[_to] += _value;
112             balances[_from] -= _value;
113             if (allowance < MAX_UINT) {
114                 allowed[_from][msg.sender] -= _value;
115             }
116             Transfer(_from, _to, _value);
117             return true;
118         } else {
119             return false;
120         }
121     }
122 }
123 
124 contract LuckChain is RegularToken {
125 
126     uint public totalSupply = 21*10**26;
127     uint8 constant public decimals = 18;
128     string constant public name = "LuckChain";
129     string constant public symbol = "LUCK";
130 
131     function LuckChain() {
132         balances[msg.sender] = totalSupply;
133         Transfer(address(0), msg.sender, totalSupply);
134     }
135 }