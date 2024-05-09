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
170 file:       DelegateApprovals.sol
171 version:    1.0
172 author:     Jackson Chan
173 checked:    Clinton Ennis
174 date:       2019-05-01
175 
176 -----------------------------------------------------------------
177 MODULE DESCRIPTION
178 -----------------------------------------------------------------
179 
180 The approval state contract is designed to allow a wallet to
181 authorise another address to perform actions, on a contract,
182 on their behalf. This could be an automated service
183 that would help a wallet claim fees / rewards on their behalf.
184 
185 The concept is similar to the ERC20 interface where a wallet can
186 approve an authorised party to spend on the authorising party's
187 behalf in the allowance interface.
188 
189 Withdrawing approval sets the delegate as false instead of
190 removing from the approvals list for auditability.
191 
192 This contract inherits state for upgradeability / associated
193 contract.
194 
195 -----------------------------------------------------------------
196 */
197 
198 
199 contract DelegateApprovals is State {
200 
201     // Approvals - [authoriser][delegate]
202     // Each authoriser can have multiple delegates
203     mapping(address => mapping(address => bool)) public approval;
204 
205     /**
206      * @dev Constructor
207      * @param _owner The address which controls this contract.
208      * @param _associatedContract The contract whose approval state this composes.
209      */
210     constructor(address _owner, address _associatedContract)
211         State(_owner, _associatedContract)
212         public
213     {}
214 
215     function setApproval(address authoriser, address delegate)
216         external
217         onlyAssociatedContract
218     {
219         approval[authoriser][delegate] = true;
220         emit Approval(authoriser, delegate);
221     }
222 
223     function withdrawApproval(address authoriser, address delegate)
224         external
225         onlyAssociatedContract
226     {
227         delete approval[authoriser][delegate];
228         emit WithdrawApproval(authoriser, delegate);
229     }
230 
231      /* ========== EVENTS ========== */
232 
233     event Approval(address indexed authoriser, address delegate);
234     event WithdrawApproval(address indexed authoriser, address delegate);
235 }
236 
