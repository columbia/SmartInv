1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { LibAccess } from "../Libraries/LibAccess.sol";
6 import { CannotAuthoriseSelf } from "../Errors/GenericErrors.sol";
7 
8 /// @title Access Manager Facet
9 /// @author LI.FI (https://li.fi)
10 /// @notice Provides functionality for managing method level access control
11 /// @custom:version 1.0.0
12 contract AccessManagerFacet {
13     /// Events ///
14 
15     event ExecutionAllowed(address indexed account, bytes4 indexed method);
16     event ExecutionDenied(address indexed account, bytes4 indexed method);
17 
18     /// External Methods ///
19 
20     /// @notice Sets whether a specific address can call a method
21     /// @param _selector The method selector to set access for
22     /// @param _executor The address to set method access for
23     /// @param _canExecute Whether or not the address can execute the specified method
24     function setCanExecute(
25         bytes4 _selector,
26         address _executor,
27         bool _canExecute
28     ) external {
29         if (_executor == address(this)) {
30             revert CannotAuthoriseSelf();
31         }
32         LibDiamond.enforceIsContractOwner();
33         _canExecute
34             ? LibAccess.addAccess(_selector, _executor)
35             : LibAccess.removeAccess(_selector, _executor);
36         if (_canExecute) {
37             emit ExecutionAllowed(_executor, _selector);
38         } else {
39             emit ExecutionDenied(_executor, _selector);
40         }
41     }
42 
43     /// @notice Check if a method can be executed by a specific address
44     /// @param _selector The method selector to check
45     /// @param _executor The address to check
46     function addressCanExecuteMethod(
47         bytes4 _selector,
48         address _executor
49     ) external view returns (bool) {
50         return LibAccess.accessStorage().execAccess[_selector][_executor];
51     }
52 }
