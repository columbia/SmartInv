1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "./LinearTokenTimelock.sol";
6 
7 interface IVotingToken is IERC20 {
8     function delegate(address delegatee) external;
9 }
10 
11 /// @title a timelock for tokens allowing for bulk delegation
12 /// @author Fei Protocol
13 /// @notice allows the timelocked tokens to be delegated by the beneficiary while locked
14 contract LinearTimelockedDelegator is LinearTokenTimelock {
15     /// @notice LinearTimelockedDelegator constructor
16     /// @param _beneficiary admin, and timelock beneficiary
17     /// @param _duration duration of the token timelock window
18     /// @param _token the token address
19     /// @param _cliff the seconds before first claim is allowed
20     /// @param _clawbackAdmin the address which can trigger a clawback
21     /// @param _startTime the unix epoch for starting timelock. Use 0 to start at deployment
22     constructor(
23         address _beneficiary,
24         uint256 _duration,
25         address _token,
26         uint256 _cliff,
27         address _clawbackAdmin,
28         uint256 _startTime
29     ) LinearTokenTimelock(_beneficiary, _duration, _token, _cliff, _clawbackAdmin, _startTime) {}
30 
31     /// @notice accept beneficiary role over timelocked TRIBE
32     /// @dev _setBeneficiary internal call checks msg.sender == pendingBeneficiary
33     function acceptBeneficiary() public override {
34         _setBeneficiary(msg.sender);
35     }
36 
37     /// @notice delegate all held TRIBE to the `to` address
38     function delegate(address to) public onlyBeneficiary {
39         IVotingToken(address(lockedToken)).delegate(to);
40     }
41 }
