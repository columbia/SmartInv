1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 
5 import "@openzeppelin/contracts-4.2.0/security/Pausable.sol";
6 import "@openzeppelin/contracts-4.2.0/token/ERC20/utils/SafeERC20.sol";
7 import "@openzeppelin/contracts-4.2.0/proxy/Clones.sol";
8 import "@openzeppelin/contracts-4.2.0/token/ERC20/extensions/ERC20VotesComp.sol";
9 import "./Vesting.sol";
10 import "./SimpleGovernance.sol";
11 
12 /**
13  * @title Saddle DAO token
14  * @notice A token that is deployed with fixed amount and appropriate vesting contracts.
15  * Transfer is blocked for a period of time until the governance can toggle the transferability.
16  */
17 contract SDL is ERC20Permit, Pausable, SimpleGovernance {
18     using SafeERC20 for IERC20;
19 
20     // Token max supply is 1,000,000,000 * 1e18 = 1e27
21     uint256 public constant MAX_SUPPLY = 1e9 ether;
22     uint256 public immutable govCanUnpauseAfter;
23     uint256 public immutable anyoneCanUnpauseAfter;
24     address public immutable vestingContractTarget;
25 
26     mapping(address => bool) public allowedTransferee;
27 
28     event Allowed(address indexed target);
29     event Disallowed(address indexed target);
30     event VestingContractDeployed(
31         address indexed beneficiary,
32         address vestingContract
33     );
34 
35     struct Recipient {
36         address to;
37         uint256 amount;
38         uint256 startTimestamp;
39         uint256 cliffPeriod;
40         uint256 durationPeriod;
41     }
42 
43     /**
44      * @notice Initializes SDL token with specified governance address and recipients. For vesting
45      * durations and amounts, please refer to our documentation on token distribution schedule.
46      * @param governance_ address of the governance who will own this contract
47      * @param pausePeriod_ time in seconds since the deployment. After this period, this token can be unpaused
48      * by the governance.
49      * @param vestingContractTarget_ logic contract of Vesting.sol to use for cloning
50      */
51     constructor(
52         address governance_,
53         uint256 pausePeriod_,
54         address vestingContractTarget_
55     ) public ERC20("Saddle DAO", "SDL") ERC20Permit("Saddle DAO") {
56         require(governance_ != address(0), "SDL: governance cannot be empty");
57         require(
58             vestingContractTarget_ != address(0),
59             "SDL: vesting contract target cannot be empty"
60         );
61         require(
62             pausePeriod_ > 0 && pausePeriod_ <= 52 weeks,
63             "SDL: pausePeriod must be in between 0 and 52 weeks"
64         );
65 
66         // Set state variables
67         vestingContractTarget = vestingContractTarget_;
68         governance = governance_;
69         govCanUnpauseAfter = block.timestamp + pausePeriod_;
70         anyoneCanUnpauseAfter = block.timestamp + 52 weeks;
71 
72         // Allow governance to transfer tokens
73         allowedTransferee[governance_] = true;
74 
75         // Mint tokens to governance
76         _mint(governance, MAX_SUPPLY);
77 
78         // Pause transfers at deployment
79         if (pausePeriod_ > 0) {
80             _pause();
81         }
82 
83         emit SetGovernance(governance_);
84     }
85 
86     /**
87      * @notice Deploys a clone of the vesting contract for the given recipient. Details about vesting and token
88      * release schedule can be found on https://docs.saddle.finance
89      * @param recipient Recipient of the token through the vesting schedule.
90      */
91     function deployNewVestingContract(Recipient memory recipient)
92         public
93         onlyGovernance
94         returns (address)
95     {
96         require(
97             recipient.durationPeriod > 0,
98             "SDL: duration for vesting cannot be 0"
99         );
100 
101         // Deploy a clone rather than deploying a whole new contract
102         Vesting vestingContract = Vesting(Clones.clone(vestingContractTarget));
103 
104         // Initialize the clone contract for the recipient
105         vestingContract.initialize(
106             address(this),
107             recipient.to,
108             recipient.startTimestamp,
109             recipient.cliffPeriod,
110             recipient.durationPeriod
111         );
112 
113         // Send tokens to the contract
114         IERC20(address(this)).safeTransferFrom(
115             msg.sender,
116             address(vestingContract),
117             recipient.amount
118         );
119 
120         // Add the vesting contract to the allowed transferee list
121         allowedTransferee[address(vestingContract)] = true;
122         emit Allowed(address(vestingContract));
123         emit VestingContractDeployed(recipient.to, address(vestingContract));
124 
125         return address(vestingContract);
126     }
127 
128     /**
129      * @notice Changes the transferability of this token.
130      * @dev When the transfer is not enabled, only those in allowedTransferee array can
131      * transfer this token.
132      */
133     function enableTransfer() external {
134         require(paused(), "SDL: transfer is enabled");
135         uint256 unpauseAfter = msg.sender == governance
136             ? govCanUnpauseAfter
137             : anyoneCanUnpauseAfter;
138         require(
139             block.timestamp > unpauseAfter,
140             "SDL: cannot enable transfer yet"
141         );
142         _unpause();
143     }
144 
145     /**
146      * @notice Add the given addresses to the list of allowed addresses that can transfer during paused period.
147      * Governance will add auxiliary contracts to the allowed list to facilitate distribution during the paused period.
148      * @param targets Array of addresses to add
149      */
150     function addToAllowedList(address[] memory targets)
151         external
152         onlyGovernance
153     {
154         for (uint256 i = 0; i < targets.length; i++) {
155             allowedTransferee[targets[i]] = true;
156             emit Allowed(targets[i]);
157         }
158     }
159 
160     /**
161      * @notice Remove the given addresses from the list of allowed addresses that can transfer during paused period.
162      * @param targets Array of addresses to remove
163      */
164     function removeFromAllowedList(address[] memory targets)
165         external
166         onlyGovernance
167     {
168         for (uint256 i = 0; i < targets.length; i++) {
169             allowedTransferee[targets[i]] = false;
170             emit Disallowed(targets[i]);
171         }
172     }
173 
174     function _beforeTokenTransfer(
175         address from,
176         address to,
177         uint256 amount
178     ) internal override {
179         super._beforeTokenTransfer(from, to, amount);
180         require(!paused() || allowedTransferee[from], "SDL: paused");
181         require(to != address(this), "SDL: invalid recipient");
182     }
183 
184     /**
185      * @notice Transfers any stuck tokens or ether out to the given destination.
186      * @dev Method to claim junk and accidentally sent tokens. This will be only used to rescue
187      * tokens that are mistakenly sent by users to this contract.
188      * @param token Address of the ERC20 token to transfer out. Set to address(0) to transfer ether instead.
189      * @param to Destination address that will receive the tokens.
190      * @param balance Amount to transfer out. Set to 0 to select all available amount.
191      */
192     function rescueTokens(
193         IERC20 token,
194         address payable to,
195         uint256 balance
196     ) external onlyGovernance {
197         require(to != address(0), "SDL: invalid recipient");
198 
199         if (token == IERC20(address(0))) {
200             // for Ether
201             uint256 totalBalance = address(this).balance;
202             balance = balance == 0
203                 ? totalBalance
204                 : Math.min(totalBalance, balance);
205             require(balance > 0, "SDL: trying to send 0 ETH");
206             // slither-disable-next-line arbitrary-send
207             (bool success, ) = to.call{value: balance}("");
208             require(success, "SDL: ETH transfer failed");
209         } else {
210             // any other erc20
211             uint256 totalBalance = token.balanceOf(address(this));
212             balance = balance == 0
213                 ? totalBalance
214                 : Math.min(totalBalance, balance);
215             require(balance > 0, "SDL: trying to send 0 balance");
216             token.safeTransfer(to, balance);
217         }
218     }
219 }
