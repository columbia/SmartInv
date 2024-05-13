1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {ERC20} from "solmate/tokens/ERC20.sol";
5 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
6 import {Errors} from "./libraries/Errors.sol";
7 
8 /**
9  * @title DineroERC20
10  * @dev A Standard ERC20 token with minting and burning with access control.
11  * @author redactedcartel.finance
12  */
13 contract DineroERC20 is ERC20, AccessControlDefaultAdminRules {
14     // Roles
15     /**
16      * @dev Bytes32 constant representing the role to mint new tokens.
17      */
18     bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
19 
20     /**
21      * @dev Bytes32 constant representing the role to burn (destroy) tokens.
22      */
23     bytes32 private constant BURNER_ROLE = keccak256("BURNER_ROLE");
24 
25     /**
26      * @notice Constructor to initialize ERC20 token with access control.
27      * @param _name          string   Token name.
28      * @param _symbol        string   Token symbol.
29      * @param _decimals      uint8    Token decimals.
30      * @param _admin         address  Admin address.
31      * @param _initialDelay  uint48   Delay required to schedule the acceptance
32      *                                of an access control transfer started.
33      */
34     constructor(
35         string memory _name,
36         string memory _symbol,
37         uint8 _decimals,
38         address _admin,
39         uint48 _initialDelay
40     )
41         AccessControlDefaultAdminRules(_initialDelay, _admin)
42         ERC20(_name, _symbol, _decimals)
43     {
44         if (bytes(_name).length == 0) revert Errors.EmptyString();
45         if (bytes(_symbol).length == 0) revert Errors.EmptyString();
46         if (_decimals == 0) revert Errors.ZeroAmount();
47     }
48 
49     /**
50      * @notice Mints tokens to an address.
51      * @dev Only callable by minters.
52      * @param _to      address  Address to mint tokens to.
53      * @param _amount  uint256  Amount of tokens to mint.
54      */
55     function mint(address _to, uint256 _amount) external onlyRole(MINTER_ROLE) {
56         if (_to == address(0)) revert Errors.ZeroAddress();
57         if (_amount == 0) revert Errors.ZeroAmount();
58 
59         _mint(_to, _amount);
60     }
61 
62     /**
63      * @notice Burns tokens from an address.
64      * @dev Only callable by burners.
65      * @param _from    address  Address to burn tokens from.
66      * @param _amount  uint256  Amount of tokens to burn.
67      */
68     function burn(
69         address _from,
70         uint256 _amount
71     ) external onlyRole(BURNER_ROLE) {
72         if (_from == address(0)) revert Errors.ZeroAddress();
73         if (_amount == 0) revert Errors.ZeroAmount();
74 
75         _burn(_from, _amount);
76     }
77 }
