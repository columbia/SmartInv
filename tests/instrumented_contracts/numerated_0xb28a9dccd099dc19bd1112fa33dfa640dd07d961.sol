1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/utils/Utils.sol
78 
79 /**
80  * @title Manageable Contract
81  * @author Validity Labs AG <info@validitylabs.org>
82  */
83  
84 pragma solidity 0.5.7;
85 
86 
87 contract Utils {
88     /** MODIFIERS **/
89     modifier onlyValidAddress(address _address) {
90         require(_address != address(0), "invalid address");
91         _;
92     }
93 }
94 
95 // File: contracts/management/Manageable.sol
96 
97 /**
98  * @title Manageable Contract
99  * @author Validity Labs AG <info@validitylabs.org>
100  */
101  
102  pragma solidity 0.5.7;
103 
104 
105 
106 contract Manageable is Ownable, Utils {
107     mapping(address => bool) public isManager;     // manager accounts
108 
109     /** EVENTS **/
110     event ChangedManager(address indexed manager, bool active);
111 
112     /** MODIFIERS **/
113     modifier onlyManager() {
114         require(isManager[msg.sender], "is not manager");
115         _;
116     }
117 
118     /**
119     * @notice constructor sets the deployer as a manager
120     */
121     constructor() public {
122         setManager(msg.sender, true);
123     }
124 
125     /**
126      * @notice enable/disable an account to be a manager
127      * @param _manager address address of the manager to create/alter
128      * @param _active bool flag that shows if the manager account is active
129      */
130     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
131         isManager[_manager] = _active;
132         emit ChangedManager(_manager, _active);
133     }
134 
135     /** OVERRIDE 
136     * @notice does not allow owner to give up ownership
137     */
138     function renounceOwnership() public onlyOwner {
139         revert("Cannot renounce ownership");
140     }
141 }
142 
143 // File: contracts/whitelist/GlobalWhitelist.sol
144 
145 /**
146  * @title Global Whitelist Contract
147  * @author Validity Labs AG <info@validitylabs.org>
148  */
149 
150 pragma solidity 0.5.7;
151 
152 
153 
154 
155 contract GlobalWhitelist is Ownable, Manageable {
156     mapping(address => bool) public isWhitelisted; // addresses of who's whitelisted
157     bool public isWhitelisting = true;             // whitelisting enabled by default
158 
159     /** EVENTS **/
160     event ChangedWhitelisting(address indexed registrant, bool whitelisted);
161     event GlobalWhitelistDisabled(address indexed manager);
162     event GlobalWhitelistEnabled(address indexed manager);
163 
164     /**
165     * @dev add an address to the whitelist
166     * @param _address address
167     */
168     function addAddressToWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
169         isWhitelisted[_address] = true;
170         emit ChangedWhitelisting(_address, true);
171     }
172 
173     /**
174     * @dev add addresses to the whitelist
175     * @param _addresses addresses array
176     */
177     function addAddressesToWhitelist(address[] calldata _addresses) external {
178         for (uint256 i = 0; i < _addresses.length; i++) {
179             addAddressToWhitelist(_addresses[i]);
180         }
181     }
182 
183     /**
184     * @dev remove an address from the whitelist
185     * @param _address address
186     */
187     function removeAddressFromWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
188         isWhitelisted[_address] = false;
189         emit ChangedWhitelisting(_address, false);
190     }
191 
192     /**
193     * @dev remove addresses from the whitelist
194     * @param _addresses addresses
195     */
196     function removeAddressesFromWhitelist(address[] calldata _addresses) external {
197         for (uint256 i = 0; i < _addresses.length; i++) {
198             removeAddressFromWhitelist(_addresses[i]);
199         }
200     }
201 
202     /** 
203     * @notice toggle the whitelist by the parent contract; ExporoTokenFactory
204     */
205     function toggleWhitelist() external onlyOwner {
206         isWhitelisting = isWhitelisting ? false : true;
207 
208         if (isWhitelisting) {
209             emit GlobalWhitelistEnabled(msg.sender);
210         } else {
211             emit GlobalWhitelistDisabled(msg.sender);
212         }
213     }
214 }