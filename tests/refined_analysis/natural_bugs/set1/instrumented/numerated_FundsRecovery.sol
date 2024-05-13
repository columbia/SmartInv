1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 import { IERC20Token } from "./interfaces/IERC20Token.sol";
5 import { Ownable } from "./Ownable.sol";
6 import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
7 
8 contract FundsRecovery is Ownable, ReentrancyGuard {
9     address payable internal fundsDestination;
10     IERC20Token public token;
11 
12     event DestinationChanged(address indexed previousDestination, address indexed newDestination);
13 
14     /**
15      * Setting new destination of funds recovery.
16      */
17     function setFundsDestination(address payable _newDestination) public virtual onlyOwner {
18         require(_newDestination != address(0));
19         emit DestinationChanged(fundsDestination, _newDestination);
20         fundsDestination = _newDestination;
21     }
22 
23     /**
24      * Getting funds destination address.
25      */
26     function getFundsDestination() public view returns (address) {
27         return fundsDestination;
28     }
29 
30     /**
31      * Possibility to recover funds in case they were sent to this address before smart contract deployment
32      */
33     function claimNativeCoin() public nonReentrant {
34         require(fundsDestination != address(0));
35         fundsDestination.transfer(address(this).balance);
36     }
37 
38     /**
39        Transfers selected tokens into owner address.
40     */
41     function claimTokens(address _token) public nonReentrant {
42         require(fundsDestination != address(0));
43         require(_token != address(token), "native token funds can't be recovered");
44         uint256 _amount = IERC20Token(_token).balanceOf(address(this));
45         IERC20Token(_token).transfer(fundsDestination, _amount);
46     }
47 }
