1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../interfaces/IBabyBaseRouter.sol";
7 import "../libraries/SafeMath.sol";
8 
9 contract BabyBaseRouter is IBabyBaseRouter, Ownable {
10     using SafeMath for uint;
11 
12     address public immutable override factory;
13     address public immutable override WETH;
14     address public override swapMining;
15     address public override routerFeeReceiver;
16 
17     modifier ensure(uint deadline) {
18         require(deadline >= block.timestamp, 'BabyRouter: EXPIRED');
19         _;
20     }
21 
22     function setSwapMining(address _swapMininng) public onlyOwner {
23         swapMining = _swapMininng;
24     }
25     
26     function setRouterFeeReceiver(address _receiver) public onlyOwner {
27         routerFeeReceiver = _receiver;
28     }
29 
30     constructor(address _factory, address _WETH, address _swapMining, address _routerFeeReceiver) {
31         factory = _factory;
32         WETH = _WETH;
33         swapMining = _swapMining;
34         routerFeeReceiver = _routerFeeReceiver;
35     }
36 
37     receive() external payable {
38         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
39     }
40 }
