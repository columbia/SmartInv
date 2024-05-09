1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         _checkOwner();
31         _;
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if the sender is not the owner.
43      */
44     function _checkOwner() internal view virtual {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Internal function without access restriction.
71      */
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 
80 interface IUniswapV2Router01 {
81     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
82         external
83         payable
84         returns (uint[] memory amounts);
85 }
86 
87 library TransferHelper {
88     function safeTransferETH(address to, uint value) internal {
89         (bool success,) = to.call{value:value}(new bytes(0));
90         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
91     }
92 }
93 
94 
95 contract SniperBot is Ownable {
96 
97     uint public ids;
98 
99     IUniswapV2Router01 public router = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
100     uint public minOrderGasPrice = 0.008 ether;
101 
102     struct Order {
103         address payable user;
104         address tokenOut;
105         uint amountIn;
106         uint gas;
107         bool isExecute;
108     }
109 
110     mapping(uint => Order) public idToOrder;
111 
112     mapping (address => mapping(uint => uint)) public userOrder;
113     mapping(address => uint) public userIndex;
114     mapping(address => bool) public Executer;
115 
116  
117     event Create(uint id, address tokenOut, uint amountIn, uint gas);
118     event Cancel(uint id, address canceler);
119     event Execute(uint id);
120 
121     constructor(){
122         Executer[msg.sender] = true;
123     }
124 
125     function createOrder(address tokenOut, uint amountIn, uint gas) external payable returns (uint id){
126 
127         require(amountIn == msg.value - gas && gas >= minOrderGasPrice, "amountIn is incorrect");
128 
129         id = ids;
130         ids++;
131 
132         idToOrder[id] = Order(
133             payable(msg.sender),
134             tokenOut,
135             amountIn,
136             gas,
137             false
138         );
139 
140         uint index = userIndex[msg.sender];
141 
142         userOrder[msg.sender][index] = id;
143         userIndex[msg.sender] ++;
144 
145         emit Create(id,tokenOut,amountIn,gas);
146     }
147 
148     function cancelOrder(uint id) external returns (bool){
149         Order storage myOrder = idToOrder[id];
150 
151         require(myOrder.isExecute == false, "order is executed");
152         require(myOrder.user == msg.sender || Executer[msg.sender] == true, "msgsender is incorrect");
153 
154         myOrder.isExecute = true;
155         TransferHelper.safeTransferETH(myOrder.user, myOrder.gas + myOrder.amountIn);
156         
157         emit Cancel(id, msg.sender);
158         return true;
159     }
160 
161     function executeOrder(uint id,address[] memory path) external returns (bool){
162         Order storage myOrder = idToOrder[id];
163         require(myOrder.isExecute == false && Executer[msg.sender] == true, "order is executed");
164 
165         router.swapExactETHForTokens{value: myOrder.amountIn}(0, path, myOrder.user, block.timestamp + 10 minutes);
166 
167         myOrder.isExecute = true;
168         TransferHelper.safeTransferETH(msg.sender, myOrder.gas);
169 
170         emit Execute(id);
171         return true;
172     }
173 
174  
175     function fetchUserOrder() external view returns (Order[] memory myOrders) {
176 
177         uint count = userIndex[msg.sender] ;
178         myOrders = new Order[](count);
179 
180         for (uint i=0; i<count; i++) {
181 
182             uint currentId = userOrder[msg.sender][i];
183             Order storage currentOrder = idToOrder[currentId];
184             myOrders[i] = currentOrder;
185         }
186     }
187 
188     function setMinOrderGasPrice(uint gas) external onlyOwner {
189         minOrderGasPrice = gas;
190     }
191 
192     function setExecuter(address _e, bool _b) external onlyOwner {
193         Executer[_e] = _b;
194     }
195 
196     receive() payable external{}
197 }