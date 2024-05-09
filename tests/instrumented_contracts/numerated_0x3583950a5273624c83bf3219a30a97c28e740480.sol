1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: registry/contracts/registry.sol
31 
32 contract Registry {
33     struct AttributeData {
34         uint256 value;
35         bytes32 notes;
36         address adminAddr;
37         uint256 timestamp;
38     }
39     
40     address public owner;
41     address public pendingOwner;
42     bool public initialized;
43 
44     // Stores arbitrary attributes for users. An example use case is an ERC20
45     // token that requires its users to go through a KYC/AML check - in this case
46     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
47     // that account can use the token. This mapping stores that value (1, in the
48     // example) as well as which validator last set the value and at what time,
49     // so that e.g. the check can be renewed at appropriate intervals.
50     mapping(address => mapping(bytes32 => AttributeData)) public attributes;
51     // The logic governing who is allowed to set what attributes is abstracted as
52     // this accessManager, so that it may be replaced by the owner as needed
53 
54     bytes32 public constant WRITE_PERMISSION = keccak256("canWriteTo-");
55 
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
61     event SetManager(address indexed oldManager, address indexed newManager);
62 
63 
64     function initialize() public {
65         require(!initialized, "already initialized");
66         owner = msg.sender;
67         initialized = true;
68     }
69 
70     function writeAttributeFor(bytes32 _attribute) public pure returns (bytes32) {
71         return keccak256(WRITE_PERMISSION ^ _attribute);
72     }
73 
74     // Allows a write if either a) the writer is that Registry's owner, or
75     // b) the writer is writing to attribute foo and that writer already has
76     // the canWriteTo-foo attribute set (in that same Registry)
77     function confirmWrite(bytes32 _attribute, address _admin) public view returns (bool) {
78         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
79     }
80 
81     // Writes are allowed only if the accessManager approves
82     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
83         require(confirmWrite(_attribute, msg.sender));
84         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
85         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
86     }
87 
88     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
89         require(confirmWrite(_attribute, msg.sender));
90         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
91         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
92     }
93 
94     // Returns true if the uint256 value stored for this attribute is non-zero
95     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
96         return attributes[_who][_attribute].value != 0;
97     }
98 
99     function hasBothAttributes(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
100         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value != 0;
101     }
102 
103     function hasEitherAttribute(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
104         return attributes[_who][_attribute1].value != 0 || attributes[_who][_attribute2].value != 0;
105     }
106 
107     function hasAttribute1ButNotAttribute2(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
108         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value == 0;
109     }
110 
111     function bothHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
112         return attributes[_who1][_attribute].value != 0 && attributes[_who2][_attribute].value != 0;
113     }
114     
115     function eitherHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
116         return attributes[_who1][_attribute].value != 0 || attributes[_who2][_attribute].value != 0;
117     }
118 
119     function haveAttributes(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
120         return attributes[_who1][_attribute1].value != 0 && attributes[_who2][_attribute2].value != 0;
121     }
122 
123     function haveEitherAttribute(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
124         return attributes[_who1][_attribute1].value != 0 || attributes[_who2][_attribute2].value != 0;
125     }
126 
127     // Returns the exact value of the attribute, as well as its metadata
128     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
129         AttributeData memory data = attributes[_who][_attribute];
130         return (data.value, data.notes, data.adminAddr, data.timestamp);
131     }
132 
133     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
134         return attributes[_who][_attribute].value;
135     }
136 
137     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
138         return attributes[_who][_attribute].adminAddr;
139     }
140 
141     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
142         return attributes[_who][_attribute].timestamp;
143     }
144 
145     function reclaimEther(address _to) external onlyOwner {
146         _to.transfer(address(this).balance);
147     }
148 
149     function reclaimToken(ERC20 token, address _to) external onlyOwner {
150         uint256 balance = token.balanceOf(this);
151         token.transfer(_to, balance);
152     }
153 
154     /**
155     * @dev sets the original `owner` of the contract to the sender
156     * at construction. Must then be reinitialized 
157     */
158     constructor() public {
159         owner = msg.sender;
160         emit OwnershipTransferred(address(0), owner);
161     }
162 
163     /**
164     * @dev Throws if called by any account other than the owner.
165     */
166     modifier onlyOwner() {
167         require(msg.sender == owner, "only Owner");
168         _;
169     }
170 
171     /**
172     * @dev Modifier throws if called by any account other than the pendingOwner.
173     */
174     modifier onlyPendingOwner() {
175         require(msg.sender == pendingOwner);
176         _;
177     }
178 
179     /**
180     * @dev Allows the current owner to set the pendingOwner address.
181     * @param newOwner The address to transfer ownership to.
182     */
183     function transferOwnership(address newOwner) public onlyOwner {
184         pendingOwner = newOwner;
185     }
186 
187     /**
188     * @dev Allows the pendingOwner address to finalize the transfer.
189     */
190     function claimOwnership() public onlyPendingOwner {
191         emit OwnershipTransferred(owner, pendingOwner);
192         owner = pendingOwner;
193         pendingOwner = address(0);
194     }
195 }