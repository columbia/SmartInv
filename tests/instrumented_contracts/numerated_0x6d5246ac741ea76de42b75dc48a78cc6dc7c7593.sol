1 pragma solidity ^0.4.24;
2 
3 // File: contracts/registry/IDeployer.sol
4 
5 interface IDeployer {
6     function deploy(bytes data) external returns(address mtkn);
7 }
8 
9 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address _newOwner) public onlyOwner {
56     _transferOwnership(_newOwner);
57   }
58 
59   /**
60    * @dev Transfers control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63   function _transferOwnership(address _newOwner) internal {
64     require(_newOwner != address(0));
65     emit OwnershipTransferred(owner, _newOwner);
66     owner = _newOwner;
67   }
68 }
69 
70 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77   event Pause();
78   event Unpause();
79 
80   bool public paused = false;
81 
82 
83   /**
84    * @dev Modifier to make a function callable only when the contract is not paused.
85    */
86   modifier whenNotPaused() {
87     require(!paused);
88     _;
89   }
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is paused.
93    */
94   modifier whenPaused() {
95     require(paused);
96     _;
97   }
98 
99   /**
100    * @dev called by the owner to pause, triggers stopped state
101    */
102   function pause() onlyOwner whenNotPaused public {
103     paused = true;
104     emit Pause();
105   }
106 
107   /**
108    * @dev called by the owner to unpause, returns to normal state
109    */
110   function unpause() onlyOwner whenPaused public {
111     paused = false;
112     emit Unpause();
113   }
114 }
115 
116 // File: contracts/registry/MultiTokenRegistry.sol
117 
118 contract MultiTokenRegistry is Pausable {
119 
120     event NewMultitoken(address indexed mtkn);
121     event NewDeployer(uint256 indexed index, address indexed oldDeployer, address indexed newDeployer);
122 
123     address[] public multitokens;
124     mapping(uint256 => IDeployer) public deployers;
125 
126     function multitokensCount() public view returns(uint256) {
127         return multitokens.length;
128     }
129     
130     function allMultitokens() public view returns(address[]) {
131         return multitokens;
132     }
133 
134     function setDeployer(uint256 index, IDeployer deployer) public onlyOwner whenNotPaused {
135         emit NewDeployer(index, deployers[index], deployer);
136         deployers[index] = deployer;
137     }
138 
139     function deploy(uint256 index, bytes data) public whenNotPaused {
140         address mtkn = deployers[index].deploy(data);
141         multitokens.push(mtkn);
142         emit NewMultitoken(mtkn);
143     }
144 }