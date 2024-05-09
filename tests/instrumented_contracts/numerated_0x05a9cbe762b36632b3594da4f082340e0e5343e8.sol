1 /*
2  * Nomin TokenState Contract
3  *
4  * Stores ERC20 balance and approval information for the
5  * nomin component of the Havven stablecoin system.
6  *
7  * version: nUSDa.1
8  * date: 29 Jun 2018
9  * url: https://github.com/Havven/havven/releases/tag/nUSDa.1
10  */
11  
12  
13 pragma solidity 0.4.24;
14  
15  
16 /*
17 -----------------------------------------------------------------
18 FILE INFORMATION
19 -----------------------------------------------------------------
20  
21 file:       Owned.sol
22 version:    1.1
23 author:     Anton Jurisevic
24             Dominic Romanowski
25  
26 date:       2018-2-26
27  
28 -----------------------------------------------------------------
29 MODULE DESCRIPTION
30 -----------------------------------------------------------------
31  
32 An Owned contract, to be inherited by other contracts.
33 Requires its owner to be explicitly set in the constructor.
34 Provides an onlyOwner access modifier.
35  
36 To change owner, the current owner must nominate the next owner,
37 who then has to accept the nomination. The nomination can be
38 cancelled before it is accepted by the new owner by having the
39 previous owner change the nomination (setting it to 0).
40  
41 -----------------------------------------------------------------
42 */
43  
44  
45 /**
46  * @title A contract with an owner.
47  * @notice Contract ownership can be transferred by first nominating the new owner,
48  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
49  */
50 contract Owned {
51     address public owner;
52     address public nominatedOwner;
53  
54     /**
55      * @dev Owned Constructor
56      */
57     constructor(address _owner)
58         public
59     {
60         require(_owner != address(0));
61         owner = _owner;
62         emit OwnerChanged(address(0), _owner);
63     }
64  
65     /**
66      * @notice Nominate a new owner of this contract.
67      * @dev Only the current owner may nominate a new owner.
68      */
69     function nominateNewOwner(address _owner)
70         external
71         onlyOwner
72     {
73         nominatedOwner = _owner;
74         emit OwnerNominated(_owner);
75     }
76  
77     /**
78      * @notice Accept the nomination to be owner.
79      */
80     function acceptOwnership()
81         external
82     {
83         require(msg.sender == nominatedOwner);
84         emit OwnerChanged(owner, nominatedOwner);
85         owner = nominatedOwner;
86         nominatedOwner = address(0);
87     }
88  
89     modifier onlyOwner
90     {
91         require(msg.sender == owner);
92         _;
93     }
94  
95     event OwnerNominated(address newOwner);
96     event OwnerChanged(address oldOwner, address newOwner);
97 }
98  
99  
100 /*
101 -----------------------------------------------------------------
102 FILE INFORMATION
103 -----------------------------------------------------------------
104  
105 file:       State.sol
106 version:    1.1
107 author:     Dominic Romanowski
108             Anton Jurisevic
109  
110 date:       2018-05-15
111  
112 -----------------------------------------------------------------
113 MODULE DESCRIPTION
114 -----------------------------------------------------------------
115  
116 This contract is used side by side with external state token
117 contracts, such as Havven and Nomin.
118 It provides an easy way to upgrade contract logic while
119 maintaining all user balances and allowances. This is designed
120 to make the changeover as easy as possible, since mappings
121 are not so cheap or straightforward to migrate.
122  
123 The first deployed contract would create this state contract,
124 using it as its store of balances.
125 When a new contract is deployed, it links to the existing
126 state contract, whose owner would then change its associated
127 contract to the new one.
128  
129 -----------------------------------------------------------------
130 */
131  
132  
133 contract State is Owned {
134     // the address of the contract that can modify variables
135     // this can only be changed by the owner of this contract
136     address public associatedContract;
137  
138  
139     constructor(address _owner, address _associatedContract)
140         Owned(_owner)
141         public
142     {
143         associatedContract = _associatedContract;
144         emit AssociatedContractUpdated(_associatedContract);
145     }
146  
147     /* ========== SETTERS ========== */
148  
149     // Change the associated contract to a new address
150     function setAssociatedContract(address _associatedContract)
151         external
152         onlyOwner
153     {
154         associatedContract = _associatedContract;
155         emit AssociatedContractUpdated(_associatedContract);
156     }
157  
158     /* ========== MODIFIERS ========== */
159  
160     modifier onlyAssociatedContract
161     {
162         require(msg.sender == associatedContract);
163         _;
164     }
165  
166     /* ========== EVENTS ========== */
167  
168     event AssociatedContractUpdated(address associatedContract);
169 }
170  
171  
172 /*
173 -----------------------------------------------------------------
174 FILE INFORMATION
175 -----------------------------------------------------------------
176  
177 file:       TokenState.sol
178 version:    1.1
179 author:     Dominic Romanowski
180             Anton Jurisevic
181  
182 date:       2018-05-15
183  
184 -----------------------------------------------------------------
185 MODULE DESCRIPTION
186 -----------------------------------------------------------------
187  
188 A contract that holds the state of an ERC20 compliant token.
189  
190 This contract is used side by side with external state token
191 contracts, such as Havven and Nomin.
192 It provides an easy way to upgrade contract logic while
193 maintaining all user balances and allowances. This is designed
194 to make the changeover as easy as possible, since mappings
195 are not so cheap or straightforward to migrate.
196  
197 The first deployed contract would create this state contract,
198 using it as its store of balances.
199 When a new contract is deployed, it links to the existing
200 state contract, whose owner would then change its associated
201 contract to the new one.
202  
203 -----------------------------------------------------------------
204 */
205  
206  
207 /**
208  * @title ERC20 Token State
209  * @notice Stores balance information of an ERC20 token contract.
210  */
211 contract TokenState is State {
212  
213     /* ERC20 fields. */
214     mapping(address => uint) public balanceOf;
215     mapping(address => mapping(address => uint)) public allowance;
216  
217     /**
218      * @dev Constructor
219      * @param _owner The address which controls this contract.
220      * @param _associatedContract The ERC20 contract whose state this composes.
221      */
222     constructor(address _owner, address _associatedContract)
223         State(_owner, _associatedContract)
224         public
225     {}
226  
227     /* ========== SETTERS ========== */
228  
229     /**
230      * @notice Set ERC20 allowance.
231      * @dev Only the associated contract may call this.
232      * @param tokenOwner The authorising party.
233      * @param spender The authorised party.
234      * @param value The total value the authorised party may spend on the
235      * authorising party's behalf.
236      */
237     function setAllowance(address tokenOwner, address spender, uint value)
238         external
239         onlyAssociatedContract
240     {
241         allowance[tokenOwner][spender] = value;
242     }
243  
244     /**
245      * @notice Set the balance in a given account
246      * @dev Only the associated contract may call this.
247      * @param account The account whose value to set.
248      * @param value The new balance of the given account.
249      */
250     function setBalanceOf(address account, uint value)
251         external
252         onlyAssociatedContract
253     {
254         balanceOf[account] = value;
255     }
256 }