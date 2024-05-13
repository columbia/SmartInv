1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "./MergerBase.sol";
5 
6 /**
7  @title Contract to exchange RGT with TRIBE post-merger
8  @author elee, Joey Santoro
9  @notice allows for exchange from RGT to TRIBE post-merger
10  Includes an expiry window intitially unset, with a minimum duration
11 */
12 contract PegExchanger is MergerBase {
13     using SafeERC20 for IERC20;
14 
15     /// @notice minimum amount of notice an RGT holder would have to exchange before expiring
16     uint256 public constant MIN_EXPIRY_WINDOW = 180 days;
17 
18     /// @notice the multiplier applied to RGT before converting to TRIBE scaled up by 1e9
19     uint256 public constant exchangeRate = 26705673430; // 26.7 TRIBE / RGT
20 
21     /// @notice the last epoch timestam an exchange can occur
22     /// @dev settable by governance
23     uint256 public expirationTimestamp = type(uint256).max;
24 
25     event Exchange(address indexed from, uint256 amountIn, uint256 amountOut);
26     event SetExpiry(address indexed caller, uint256 expiry);
27 
28     constructor(address tribeRariDAO) MergerBase(tribeRariDAO) {}
29 
30     /// @notice call to exchange held RGT with TRIBE
31     /// @param amount the amount to exchange
32     function exchange(uint256 amount) public {
33         require(!isExpired(), "Redemption period is over");
34         require(bothPartiesAccepted, "Proposals are not both passed");
35         uint256 tribeOut = (amount * exchangeRate) / scalar;
36         rgt.safeTransferFrom(msg.sender, address(this), amount);
37         tribe.safeTransfer(msg.sender, tribeOut);
38         emit Exchange(msg.sender, amount, tribeOut);
39     }
40 
41     /// @notice tells whether or not the contract is expired.
42     /// @return boolean true if we have passed the expiration block, else false
43     function isExpired() public view returns (bool) {
44         return block.timestamp > expirationTimestamp;
45     }
46 
47     // Admin function
48 
49     /// @param timestamp  the block timestamp for expiration
50     /// @notice the expiry must be set to at least MIN_EXPIRY_WINDOW in the future.
51     function setExpirationTimestamp(uint256 timestamp) public {
52         require(msg.sender == tribeTimelock, "Only the tribe timelock may call this function");
53         require(timestamp > (block.timestamp + MIN_EXPIRY_WINDOW), "timestamp too low");
54         require(bothPartiesAccepted == true, "Contract must be enabled before admin functions called");
55         expirationTimestamp = timestamp;
56         emit SetExpiry(msg.sender, timestamp);
57     }
58 }
