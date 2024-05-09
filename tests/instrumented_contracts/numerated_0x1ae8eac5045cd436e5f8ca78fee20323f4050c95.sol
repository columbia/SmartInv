1 pragma solidity 0.4.25;
2 
3 contract AlarmClock {
4 
5     event _newAlarmClock(address _contract, uint startBlock, uint blockWindow, uint reward, uint gas, bytes _callData);
6     
7     address public owner;
8     //uint public initBlock;
9     uint public totalTimers;
10     uint public waitingTimers;
11     
12     struct ClockStruct {
13         address _contract;
14         uint startBlock;
15         uint blockWindow;
16         uint reward;
17         uint gas;
18         bytes callData;
19     }
20     
21     //sha3("setA(uint256)")[0:8].hex()
22     //'ee919d50'
23     //0xee919d500000000000000000000000000000000000000000000000000000000000000001 - call setA(1), method selector 4 bytes
24     
25     //0x6a3d9d350000000000000000000000000000000000000000000000000000000000000005 - call alarmtest.testFunc(5)
26     
27     ClockStruct[] public clockList;
28   
29     constructor () public payable {
30         owner = msg.sender;
31         //initBlock = block.number;
32         totalTimers = 0;
33         waitingTimers = 0;
34     }  
35   
36     modifier ownerOnly() {
37         require(msg.sender == owner);
38         _;
39     }  
40   
41     // 1. transfer  //
42     function setNewOwner(address _newOwner) public ownerOnly {
43         owner = _newOwner;
44     }   
45   
46     /*function refreshBlock() public ownerOnly {
47         initBlock = block.number;
48     }*/ 
49   
50     // gas required for registration ~200000
51     function registerAlarmClock(address _contract, uint startBlock, uint blockWindow, uint gas, bytes  _callData) external payable {
52         
53         require(gas >= 200000);
54         require(msg.value > gas);
55         require(block.number < startBlock);
56         
57         clockList.push(ClockStruct(_contract, startBlock, blockWindow, msg.value - gas, gas, _callData));
58         //uint id = clockList.push(ClockStruct(_contract, startBlock, blockWindow, msg.value - gas, gas, callData)) - 1;
59         //clockToOwner[id] = msg.sender;
60         //clockToValue[id] = msg.value;
61         //ownerClockCount[msg.sender]++;
62         
63         totalTimers++;
64         waitingTimers++;
65         
66         emit _newAlarmClock(_contract, startBlock, blockWindow, msg.value - gas, gas, _callData);
67     }  
68   
69 	// ~30000   +200000gas if called contract request new registration 
70     function trigerAlarmClock(uint id) external payable {
71         
72         uint _reward;
73         
74         require(clockList[id].reward > 0);
75         require(block.number >= clockList[id].startBlock);
76         require(block.number < (clockList[id].startBlock + clockList[id].blockWindow));
77         
78         require(clockList[id]._contract.call.value(0).gas(clockList[id].gas)(clockList[id].callData));
79         
80         waitingTimers--; 
81         _reward = clockList[id].reward;
82         clockList[id].reward = 0;
83         
84         msg.sender.transfer(_reward);
85         
86     }  
87   
88     // fallback function tigered, when contract gets ETH
89     function() external payable {
90         //?
91     }   
92     
93     function _destroyContract() external ownerOnly {
94         selfdestruct(msg.sender);
95     }    
96   
97 }