1 // solhint-disable max-line-length
2 // @title A contract to store a hash for each client. Allows only one hash per user.
3 
4 /* Deployment:
5 Owner: 0x33a7ae7536d39032e16b0475aef6692a09727fe2
6 Owner Ropsten testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
7 Owner private testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
8 
9 [IPFS listings]
10 Address: 0xbfaab10b1d4b79b3380d3f4247675606d219adc3
11 Address Ropsten testnet: 0xe844b58ae5633f0d5096769f16ad181ada71ef71
12 Address private testnet: 0x651f84de4d523a59d5763699d68e7e79422297ba
13 
14 [Storenames]
15 Address:
16 Address Ropsten testnet: 0x37925cfb05aec6333b8cb2d0d1ae68ccfe6a22ba
17 Address private testnet:
18 
19 ABI: [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_version","type":"uint256"},{"name":"_dataInfo","type":"string"}],"name":"add","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_version","type":"uint256"},{"name":"_dataInfo","type":"string"}],"name":"remove","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"contentCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"version","type":"uint256"},{"indexed":true,"name":"sender","type":"address"},{"indexed":true,"name":"timePage","type":"uint256"},{"indexed":false,"name":"eventType","type":"uint16"},{"indexed":false,"name":"dataInfo","type":"string"}],"name":"LogStore","type":"event"}]
20 Optimized: yes
21 Solidity version: v0.4.24
22 */
23 
24 // solhint-enable max-line-length
25 
26 pragma solidity 0.4.24;
27 
28 
29 contract Store2 {
30 
31     //enum EventTypes
32     uint16 constant internal NONE = 0;
33     uint16 constant internal ADD = 1;
34     uint16 constant internal REMOVE = 2;
35 
36     address public owner;
37     uint public contentCount = 0;
38     
39     event LogStore(uint indexed version, address indexed sender, uint indexed timePage,
40         uint16 eventType, string dataInfo);
41 
42     modifier onlyOwner {
43 
44         require(msg.sender == owner);
45         _;
46     }
47     
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     // @notice fallback function, don't allow call to it
53     function () public {
54 
55         revert();
56     }
57 
58     function kill() public onlyOwner {
59 
60         selfdestruct(owner);
61     }
62 
63     function add(uint _version, string _dataInfo) public {
64 
65         contentCount++;
66         emit LogStore(_version, msg.sender, block.timestamp / (1 days), ADD, _dataInfo);
67     }
68 
69     function remove(uint _version, string _dataInfo) public {
70 
71         contentCount++;
72         emit LogStore(_version, msg.sender, block.timestamp / (1 days), REMOVE, _dataInfo);
73     }
74 }