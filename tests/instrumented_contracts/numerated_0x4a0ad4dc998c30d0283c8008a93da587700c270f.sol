1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-01-11
7 */
8 
9 /*
10 
11   Copyright 2017 IOS Foundation LTD
12 
13   Licensed under the Apache License, Version 2.0 (the "License");
14   you may not use this file except in compliance with the License.
15   You may obtain a copy of the License at
16 
17     http://www.apache.org/licenses/LICENSE-2.0
18 
19   Unless required by applicable law or agreed to in writing, software
20   distributed under the License is distributed on an "AS IS" BASIS,
21   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
22   See the License for the specific language governing permissions and
23   limitations under the License.
24 
25 */
26 
27 pragma solidity 0.4.19;
28 
29 contract Token {
30 
31     /// @return total amount of tokens
32     function totalSupply() constant returns (uint supply) {}
33 
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) constant returns (uint balance) {}
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint _value) returns (bool success) {}
43 
44     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45     /// @param _from The address of the sender
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
50 
51     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @param _value The amount of wei to be approved for transfer
54     /// @return Whether the approval was successful or not
55     function approve(address _spender, uint _value) returns (bool success) {}
56 
57     /// @param _owner The address of the account owning tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @return Amount of remaining tokens allowed to spent
60     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
61 
62     event Transfer(address indexed _from, address indexed _to, uint _value);
63     event Approval(address indexed _owner, address indexed _spender, uint _value);
64 }
65 
66 contract RegularToken is Token {
67 
68     function transfer(address _to, uint _value) returns (bool) {
69         //Default assumes totalSupply can't be over max (2^256 - 1).
70         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
71             balances[msg.sender] -= _value;
72             balances[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function transferFrom(address _from, address _to, uint _value) returns (bool) {
79         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
80             balances[_to] += _value;
81             balances[_from] -= _value;
82             allowed[_from][msg.sender] -= _value;
83             Transfer(_from, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function balanceOf(address _owner) constant returns (uint) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint _value) returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint) {
99         return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint) balances;
103     mapping (address => mapping (address => uint)) allowed;
104     uint public totalSupply;
105 }
106 
107 contract UnboundedRegularToken is RegularToken {
108 
109     uint constant MAX_UINT = 2**256 - 1;
110     
111     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
112     /// @param _from Address to transfer from.
113     /// @param _to Address to transfer to.
114     /// @param _value Amount to transfer.
115     /// @return Success of transfer.
116     function transferFrom(address _from, address _to, uint _value)
117         public
118         returns (bool)
119     {
120         uint allowance = allowed[_from][msg.sender];
121         if (balances[_from] >= _value
122             && allowance >= _value
123             && balances[_to] + _value >= balances[_to]
124         ) {
125             balances[_to] += _value;
126             balances[_from] -= _value;
127             if (allowance < MAX_UINT) {
128                 allowed[_from][msg.sender] -= _value;
129             }
130             Transfer(_from, _to, _value);
131             return true;
132         } else {
133             return false;
134         }
135     }
136 }
137 
138 contract CHToken is UnboundedRegularToken {
139 
140     uint public totalSupply = 0.21*10**27;
141     uint8 constant public decimals = 18;
142     string constant public name = "CHAOS HASH token";
143     string constant public symbol = "CHT";
144 
145     function CHToken() {
146         balances[msg.sender] = totalSupply;
147         Transfer(address(0), msg.sender, totalSupply);
148     }
149 }