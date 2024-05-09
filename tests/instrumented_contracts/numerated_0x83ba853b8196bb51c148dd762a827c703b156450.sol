1 /*
2 
3   Copyright 2018 Dexdex.
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
19 pragma solidity ^0.4.21;
20 
21 
22 /*
23  * Ownable
24  *
25  * Base contract with an owner.
26  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
27  */
28 
29 contract Ownable {
30     address public owner;
31 
32     function Ownable()
33         public
34     {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner)
44         public
45         onlyOwner
46     {
47         if (newOwner != address(0)) {
48             owner = newOwner;
49         }
50     }
51 }
52 
53 library SafeMath {
54     function safeMul(uint a, uint b)
55         internal
56         pure
57         returns (uint256)
58     {
59         uint c = a * b;
60         assert(a == 0 || c / a == b);
61         return c;
62     }
63 
64     function safeDiv(uint a, uint b)
65         internal
66         pure
67         returns (uint256)
68     {
69         uint c = a / b;
70         return c;
71     }
72 
73     function safeSub(uint a, uint b)
74         internal
75         pure
76         returns (uint256)
77     {
78         assert(b <= a);
79         return a - b;
80     }
81 
82     function safeAdd(uint a, uint b)
83         internal
84         pure
85         returns (uint256)
86     {
87         uint c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 
92     function max64(uint64 a, uint64 b)
93         internal
94         pure
95         returns (uint256)
96     {
97         return a >= b ? a : b;
98     }
99 
100     function min64(uint64 a, uint64 b)
101         internal
102         pure
103         returns (uint256)
104     {
105         return a < b ? a : b;
106     }
107 
108     function max256(uint256 a, uint256 b)
109         internal
110         pure
111         returns (uint256)
112     {
113         return a >= b ? a : b;
114     }
115 
116     function min256(uint256 a, uint256 b)
117         internal
118         pure
119         returns (uint256)
120     {
121         return a < b ? a : b;
122     }
123 }
124 
125 contract Members is Ownable {
126 
127   mapping(address => bool) public members; // Mappings of addresses of allowed addresses
128 
129   modifier onlyMembers() {
130     require(isValidMember(msg.sender));
131     _;
132   }
133 
134   /// @dev Check if an address is a valid member.
135   function isValidMember(address _member) public view returns(bool) {
136     return members[_member];
137   }
138 
139   /// @dev Add a valid member address. Only owner.
140   function addMember(address _member) public onlyOwner {
141     members[_member] = true;
142   }
143 
144   /// @dev Remove a member address. Only owner.
145   function removeMember(address _member) public onlyOwner {
146     delete members[_member];
147   }
148 }
149 
150 contract IFeeWallet {
151 
152   function getFee(
153     uint amount) public view returns(uint);
154 
155   function collect(
156     address _affiliate) public payable;
157 }
158 
159 contract FeeWallet is IFeeWallet, Ownable, Members {
160 
161   address public serviceAccount; // Address of service account
162   uint public servicePercentage; // Percentage times (1 ether)
163   uint public affiliatePercentage; // Percentage times (1 ether)
164 
165   mapping (address => uint) public pendingWithdrawals; // Balances
166 
167   function FeeWallet(
168     address _serviceAccount,
169     uint _servicePercentage,
170     uint _affiliatePercentage) public
171   {
172     serviceAccount = _serviceAccount;
173     servicePercentage = _servicePercentage;
174     affiliatePercentage = _affiliatePercentage;
175   }
176 
177   /// @dev Set the new service account. Only owner.
178   function changeServiceAccount(address _serviceAccount) public onlyOwner {
179     serviceAccount = _serviceAccount;
180   }
181 
182   /// @dev Set the service percentage. Only owner.
183   function changeServicePercentage(uint _servicePercentage) public onlyOwner {
184     servicePercentage = _servicePercentage;
185   }
186 
187   /// @dev Set the affiliate percentage. Only owner.
188   function changeAffiliatePercentage(uint _affiliatePercentage) public onlyOwner {
189     affiliatePercentage = _affiliatePercentage;
190   }
191 
192   /// @dev Calculates the service fee for a specific amount. Only owner.
193   function getFee(uint amount) public view returns(uint)  {
194     return SafeMath.safeMul(amount, servicePercentage) / (1 ether);
195   }
196 
197   /// @dev Calculates the affiliate amount for a specific amount. Only owner.
198   function getAffiliateAmount(uint amount) public view returns(uint)  {
199     return SafeMath.safeMul(amount, affiliatePercentage) / (1 ether);
200   }
201 
202   /// @dev Collects fees according to last payment receivedi. Only valid smart contracts.
203   function collect(
204     address _affiliate) public payable onlyMembers
205   {
206     if(_affiliate == address(0))
207       pendingWithdrawals[serviceAccount] += msg.value;
208     else {
209       uint affiliateAmount = getAffiliateAmount(msg.value);
210       pendingWithdrawals[_affiliate] += affiliateAmount;
211       pendingWithdrawals[serviceAccount] += SafeMath.safeSub(msg.value, affiliateAmount);
212     }
213   }
214 
215   /// @dev Withdraw.
216   function withdraw() public {
217     uint amount = pendingWithdrawals[msg.sender];
218     pendingWithdrawals[msg.sender] = 0;
219     msg.sender.transfer(amount);
220   }
221 }