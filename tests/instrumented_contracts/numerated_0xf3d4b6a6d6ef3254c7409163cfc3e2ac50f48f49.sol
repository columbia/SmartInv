1 // solhint-disable max-line-length
2 // @title A contract to feed uBBT price in wei. Notice: price for 1 BBT fraction (uBBT). Should multiply to 
3 // 10^decimals to get the real 1 BBT price.
4 
5 /* Deployment:
6 Owner: 0x33a7ae7536d39032e16b0475aef6692a09727fe2
7 Owner Ropsten testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
8 Owner private testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
9 Address: 0xf3d4b6a6d6ef3254c7409163cfc3e2ac50f48f49
10 Address Ropsten testnet: 0x8e3dac11beb621ac398a87171c59502447734e76
11 Address private testnet: 0x12816f78d062c22fb35c98ba3082409a176cb435
12 ABI: [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_version","type":"uint256"},{"name":"_fee","type":"uint256"},{"name":"_dataInfo","type":"string"}],"name":"add","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"contentCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"fee","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"version","type":"uint256"},{"indexed":true,"name":"timePage","type":"uint256"},{"indexed":true,"name":"payment","type":"uint256"},{"indexed":false,"name":"dataInfo","type":"string"}],"name":"Feed","type":"event"}]
13 Optimized: yes
14 Solidity version: v0.4.24
15 */
16 
17 // solhint-enable max-line-length
18 
19 pragma solidity 0.4.24;
20 
21 
22 contract FeedBbt {
23 
24     address public owner;
25 
26     uint public contentCount = 0;
27     uint public fee = 1;
28     
29     event Feed(uint indexed version, uint indexed timePage, uint indexed payment, string dataInfo);
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35     
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     // @notice fallback function, don't allow call to it
41     function () public {
42         revert();
43     }
44     
45     function kill() public onlyOwner {
46         selfdestruct(owner);
47     }
48 
49     function add(uint _version, uint _fee, string _dataInfo) public onlyOwner {
50         contentCount++;
51         fee = _fee;
52         emit Feed(_version, block.timestamp / (1 days), _fee, _dataInfo);
53     }
54 }