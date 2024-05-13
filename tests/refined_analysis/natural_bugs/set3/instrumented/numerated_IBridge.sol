1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 /**
5     @title Interface for Bridge contract.
6     @author ChainSafe Systems.
7  */
8 interface IBridge {
9     /**
10         @notice Exposing getter for {_domainID} instead of forcing the use of call.
11         @return uint8 The {_domainID} that is currently set for the Bridge contract.
12      */
13     function _domainID() external returns (uint8);
14 }