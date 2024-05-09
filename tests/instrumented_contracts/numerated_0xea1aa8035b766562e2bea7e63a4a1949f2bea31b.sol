1 // File: access/HasAdmin.sol
2 
3 pragma solidity 0.5.17;
4 
5 
6 contract HasAdmin {
7   event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
8   event AdminRemoved(address indexed _oldAdmin);
9 
10   address public admin;
11 
12   modifier onlyAdmin {
13     require(msg.sender == admin, "HasAdmin: not admin");
14     _;
15   }
16 
17   constructor() internal {
18     admin = msg.sender;
19     emit AdminChanged(address(0), admin);
20   }
21 
22   function changeAdmin(address _newAdmin) external onlyAdmin {
23     require(_newAdmin != address(0), "HasAdmin: new admin is the zero address");
24     emit AdminChanged(admin, _newAdmin);
25     admin = _newAdmin;
26   }
27 
28   function removeAdmin() external onlyAdmin {
29     emit AdminRemoved(admin);
30     admin = address(0);
31   }
32 }
33 
34 // File: token/erc20/IERC20.sol
35 
36 pragma solidity 0.5.17;
37 
38 
39 interface IERC20 {
40   event Transfer(address indexed _from, address indexed _to, uint256 _value);
41   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43   function totalSupply() external view returns (uint256 _supply);
44   function balanceOf(address _owner) external view returns (uint256 _balance);
45 
46   function approve(address _spender, uint256 _value) external returns (bool _success);
47   function allowance(address _owner, address _spender) external view returns (uint256 _value);
48 
49   function transfer(address _to, uint256 _value) external returns (bool _success);
50   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
51 }
52 
53 // File: MainchainGateway.sol
54 
55 pragma solidity 0.5.17;
56 
57 
58 contract MainchainGateway {
59   function depositERC20For(address _user, address _token, uint256 _amount) external returns (uint256);
60 }
61 
62 // File: TokenSwap.sol
63 
64 pragma solidity 0.5.17;
65 
66 
67 
68 
69 
70 /**
71   * Smart contract wallet to support swapping between old ERC-20 token to a new contract.
72   * It also supports swap and deposit into mainchainGateway in a single transaction.
73   * Pre-requisites: New token needs to be transferred to this contract.
74   * Dev should check that the decimals and supply of old token and new token are identical.
75  */
76 contract TokenSwap is HasAdmin {
77   IERC20 public oldToken;
78   IERC20 public newToken;
79   MainchainGateway public mainchainGateway;
80 
81   constructor(
82     IERC20 _oldToken,
83     IERC20 _newToken
84   )
85     public
86   {
87     oldToken = _oldToken;
88     newToken = _newToken;
89   }
90 
91   function setGateway(MainchainGateway _mainchainGateway) external onlyAdmin {
92     if (address(mainchainGateway) != address(0)) {
93       require(newToken.approve(address(mainchainGateway), 0));
94     }
95 
96     mainchainGateway = _mainchainGateway;
97     require(newToken.approve(address(mainchainGateway), uint256(-1)));
98   }
99 
100   function swapToken() external {
101     uint256 _balance = oldToken.balanceOf(msg.sender);
102     require(oldToken.transferFrom(msg.sender, address(this), _balance));
103     require(newToken.transfer(msg.sender, _balance));
104   }
105 
106   function swapAndBridge(address _recipient, uint256 _amount) external {
107     require(_recipient != address(0), "TokenSwap: recipient is the zero address");
108     uint256 _balance = oldToken.balanceOf(msg.sender);
109     require(oldToken.transferFrom(msg.sender, address(this), _balance));
110 
111     require(_amount <= _balance);
112     require(newToken.transfer(msg.sender, _balance - _amount));
113     mainchainGateway.depositERC20For(_recipient, address(newToken), _amount);
114   }
115 
116   function swapAndBridgeAll(address _recipient) external {
117     require(_recipient != address(0), "TokenSwap: recipient is the zero address");
118     uint256 _balance = oldToken.balanceOf(msg.sender);
119     require(oldToken.transferFrom(msg.sender, address(this), _balance));
120     mainchainGateway.depositERC20For(_recipient, address(newToken), _balance);
121   }
122 
123   // Used when some old token lost forever
124   function withdrawToken() external onlyAdmin {
125     newToken.transfer(msg.sender, newToken.balanceOf(address(this)));
126   }
127 }