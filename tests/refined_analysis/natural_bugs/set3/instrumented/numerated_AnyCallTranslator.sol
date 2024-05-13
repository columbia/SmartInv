1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 import "@openzeppelin/contracts-4.7.3/proxy/transparent/TransparentUpgradeableProxy.sol";
6 import "@openzeppelin/contracts-4.7.3/proxy/transparent/ProxyAdmin.sol";
7 import "@openzeppelin/contracts-4.7.3/utils/math/Math.sol";
8 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
9 
10 import "@openzeppelin/contracts-upgradeable-4.7.3/access/OwnableUpgradeable.sol";
11 
12 interface ICallProxy {
13     function anyCall(
14         address _to,
15         bytes calldata _data,
16         address _fallback,
17         uint256 _toChainId,
18         uint256 _flags
19     ) external payable; // nonpayable
20 
21     function withdraw(uint256 amount) external;
22 
23     function executor() external view returns (address executor);
24 }
25 
26 interface IAnyCallExecutor {
27     function context()
28         external
29         view
30         returns (
31             address from,
32             uint256 fromChainID,
33             uint256 nonce
34         );
35 }
36 
37 // Empty contract to ensure hardhat import of TransparentUpgradeableProxy contract
38 contract EmptyProxy is TransparentUpgradeableProxy {
39     constructor(
40         address _logic,
41         address admin_,
42         bytes memory _data
43     ) payable TransparentUpgradeableProxy(_logic, admin_, _data) {}
44 }
45 
46 // Empty contract to ensure hardhat import of ProxyAdmin contract
47 contract EmptyProxyAdmin is ProxyAdmin {
48 
49 }
50 
51 /// @title AnyCallTranslator also know as the AnyCallProxy
52 /// @notice AnyCallTranslator is responsible for translating messages for AnyCallV6
53 contract AnyCallTranslator is OwnableUpgradeable {
54     using SafeERC20 for IERC20;
55     // address of anyCallV6 contract
56     address public anyCallContract;
57     // address of the AnyCallExecutor contract
58     address public anyCallExecutor;
59     // mapping of address to whether or not they are allowed to call anyCall
60     mapping(address => bool) public isKnownCaller;
61 
62     /// @notice AnyCallTranslator constructor
63     /// @dev Doesn't do anything except to set isInitialized = true via initializer
64     constructor() initializer {
65         // Do not do anything on logic contract deployment
66         // intializer modifier will prevent any future `initialize()` calls
67     }
68 
69     receive() external payable {
70         // fallback payable function
71     }
72 
73     /// @notice Initialize the AnyCallTranslator contract for proxies
74     /// @dev This needs to be called on proxies of this contract
75     /// @param _owner address that will be the owner of this contract
76     /// @param _anyCallContract address of the anyCallV6 contract
77     function initialize(address _owner, address _anyCallContract)
78         public
79         initializer
80     {
81         _transferOwnership(_owner);
82         anyCallContract = _anyCallContract;
83         anyCallExecutor = ICallProxy(_anyCallContract).executor();
84     }
85 
86     /// @notice Adds addresses to known caller array
87     /// @dev Only callable by owner
88     /// @param _callers array of addresses that should be added to known callers
89     function addKnownCallers(address[] calldata _callers) external onlyOwner {
90         for (uint256 i = 0; i < _callers.length; i++) {
91             isKnownCaller[_callers[i]] = true;
92         }
93     }
94 
95     /// @notice Removes addresses from known caller array
96     /// @dev Only callable by owner
97     function removeKnownCallers(address[] calldata _callers)
98         external
99         onlyOwner
100     {
101         for (uint256 i = 0; i < _callers.length; i++) {
102             isKnownCaller[_callers[i]] = false;
103         }
104     }
105 
106     /// @notice Set the AnyCall contract address
107     /// @dev Only callable by owner
108     /// @param _anyCallContract address of the AnyCallV6 contract
109     function setAnyCall(address _anyCallContract) external onlyOwner {
110         anyCallContract = _anyCallContract;
111         anyCallExecutor = ICallProxy(_anyCallContract).executor();
112     }
113 
114     /// @notice withdraw any ETH that was sent to AnyCall contract
115     /// @dev Only callable by owner
116     /// @param _amount amount of ETH to withdraw
117     function withdraw(uint256 _amount) external onlyOwner {
118         ICallProxy(anyCallContract).withdraw(_amount);
119     }
120 
121     /// @notice Rescue any ERC20 tokens that are stuck in this contract
122     /// @dev Only callable by owner
123     /// @param token address of the ERC20 token to rescue. Use zero address for ETH
124     /// @param to address to send the tokens to
125     /// @param balance amount of tokens to rescue
126     function rescue(
127         IERC20 token,
128         address to,
129         uint256 balance
130     ) external onlyOwner {
131         if (address(token) == address(0)) {
132             // for Ether
133             uint256 totalBalance = address(this).balance;
134             balance = balance == 0
135                 ? totalBalance
136                 : Math.min(totalBalance, balance);
137             require(balance > 0, "trying to send 0 ETH");
138             // slither-disable-next-line arbitrary-send
139             (bool success, ) = to.call{value: balance}("");
140             require(success, "ETH transfer failed");
141         } else {
142             // any other erc20
143             uint256 totalBalance = token.balanceOf(address(this));
144             balance = balance == 0
145                 ? totalBalance
146                 : Math.min(totalBalance, balance);
147             require(balance > 0, "trying to send 0 balance");
148             token.safeTransfer(to, balance);
149         }
150     }
151 
152     /// @notice Send a cross chain call via anyCallV6
153     /// @dev Only callable by known callers. Fee flags should be set to 2 in most
154     /// if not all use cases involing this contract.
155     /// @param _to address to call
156     /// @param _data calldata with function signature to use
157     /// @param _fallback address of the fallback contract to use if the call fails
158     /// @param _toChainId chainId to send the call to
159     /// @param _flags flags for determining on which network should caller pay the fee
160     /// (0 = desitnation chain, 2 = origin chain)
161     function anyCall(
162         address _to,
163         bytes calldata _data,
164         address _fallback,
165         uint256 _toChainId,
166         // Use 0 flag to pay fee on destination chain, 1 to pay on source
167         uint256 _flags
168     ) external payable {
169         require(isKnownCaller[msg.sender], "Unknown caller");
170         ICallProxy(anyCallContract).anyCall{value: msg.value}(
171             address(this),
172             abi.encode(_to, _data),
173             _fallback,
174             _toChainId,
175             _flags
176         );
177     }
178 
179     /// @notice Receive a cross chain call via anyCallV6 and execute a call on this network
180     /// @dev Only callable anyCallExecutor, the executor contract of anyCallV6
181     /// @param toAndData abi encoded target address and function calldata to execute
182     /// @return boolean indicating success of the call
183     /// @return bytes any data returned from the call
184     function anyExecute(bytes calldata toAndData)
185         external
186         returns (bool, bytes memory)
187     {
188         // Check that caller is anycall executor
189         require(
190             msg.sender == anyCallExecutor,
191             "Caller is not anyCall executor"
192         );
193         // Get the address of the caller from the source chain
194         (address _from, , ) = IAnyCallExecutor(msg.sender).context();
195         // Check that caller is AnyCallTranslator
196         require(_from == address(this), "Wrong context");
197 
198         // Decode to and data
199         (address to, bytes memory data) = abi.decode(
200             toAndData,
201             (address, bytes)
202         );
203         (bool success, bytes memory returnData) = to.call(data);
204         require(success, "Target call failed");
205         return (success, returnData);
206     }
207 }
