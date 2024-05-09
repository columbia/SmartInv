1 pragma solidity ^0.5.0;
2 
3 
4 contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev Initializes the contract setting the deployer as the initial owner.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @dev Returns the address of the current owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     /**
33      * @dev Returns true if the caller is the current owner.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Leaves the contract without owner. It will not be possible to call
41      * `onlyOwner` functions anymore. Can only be called by the current owner.
42      *
43      * > Note: Renouncing ownership will leave the contract without an owner,
44      * thereby removing any functionality that is only available to the owner.
45      */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50 
51     /**
52      * @dev Transfers ownership of the contract to a new account (`newOwner`).
53      * Can only be called by the current owner.
54      */
55     function transferOwnership(address newOwner) public onlyOwner {
56         _transferOwnership(newOwner);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 
70 
71 contract TrbInterface {
72     function getUintVar(bytes32 _data) view public returns(uint256);
73     function transfer(address _to, uint256 _amount) external returns (bool);
74     function depositStake() external;
75     function requestStakingWithdraw() external;
76     function withdrawStake() external;
77     function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external;
78     function addTip(uint256 _requestId, uint256 _tip) external;
79 }
80 
81 contract Collection is Ownable {
82     
83     address createAddress;
84     address trbAddress = 0x0Ba45A8b5d5575935B8158a88C631E9F9C95a2e5;
85     
86     TrbInterface trbContract = TrbInterface(trbAddress);
87     
88     constructor() public {
89         createAddress = msg.sender;
90     }
91     
92     function() external onlyOwner payable{
93         require(createAddress == msg.sender, "author no");
94     }
95     
96     function finalize() external onlyOwner payable{
97         require(createAddress == msg.sender, "author no");
98     }
99     
100     function getCreate() public view returns(address){
101         return createAddress;
102     }
103     
104     //ETH
105     function withdrawEth(uint _amount) public onlyOwner payable{
106         require(createAddress == msg.sender, "author no");
107         msg.sender.transfer(_amount);
108     }
109     
110     function withdrawTrb(uint _amount) public onlyOwner payable{
111         require(createAddress == msg.sender, "author no");
112         trbContract.transfer(msg.sender, _amount);
113     }
114     
115     function depositStake() external onlyOwner payable{
116         require(createAddress == msg.sender, "author no");
117         trbContract.depositStake();
118     }
119     
120     function requestStakingWithdraw() external onlyOwner payable{
121         require(createAddress == msg.sender, "author no");
122         trbContract.requestStakingWithdraw();
123     }
124     
125     function withdrawStake() external onlyOwner payable{
126         require(createAddress == msg.sender, "author no");
127         trbContract.withdrawStake();
128     }
129     
130     function submitMiningSolution(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value) external onlyOwner payable{
131         require(createAddress == msg.sender, "author no");
132         
133         if (gasleft() <= 10**6){
134             bytes32 slotProgress =0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a;
135             uint256 tmpSlot = trbContract.getUintVar(slotProgress);
136             require(tmpSlot < 4, "Z");
137         }
138         
139         trbContract.submitMiningSolution(_nonce, _requestId, _value);
140     }
141     
142     function addTip(uint256 _requestId, uint256 _tip) external onlyOwner payable{
143         require(createAddress == msg.sender, "author no");
144         trbContract.addTip(_requestId, _tip);
145     }
146     
147     function getUintVar(bytes32 _data) public onlyOwner view returns (uint256){
148         require(createAddress == msg.sender, "author no");
149         //bytes32 slotProgress =0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a;
150         
151         return trbContract.getUintVar(_data);
152     }
153     
154 }