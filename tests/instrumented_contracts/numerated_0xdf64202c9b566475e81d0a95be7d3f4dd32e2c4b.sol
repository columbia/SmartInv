1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.11;
20 
21 contract Token {
22 
23     /// @return total amount of tokens
24     function totalSupply() constant returns (uint supply) {}
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint balance) {}
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint _value) returns (bool success) {}
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint _value) returns (bool success) {}
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
53 
54     event Transfer(address indexed _from, address indexed _to, uint _value);
55     event Approval(address indexed _owner, address indexed _spender, uint _value);
56 }
57 
58 contract StandardToken is Token {
59 
60     function transfer(address _to, uint _value) returns (bool) {
61         //Default assumes totalSupply can't be over max (2^256 - 1).
62         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint _value) returns (bool) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint _value) returns (bool) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint) {
91         return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint) balances;
95     mapping (address => mapping (address => uint)) allowed;
96     uint public totalSupply;
97 }
98 
99 contract UnlimitedAllowanceToken is StandardToken {
100 
101     uint constant MAX_UINT = 200000000;
102     
103     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
104     /// @param _from Address to transfer from.
105     /// @param _to Address to transfer to.
106     /// @param _value Amount to transfer.
107     /// @return Success of transfer.
108     function transferFrom(address _from, address _to, uint _value)
109         public
110         returns (bool)
111     {
112         uint allowance = allowed[_from][msg.sender];
113         if (balances[_from] >= _value
114             && allowance >= _value
115             && balances[_to] + _value >= balances[_to]
116         ) {
117             balances[_to] += _value;
118             balances[_from] -= _value;
119             if (allowance < MAX_UINT) {
120                 allowed[_from][msg.sender] -= _value;
121             }
122             Transfer(_from, _to, _value);
123             return true;
124         } else {
125             return false;
126         }
127     }
128 }
129 
130 contract ArabToken is UnlimitedAllowanceToken {
131 
132     uint8 constant public decimals = 2;
133     uint public totalSupply = 200000000; // 2 million tokens, 2 decimal places
134     string constant public name = "ArabToken";
135     string constant public symbol = "ARBT";
136 
137     function ArabToken() {
138         balances[msg.sender] = totalSupply;
139     }
140 }