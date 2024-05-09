1 /*
2 -----------------------------------------------------------------
3 FILE HEADER
4 -----------------------------------------------------------------
5 
6 file:       TokenState.sol
7 version:    1.0
8 author:     Dominic Romanowski
9             Anton Jurisevic
10 
11 date:       2018-2-24
12 checked:    Anton Jurisevic
13 approved:   Samuel Brooks
14 
15 repo:       https://github.com/Havven/havven
16 commit:     34e66009b98aa18976226c139270970d105045e3
17 
18 -----------------------------------------------------------------
19 CONTRACT DESCRIPTION
20 -----------------------------------------------------------------
21 
22 An Owned contract, to be inherited by other contracts.
23 Requires its owner to be explicitly set in the constructor.
24 Provides an onlyOwner access modifier.
25 
26 To change owner, the current owner must nominate the next owner,
27 who then has to accept the nomination. The nomination can be
28 cancelled before it is accepted by the new owner by having the
29 previous owner change the nomination (setting it to 0).
30 -----------------------------------------------------------------
31 */
32 
33 pragma solidity ^0.4.20;
34 
35 contract Owned {
36     address public owner;
37     address public nominatedOwner;
38 
39     function Owned(address _owner)
40         public
41     {
42         owner = _owner;
43     }
44 
45     function nominateOwner(address _owner)
46         external
47         onlyOwner
48     {
49         nominatedOwner = _owner;
50         emit OwnerNominated(_owner);
51     }
52 
53     function acceptOwnership()
54         external
55     {
56         require(msg.sender == nominatedOwner);
57         emit OwnerChanged(owner, nominatedOwner);
58         owner = nominatedOwner;
59         nominatedOwner = address(0);
60     }
61 
62     modifier onlyOwner
63     {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     event OwnerNominated(address newOwner);
69     event OwnerChanged(address oldOwner, address newOwner);
70 }
71 
72 /*
73 -----------------------------------------------------------------
74 CONTRACT DESCRIPTION
75 -----------------------------------------------------------------
76 
77 A contract that holds the state of an ERC20 compliant token.
78 
79 This contract is used side by side with external state token
80 contracts, such as Havven and EtherNomin.
81 It provides an easy way to upgrade contract logic while
82 maintaining all user balances and allowances. This is designed
83 to to make the changeover as easy as possible, since mappings
84 are not so cheap or straightforward to migrate.
85 
86 The first deployed contract would create this state contract,
87 using it as its store of balances.
88 When a new contract is deployed, it links to the existing
89 state contract, whose owner would then change its associated
90 contract to the new one.
91 
92 -----------------------------------------------------------------
93 */
94 
95 contract TokenState is Owned {
96 
97     // the address of the contract that can modify balances and allowances
98     // this can only be changed by the owner of this contract
99     address public associatedContract;
100 
101     // ERC20 fields.
102     mapping(address => uint) public balanceOf;
103     mapping(address => mapping(address => uint256)) public allowance;
104 
105     function TokenState(address _owner, address _associatedContract)
106         Owned(_owner)
107         public
108     {
109         associatedContract = _associatedContract;
110         emit AssociatedContractUpdated(_associatedContract);
111     }
112 
113     /* ========== SETTERS ========== */
114 
115     // Change the associated contract to a new address
116     function setAssociatedContract(address _associatedContract)
117         external
118         onlyOwner
119     {
120         associatedContract = _associatedContract;
121         emit AssociatedContractUpdated(_associatedContract);
122     }
123 
124     function setAllowance(address tokenOwner, address spender, uint value)
125         external
126         onlyAssociatedContract
127     {
128         allowance[tokenOwner][spender] = value;
129     }
130 
131     function setBalanceOf(address account, uint value)
132         external
133         onlyAssociatedContract
134     {
135         balanceOf[account] = value;
136     }
137 
138 
139     /* ========== MODIFIERS ========== */
140 
141     modifier onlyAssociatedContract
142     {
143         require(msg.sender == associatedContract);
144         _;
145     }
146 
147     /* ========== EVENTS ========== */
148 
149     event AssociatedContractUpdated(address _associatedContract);
150 }
151 
152 /*
153 MIT License
154 
155 Copyright (c) 2018 Havven
156 
157 Permission is hereby granted, free of charge, to any person obtaining a copy
158 of this software and associated documentation files (the "Software"), to deal
159 in the Software without restriction, including without limitation the rights
160 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
161 copies of the Software, and to permit persons to whom the Software is
162 furnished to do so, subject to the following conditions:
163 
164 The above copyright notice and this permission notice shall be included in all
165 copies or substantial portions of the Software.
166 
167 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
168 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
169 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
170 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
171 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
172 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
173 SOFTWARE.
174 */