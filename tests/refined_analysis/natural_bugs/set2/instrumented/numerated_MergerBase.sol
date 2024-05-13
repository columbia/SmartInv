1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "../dao/timelock/Timelock.sol";
6 
7 /** 
8  @title Base contract for merger logic
9  @author elee, Joey Santoro
10  @notice MergerBase is used by all merger contracts. 
11  It represents an "AND" gate on both DAOs accepting the contract, and Rari Timelock being owned by the specified DAO.
12 */
13 contract MergerBase {
14     event Accept(address indexed dao);
15     event Enabled(address indexed caller);
16 
17     /// @notice the granularity of the exchange rate
18     uint256 public constant scalar = 1e9;
19 
20     address public constant rgtTimelock = 0x8ace03Fc45139fDDba944c6A4082b604041d19FC;
21     address public constant tribeTimelock = 0xd51dbA7a94e1adEa403553A8235C302cEbF41a3c;
22 
23     bool public rgtAccepted;
24     bool public tribeAccepted;
25 
26     IERC20 public constant rgt = IERC20(0xD291E7a03283640FDc51b121aC401383A46cC623);
27     IERC20 public constant tribe = IERC20(0xc7283b66Eb1EB5FB86327f08e1B5816b0720212B);
28 
29     /// @notice the new DAO to assume governance for rgtTimelock
30     address public immutable tribeRariDAO;
31 
32     /// @notice tells whether or not both parties have accepted the deal
33     bool public bothPartiesAccepted;
34 
35     constructor(address _tribeRariDAO) {
36         tribeRariDAO = _tribeRariDAO;
37     }
38 
39     /// @notice function for the rari timelock to accept the deal
40     function rgtAccept() external {
41         require(msg.sender == rgtTimelock, "Only rari timelock");
42         rgtAccepted = true;
43         emit Accept(rgtTimelock);
44     }
45 
46     /// @notice function for the tribe timelock to accept the deal
47     function tribeAccept() external {
48         require(msg.sender == tribeTimelock, "Only tribe timelock");
49         tribeAccepted = true;
50         emit Accept(tribeTimelock);
51     }
52 
53     /// @notice make sure Tribe rari timelock is active
54     function setBothPartiesAccepted() external {
55         require(!bothPartiesAccepted, "already set");
56         require(Timelock(payable(rgtTimelock)).admin() == tribeRariDAO, "admin not accepted");
57         require(tribeAccepted, "Tribe DAO not yet accepted");
58         require(rgtAccepted, "Rari DAO not yet accepted");
59         bothPartiesAccepted = true;
60         emit Enabled(msg.sender);
61     }
62 }
