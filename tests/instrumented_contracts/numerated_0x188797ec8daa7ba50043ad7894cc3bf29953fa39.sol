1 contract ProxyData {
2     address internal proxied;
3 }
4 
5 contract Proxy is ProxyData {
6     constructor(address _proxied) public {
7         proxied = _proxied;
8 }
9 
10 function () external payable {
11     address addr = proxied;
12     assembly {
13         let freememstart := mload(0x40)
14         calldatacopy(freememstart, 0, calldatasize())
15         let success := delegatecall(not(0), addr, freememstart, calldatasize(), freememstart, 0)
16         returndatacopy(freememstart, 0, returndatasize())
17         switch success
18             case 0 { revert(freememstart, returndatasize()) }
19             default { return(freememstart, returndatasize()) }
20         }
21     }
22 }
23 
24 contract UniswapFactoryInterface {
25     // Public Variables
26     address public exchangeTemplate;
27     uint256 public tokenCount;
28     // Create Exchange
29     function createExchange(address token) external returns (address exchange);
30     // Get Exchange and Token Info
31     function getExchange(address token) external view returns (address exchange);
32     function getToken(address exchange) external view returns (address token);
33     function getTokenWithId(uint256 tokenId) external view returns (address token);
34     // Never use
35     function initializeFactory(address template) external;
36 }
37 contract FundHeader {
38     address constant internal cEth = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
39     UniswapFactoryInterface constant internal uniswapFactory = UniswapFactoryInterface(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
40 }
41 
42 contract FundDataInternal is ProxyData, FundHeader {
43     address internal collateralOwner;
44     address internal interestWithdrawer;
45     // cTokenAddress -> sum deposits denominated in underlying
46     mapping(address => uint) internal initialDepositCollateral;
47     // cTokenAddresses
48     address[] internal markets;
49 }
50 
51 contract CERC20NoBorrowInterface {
52     function mint(uint mintAmount) external returns (uint);
53     address public underlying;
54 }
55 
56 interface IERC20 {
57     function transfer(address to, uint256 value) external returns (bool);
58     function approve(address spender, uint256 value) external returns (bool);
59     function transferFrom(address from, address to, uint256 value) external returns (bool);
60     function totalSupply() external view returns (uint256);
61     function balanceOf(address who) external view returns (uint256);
62     function allowance(address owner, address spender) external view returns (uint256);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract FundProxy is Proxy, FundDataInternal {
68     constructor(
69         address proxied,
70         address _collateralOwner,
71         address _interestWithdrawer,
72         address[] memory _markets
73     )
74     public
75     Proxy(proxied)
76     {
77         for (uint i=0; i < _markets.length; i++) {
78             markets.push(_markets[i]);
79             if (_markets[i] == cEth) {
80                 continue;
81             }
82             address underlying = CERC20NoBorrowInterface(_markets[i]).underlying();
83             require(IERC20(underlying).approve(_markets[i], uint(-1)));
84             require(IERC20(underlying).approve(uniswapFactory.getExchange(underlying), uint(-1)));
85         }
86             collateralOwner = _collateralOwner;
87             interestWithdrawer = _interestWithdrawer;
88     }
89 
90 }
91 
92 contract FundFactory {
93     address private implementation;
94     event NewFundCreated(address indexed collateralOwner, address proxyAddress);
95 
96     constructor(address _implementation) public {
97         implementation = _implementation;
98     }
99 
100     function createFund(address _interestWithdrawer, address[] calldata _markets)
101     external
102     {
103         emit NewFundCreated(
104                 msg.sender,
105                 address(new FundProxy(address(implementation), msg.sender, _interestWithdrawer, _markets))
106             );
107     }
108 
109 }