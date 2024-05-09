1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/IOwned.sol
4 
5 /*
6     Owned Contract Interface
7 */
8 contract IOwned {
9     function transferOwnership(address _newOwner) public;
10     function acceptOwnership() public;
11     function transferOwnershipNow(address newContractOwner) public;
12 }
13 
14 // File: contracts/utility/Owned.sol
15 
16 /*
17     This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()
18     
19     The original unmodified version can be found here:
20     https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846
21     
22     Provides support and utilities for contract ownership
23 */
24 contract Owned is IOwned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
29 
30     /**
31         @dev constructor
32     */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     // allows execution by the owner only
38     modifier ownerOnly {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44         @dev allows transferring the contract ownership
45         the new owner still needs to accept the transfer
46         can only be called by the contract owner
47         @param _newOwner    new contract owner
48     */
49     function transferOwnership(address _newOwner) public ownerOnly {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     /**
55         @dev used by a new owner to accept an ownership transfer
56     */
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnerUpdate(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 
64     /**
65         @dev transfers the contract ownership without needing the new owner to accept ownership
66         @param newContractOwner    new contract owner
67     */
68     function transferOwnershipNow(address newContractOwner) ownerOnly public {
69         require(newContractOwner != owner);
70         emit OwnerUpdate(owner, newContractOwner);
71         owner = newContractOwner;
72     }
73 
74 }
75 
76 // File: contracts/interfaces/IERC20.sol
77 
78 /*
79     Smart Token Interface
80 */
81 contract IERC20 {
82     function balanceOf(address tokenOwner) public constant returns (uint balance);
83     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
84     function transfer(address to, uint tokens) public returns (bool success);
85     function approve(address spender, uint tokens) public returns (bool success);
86     function transferFrom(address from, address to, uint tokens) public returns (bool success);
87 
88     event Transfer(address indexed from, address indexed to, uint tokens);
89     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
90 }
91 
92 // File: contracts/interfaces/ICommunityAccount.sol
93 
94 /*
95     Community Account Interface
96 */
97 contract ICommunityAccount is IOwned {
98     function setStakedBalances(uint _amount, address msgSender) public;
99     function setTotalStaked(uint _totalStaked) public;
100     function setTimeStaked(uint _timeStaked, address msgSender) public;
101     function setEscrowedTaskBalances(uint uuid, uint balance) public;
102     function setEscrowedProjectBalances(uint uuid, uint balance) public;
103     function setEscrowedProjectPayees(uint uuid, address payeeAddress) public;
104     function setTotalTaskEscrow(uint balance) public;
105     function setTotalProjectEscrow(uint balance) public;
106 }
107 
108 // File: contracts/CommunityAccount.sol
109 
110 /**
111 @title Tribe Account
112 @notice This contract is used as a community's data store.
113 @notice Advantages:
114 @notice 1) Decouple logic contract from data contract
115 @notice 2) Safely upgrade logic contract without compromising stored data
116 */
117 contract CommunityAccount is Owned, ICommunityAccount {
118 
119     // Staking Variables.  In community token
120     mapping (address => uint256) public stakedBalances;
121     mapping (address => uint256) public timeStaked;
122     uint public totalStaked;
123 
124     // Escrow variables.  In native token
125     uint public totalTaskEscrow;
126     uint public totalProjectEscrow;
127     mapping (uint256 => uint256) public escrowedTaskBalances;
128     mapping (uint256 => uint256) public escrowedProjectBalances;
129     mapping (uint256 => address) public escrowedProjectPayees;
130     
131     /**
132     @notice This function allows the community to transfer tokens out of the contract.
133     @param tokenContractAddress Address of community contract
134     @param destination Destination address of user looking to remove tokens from contract
135     @param amount Amount to transfer out of community
136     */
137     function transferTokensOut(address tokenContractAddress, address destination, uint amount) public ownerOnly returns(bool result) {
138         IERC20 token = IERC20(tokenContractAddress);
139         return token.transfer(destination, amount);
140     }
141 
142     /**
143     @notice This is the community staking method
144     @param _amount Amount to be staked
145     @param msgSender Address of the staker
146     */
147     function setStakedBalances(uint _amount, address msgSender) public ownerOnly {
148         stakedBalances[msgSender] = _amount;
149     }
150 
151     /**
152     @param _totalStaked Set total amount staked in community
153      */
154     function setTotalStaked(uint _totalStaked) public ownerOnly {
155         totalStaked = _totalStaked;
156     }
157 
158     /**
159     @param _timeStaked Time of user staking into community
160     @param msgSender Staker address
161      */
162     function setTimeStaked(uint _timeStaked, address msgSender) public ownerOnly {
163         timeStaked[msgSender] = _timeStaked;
164     }
165 
166     /**
167     @param uuid id of escrowed task
168     @param balance Balance to be set of escrowed task
169      */
170     function setEscrowedTaskBalances(uint uuid, uint balance) public ownerOnly {
171         escrowedTaskBalances[uuid] = balance;
172     }
173 
174     /**
175     @param uuid id of escrowed project
176     @param balance Balance to be set of escrowed project
177      */
178     function setEscrowedProjectBalances(uint uuid, uint balance) public ownerOnly {
179         escrowedProjectBalances[uuid] = balance;
180     }
181 
182     /**
183     @param uuid id of escrowed project
184     @param payeeAddress Address funds will go to once project completed
185      */
186     function setEscrowedProjectPayees(uint uuid, address payeeAddress) public ownerOnly {
187         escrowedProjectPayees[uuid] = payeeAddress;
188     }
189 
190     /**
191     @param balance Balance which to set total task escrow to
192      */
193     function setTotalTaskEscrow(uint balance) public ownerOnly {
194         totalTaskEscrow = balance;
195     }
196 
197     /**
198     @param balance Balance which to set total project to
199      */
200     function setTotalProjectEscrow(uint balance) public ownerOnly {
201         totalProjectEscrow = balance;
202     }
203 }