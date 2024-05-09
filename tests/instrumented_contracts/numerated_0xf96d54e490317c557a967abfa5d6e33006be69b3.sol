1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 contract IController is Pausable {
89     event SetContractInfo(bytes32 id, address contractAddress, bytes20 gitCommitHash);
90 
91     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external;
92     function updateController(bytes32 _id, address _controller) external;
93     function getContract(bytes32 _id) public view returns (address);
94 }
95 
96 contract IManager {
97     event SetController(address controller);
98     event ParameterUpdate(string param);
99 
100     function setController(address _controller) external;
101 }
102 
103 contract Controller is Pausable, IController {
104     // Track information about a registered contract
105     struct ContractInfo {
106         address contractAddress;                 // Address of contract
107         bytes20 gitCommitHash;                   // SHA1 hash of head Git commit during registration of this contract
108     }
109 
110     // Track contract ids and contract info
111     mapping (bytes32 => ContractInfo) private registry;
112 
113     function Controller() public {
114         // Start system as paused
115         paused = true;
116     }
117 
118     /*
119      * @dev Register contract id and mapped address
120      * @param _id Contract id (keccak256 hash of contract name)
121      * @param _contract Contract address
122      */
123     function setContractInfo(bytes32 _id, address _contractAddress, bytes20 _gitCommitHash) external onlyOwner {
124         registry[_id].contractAddress = _contractAddress;
125         registry[_id].gitCommitHash = _gitCommitHash;
126 
127         SetContractInfo(_id, _contractAddress, _gitCommitHash);
128     }
129 
130     /*
131      * @dev Update contract's controller
132      * @param _id Contract id (keccak256 hash of contract name)
133      * @param _controller Controller address
134      */
135     function updateController(bytes32 _id, address _controller) external onlyOwner {
136         return IManager(registry[_id].contractAddress).setController(_controller);
137     }
138 
139     /*
140      * @dev Return contract info for a given contract id
141      * @param _id Contract id (keccak256 hash of contract name)
142      */
143     function getContractInfo(bytes32 _id) public view returns (address, bytes20) {
144         return (registry[_id].contractAddress, registry[_id].gitCommitHash);
145     }
146 
147     /*
148      * @dev Get contract address for an id
149      * @param _id Contract id
150      */
151     function getContract(bytes32 _id) public view returns (address) {
152         return registry[_id].contractAddress;
153     }
154 }