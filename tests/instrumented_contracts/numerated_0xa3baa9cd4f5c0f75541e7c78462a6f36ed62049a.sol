1 pragma solidity 0.5.0;
2 
3 // File: contracts/lib/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: contracts/lib/openzeppelin-solidity/contracts/ownership/Ownable.sol
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     constructor () internal {
61         _owner = msg.sender;
62         emit OwnershipTransferred(address(0), _owner);
63     }
64 
65     /**
66      * @return the address of the owner.
67      */
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(isOwner());
77         _;
78     }
79 
80     /**
81      * @return true if `msg.sender` is the owner of the contract.
82      */
83     function isOwner() public view returns (bool) {
84         return msg.sender == _owner;
85     }
86 
87     /**
88      * @dev Allows the current owner to relinquish control of the contract.
89      * @notice Renouncing to ownership will leave the contract without an owner.
90      * It will not be possible to call the functions with the `onlyOwner`
91      * modifier anymore.
92      */
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98     /**
99      * @dev Allows the current owner to transfer control of the contract to a newOwner.
100      * @param newOwner The address to transfer ownership to.
101      */
102     function transferOwnership(address newOwner) public onlyOwner {
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers control of the contract to a newOwner.
108      * @param newOwner The address to transfer ownership to.
109      */
110     function _transferOwnership(address newOwner) internal {
111         require(newOwner != address(0));
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 // File: contracts/access/roles/OperatorRole.sol
118 
119 contract OperatorRole is Ownable {
120     using Roles for Roles.Role;
121 
122     event OperatorAdded(address indexed account);
123     event OperatorRemoved(address indexed account);
124 
125     Roles.Role private operators;
126 
127     constructor() public {
128         operators.add(msg.sender);
129     }
130 
131     modifier onlyOperator() {
132         require(isOperator(msg.sender));
133         _;
134     }
135     
136     function isOperator(address account) public view returns (bool) {
137         return operators.has(account);
138     }
139 
140     function addOperator(address account) public onlyOwner() {
141         operators.add(account);
142         emit OperatorAdded(account);
143     }
144 
145     function removeOperator(address account) public onlyOwner() {
146         operators.remove(account);
147         emit OperatorRemoved(account);
148     }
149 
150 }
151 
152 // File: contracts/Referrers.sol
153 
154 contract Referrers is OperatorRole {
155     using Roles for Roles.Role;
156 
157     event ReferrerAdded(address indexed account);
158     event ReferrerRemoved(address indexed account);
159 
160     Roles.Role private referrers;
161 
162     uint32 internal index;
163     uint16 public constant limit = 10;
164     mapping(uint32 => address) internal indexToAddress;
165     mapping(address => uint32) internal addressToIndex;
166 
167     modifier onlyReferrer() {
168         require(isReferrer(msg.sender));
169         _;
170     }
171 
172     function getNumberOfAddresses() public view onlyOperator() returns (uint32) {
173         return index;
174     }
175 
176     function addressOfIndex(uint32 _index) onlyOperator() public view returns (address) {
177         return indexToAddress[_index];
178     }
179     
180     function isReferrer(address _account) public view returns (bool) {
181         return referrers.has(_account);
182     }
183 
184     function addReferrer(address _account) public onlyOperator() {
185         referrers.add(_account);
186         indexToAddress[index] = _account;
187         addressToIndex[_account] = index;
188         index++;
189         emit ReferrerAdded(_account);
190     }
191 
192     function addReferrers(address[limit] memory accounts) public onlyOperator() {
193         for (uint16 i=0; i<limit; i++) {
194             if (accounts[i] != address(0x0)) {
195                 addReferrer(accounts[i]);
196             }
197         }
198     }
199 
200     function removeReferrer(address _account) public onlyOperator() {
201         referrers.remove(_account);
202         indexToAddress[addressToIndex[_account]] = address(0x0);
203         emit ReferrerRemoved(_account);
204     }
205 
206 }