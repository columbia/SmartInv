1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 import {CoreRef} from "../refs/CoreRef.sol";
4 import {TribeRoles} from "../core/TribeRoles.sol";
5 
6 /// @title Metadata registry for Pods
7 /// @notice Exposes a single public state changing method that should be called as part of a Pods proposal
8 /// @dev Expected that a call is made to this GovernanceMetadataRegistry contract as the first function call in a proposal
9 ///      submitted to a pod
10 contract GovernanceMetadataRegistry is CoreRef {
11     /// @notice Mapping identifying whether a particular proposal metadata was submitted for registration
12     /// @dev Maps the hash of the proposal metadata to a bool identifying if it was submitted
13     mapping(bytes32 => bool) public registration;
14 
15     /// @notice Event that logs the metadata associated with a pod proposal
16     event RegisterProposal(uint256 indexed podId, uint256 indexed proposalId, string metadata);
17 
18     constructor(address _core) CoreRef(_core) {}
19 
20     /// @notice Get whether a pod proposal has been registered
21     /// @param podId Unique identifier of the pod for which metadata is being registered
22     /// @param proposalId Unique identifier of the proposal for which metadata is being registered
23     /// @param metadata Proposal metadata
24     function isProposalRegistered(
25         uint256 podId,
26         uint256 proposalId,
27         string memory metadata
28     ) external view returns (bool) {
29         bytes32 proposalHash = keccak256(abi.encode(podId, proposalId, metadata));
30         return registration[proposalHash];
31     }
32 
33     /// @notice Register a pod proposal. Specifically used as a layer ontop of a Gnosis safe to emit
34     ///         proposal metadata
35     /// @param podId Unique identifier of the pod for which metadata is being registered
36     /// @param proposalId Unique identifier of the proposal for which metadata is being registered
37     /// @param metadata Proposal metadata
38     function registerProposal(
39         uint256 podId,
40         uint256 proposalId,
41         string memory metadata
42     ) external onlyTribeRole(TribeRoles.POD_METADATA_REGISTER_ROLE) {
43         require(bytes(metadata).length > 0, "Metadata must be non-empty");
44 
45         bytes32 proposalHash = keccak256(abi.encode(podId, proposalId, metadata));
46         require(registration[proposalHash] == false, "Proposal already registered");
47         registration[proposalHash] = true;
48         emit RegisterProposal(podId, proposalId, metadata);
49     }
50 }
