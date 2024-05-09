1 /*
2    Copyright 2016 Nexus Development, LLC
3 
4    Licensed under the Apache License, Version 2.0 (the "License");
5    you may not use this file except in compliance with the License.
6    You may obtain a copy of the License at
7 
8        http://www.apache.org/licenses/LICENSE-2.0
9 
10    Unless required by applicable law or agreed to in writing, software
11    distributed under the License is distributed on an "AS IS" BASIS,
12    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13    See the License for the specific language governing permissions and
14    limitations under the License.
15 */
16 
17 pragma solidity ^0.4.2;
18 
19 // Token standard API
20 // https://github.com/ethereum/EIPs/issues/20
21 
22 contract ERC20Constant {
23     function totalSupply() constant returns (uint supply);
24     function balanceOf( address who ) constant returns (uint value);
25     function allowance(address owner, address spender) constant returns (uint _allowance);
26 }
27 contract ERC20Stateful {
28     function transfer( address to, uint value) returns (bool ok);
29     function transferFrom( address from, address to, uint value) returns (bool ok);
30     function approve(address spender, uint value) returns (bool ok);
31 }
32 contract ERC20Events {
33     event Transfer(address indexed from, address indexed to, uint value);
34     event Approval( address indexed owner, address indexed spender, uint value);
35 }
36 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
37 
38 contract ERC20Base is ERC20
39 {
40     mapping( address => uint ) _balances;
41     mapping( address => mapping( address => uint ) ) _approvals;
42     uint _supply;
43     function ERC20Base( uint initial_balance ) {
44         _balances[msg.sender] = initial_balance;
45         _supply = initial_balance;
46     }
47     function totalSupply() constant returns (uint supply) {
48         return _supply;
49     }
50     function balanceOf( address who ) constant returns (uint value) {
51         return _balances[who];
52     }
53     function transfer( address to, uint value) returns (bool ok) {
54         if( _balances[msg.sender] < value ) {
55             throw;
56         }
57         if( !safeToAdd(_balances[to], value) ) {
58             throw;
59         }
60         _balances[msg.sender] -= value;
61         _balances[to] += value;
62         Transfer( msg.sender, to, value );
63         return true;
64     }
65     function transferFrom( address from, address to, uint value) returns (bool ok) {
66         // if you don't have enough balance, throw
67         if( _balances[from] < value ) {
68             throw;
69         }
70         // if you don't have approval, throw
71         if( _approvals[from][msg.sender] < value ) {
72             throw;
73         }
74         if( !safeToAdd(_balances[to], value) ) {
75             throw;
76         }
77         // transfer and return true
78         _approvals[from][msg.sender] -= value;
79         _balances[from] -= value;
80         _balances[to] += value;
81         Transfer( from, to, value );
82         return true;
83     }
84     function approve(address spender, uint value) returns (bool ok) {
85         _approvals[msg.sender][spender] = value;
86         Approval( msg.sender, spender, value );
87         return true;
88     }
89     function allowance(address owner, address spender) constant returns (uint _allowance) {
90         return _approvals[owner][spender];
91     }
92     function safeToAdd(uint a, uint b) internal returns (bool) {
93         return (a + b >= a);
94     }
95 }
96 
97 contract ReducedToken {
98     function balanceOf(address _owner) returns (uint256);
99     function transfer(address _to, uint256 _value) returns (bool);
100     function migrate(uint256 _value);
101 }
102 
103 contract DepositBrokerInterface {
104     function clear();
105 }
106 
107 contract TokenWrapperInterface is ERC20 {
108     function withdraw(uint amount);
109 
110     // NO deposit, must be done via broker! Sorry!
111     function createBroker() returns (DepositBrokerInterface);
112 
113     // broker contracts only - transfer to a personal broker then use `clear`
114     function notifyDeposit(uint amount);
115 
116     function getBroker(address owner) returns (DepositBrokerInterface);
117 }
118 
119 contract DepositBroker is DepositBrokerInterface {
120     ReducedToken _g;
121     TokenWrapperInterface _w;
122     function DepositBroker( ReducedToken token ) {
123         _w = TokenWrapperInterface(msg.sender);
124         _g = token;
125     }
126     function clear() {
127         var amount = _g.balanceOf(this);
128         _g.transfer(_w, amount);
129         _w.notifyDeposit(amount);
130     }
131 }
132 
133 contract TokenWrapperEvents {
134     event LogBroker(address indexed broker);
135 }
136 
137 // Deposits only accepted via broker!
138 contract TokenWrapper is ERC20Base(0), TokenWrapperInterface, TokenWrapperEvents {
139     ReducedToken _unwrapped;
140     mapping(address=>address) _broker2owner;
141     mapping(address=>address) _owner2broker;
142     function TokenWrapper( ReducedToken unwrapped) {
143         _unwrapped = unwrapped;
144     }
145     function createBroker() returns (DepositBrokerInterface) {
146         DepositBroker broker;
147         if( _owner2broker[msg.sender] == address(0) ) {
148             broker = new DepositBroker(_unwrapped);
149             _broker2owner[broker] = msg.sender;
150             _owner2broker[msg.sender] = broker;
151             LogBroker(broker);
152         }
153         else {
154             broker = DepositBroker(_owner2broker[msg.sender]);
155         }
156         
157         return broker;
158     }
159     function notifyDeposit(uint amount) {
160         var owner = _broker2owner[msg.sender];
161         if( owner == address(0) ) {
162             throw;
163         }
164         _balances[owner] += amount;
165         _supply += amount;
166     }
167     function withdraw(uint amount) {
168         if( _balances[msg.sender] < amount ) {
169             throw;
170         }
171         _balances[msg.sender] -= amount;
172         _supply -= amount;
173         _unwrapped.transfer(msg.sender, amount);
174     }
175     function getBroker(address owner) returns (DepositBrokerInterface) {
176         return DepositBroker(_owner2broker[msg.sender]);
177     }
178 }