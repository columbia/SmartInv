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
58 /*
59  * Ownable
60  *
61  * Base contract with an owner.
62  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
63  */
64 
65 contract Ownable {
66     address public owner;
67 
68     function Ownable() {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address newOwner) onlyOwner {
78         if (newOwner != address(0)) {
79             owner = newOwner;
80         }
81     }
82 }
83 
84 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
85 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
86 contract TokenTransferProxy is Ownable {
87 
88     /// @dev Only authorized addresses can invoke functions with this modifier.
89     modifier onlyAuthorized {
90         require(authorized[msg.sender]);
91         _;
92     }
93 
94     modifier targetAuthorized(address target) {
95         require(authorized[target]);
96         _;
97     }
98 
99     modifier targetNotAuthorized(address target) {
100         require(!authorized[target]);
101         _;
102     }
103 
104     mapping (address => bool) public authorized;
105     address[] public authorities;
106 
107     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
108     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
109 
110     /*
111      * Public functions
112      */
113 
114     /// @dev Authorizes an address.
115     /// @param target Address to authorize.
116     function addAuthorizedAddress(address target)
117         public
118         onlyOwner
119         targetNotAuthorized(target)
120     {
121         authorized[target] = true;
122         authorities.push(target);
123         LogAuthorizedAddressAdded(target, msg.sender);
124     }
125 
126     /// @dev Removes authorizion of an address.
127     /// @param target Address to remove authorization from.
128     function removeAuthorizedAddress(address target)
129         public
130         onlyOwner
131         targetAuthorized(target)
132     {
133         delete authorized[target];
134         for (uint i = 0; i < authorities.length; i++) {
135             if (authorities[i] == target) {
136                 authorities[i] = authorities[authorities.length - 1];
137                 authorities.length -= 1;
138                 break;
139             }
140         }
141         LogAuthorizedAddressRemoved(target, msg.sender);
142     }
143 
144     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
145     /// @param token Address of token to transfer.
146     /// @param from Address to transfer token from.
147     /// @param to Address to transfer token to.
148     /// @param value Amount of token to transfer.
149     /// @return Success of transfer.
150     function transferFrom(
151         address token,
152         address from,
153         address to,
154         uint value)
155         public
156         onlyAuthorized
157         returns (bool)
158     {
159         return Token(token).transferFrom(from, to, value);
160     }
161 
162     /*
163      * Public constant functions
164      */
165 
166     /// @dev Gets all authorized addresses.
167     /// @return Array of authorized addresses.
168     function getAuthorizedAddresses()
169         public
170         constant
171         returns (address[])
172     {
173         return authorities;
174     }
175 }