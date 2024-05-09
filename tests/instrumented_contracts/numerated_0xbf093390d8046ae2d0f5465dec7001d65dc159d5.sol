1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       Owned.sol
15 version:    1.1
16 author:     Anton Jurisevic
17             Dominic Romanowski
18 
19 date:       2018-2-26
20 
21 -----------------------------------------------------------------
22 MODULE DESCRIPTION
23 -----------------------------------------------------------------
24 
25 An Owned contract, to be inherited by other contracts.
26 Requires its owner to be explicitly set in the constructor.
27 Provides an onlyOwner access modifier.
28 
29 To change owner, the current owner must nominate the next owner,
30 who then has to accept the nomination. The nomination can be
31 cancelled before it is accepted by the new owner by having the
32 previous owner change the nomination (setting it to 0).
33 
34 -----------------------------------------------------------------
35 */
36 
37 pragma solidity 0.4.25;
38 
39 /**
40  * @title A contract with an owner.
41  * @notice Contract ownership can be transferred by first nominating the new owner,
42  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
43  */
44 contract Owned {
45     address public owner;
46     address public nominatedOwner;
47 
48     /**
49      * @dev Owned Constructor
50      */
51     constructor(address _owner)
52         public
53     {
54         require(_owner != address(0), "Owner address cannot be 0");
55         owner = _owner;
56         emit OwnerChanged(address(0), _owner);
57     }
58 
59     /**
60      * @notice Nominate a new owner of this contract.
61      * @dev Only the current owner may nominate a new owner.
62      */
63     function nominateNewOwner(address _owner)
64         external
65         onlyOwner
66     {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     /**
72      * @notice Accept the nomination to be owner.
73      */
74     function acceptOwnership()
75         external
76     {
77         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
78         emit OwnerChanged(owner, nominatedOwner);
79         owner = nominatedOwner;
80         nominatedOwner = address(0);
81     }
82 
83     modifier onlyOwner
84     {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 /*
94 -----------------------------------------------------------------
95 FILE INFORMATION
96 -----------------------------------------------------------------
97 
98 file:       State.sol
99 version:    1.1
100 author:     Dominic Romanowski
101             Anton Jurisevic
102 
103 date:       2018-05-15
104 
105 -----------------------------------------------------------------
106 MODULE DESCRIPTION
107 -----------------------------------------------------------------
108 
109 This contract is used side by side with external state token
110 contracts, such as Synthetix and Synth.
111 It provides an easy way to upgrade contract logic while
112 maintaining all user balances and allowances. This is designed
113 to make the changeover as easy as possible, since mappings
114 are not so cheap or straightforward to migrate.
115 
116 The first deployed contract would create this state contract,
117 using it as its store of balances.
118 When a new contract is deployed, it links to the existing
119 state contract, whose owner would then change its associated
120 contract to the new one.
121 
122 -----------------------------------------------------------------
123 */
124 
125 
126 contract State is Owned {
127     // the address of the contract that can modify variables
128     // this can only be changed by the owner of this contract
129     address public associatedContract;
130 
131 
132     constructor(address _owner, address _associatedContract)
133         Owned(_owner)
134         public
135     {
136         associatedContract = _associatedContract;
137         emit AssociatedContractUpdated(_associatedContract);
138     }
139 
140     /* ========== SETTERS ========== */
141 
142     // Change the associated contract to a new address
143     function setAssociatedContract(address _associatedContract)
144         external
145         onlyOwner
146     {
147         associatedContract = _associatedContract;
148         emit AssociatedContractUpdated(_associatedContract);
149     }
150 
151     /* ========== MODIFIERS ========== */
152 
153     modifier onlyAssociatedContract
154     {
155         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
156         _;
157     }
158 
159     /* ========== EVENTS ========== */
160 
161     event AssociatedContractUpdated(address associatedContract);
162 }
163 
164 
165 /*
166 -----------------------------------------------------------------
167 FILE INFORMATION
168 -----------------------------------------------------------------
169 
170 file:       TokenState.sol
171 version:    1.1
172 author:     Dominic Romanowski
173             Anton Jurisevic
174 
175 date:       2018-05-15
176 
177 -----------------------------------------------------------------
178 MODULE DESCRIPTION
179 -----------------------------------------------------------------
180 
181 A contract that holds the state of an ERC20 compliant token.
182 
183 This contract is used side by side with external state token
184 contracts, such as Synthetix and Synth.
185 It provides an easy way to upgrade contract logic while
186 maintaining all user balances and allowances. This is designed
187 to make the changeover as easy as possible, since mappings
188 are not so cheap or straightforward to migrate.
189 
190 The first deployed contract would create this state contract,
191 using it as its store of balances.
192 When a new contract is deployed, it links to the existing
193 state contract, whose owner would then change its associated
194 contract to the new one.
195 
196 -----------------------------------------------------------------
197 */
198 
199 
200 /**
201  * @title ERC20 Token State
202  * @notice Stores balance information of an ERC20 token contract.
203  */
204 contract TokenState is State {
205 
206     /* ERC20 fields. */
207     mapping(address => uint) public balanceOf;
208     mapping(address => mapping(address => uint)) public allowance;
209 
210     /**
211      * @dev Constructor
212      * @param _owner The address which controls this contract.
213      * @param _associatedContract The ERC20 contract whose state this composes.
214      */
215     constructor(address _owner, address _associatedContract)
216         State(_owner, _associatedContract)
217         public
218     {}
219 
220     /* ========== SETTERS ========== */
221 
222     /**
223      * @notice Set ERC20 allowance.
224      * @dev Only the associated contract may call this.
225      * @param tokenOwner The authorising party.
226      * @param spender The authorised party.
227      * @param value The total value the authorised party may spend on the
228      * authorising party's behalf.
229      */
230     function setAllowance(address tokenOwner, address spender, uint value)
231         external
232         onlyAssociatedContract
233     {
234         allowance[tokenOwner][spender] = value;
235     }
236 
237     /**
238      * @notice Set the balance in a given account
239      * @dev Only the associated contract may call this.
240      * @param account The account whose value to set.
241      * @param value The new balance of the given account.
242      */
243     function setBalanceOf(address account, uint value)
244         external
245         onlyAssociatedContract
246     {
247         balanceOf[account] = value;
248     }
249 }
250 
