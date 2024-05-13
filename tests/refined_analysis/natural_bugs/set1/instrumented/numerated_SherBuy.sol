1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
10 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
11 
12 import './interfaces/ISherClaim.sol';
13 import './interfaces/ISherlock.sol';
14 
15 /// @title Buy SHER tokens by staking USDC and paying USDC
16 /// @author Evert Kors
17 /// @dev The goal is to get TVL in Sherlock.sol and raise funds with `receiver`
18 /// @dev Bought SHER tokens are moved to a timelock contract (SherClaim)
19 /// @dev Admin should send factor of 0.01 SHER tokens to the contract, otherwise logic will break.
20 contract SherBuy is ReentrancyGuard {
21   using SafeERC20 for IERC20;
22 
23   error InvalidSender();
24   error InvalidAmount();
25   error ZeroArgument();
26   error InvalidState();
27   error SoldOut();
28 
29   /// @notice Emitted when SHER purchase is executed
30   /// @param buyer Account that bought SHER tokens
31   /// @param amount How much SHER tokens are bought
32   /// @param staked How much USDC is staked
33   /// @param paid How much USDC is paid
34   event Purchase(address indexed buyer, uint256 amount, uint256 staked, uint256 paid);
35 
36   // The staking period used for the staking USDC
37   uint256 public constant PERIOD = 26 weeks;
38   // Allows purchases in steps of 0.01 SHER
39   uint256 internal constant SHER_STEPS = 10**16;
40   // Allows stakeRate and buyRate with steps of 0.01 USDC
41   uint256 internal constant RATE_STEPS = 10**4;
42   // SHER has 18 decimals
43   uint256 internal constant SHER_DECIMALS = 10**18;
44 
45   // SHER token address (18 decimals)
46   IERC20 public immutable sher;
47   // USDC token address (6 decimals)
48   IERC20 public immutable usdc;
49 
50   // 10**6 means for every 1 SHER token you want to buy, you will stake 1 USDC (10**7 means 1 SHER for 10 USDC)
51   uint256 public immutable stakeRate;
52   // 10**6 means for every 1 SHER token you want to buy, you will pay 1 USDC (10**7 means 1 SHER for 10 USDC)
53   uint256 public immutable buyRate;
54   // The `Sherlock.sol` contract that is a ERC721
55   ISherlock public immutable sherlockPosition;
56   // Address receiving the USDC payments
57   address public immutable receiver;
58   // Contract to claim SHER at
59   ISherClaim public immutable sherClaim;
60 
61   /// @notice Construct BuySher contract
62   /// @param _sher ERC20 contract for SHER token
63   /// @param _usdc ERC20 contract for USDC token
64   /// @param _stakeRate Rate at which SHER tokens translate to the amount of USDC needed to be staked
65   /// @param _buyRate Rate at which SHER tokens translate to the amount of USDC needed to be paid
66   /// @param _sherlockPosition ERC721 contract of Sherlock positions
67   /// @param _receiver Address that receives USDC from purchases
68   /// @param _sherClaim Contract that keeps the SHER timelocked
69   constructor(
70     IERC20 _sher,
71     IERC20 _usdc,
72     uint256 _stakeRate,
73     uint256 _buyRate,
74     ISherlock _sherlockPosition,
75     address _receiver,
76     ISherClaim _sherClaim
77   ) {
78     if (address(_sher) == address(0)) revert ZeroArgument();
79     if (address(_usdc) == address(0)) revert ZeroArgument();
80     if (_stakeRate == 0) revert ZeroArgument();
81     if (_stakeRate % RATE_STEPS != 0) revert InvalidState();
82     if (_buyRate == 0) revert ZeroArgument();
83     if (_buyRate % RATE_STEPS != 0) revert InvalidState();
84     if (address(_sherlockPosition) == address(0)) revert ZeroArgument();
85     if (_receiver == address(0)) revert ZeroArgument();
86     if (address(_sherClaim) == address(0)) revert ZeroArgument();
87 
88     // Verify if PERIOD is active
89     // Theoretically this period can be disabled during the lifetime of this contract, which will cause issues
90     if (_sherlockPosition.stakingPeriods(PERIOD) == false) revert InvalidState();
91 
92     sher = _sher;
93     usdc = _usdc;
94     stakeRate = _stakeRate;
95     buyRate = _buyRate;
96     sherlockPosition = _sherlockPosition;
97     receiver = _receiver;
98     sherClaim = _sherClaim;
99 
100     // Do max approve in constructor as this contract will not hold any USDC
101     usdc.safeIncreaseAllowance(address(sherlockPosition), type(uint256).max);
102   }
103 
104   /// @notice Check if the liquidity event is active
105   /// @dev SHER tokens can run out while event is active
106   /// @return True if the liquidity event is active
107   function active() public view returns (bool) {
108     // The claim contract will become active once the liquidity event is inactive
109     return block.timestamp < sherClaim.newEntryDeadline();
110   }
111 
112   /// @notice View the capital requirements needed to buy up until `_sherAmountWant`
113   /// @dev Will adjust to remaining SHER if `_sherAmountWant` exceeds that
114   /// @return sherAmount Will adjust to remining SHER if `_sherAmountWant` exceeds that
115   /// @return stake How much USDC needs to be staked for `PERIOD` of time to buy `sherAmount` SHER
116   /// @return price How much USDC needs to be paid to buy `sherAmount` SHER
117   function viewCapitalRequirements(uint256 _sherAmountWant)
118     public
119     view
120     returns (
121       uint256 sherAmount,
122       uint256 stake,
123       uint256 price
124     )
125   {
126     // Only allow if liquidity event is active
127     if (active() == false) revert InvalidState();
128     // Zero isn't allowed
129     if (_sherAmountWant == 0) revert ZeroArgument();
130 
131     // View how much SHER is still available to be sold
132     uint256 available = sher.balanceOf(address(this));
133     // If remaining SHER is 0 it's sold out
134     if (available == 0) revert SoldOut();
135 
136     // Use remaining SHER if it's less then `_sherAmountWant`, otherwise go for `_sherAmountWant`
137     // Remaining SHER will only be assigned on the last sale of this contract, `SoldOut()` error will be thrown after
138     // sherAmount is not able to be zero as both 'available' and '_sherAmountWant' will be bigger than 0
139     sherAmount = available < _sherAmountWant ? available : _sherAmountWant;
140     // Only allows SHER amounts with certain precision steps
141     // To ensure there is no rounding error at loss for the contract in stake / price calculation
142     // Theoretically, if `available` is used, the function can fail if '% SHER_STEPS != 0' will be true
143     // This can be caused by a griefer sending a small amount of SHER to the contract
144     // Realistically, no SHER tokens will be on the market when this function is active
145     // So it can only be caused if the admin sends too small amounts (documented at top of file with @dev)
146     if (sherAmount % SHER_STEPS != 0) revert InvalidAmount();
147 
148     // Calculate how much USDC needs to be staked to buy `sherAmount`
149     stake = (sherAmount * stakeRate) / SHER_DECIMALS;
150     // Calculate how much USDC needs to be paid to buy `sherAmount`
151     price = (sherAmount * buyRate) / SHER_DECIMALS;
152   }
153 
154   /// @notice Buy up until `_sherAmountWant`
155   /// @param _sherAmountWant The maximum amount of SHER the user wants to buy
156   /// @dev Bought SHER tokens are moved to a timelock contract (SherClaim)
157   /// @dev Will revert if liquidity event is inactive because of the viewCapitalRequirements call
158   function execute(uint256 _sherAmountWant) external nonReentrant {
159     // Calculate the capital requirements
160     // Check how much SHER can actually be bought
161     (uint256 sherAmount, uint256 stake, uint256 price) = viewCapitalRequirements(_sherAmountWant);
162 
163     // Transfer usdc from user to this, for staking (max is approved in constructor)
164     usdc.safeTransferFrom(msg.sender, address(this), stake);
165     // Transfer usdc from user to receiver, for payment of the SHER
166     usdc.safeTransferFrom(msg.sender, receiver, price);
167 
168     // Stake usdc and send NFT to user
169     sherlockPosition.initialStake(stake, PERIOD, msg.sender);
170     // Increase allowance for SherClaim by the amount of SHER tokens bought
171     sher.safeIncreaseAllowance(address(sherClaim), sherAmount);
172     // Add bought SHER tokens to timelock for user
173     sherClaim.add(msg.sender, sherAmount);
174 
175     // Emit event about the purchase
176     emit Purchase(msg.sender, sherAmount, stake, price);
177   }
178 
179   /// @notice Rescue remaining ERC20 tokens when liquidity event is inactive
180   /// @param _tokens Array of ERC20 tokens to rescue
181   /// @dev Can only be called by `receiver`
182   function sweepTokens(IERC20[] memory _tokens) external {
183     if (msg.sender != receiver) revert InvalidSender();
184     if (active()) revert InvalidState();
185 
186     // Loops through the extra tokens (ERC20) provided and sends all of them to the sender address
187     for (uint256 i; i < _tokens.length; i++) {
188       IERC20 token = _tokens[i];
189       token.safeTransfer(msg.sender, token.balanceOf(address(this)));
190     }
191   }
192 }
