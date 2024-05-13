1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "./Owned.sol";
6 
7 // https://docs.synthetix.io/contracts/SelfDestructible
8 abstract contract SelfDestructible is Owned {
9     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
10 
11     uint public initiationTime;
12     bool public selfDestructInitiated;
13 
14     address public selfDestructBeneficiary;
15 
16     constructor() {
17         // This contract is abstract, and thus cannot be instantiated directly
18         require(owner() != address(0), "Owner must be set");
19         selfDestructBeneficiary = owner();
20         emit SelfDestructBeneficiaryUpdated(owner());
21     }
22 
23     /**
24      * @notice Set the beneficiary address of this contract.
25      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
26      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
27      */
28     function setSelfDestructBeneficiary(address payable _beneficiary) external onlyOwner {
29         require(_beneficiary != address(0), "Beneficiary must not be zero");
30         selfDestructBeneficiary = _beneficiary;
31         emit SelfDestructBeneficiaryUpdated(_beneficiary);
32     }
33 
34     /**
35      * @notice Begin the self-destruction counter of this contract.
36      * Once the delay has elapsed, the contract may be self-destructed.
37      * @dev Only the contract owner may call this.
38      */
39     function initiateSelfDestruct() external onlyOwner {
40         initiationTime = block.timestamp;
41         selfDestructInitiated = true;
42         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
43     }
44 
45     /**
46      * @notice Terminate and reset the self-destruction timer.
47      * @dev Only the contract owner may call this.
48      */
49     function terminateSelfDestruct() external onlyOwner {
50         initiationTime = 0;
51         selfDestructInitiated = false;
52         emit SelfDestructTerminated();
53     }
54 
55     /**
56      * @notice If the self-destruction delay has elapsed, destroy this contract and
57      * remit any ether it owns to the beneficiary address.
58      * @dev Only the contract owner may call this.
59      */
60     function selfDestruct() external onlyOwner {
61         require(selfDestructInitiated, "Self Destruct not yet initiated");
62         require(initiationTime + SELFDESTRUCT_DELAY < block.timestamp, "Self destruct delay not met");
63         emit SelfDestructed(selfDestructBeneficiary);
64         selfdestruct(address(uint160(selfDestructBeneficiary)));
65     }
66 
67     event SelfDestructTerminated();
68     event SelfDestructed(address beneficiary);
69     event SelfDestructInitiated(uint selfDestructDelay);
70     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
71 }
