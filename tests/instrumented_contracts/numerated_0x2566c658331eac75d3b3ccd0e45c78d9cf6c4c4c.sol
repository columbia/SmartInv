1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/NetworkSettings.sol
46 
47 // solhint-disable-line
48 
49 
50 
51 /// @title Atonomi Network Settings
52 /// @notice This contract controls all owner configurable variables in the network
53 contract NetworkSettings is Ownable {
54     /// @title Registration Fee
55     /// @notice Manufacturer pays token to register a device
56     /// @notice Manufacturer will recieve a share in any reputation updates for a device
57     uint256 public registrationFee;
58 
59     /// @title Activiation Fee
60     /// @notice Manufacturer or Device Owner pays token to activate device
61     uint256 public activationFee;
62 
63     /// @title Default Reputation Reward
64     /// @notice The default reputation reward set for new manufacturers
65     uint256 public defaultReputationReward;
66 
67     /// @title Reputation Share for IRN Nodes
68     /// @notice percentage that the irn node or auditor receives (remaining goes to manufacturer)
69     uint256 public reputationIRNNodeShare;
70 
71     /// @title Block threshold
72     /// @notice the number of blocks that need to pass between reputation updates to gain the full reward
73     uint256 public blockThreshold;
74 
75     /// @notice emitted everytime the registration fee changes
76     /// @param _sender ethereum account of participant that made the change
77     /// @param _amount new fee value in ATMI tokens
78     event RegistrationFeeUpdated(
79         address indexed _sender,
80         uint256 _amount
81     );
82 
83     /// @notice emitted everytime the activation fee changes
84     /// @param _sender ethereum account of participant that made the change
85     /// @param _amount new fee value in ATMI tokens
86     event ActivationFeeUpdated(
87         address indexed _sender,
88         uint256 _amount
89     );
90 
91     /// @notice emitted everytime the default reputation reward changes
92     /// @param _sender ethereum account of participant that made the change
93     /// @param _amount new fee value in ATMI tokens
94     event DefaultReputationRewardUpdated(
95         address indexed _sender,
96         uint256 _amount
97     );
98 
99     /// @notice emitted everytime owner changes the contributation share for reputation authors
100     /// @param _sender ethereum account of participant that made the change
101     /// @param _percentage new percentage value
102     event ReputationIRNNodeShareUpdated(
103         address indexed _sender,
104         uint256 _percentage
105     );
106 
107     /// @notice emitted everytime the block threshold is changed
108     /// @param _sender ethereum account who made the change
109     /// @param _newBlockThreshold new value for all token pools
110     event RewardBlockThresholdChanged(
111         address indexed _sender,
112         uint256 _newBlockThreshold
113     );
114 
115     /// @notice Constructor for Atonomi Reputation contract
116     /// @param _registrationFee initial registration fee on the network
117     /// @param _activationFee initial activation fee on the network
118     /// @param _defaultReputationReward initial reputation reward on the network
119     /// @param _reputationIRNNodeShare share that the reputation author recieves (remaining goes to manufacturer)
120     /// @param _blockThreshold the number of blocks that need to pass to receive the full reward
121     constructor(
122         uint256 _registrationFee,
123         uint256 _activationFee,
124         uint256 _defaultReputationReward,
125         uint256 _reputationIRNNodeShare,
126         uint256 _blockThreshold) public {
127         require(_activationFee > 0, "activation fee must be greater than 0");
128         require(_registrationFee > 0, "registration fee must be greater than 0");
129         require(_defaultReputationReward > 0, "default reputation reward must be greater than 0");
130         require(_reputationIRNNodeShare > 0, "new share must be larger than zero");
131         require(_reputationIRNNodeShare < 100, "new share must be less than 100");
132 
133         activationFee = _activationFee;
134         registrationFee = _registrationFee;
135         defaultReputationReward = _defaultReputationReward;
136         reputationIRNNodeShare = _reputationIRNNodeShare;
137         blockThreshold = _blockThreshold;
138     }
139 
140     /// @notice sets the global registration fee
141     /// @param _registrationFee new fee for registrations in ATMI tokens
142     /// @return true if successful, otherwise false
143     function setRegistrationFee(uint256 _registrationFee) public onlyOwner returns (bool) {
144         require(_registrationFee > 0, "new registration fee must be greater than zero");
145         require(_registrationFee != registrationFee, "new registration fee must be different");
146         registrationFee = _registrationFee;
147         emit RegistrationFeeUpdated(msg.sender, _registrationFee);
148         return true;
149     }
150 
151     /// @notice sets the global activation fee
152     /// @param _activationFee new fee for activations in ATMI tokens
153     /// @return true if successful, otherwise false
154     function setActivationFee(uint256 _activationFee) public onlyOwner returns (bool) {
155         require(_activationFee > 0, "new activation fee must be greater than zero");
156         require(_activationFee != activationFee, "new activation fee must be different");
157         activationFee = _activationFee;
158         emit ActivationFeeUpdated(msg.sender, _activationFee);
159         return true;
160     }
161 
162     /// @notice sets the default reputation reward for new manufacturers
163     /// @param _defaultReputationReward new reward for reputation score changes in ATMI tokens
164     /// @return true if successful, otherwise false
165     function setDefaultReputationReward(uint256 _defaultReputationReward) public onlyOwner returns (bool) {
166         require(_defaultReputationReward > 0, "new reputation reward must be greater than zero");
167         require(_defaultReputationReward != defaultReputationReward, "new reputation reward must be different");
168         defaultReputationReward = _defaultReputationReward;
169         emit DefaultReputationRewardUpdated(msg.sender, _defaultReputationReward);
170         return true;
171     }
172 
173     /// @notice sets the global reputation reward share allotted to the authors and manufacturers
174     /// @param _reputationIRNNodeShare new percentage of the reputation reward allotted to author
175     /// @return true if successful, otherwise false
176     function setReputationIRNNodeShare(uint256 _reputationIRNNodeShare) public onlyOwner returns (bool) {
177         require(_reputationIRNNodeShare > 0, "new share must be larger than zero");
178         require(_reputationIRNNodeShare < 100, "new share must be less than to 100");
179         require(reputationIRNNodeShare != _reputationIRNNodeShare, "new share must be different");
180         reputationIRNNodeShare = _reputationIRNNodeShare;
181         emit ReputationIRNNodeShareUpdated(msg.sender, _reputationIRNNodeShare);
182         return true;
183     }
184 
185     /// @notice sets the global block threshold for rewards
186     /// @param _newBlockThreshold new value for all token pools
187     /// @return true if successful, otherwise false
188     function setRewardBlockThreshold(uint _newBlockThreshold) public onlyOwner returns (bool) {
189         require(_newBlockThreshold != blockThreshold, "must be different");
190         blockThreshold = _newBlockThreshold;
191         emit RewardBlockThresholdChanged(msg.sender, _newBlockThreshold);
192         return true;
193     }
194 }