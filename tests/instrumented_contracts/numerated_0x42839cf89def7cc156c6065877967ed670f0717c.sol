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
19 
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
58 
59 /*
60  * Ownable
61  *
62  * Base contract with an owner.
63  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
64  */
65 
66 contract Ownable {
67     address public owner;
68 
69     function Ownable() {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address newOwner) onlyOwner {
79         if (newOwner != address(0)) {
80             owner = newOwner;
81         }
82     }
83 }
84 
85 
86 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
87 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
88 contract TokenTransferProxy is Ownable {
89 
90     /// @dev Only authorized addresses can invoke functions with this modifier.
91     modifier onlyAuthorized {
92         require(authorized[msg.sender]);
93         _;
94     }
95 
96     modifier targetAuthorized(address target) {
97         require(authorized[target]);
98         _;
99     }
100 
101     modifier targetNotAuthorized(address target) {
102         require(!authorized[target]);
103         _;
104     }
105 
106     mapping (address => bool) public authorized;
107     address[] public authorities;
108 
109     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
110     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
111 
112     function TokenTransferProxy() Ownable() {
113       // This is here for our verification code only
114     }
115 
116     /*
117      * Public functions
118      */
119 
120     /// @dev Authorizes an address.
121     /// @param target Address to authorize.
122     function addAuthorizedAddress(address target)
123         public
124         onlyOwner
125         targetNotAuthorized(target)
126     {
127         authorized[target] = true;
128         authorities.push(target);
129         LogAuthorizedAddressAdded(target, msg.sender);
130     }
131 
132     /// @dev Removes authorizion of an address.
133     /// @param target Address to remove authorization from.
134     function removeAuthorizedAddress(address target)
135         public
136         onlyOwner
137         targetAuthorized(target)
138     {
139         delete authorized[target];
140         for (uint i = 0; i < authorities.length; i++) {
141             if (authorities[i] == target) {
142                 authorities[i] = authorities[authorities.length - 1];
143                 authorities.length -= 1;
144                 break;
145             }
146         }
147         LogAuthorizedAddressRemoved(target, msg.sender);
148     }
149 
150     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
151     /// @param token Address of token to transfer.
152     /// @param from Address to transfer token from.
153     /// @param to Address to transfer token to.
154     /// @param value Amount of token to transfer.
155     /// @return Success of transfer.
156     function transferFrom(
157         address token,
158         address from,
159         address to,
160         uint value)
161         public
162         onlyAuthorized
163         returns (bool)
164     {
165         return Token(token).transferFrom(from, to, value);
166     }
167 
168     /*
169      * Public constant functions
170      */
171 
172     /// @dev Gets all authorized addresses.
173     /// @return Array of authorized addresses.
174     function getAuthorizedAddresses()
175         public
176         constant
177         returns (address[])
178     {
179         return authorities;
180     }
181 }