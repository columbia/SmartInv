1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity ^0.8.14;
3 
4 interface Weth {
5     function withdraw(uint256 _wad) external;
6 
7     function transferFrom(
8         address _from,
9         address _to,
10         uint256 _wad
11     ) external;
12 }
13 
14 interface ovmL1Bridge {
15     function depositETHTo(
16         address _to,
17         uint32 _l2Gas,
18         bytes calldata _data
19     ) external payable;
20 }
21 
22 interface PolygonL1Bridge {
23     function depositEtherFor(address _to) external payable;
24 }
25 
26 /**
27  * @notice Contract deployed on Ethereum helps relay bots atomically unwrap and bridge WETH over the canonical chain
28  * bridges for Optimism, Boba and Polygon. Needed as these chains only support bridging of ETH, not WETH.
29  */
30 
31 contract AtomicDepositor {
32     Weth weth = Weth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
33     ovmL1Bridge optimismL1Bridge = ovmL1Bridge(0x99C9fc46f92E8a1c0deC1b1747d010903E884bE1);
34     ovmL1Bridge bobaL1Bridge = ovmL1Bridge(0xdc1664458d2f0B6090bEa60A8793A4E66c2F1c00);
35     PolygonL1Bridge polygonL1Bridge = PolygonL1Bridge(0xA0c68C638235ee32657e8f720a23ceC1bFc77C77);
36 
37     function bridgeWethToOvm(
38         address to,
39         uint256 amount,
40         uint32 l2Gas,
41         uint256 chainId
42     ) public {
43         require(chainId == 10 || chainId == 288, "Can only bridge to Optimism Or boba");
44         weth.transferFrom(msg.sender, address(this), amount);
45         weth.withdraw(amount);
46         (chainId == 10 ? optimismL1Bridge : bobaL1Bridge).depositETHTo{ value: amount }(to, l2Gas, "");
47     }
48 
49     function bridgeWethToPolygon(address to, uint256 amount) public {
50         weth.transferFrom(msg.sender, address(this), amount);
51         weth.withdraw(amount);
52         polygonL1Bridge.depositEtherFor{ value: amount }(to);
53     }
54 
55     fallback() external payable {}
56 
57     receive() external payable {}
58 }