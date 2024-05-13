1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 import "../interfaces/IERCHandler.sol";
5 
6 /**
7     @title Function used across handler contracts.
8     @author ChainSafe Systems.
9     @notice This contract is intended to be used with the Bridge contract.
10  */
11 contract HandlerHelpers is IERCHandler {
12     address public immutable _bridgeAddress;
13 
14     // resourceID => token contract address
15     mapping (bytes32 => address) public _resourceIDToTokenContractAddress;
16 
17     // token contract address => resourceID
18     mapping (address => bytes32) public _tokenContractAddressToResourceID;
19 
20     // token contract address => is whitelisted
21     mapping (address => bool) public _contractWhitelist;
22 
23     // token contract address => is burnable
24     mapping (address => bool) public _burnList;
25 
26     modifier onlyBridge() {
27         _onlyBridge();
28         _;
29     }
30     
31     /**
32         @param bridgeAddress Contract address of previously deployed Bridge.
33      */
34     constructor(
35         address          bridgeAddress
36     ) public {
37         _bridgeAddress = bridgeAddress;
38     }
39 
40     function _onlyBridge() private view {
41         require(msg.sender == _bridgeAddress, "sender must be bridge contract");
42     }
43 
44     /**
45         @notice First verifies {_resourceIDToContractAddress}[{resourceID}] and
46         {_contractAddressToResourceID}[{contractAddress}] are not already set,
47         then sets {_resourceIDToContractAddress} with {contractAddress},
48         {_contractAddressToResourceID} with {resourceID},
49         and {_contractWhitelist} to true for {contractAddress}.
50         @param resourceID ResourceID to be used when making deposits.
51         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
52      */
53     function setResource(bytes32 resourceID, address contractAddress) external override onlyBridge {
54 
55         _setResource(resourceID, contractAddress);
56     }
57 
58     /**
59         @notice First verifies {contractAddress} is whitelisted, then sets {_burnList}[{contractAddress}]
60         to true.
61         @param contractAddress Address of contract to be used when making or executing deposits.
62      */
63     function setBurnable(address contractAddress) external override onlyBridge{
64         _setBurnable(contractAddress);
65     }
66 
67     function withdraw(bytes memory data) external virtual override {}
68 
69     function _setResource(bytes32 resourceID, address contractAddress) internal {
70         _resourceIDToTokenContractAddress[resourceID] = contractAddress;
71         _tokenContractAddressToResourceID[contractAddress] = resourceID;
72 
73         _contractWhitelist[contractAddress] = true;
74     }
75 
76     function _setBurnable(address contractAddress) internal {
77         require(_contractWhitelist[contractAddress], "provided contract is not whitelisted");
78         _burnList[contractAddress] = true;
79     }
80 }
