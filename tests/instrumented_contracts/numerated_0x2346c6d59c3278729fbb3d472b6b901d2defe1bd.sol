1 pragma solidity ^0.5.2;
2 
3 contract ProxyData {
4     address internal proxied;
5 }
6 
7 contract Proxy is ProxyData {
8     constructor(address _proxied) public {
9         proxied = _proxied;
10     }
11 
12     function () external payable {
13         address addr = proxied;
14         assembly {
15             let freememstart := mload(0x40)
16             calldatacopy(freememstart, 0, calldatasize())
17             let success := delegatecall(not(0), addr, freememstart, calldatasize(), freememstart, 0)
18             returndatacopy(freememstart, 0, returndatasize())
19             switch success
20                 case 0 { revert(freememstart, returndatasize()) }
21                 default { return(freememstart, returndatasize()) }
22         }
23     }
24 }
25 
26 contract UniswapFactoryInterface {
27     // Public Variables
28     address public exchangeTemplate;
29     uint256 public tokenCount;
30     // Create Exchange
31     function createExchange(address token) external returns (address exchange);
32     // Get Exchange and Token Info
33     function getExchange(address token) external view returns (address exchange);
34     function getToken(address exchange) external view returns (address token);
35     function getTokenWithId(uint256 tokenId) external view returns (address token);
36     // Never use
37     function initializeFactory(address template) external;
38 }
39 
40 contract FundHeader {
41     address constant internal cEth = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
42     UniswapFactoryInterface constant internal uniswapFactory = UniswapFactoryInterface(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
43 }
44 
45 contract FundDataInternal is ProxyData, FundHeader {
46     address internal collateralOwner;
47     address internal interestWithdrawer;
48     // cTokenAddress -> sum deposits denominated in underlying
49     mapping(address => uint) internal initialDepositCollateral;
50     // cTokenAddresses
51     address[] internal markets;
52 }
53 
54 contract CERC20NoBorrowInterface {
55     function mint(uint mintAmount) external returns (uint);
56     address public underlying;
57 }
58 
59 interface IERC20 {
60     function transfer(address to, uint256 value) external returns (bool);
61     function approve(address spender, uint256 value) external returns (bool);
62     function transferFrom(address from, address to, uint256 value) external returns (bool);
63     function totalSupply() external view returns (uint256);
64     function balanceOf(address who) external view returns (uint256);
65     function allowance(address owner, address spender) external view returns (uint256);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 contract FundProxy is Proxy, FundDataInternal {
71     constructor(
72         address proxied,
73         address _collateralOwner,
74         address _interestWithdrawer,
75         address[] memory _markets)
76             public
77             Proxy(proxied)
78     {
79         for (uint i=0; i < _markets.length; i++) {
80             markets.push(_markets[i]);
81             if (_markets[i] == cEth) {
82                 continue;
83             }
84             address underlying = CERC20NoBorrowInterface(_markets[i]).underlying();
85             require(IERC20(underlying).approve(_markets[i], uint(-1)));
86             require(IERC20(underlying).approve(uniswapFactory.getExchange(underlying), uint(-1)));
87         }
88         collateralOwner = _collateralOwner;
89         interestWithdrawer = _interestWithdrawer;
90     }
91 }