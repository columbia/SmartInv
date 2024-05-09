1 pragma solidity ^0.6.0;
2 
3 interface ERC20 {
4     function totalSupply() external view returns (uint supply);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8     function approve(address _spender, uint _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external view returns (uint remaining);
10     function decimals() external view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 abstract contract SaverExchange {
15     function swapTokenToToken(
16         address _src,
17         address _dest,
18         uint256 _amount,
19         uint256 _minPrice,
20         uint256 _exchangeType,
21         address _exchangeAddress,
22         bytes memory _callData,
23         uint256 _0xPrice
24     ) virtual public;
25 }
26 
27 contract Reserve {
28     address ExchangeRedeemerAddr = 0x9523Fe0d1D488CaFDDfb3dcE28d7D177DDdBC300;
29     
30     function retreiveTokens(address _tokenAddr, uint _value) public {
31         require(msg.sender == ExchangeRedeemerAddr);
32         
33         ERC20(_tokenAddr).transfer(ExchangeRedeemerAddr, _value);
34     }
35 }
36 
37 contract ExchangeRedeemer {
38     
39     address public owner;
40     mapping(address => bool) public callers;
41     
42     address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
43     
44     event Redeemed(address user, address token, uint amount);
45     
46     Reserve reserve;
47     
48     constructor() public {
49         owner = msg.sender;
50         callers[owner] = true;
51         
52         callers[0xF2BC1ed33Ee7EA37e7c5643751cbE86238664F24] = true;
53         callers[0xc05c6356aCfD344c9Cf761aA451ca4F412D1B0f7] = true;
54         callers[0xb560fA7b7cA2cF5ddBBb0622aE2C2FcbD4EA866F] = true;
55         callers[0x5E96032e58CfDAD75d81a794B9C03e1B9970D9ed] = true;
56     }
57     
58     mapping (address => mapping(address => uint)) public balances;
59     
60     function redeemAllTokens(address[] memory _tokenAddr) public {
61         for(uint i = 0; i < _tokenAddr.length; ++i) {
62             redeemTokens(_tokenAddr[i]);
63         }
64     }
65     
66     function redeemTokens(address _tokenAddr) public {
67         uint balance = balances[msg.sender][_tokenAddr];
68         
69         if (balance > 0) {
70             balances[msg.sender][_tokenAddr] = 0;
71             
72             reserve.retreiveTokens(_tokenAddr, balance);
73 
74             ERC20(_tokenAddr).transfer(msg.sender, balance);
75             
76             emit Redeemed(msg.sender, _tokenAddr, balance);
77         }
78         
79     }
80     
81     /// @dev Set fee = 0 for address(this)
82     /// @dev Send a little bit of Dai to this address so we can go over the require > 0
83     function withdrawTokens(address _exchangeAddr, address _tokenAddr, address _user, uint _amount) public {
84         require(callers[msg.sender]);
85         
86         // require(success && tokens[0] > 0, "0x transaction failed");
87         ERC20(DAI_ADDRESS).transfer(_exchangeAddr, 1); // transfer 1 wei so we can go over this require
88         
89         SaverExchange(_exchangeAddr).swapTokenToToken(
90             DAI_ADDRESS,
91             DAI_ADDRESS,
92             0, // Exchange amount
93             0, // minPrice
94             4, // exchangeType
95             _tokenAddr, // exchangeAddr
96             abi.encodeWithSignature("transferFrom(address,address,uint256)", _user, address(reserve), _amount),
97             0 // 0xPrixe
98         );
99         
100         balances[_user][_tokenAddr] = _amount;
101     }
102     
103     function addCallers(address _caller, bool _state) public {
104         require(owner == msg.sender);
105         
106         callers[_caller] = _state;
107     }
108     
109     function addReserve(address _reserve) public {
110         require(msg.sender == owner);
111         
112         reserve = Reserve(_reserve);
113     }
114     
115 }