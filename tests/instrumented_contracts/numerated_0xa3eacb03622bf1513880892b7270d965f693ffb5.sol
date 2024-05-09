1 pragma solidity ^0.4.24;
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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 interface IERC20 {
67     function decimals() external view returns (uint8);
68     function totalSupply() external view returns (uint256);
69     function balanceOf(address _owner) external view returns (uint256);
70     function allowance(address _owner, address _spender) external view returns (uint256);
71     function transfer(address _to, uint256 _value) external returns (bool);
72     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
73     function approve(address _spender, uint256 _value) external returns (bool);
74     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
75     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
82  */
83 contract ReclaimTokens is Ownable {
84 
85     /**
86     * @notice Reclaim all ERC20Basic compatible tokens
87     * @param _tokenContract The address of the token contract
88     */
89     function reclaimERC20(address _tokenContract) external onlyOwner {
90         require(_tokenContract != address(0), "Invalid address");
91         IERC20 token = IERC20(_tokenContract);
92         uint256 balance = token.balanceOf(address(this));
93         require(token.transfer(owner, balance), "Transfer failed");
94     }
95 }
96 
97 /**
98  * @title Interface for managing polymath feature switches
99  */
100 interface IFeatureRegistry {
101 
102     /**
103      * @notice Get the status of a feature
104      * @param _nameKey is the key for the feature status mapping
105      * @return bool
106      */
107     function getFeatureStatus(string _nameKey) external view returns(bool);
108 
109 }
110 
111 /**
112  * @title Registry for managing polymath feature switches
113  */
114 contract FeatureRegistry is IFeatureRegistry, ReclaimTokens {
115 
116     mapping (bytes32 => bool) public featureStatus;
117 
118     event ChangeFeatureStatus(string _nameKey, bool _newStatus);
119 
120     /**
121      * @notice Get the status of a feature
122      * @param _nameKey is the key for the feature status mapping
123      * @return bool
124      */
125     function getFeatureStatus(string _nameKey) external view returns(bool) {
126         bytes32 key = keccak256(bytes(_nameKey));
127         return featureStatus[key];
128     }
129 
130     /**
131      * @notice change a feature status
132      * @dev feature status is set to false by default
133      * @param _nameKey is the key for the feature status mapping
134      * @param _newStatus is the new feature status
135      */
136     function setFeatureStatus(string _nameKey, bool _newStatus) public onlyOwner {
137         bytes32 key = keccak256(bytes(_nameKey));
138         require(featureStatus[key] != _newStatus, "Status unchanged");
139         emit ChangeFeatureStatus(_nameKey, _newStatus);
140         featureStatus[key] = _newStatus;
141     }
142 
143 }