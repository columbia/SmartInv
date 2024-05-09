1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4     address public owner;
5 
6     modifier onlyOwner() {
7         require(msg.sender == owner);
8         _;
9     }
10 
11     constructor() public {
12         owner = msg.sender; 
13     }
14 
15     /**
16         @dev Transfers the ownership of the contract.
17 
18         @param _owner Address of the new owner
19     */
20     function setOwner(address _owner) public onlyOwner returns (bool) {
21         require(_owner != address(0));
22         owner = _owner;
23         return true;
24     } 
25 }
26 
27 
28 contract HasWorkers is Ownable {
29     mapping(address => uint256) private workerToIndex;    
30     address[] private workers;
31 
32     event AddedWorker(address _worker);
33     event RemovedWorker(address _worker);
34 
35     constructor() public {
36         workers.length++;
37     }
38 
39     modifier onlyWorker() {
40         require(isWorker(msg.sender));
41         _;
42     }
43 
44     modifier workerOrOwner() {
45         require(isWorker(msg.sender) || msg.sender == owner);
46         _;
47     }
48 
49     function isWorker(address _worker) public view returns (bool) {
50         return workerToIndex[_worker] != 0;
51     }
52 
53     function allWorkers() public view returns (address[] memory result) {
54         result = new address[](workers.length - 1);
55         for (uint256 i = 1; i < workers.length; i++) {
56             result[i - 1] = workers[i];
57         }
58     }
59 
60     function addWorker(address _worker) public onlyOwner returns (bool) {
61         require(!isWorker(_worker));
62         uint256 index = workers.push(_worker) - 1;
63         workerToIndex[_worker] = index;
64         emit AddedWorker(_worker);
65         return true;
66     }
67 
68     function removeWorker(address _worker) public onlyOwner returns (bool) {
69         require(isWorker(_worker));
70         uint256 index = workerToIndex[_worker];
71         address lastWorker = workers[workers.length - 1];
72         workerToIndex[lastWorker] = index;
73         workers[index] = lastWorker;
74         workers.length--;
75         delete workerToIndex[_worker];
76         emit RemovedWorker(_worker);
77         return true;
78     }
79 }
80 
81 contract ControllerStorage {
82     address public walletsDelegate;
83     address public controllerDelegate;
84     address public forward;
85     uint256 public createdWallets;
86     mapping(bytes32 => bytes32) public gStorage;
87 }
88 
89 contract DelegateProxy {
90   /**
91    * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
92    * @param _dst Destination address to perform the delegatecall
93    * @param _calldata Calldata for the delegatecall
94    */
95   function delegatedFwd(address _dst, bytes _calldata) internal {
96     assembly {
97       let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
98       let size := returndatasize
99 
100       let ptr := mload(0x40)
101       returndatacopy(ptr, 0, size)
102 
103       // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
104       // if the call returned error data, forward it
105       switch result case 0 { revert(ptr, size) }
106       default { return(ptr, size) }
107     }
108   }
109 }
110 
111 contract DelegateProvider {
112     function getDelegate() public view returns (address delegate);
113 }
114 
115 contract ControllerProxy is ControllerStorage, Ownable, HasWorkers, DelegateProvider, DelegateProxy {
116     function getDelegate() public view returns (address delegate) {
117         delegate = walletsDelegate;
118     }
119 
120     function setWalletsDelegate(address _delegate) public onlyOwner returns (bool) {
121         walletsDelegate = _delegate;
122         return true;
123     }
124 
125     function setControllerDelegate(address _delegate) public onlyOwner returns (bool) {
126         controllerDelegate = _delegate;
127         return true;
128     }
129 
130     function() public payable {
131         if (gasleft() > 2400) {
132             delegatedFwd(controllerDelegate, msg.data);
133         }
134     }
135 }