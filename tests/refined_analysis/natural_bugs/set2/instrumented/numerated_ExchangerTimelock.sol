1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 
7 interface IExchanger {
8     function exchange(uint256 amount) external;
9 }
10 
11 /** 
12  @title Send RGT straight to TRIBE timelock
13  @author Joey Santoro
14  @notice For Rari core contributors to trustlessly maintain incentive alignment
15 */
16 contract ExchangerTimelock is Ownable {
17     using SafeERC20 for IERC20;
18 
19     IExchanger public immutable exchanger;
20     address public immutable timelock;
21 
22     /// @notice rari DAO timelock can clawback in event of no-deal
23     address public constant guardian = 0x8ace03Fc45139fDDba944c6A4082b604041d19FC;
24 
25     IERC20 public constant rgt = IERC20(0xD291E7a03283640FDc51b121aC401383A46cC623);
26     IERC20 public constant tribe = IERC20(0xc7283b66Eb1EB5FB86327f08e1B5816b0720212B);
27 
28     constructor(IExchanger _exchanger, address _timelock) {
29         exchanger = _exchanger;
30         timelock = _timelock;
31     }
32 
33     /// @notice exchange RGT to TRIBE and send to timelock
34     function exchangeToTimelock() external {
35         uint256 rgtBalance = rgt.balanceOf(address(this));
36 
37         rgt.approve(address(exchanger), rgtBalance);
38         exchanger.exchange(rgtBalance);
39 
40         assert(rgt.balanceOf(address(this)) == 0);
41 
42         tribe.safeTransfer(timelock, tribe.balanceOf(address(this)));
43 
44         assert(tribe.balanceOf(address(this)) == 0);
45     }
46 
47     /// @notice guardian sends back RGT
48     function recoverRGT() external {
49         require(msg.sender == guardian);
50         rgt.transfer(owner(), rgt.balanceOf(address(this)));
51     }
52 }
