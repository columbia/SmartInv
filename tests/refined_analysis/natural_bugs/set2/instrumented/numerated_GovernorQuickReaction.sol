1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
5 
6 /**
7  * @dev Extension of {Governor} for quick reaction, whereby a proposal
8  *      is executed immediately once Quorum is reached.
9  */
10 abstract contract GovernorQuickReaction is Governor {
11     /// @notice Override state to achieve early execution
12     function state(uint256 proposalId) public view virtual override returns (ProposalState) {
13         ProposalState status = super.state(proposalId);
14 
15         // Check if proposal is marked as Active.
16         // If so, check if quorum has been reached and vote is successful
17         //   - if so, mark as Succeeded
18         // If quorum and vote are not achieved, but proposal is active just return
19         if (status == ProposalState.Active) {
20             if (_quorumReached(proposalId) && _voteSucceeded(proposalId)) {
21                 return ProposalState.Succeeded;
22             }
23         }
24         return status;
25     }
26 }
