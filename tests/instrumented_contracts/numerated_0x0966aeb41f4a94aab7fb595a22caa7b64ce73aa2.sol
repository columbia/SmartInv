1 pragma solidity ^0.5.0;
2 
3 contract TellorWrapper {
4     function balanceOf(address _user) external view returns (uint256);
5     function transfer(address _to, uint256 _amount) external returns (bool);
6     
7     function withdrawStake() external;
8     function getUintVar(bytes32 _data) public view returns (uint256);
9 }
10 
11 contract TellorC {
12     address private tellor = 0x0Ba45A8b5d5575935B8158a88C631E9F9C95a2e5;
13 
14     bytes32 constant slotProgress = 0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a; // keccak256("slotProgress")
15     address private owner;
16     address private miner;
17     
18     constructor () public {
19         owner = msg.sender;
20     }
21     
22     function changeMiner(address _addr) external {
23         require(msg.sender == owner);
24         
25         miner = _addr;
26     }
27 
28     function withdrawTrb(uint256 _amount) external {
29         require(msg.sender == owner);
30 
31         TellorWrapper(tellor).transfer(msg.sender, _amount);
32     }
33 
34     function withdrawEth(uint256 _amount) external {
35         require(msg.sender == owner);
36 
37         msg.sender.transfer(_amount);
38     }
39 
40     function depositStake() external {
41         require(msg.sender == owner);
42 
43         TellorC(tellor).depositStake();
44     }
45 
46     function requestStakingWithdraw() external {
47         require(msg.sender == owner);
48 
49         TellorC(tellor).requestStakingWithdraw();
50     }
51 
52     // Use finalize() if possible
53     function withdrawStake() external {
54         require(msg.sender == owner);
55 
56         TellorC(tellor).withdrawStake();
57     }
58 
59     function finalize() external {
60         require(msg.sender == owner);
61 
62         TellorWrapper(tellor).withdrawStake();
63         uint256 _balance = TellorWrapper(tellor).balanceOf(address(this));
64         TellorWrapper(tellor).transfer(msg.sender, _balance);
65         selfdestruct(msg.sender);
66     }
67 
68     function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external {
69         require(msg.sender == miner || msg.sender == owner, "Unauthorized");
70         require(gasleft() > 1000000 || TellorWrapper(tellor).getUintVar(slotProgress) < 4, 'X');
71 
72         TellorC(tellor).submitMiningSolution(_nonce, _requestId, _value);
73     }
74     
75     function() external {
76         require(msg.sender == address(0), "Not allowed"); // Dont allow actual calls, only views
77         
78         address addr = tellor;
79         bytes memory _calldata = msg.data;
80         assembly {
81             let result := call(not(0), addr, 0, add(_calldata, 0x20), mload(_calldata), 0, 0)
82             let size := returndatasize
83             let ptr := mload(0x40)
84             returndatacopy(ptr, 0, size)
85             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
86             // if the call returned error data, forward it
87             switch result
88                 case 0 {
89                     revert(ptr, size)
90                 }
91                 default {
92                     return(ptr, size)
93                 }
94         }
95     }
96 }