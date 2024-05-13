1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {BalancerGaugeStaker} from "./BalancerGaugeStaker.sol";
5 import {IVotingEscrowDelegation} from "./IVotingEscrowDelegation.sol";
6 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
7 
8 /// @title Vote-escrowed boost Manager for Balancer
9 /// Used to manage delegation of vote-escrow boost as in Curve Protocol.
10 /// @author eswak
11 contract BalancerGaugeStakerV2 is BalancerGaugeStaker, Ownable {
12     // events
13     event VotingEscrowDelegationChanged(address indexed oldAddress, address indexed newAddress);
14 
15     /// @notice Balancer gauge staker
16     /// @param _core Fei Core for reference
17     constructor(
18         address _core,
19         address _gaugeController,
20         address _balancerMinter
21     ) BalancerGaugeStaker(_core, _gaugeController, _balancerMinter) {}
22 
23     /// @notice The token address
24     address public votingEscrowDelegation;
25 
26     /// @notice to initialize state variables in the proxy
27     function _initialize(address _owner, address _votingEscrowDelegation) external {
28         address currentOwner = owner();
29         require(currentOwner == address(0) || msg.sender == currentOwner, "ALREADY_INITIALIZED");
30         if (currentOwner != _owner) _transferOwnership(_owner);
31         votingEscrowDelegation = _votingEscrowDelegation;
32     }
33 
34     /// @notice Set the contract used to manage boost delegation
35     /// @dev the call is gated to the same role as the role to manage veTokens
36     function setVotingEscrowDelegation(address newVotingEscrowDelegation) public onlyOwner {
37         emit VotingEscrowDelegationChanged(votingEscrowDelegation, newVotingEscrowDelegation);
38         votingEscrowDelegation = newVotingEscrowDelegation;
39     }
40 
41     /// @notice Create a boost and delegate it to another account.
42     function create_boost(
43         address _delegator,
44         address _receiver,
45         int256 _percentage,
46         uint256 _cancel_time,
47         uint256 _expire_time,
48         uint256 _id
49     ) external onlyOwner {
50         IVotingEscrowDelegation(votingEscrowDelegation).create_boost(
51             _delegator,
52             _receiver,
53             _percentage,
54             _cancel_time,
55             _expire_time,
56             _id
57         );
58     }
59 
60     /// @notice Extend the boost of an existing boost or expired boost
61     function extend_boost(
62         uint256 _token_id,
63         int256 _percentage,
64         uint256 _expire_time,
65         uint256 _cancel_time
66     ) external onlyOwner {
67         IVotingEscrowDelegation(votingEscrowDelegation).extend_boost(
68             _token_id,
69             _percentage,
70             _expire_time,
71             _cancel_time
72         );
73     }
74 
75     /// @notice Cancel an outstanding boost
76     function cancel_boost(uint256 _token_id) external onlyOwner {
77         IVotingEscrowDelegation(votingEscrowDelegation).cancel_boost(_token_id);
78     }
79 
80     /// @notice Destroy a token
81     function burn(uint256 _token_id) external onlyOwner {
82         IVotingEscrowDelegation(votingEscrowDelegation).burn(_token_id);
83     }
84 }
