1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IRegistryProvider.sol";
6 import '@openzeppelin/contracts/utils/introspection/IERC165.sol';
7 
8 /**
9  * @title Provider interface for Revest FNFTs
10  * @dev Address locks MUST be non-upgradeable to be considered for trusted status
11  * @author Revest
12  */
13 interface IAddressLock is IRegistryProvider, IERC165{
14 
15     /// Creates a lock to the specified lockID
16     /// @param fnftId the fnftId to map this lock to. Not recommended for typical locks, as it will break on splitting
17     /// @param lockId the lockId to map this lock to. Recommended uint for storing references to lock configurations
18     /// @param arguments an abi.encode() bytes array. Allows frontend to encode and pass in an arbitrary set of parameters
19     /// @dev creates a lock for the specified lockId. Will be called during the creation process for address locks when the address
20     ///      of a contract implementing this interface is passed in as the "trigger" address for minting an address lock. The bytes
21     ///      representing any parameters this lock requires are passed through to this method, where abi.decode must be call on them
22     function createLock(uint fnftId, uint lockId, bytes memory arguments) external;
23 
24     /// Updates a lock at the specified lockId
25     /// @param fnftId the fnftId that can map to a lock config stored in implementing contracts. Not recommended, as it will break on splitting
26     /// @param lockId the lockId that maps to the lock config which should be updated. Recommended for retrieving references to lock configurations
27     /// @param arguments an abi.encode() bytes array. Allows frontend to encode and pass in an arbitrary set of parameters
28     /// @dev updates a lock for the specified lockId. Will be called by the frontend from the information section if an update is requested
29     ///      can further accept and decode parameters to use in modifying the lock's config or triggering other actions
30     ///      such as triggering an on-chain oracle to update
31     function updateLock(uint fnftId, uint lockId, bytes memory arguments) external;
32 
33     /// Whether or not the lock can be unlocked
34     /// @param fnftId the fnftId that can map to a lock config stored in implementing contracts. Not recommended, as it will break on splitting
35     /// @param lockId the lockId that maps to the lock config which should be updated. Recommended for retrieving references to lock configurations
36     /// @dev this method is called during the unlocking and withdrawal processes by the Revest contract - it is also used by the frontend
37     ///      if this method is returning true and someone attempts to unlock or withdraw from an FNFT attached to the requested lock, the request will succeed
38     /// @return whether or not this lock may be unlocked
39     function isUnlockable(uint fnftId, uint lockId) external view returns (bool);
40 
41     /// Provides an encoded bytes arary that represents values this lock wants to display on the info screen
42     /// Info to decode these values is provided in the metadata file
43     /// @param fnftId the fnftId that can map to a lock config stored in implementing contracts. Not recommended, as it will break on splitting
44     /// @param lockId the lockId that maps to the lock config which should be updated. Recommended for retrieving references to lock configurations
45     /// @dev used by the frontend to fetch on-chain data on the state of any given lock
46     /// @return a bytes array that represents the result of calling abi.encode on values which the developer wants to appear on the frontend
47     function getDisplayValues(uint fnftId, uint lockId) external view returns (bytes memory);
48 
49     /// Maps to a URL, typically IPFS-based, that contains information on how to encode and decode paramters sent to and from this lock
50     /// Please see additional documentation for JSON config info
51     /// @dev this method will be called by the frontend only but is crucial to properly implement for proper minting and information workflows
52     /// @return a URL to the JSON file containing this lock's metadata schema
53     function getMetadata() external view returns (string memory);
54 
55     /// Whether or not this lock will need updates and should display the option for them
56     /// @dev this will be called by the frontend to determine if update inputs and buttons should be displayed
57     /// @return whether or not the locks created by this contract will need updates
58     function needsUpdate() external view returns (bool);
59 }
