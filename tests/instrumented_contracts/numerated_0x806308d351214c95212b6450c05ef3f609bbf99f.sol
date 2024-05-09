1 pragma solidity 0.4.25;
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
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }  
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 contract ClaimReward is Ownable {
84     /// @dev This emits when claimReward is called
85     event LogClaimReward(address indexed sender, uint256 indexed rewards);
86     
87     address communityFundAddress = 0x325a7A78e5da2333b475570398F27D8F4e8E9Eb3;
88     address livePeerContractAddress = 0x58b6A8A3302369DAEc383334672404Ee733aB239;
89 
90     // Delegators addresses 
91     address[] private delegatorAddressList;
92 
93     mapping (address => Delegator) rewardDelegators;
94     // count the number of reward claimed    
95     uint256 public claimCounter = 0;
96     // Status of the current contract 
97     bool public contractStopped = false;
98     
99     struct Delegator {
100         address delegator;
101         uint rewards;
102         bool hasClaimed;
103     }
104     
105     // Used to check contract status before executing createQuestionnaire function
106     modifier haltInEmergency {
107         require(!contractStopped);
108         _;
109     }
110     
111     /// @notice only the contract owner is allowed to change
112     /// @dev change the contract status to pause or continue
113     function toggleContractStopped() public onlyOwner {
114         contractStopped = !contractStopped;
115     }
116     
117     // @dev initialize delegator address and rewards
118     function updateDelegatorRewards(address[] delegatorAddress, uint[] rewards) onlyOwner public returns (bool) {
119         for (uint i=0; i<delegatorAddress.length; i++) {
120             Delegator memory delegator = Delegator(delegatorAddress[i], rewards[i] * 10 ** 14 , false);
121             rewardDelegators[delegatorAddress[i]] = delegator;
122             delegatorAddressList.push(delegatorAddress[i]);
123         }
124         return true;
125     }
126     
127     // @dev query the delegator rewards
128     function checkRewards() external view returns (uint256) {
129         return rewardDelegators[msg.sender].rewards;
130     }
131     
132     // @dev transfer the reward to the delegator
133     function claimRewards() external haltInEmergency returns (bool) {
134         require(!rewardDelegators[msg.sender].hasClaimed);
135         require(rewardDelegators[msg.sender].delegator == msg.sender);
136         require((ERC20(livePeerContractAddress).balanceOf(this) - this.checkRewards()) > 0);
137         require(claimCounter < this.getAllDelegatorAddress().length);
138         
139         rewardDelegators[msg.sender].hasClaimed = true;
140         claimCounter += 1;
141         ERC20(livePeerContractAddress).transfer(msg.sender, rewardDelegators[msg.sender].rewards);
142         
143         emit LogClaimReward(msg.sender, rewardDelegators[msg.sender].rewards);
144         
145         return true;
146     }
147 
148     // @dev transfer those remaining LPT to the community fund address
149     function activateCommunityFund() external onlyOwner returns (bool) {
150         require(ERC20(livePeerContractAddress).balanceOf(this) > 0);
151         ERC20(livePeerContractAddress).transfer(communityFundAddress, ERC20(livePeerContractAddress).balanceOf(this));
152         return true;
153     }
154     
155     // @dev return all delegators
156     function getAllDelegatorAddress() external view returns (address[]) {
157         return delegatorAddressList;  
158     } 
159 }