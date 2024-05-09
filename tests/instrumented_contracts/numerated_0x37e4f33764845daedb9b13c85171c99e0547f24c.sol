1 // solhint-disable max-line-length
2 // @title A contract to store a list of messages. Obtainable as events.
3 
4 /* Deployment:
5 Owner: 0x33a7ae7536d39032e16b0475aef6692a09727fe2
6 Owner Ropsten testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
7 Owner private testnet: 0x4460f4c8edbca96f9db17ef95aaf329eddaeac29
8 Address: 0x37e4f33764845daedb9b13c85171c99e0547f24c
9 Address Ropsten testnet: 0x93f28d717011771aaa0e462bd7ee5c43c98819f2
10 Address private testnet: 0x3fb4de9f7a4fe40f10f04bc347c11c5ad9094029
11 ABI: [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"flush","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_version","type":"uint256"},{"name":"_eventType","type":"uint16"},{"name":"_timeSpan","type":"uint256"},{"name":"_dataInfo","type":"string"}],"name":"add","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenAddress","type":"address"}],"name":"flushToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"contentCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"version","type":"uint256"},{"indexed":true,"name":"sender","type":"address"},{"indexed":true,"name":"timePage","type":"uint256"},{"indexed":false,"name":"eventType","type":"uint16"},{"indexed":false,"name":"timeSpan","type":"uint256"},{"indexed":false,"name":"dataInfo","type":"string"}],"name":"LogStore","type":"event"}]
12 Optimized: yes
13 Solidity version: v0.4.24
14 */
15 
16 // solhint-enable max-line-length
17 
18 pragma solidity 0.4.24;
19 
20 
21 contract MiniMeToken {
22 
23     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _amount The amount of tokens to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _amount) public returns (bool success);
28 
29     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
30     ///  is approved by `_from`
31     /// @param _from The address holding the tokens being transferred
32     /// @param _to The address of the recipient
33     /// @param _amount The amount of tokens to be transferred
34     /// @return True if the transfer was successful
35     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
36 
37     /// @param _owner The address that's balance is being requested
38     /// @return The balance of `_owner` at the current block
39     function balanceOf(address _owner) public constant returns (uint256 balance);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
42     ///  its behalf. This is a modified version of the ERC20 approve function
43     ///  to be a little bit safer
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _amount The amount of tokens to be approved for transfer
46     /// @return True if the approval was successful
47     function approve(address _spender, uint256 _amount) public returns (bool success);
48 }
49 
50 
51 contract Store {
52 
53     //enum EventTypes
54     uint16 constant internal NONE = 0;
55     uint16 constant internal ADD = 1;
56     uint16 constant internal CANCEL = 2;
57 
58     address public owner;
59     uint public contentCount = 0;
60     
61     event LogStore(uint indexed version, address indexed sender, uint indexed timePage,
62         uint16 eventType, uint timeSpan, string dataInfo);
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68     
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     // @notice fallback function, don't allow call to it
74     function () public {
75         revert();
76     }
77 
78     function kill() public onlyOwner {
79 
80         selfdestruct(owner);
81     }
82 
83     function flush() public onlyOwner {
84 
85         if (!owner.send(address(this).balance))
86             revert();
87     }
88 
89     function flushToken(address _tokenAddress) public onlyOwner {
90 
91         MiniMeToken token = MiniMeToken(_tokenAddress);
92         uint balance = token.balanceOf(this);
93 
94         if (!token.transfer(owner, balance))
95             revert();
96     }
97 
98     function add(uint _version, uint16 _eventType, uint _timeSpan, string _dataInfo) public {
99         contentCount++;
100         emit LogStore(_version, msg.sender, block.timestamp / (1 days), _eventType, _timeSpan, _dataInfo);
101     }
102 }