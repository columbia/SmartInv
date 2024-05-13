1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { CannotAuthoriseSelf, UnAuthorized } from "../Errors/GenericErrors.sol";
5 
6 /// @title Access Library
7 /// @author LI.FI (https://li.fi)
8 /// @notice Provides functionality for managing method level access control
9 library LibAccess {
10     /// Types ///
11     bytes32 internal constant NAMESPACE =
12         keccak256("com.lifi.library.access.management");
13 
14     /// Storage ///
15     struct AccessStorage {
16         mapping(bytes4 => mapping(address => bool)) execAccess;
17     }
18 
19     /// Events ///
20     event AccessGranted(address indexed account, bytes4 indexed method);
21     event AccessRevoked(address indexed account, bytes4 indexed method);
22 
23     /// @dev Fetch local storage
24     function accessStorage()
25         internal
26         pure
27         returns (AccessStorage storage accStor)
28     {
29         bytes32 position = NAMESPACE;
30         // solhint-disable-next-line no-inline-assembly
31         assembly {
32             accStor.slot := position
33         }
34     }
35 
36     /// @notice Gives an address permission to execute a method
37     /// @param selector The method selector to execute
38     /// @param executor The address to grant permission to
39     function addAccess(bytes4 selector, address executor) internal {
40         if (executor == address(this)) {
41             revert CannotAuthoriseSelf();
42         }
43         AccessStorage storage accStor = accessStorage();
44         accStor.execAccess[selector][executor] = true;
45         emit AccessGranted(executor, selector);
46     }
47 
48     /// @notice Revokes permission to execute a method
49     /// @param selector The method selector to execute
50     /// @param executor The address to revoke permission from
51     function removeAccess(bytes4 selector, address executor) internal {
52         AccessStorage storage accStor = accessStorage();
53         accStor.execAccess[selector][executor] = false;
54         emit AccessRevoked(executor, selector);
55     }
56 
57     /// @notice Enforces access control by reverting if `msg.sender`
58     ///     has not been given permission to execute `msg.sig`
59     function enforceAccessControl() internal view {
60         AccessStorage storage accStor = accessStorage();
61         if (accStor.execAccess[msg.sig][msg.sender] != true)
62             revert UnAuthorized();
63     }
64 }
