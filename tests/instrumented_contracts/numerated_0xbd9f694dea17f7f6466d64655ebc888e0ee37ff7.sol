1 pragma solidity ^0.6.0;
2 
3 contract VasaPowerSwitch {
4 
5     uint256 private _totalMintable;
6     uint256[] private _timeWindows;
7     uint256[][] private _multipliers;
8 
9     address private _proxy;
10 
11     address private _oldTokenAddress;
12 
13     uint256 private _startBlock;
14 
15     constructor(address proxyAddress, address oldTokenAddress, uint256 startBlock, uint256 totalMintable, uint256[] memory timeWindows, uint256[] memory multipliers, uint256[] memory dividers) public {
16         _startBlock = startBlock;
17         _proxy = proxyAddress;
18         _oldTokenAddress = oldTokenAddress;
19         _totalMintable = totalMintable;
20         _timeWindows = timeWindows;
21         assert(timeWindows.length == multipliers.length && multipliers.length == dividers.length);
22         for(uint256 i = 0; i < multipliers.length; i++) {
23             _multipliers.push([multipliers[i], dividers[i]]);
24         }
25     }
26 
27     function totalMintable() public view returns(uint256) {
28         return block.number > _timeWindows[_timeWindows.length - 1] ? 0 :_totalMintable;
29     }
30 
31     function startBlock() public view returns(uint256) {
32         return _startBlock;
33     }
34 
35     function proxy() public view returns(address) {
36         return _proxy;
37     }
38 
39     function setProxy(address newProxy) public {
40         require(IMVDFunctionalitiesManager(IMVDProxy(_proxy).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");
41         _proxy = newProxy;
42     }
43 
44     function calculateMintable(uint256 amount) public view returns(uint256) {
45         if(amount == 0 || block.number > _timeWindows[_timeWindows.length - 1]) {
46             return 0;
47         }
48         uint256 i = 0;
49         for(i; i < _timeWindows.length; i++) {
50             if(block.number <= _timeWindows[i]) {
51                 break;
52             }
53         }
54         uint256 mintable = i >= _timeWindows.length ? 0 : ((amount * _multipliers[i][0]) / _multipliers[i][1]);
55         return mintable > _totalMintable ? _totalMintable : mintable;
56     }
57 
58     function length() public view returns(uint256) {
59         return _timeWindows.length;
60     }
61 
62     function timeWindow(uint256 i) public view returns(uint256, uint256, uint256) {
63         return (_timeWindows[i], _multipliers[i][0], _multipliers[i][1]);
64     }
65 
66     function getContextInfo(uint256 amount) public view returns (uint256 timeWindow, uint256 multiplier, uint256 divider, uint256 mintable) {
67         if(amount == 0 || block.number > _timeWindows[_timeWindows.length - 1]) {
68             return (0, 0, 0, 0);
69         }
70         uint256 i = 0;
71         for(i; i < _timeWindows.length; i++) {
72             if(block.number <= _timeWindows[i]) {
73                 break;
74             }
75         }
76         if(i < _timeWindows.length) {
77             timeWindow = _timeWindows[i];
78             multiplier = _multipliers[i][0];
79             divider = _multipliers[i][1];
80         }
81         mintable = i >= _timeWindows.length ? 0 : ((amount * multiplier) / divider);
82         mintable = mintable > _totalMintable ? _totalMintable : mintable;
83     }
84 
85     function vasaPowerSwitch(uint256 senderBalanceOf) public {
86         require(block.number >= _startBlock, "Switch still not started!");
87 
88         IERC20 oldToken = IERC20(_oldTokenAddress);
89 
90         uint256 mintableAmount = calculateMintable(senderBalanceOf);
91         require(mintableAmount > 0, "Zero tokens to mint!");
92 
93         oldToken.transferFrom(msg.sender, address(this), senderBalanceOf);
94         oldToken.burn(senderBalanceOf);
95         _totalMintable -= senderBalanceOf;
96         IMVDProxy(_proxy).submit("mintAndTransfer", abi.encode(address(0), 0, mintableAmount, msg.sender));
97     }
98 }
99 
100 interface IMVDProxy {
101     function getMVDFunctionalitiesManagerAddress() external view returns(address);
102     function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
103 }
104 
105 interface IMVDFunctionalitiesManager {
106     function isAuthorizedFunctionality(address functionality) external view returns(bool);
107 }
108 
109 interface IERC20 {
110     function balanceOf(address account) external view returns (uint256);
111     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
112     function burn(uint256 amount) external;
113 }