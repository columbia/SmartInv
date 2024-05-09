1 pragma solidity 0.5.1;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     /**
21      * @dev Throws if called by any account other than the owner.
22      */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25     _;
26     }
27 
28 }
29 
30 contract Claimable is Ownable {
31     address public pendingOwner;
32 
33     /**
34      * @dev Modifier throws if called by any account other than the pendingOwner.
35      */
36     modifier onlyPendingOwner() {
37         require(msg.sender == pendingOwner);
38         _;
39     }
40 
41     /**
42      * @dev Allows the current owner to set the pendingOwner address.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) onlyOwner public {
46         pendingOwner = newOwner;
47     }
48 
49     /**
50      * @dev Allows the pendingOwner address to finalize the transfer.
51      */
52     function claimOwnership() onlyPendingOwner public {
53         emit OwnershipTransferred(owner, pendingOwner);
54         owner = pendingOwner;
55         pendingOwner = address(0);
56     }
57 }
58 
59 /**
60  * @title Synvote
61  * @dev Vote with rewards
62  */
63 contract Synvote is Claimable {
64 
65     string  public constant  VERSION='2018.02';
66     uint256 public constant  MINETHVOTE = 1*(10**17);
67     
68 
69     //////////////////////
70     // DATA Structures  //
71     //////////////////////
72     enum StageName {preList, inProgress, voteFinished,rewardWithdrawn}
73     struct PrjProperties{
74         address prjAddress;
75         uint256 voteCount;
76         uint256 prjWeiRaised;
77     }
78 
79     //////////////////////
80     // State var       ///
81     //////////////////////
82     StageName public currentStage;
83     mapping(bytes32 => PrjProperties) public projects;// projects for vote
84     string public currentWinner;
85     uint64  public voteFinishDate;
86     //      86400     1 day
87     //     604800     1 week
88     //    2592000    30 day
89     //   31536000   365 days
90 
91     //////////////////////
92     // Events           //
93     //////////////////////
94     event VoteStarted(uint64 _when);
95     event NewBet(address _who, uint256 _wei, string _prj);
96     event VoteFinished(address _who, uint64 _when);
97    
98     
99     function() external { }
100     
101     ///@notice Add item to progject vote list
102     /// @dev It must be call from owner before startVote()
103     /// @param _prjName   - string, project name for vote.
104     /// @param _prjAddress   - address, only this address can get 
105     /// reward if project will win.
106     function addProjectToVote(string calldata _prjName, address _prjAddress) 
107     external 
108     payable 
109     onlyOwner
110     {
111         require(currentStage == StageName.preList, "Can't add item after vote has starting!");
112         require(_prjAddress != address(0),"Address must be valid!");
113         bytes32 hash = keccak256(bytes(_prjName));
114         require( projects[hash].prjAddress == address(0), 
115             "It seems like this item allready exist!"
116         );
117         projects[hash] = PrjProperties({
118                 prjAddress: _prjAddress,
119                 voteCount: 0,
120                 prjWeiRaised: 0
121             });
122     }
123     
124     ///@notice Start vote
125     /// @dev It must be call from owner when vote list is ready
126     /// @param _votefinish   - uint64,end of vote in Unix date format.
127     function startVote(uint64 _votefinish) external onlyOwner {
128         require(currentStage == StageName.preList);
129         require(_votefinish > now);
130         voteFinishDate = _votefinish;
131         currentStage = StageName.inProgress;
132         emit VoteStarted(uint64(now));
133     }
134 
135     ///@notice Make vote for sender
136     /// @dev Sender must send enough ether
137     /// @param _prjName   - string, project name for vote.
138     function vote(string calldata _prjName) external payable {
139         require(currentStage == StageName.inProgress,
140             "Vote disable now!"
141         
142         );
143         require(msg.value >= MINETHVOTE, "Please send more ether!");
144         bytes32 hash = keccak256(bytes(_prjName));
145         PrjProperties memory currentBet = projects[hash];//Storage - or   other place!!!!
146         require(currentBet.prjAddress != address(0), 
147             "It seems like there is no item with that name"
148         );
149         projects[hash].voteCount = currentBet.voteCount + 1;
150         projects[hash].prjWeiRaised = currentBet.prjWeiRaised + msg.value;
151         emit NewBet(msg.sender, msg.value, _prjName);
152         //Check for new winner
153         if  (currentBet.voteCount + 1 > projects[keccak256(bytes(currentWinner))].voteCount)
154             currentWinner = _prjName;
155         //Check vote end    
156         if  (now >= voteFinishDate)
157             currentStage = StageName.voteFinished;
158             emit VoteFinished(msg.sender, uint64(now));
159         
160     }
161 
162     /// @notice Transfer all ether from contract balance(reward found) to winner
163     /// @dev New currentStage will be set after successful call
164     function withdrawWinner() external {
165         require(currentStage == StageName.voteFinished, 
166             "Withdraw disable yet/allready!"
167         );
168         require(msg.sender == projects[keccak256(bytes(currentWinner))].prjAddress,
169             "Only winner can Withdraw reward"
170         );
171         currentStage = StageName.rewardWithdrawn;
172         msg.sender.transfer(address(this).balance);
173     }
174     
175     ///@notice Calculate hash
176     /// @dev There is web3py analog exists: Web3.soliditySha3(['string'], ['_hashinput'])
177     /// @param _hashinput   - string .
178     /// @return byte32, result of keccak256 (sha3 in old style) 
179     function calculateSha3(string memory _hashinput) public pure returns (bytes32){
180         return keccak256(bytes(_hashinput)); 
181     }
182    
183     
184     ///@dev use in case of depricate this contract or for gas reclaiming after vote
185     function kill() external onlyOwner {
186         require(currentStage == StageName.rewardWithdrawn, 
187             "Withdraw reward first!!!"
188         );
189         selfdestruct(msg.sender);
190     }
191     
192          
193 }