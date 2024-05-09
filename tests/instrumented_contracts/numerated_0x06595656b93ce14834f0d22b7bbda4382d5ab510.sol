1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Utility contract to allow pausing and unpausing of certain functions
5  */
6 contract Pausable {
7 
8     event Pause(uint256 _timestammp);
9     event Unpause(uint256 _timestamp);
10 
11     bool public paused = false;
12 
13     /**
14     * @notice Modifier to make a function callable only when the contract is not paused.
15     */
16     modifier whenNotPaused() {
17         require(!paused);
18         _;
19     }
20 
21     /**
22     * @notice Modifier to make a function callable only when the contract is paused.
23     */
24     modifier whenPaused() {
25         require(paused);
26         _;
27     }
28 
29    /**
30     * @notice called by the owner to pause, triggers stopped state
31     */
32     function _pause() internal {
33         require(!paused);
34         paused = true;
35         emit Pause(now);
36     }
37 
38     /**
39     * @notice called by the owner to unpause, returns to normal state
40     */
41     function _unpause() internal {
42         require(paused);
43         paused = false;
44         emit Unpause(now);
45     }
46 
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to relinquish control of the contract.
83    */
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address _newOwner) public onlyOwner {
94     _transferOwnership(_newOwner);
95   }
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address _newOwner) internal {
102     require(_newOwner != address(0));
103     emit OwnershipTransferred(owner, _newOwner);
104     owner = _newOwner;
105   }
106 }
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 /**
121  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
122  */
123 contract ReclaimTokens is Ownable {
124 
125     /**
126     * @notice Reclaim all ERC20Basic compatible tokens
127     * @param _tokenContract The address of the token contract
128     */
129     function reclaimERC20(address _tokenContract) external onlyOwner {
130         require(_tokenContract != address(0));
131         ERC20Basic token = ERC20Basic(_tokenContract);
132         uint256 balance = token.balanceOf(address(this));
133         require(token.transfer(owner, balance));
134     }
135 }
136 
137 /**
138  * @title Core functionality for registry upgradability
139  */
140 contract PolymathRegistry is ReclaimTokens {
141 
142     mapping (bytes32 => address) public storedAddresses;
143 
144     event LogChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
145 
146     /**
147      * @notice Get the contract address
148      * @param _nameKey is the key for the contract address mapping
149      * @return address
150      */
151     function getAddress(string _nameKey) view public returns(address) {
152         bytes32 key = keccak256(bytes(_nameKey));
153         require(storedAddresses[key] != address(0), "Invalid address key");
154         return storedAddresses[key];
155     }
156 
157     /**
158      * @notice change the contract address
159      * @param _nameKey is the key for the contract address mapping
160      * @param _newAddress is the new contract address
161      */
162     function changeAddress(string _nameKey, address _newAddress) public onlyOwner {
163         bytes32 key = keccak256(bytes(_nameKey));
164         emit LogChangeAddress(_nameKey, storedAddresses[key], _newAddress);
165         storedAddresses[key] = _newAddress;
166     }
167 
168 
169 }