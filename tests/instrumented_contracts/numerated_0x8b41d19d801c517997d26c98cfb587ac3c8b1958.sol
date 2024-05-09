1 // solhint-disable max-line-length
2 // @title A contract to store settings as uint values.
3 
4 /* Deployment:
5 Owner: 0x33a7ae7536d39032e16b0475aef6692a09727fe2
6 Owner Ropsten testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
7 Owner private testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
8 Address: 0x8b41d19d801c517997d26c98cfb587ac3c8b1958
9 Address Ropsten testnet: 0x46c0f19e3b7f2dbcc7787d0a854e363c42c29338
10 Address private testnet: 0x52fc489a53c42d29ef1286af62048f60c39b912e
11 ABI: [{"constant":false,"inputs":[{"name":"_version","type":"uint256"},{"name":"_field","type":"uint256"},{"name":"_value","type":"uint256"},{"name":"_dataInfo","type":"string"}],"name":"add","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"settings","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_field","type":"uint256"}],"name":"get","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"contentCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"version","type":"uint256"},{"indexed":true,"name":"timePage","type":"uint256"},{"indexed":true,"name":"field","type":"uint256"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":false,"name":"dataInfo","type":"string"}],"name":"Setting","type":"event"}]
12 Optimized: yes
13 Solidity version: v0.4.24
14 */
15 
16 // solhint-enable max-line-length
17 
18 pragma solidity 0.4.24;
19 
20 
21 contract Settings {
22 
23     address public owner;
24 
25     uint public contentCount = 0;
26  
27     // our settings
28     mapping (uint => uint) public settings;
29     
30     event Setting(uint indexed version, uint indexed timePage, uint indexed field, uint value, string dataInfo);
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36     
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     // @notice fallback function, don't allow call to it
42     function () public {
43         revert();
44     }
45     
46     function kill() public onlyOwner {
47         selfdestruct(owner);
48     }
49 
50     function add(uint _version, uint _field, uint _value, string _dataInfo) public onlyOwner {
51         contentCount++;
52         settings[_field] = _value;
53         emit Setting(_version, block.timestamp / (1 days), _field, _value, _dataInfo);
54     }
55 
56     function get(uint _field) public constant returns (uint) {
57         return settings[_field];
58     }
59 }