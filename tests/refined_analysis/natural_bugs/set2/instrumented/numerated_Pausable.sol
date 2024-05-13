1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "./Owned.sol";
6 
7 
8 abstract contract Pausable is Owned {
9     bool public paused;
10 
11     constructor() {
12         // This contract is abstract, and thus cannot be instantiated directly
13         require(owner() != address(0), "Owner must be set");
14         // Paused will be false
15     }
16 
17     /**
18      * @notice Change the paused state of the contract
19      * @dev Only the contract owner may call this.
20      */
21     function setPaused(bool _paused) external onlyOwner {
22         // Ensure we're actually changing the state before we do anything
23         if (_paused == paused) {
24             return;
25         }
26 
27         // Set our paused state.
28         paused = _paused;
29 
30         // Let everyone know that our pause state has changed.
31         emit PauseChanged(paused);
32     }
33 
34     event PauseChanged(bool isPaused);
35 
36     modifier notPaused {
37         require(!paused, "This action cannot be performed while the contract is paused");
38         _;
39     }
40 }
