1 pragma solidity ^0.4.16;
2 
3 contract IERC20Token {
4     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
5     function name() public constant returns (string);
6     function symbol() public constant returns (string);
7     function decimals() public constant returns (uint8);
8     function totalSupply() public constant returns (uint256);
9     function balanceOf(address _owner) public constant returns (uint256);
10     function allowance(address _owner, address _spender) public constant returns (uint256);
11 
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15 }
16 
17 contract BancorConverter {
18     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) payable public returns (uint256);
19 }
20 
21 contract BancorMarketMaker {
22     BancorConverter public constant bancorConverterAddress = BancorConverter(0x578f3c8454F316293DBd31D8C7806050F3B3E2D8);
23 
24     IERC20Token public constant dai = IERC20Token(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
25     IERC20Token public constant bancorErc20Eth = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
26     IERC20Token public constant bancorToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
27     IERC20Token public constant bancorDaiSmartTokenRelay = IERC20Token(0xee01b3AB5F6728adc137Be101d99c678938E6E72);
28     // sell dai price, will be less than normal conversion, _minReturn should be 1/(Dai/Eth price) * .95
29     function sellDaiForEth(uint256 _amountDai, uint256 _minReturn) external returns (uint256) {
30         require(_amountDai > 0);
31         
32         IERC20Token(dai).transferFrom(msg.sender, address(this), _amountDai);
33         require(IERC20Token(dai).approve(address(bancorConverterAddress), _amountDai));
34         
35         IERC20Token[] memory daiToEthConversionPath;
36         daiToEthConversionPath[0] = dai;
37         daiToEthConversionPath[1] = bancorDaiSmartTokenRelay;
38         daiToEthConversionPath[2] = bancorDaiSmartTokenRelay;
39         daiToEthConversionPath[3] = bancorDaiSmartTokenRelay;
40         daiToEthConversionPath[4] = bancorToken;
41         daiToEthConversionPath[5] = bancorToken;
42         daiToEthConversionPath[6] = bancorErc20Eth;
43         bancorConverterAddress.quickConvert(daiToEthConversionPath, _amountDai, _minReturn);
44         msg.sender.transfer(this.balance);
45         
46     }
47 
48     // buy dai price, will be more than normal conversion, _minReturn should be 1/(Dai/Eth price) * 1.05
49     function buyDaiWithEth(uint256 _minReturn) payable external returns (uint256) {
50         require(msg.value > 0);
51         IERC20Token[] memory ethToDaiConversionPath;
52         ethToDaiConversionPath[0] = bancorErc20Eth;
53         ethToDaiConversionPath[1] = bancorToken;
54         ethToDaiConversionPath[2] = bancorToken;
55         ethToDaiConversionPath[3] = bancorDaiSmartTokenRelay;
56         ethToDaiConversionPath[4] = bancorDaiSmartTokenRelay;
57         ethToDaiConversionPath[5] = bancorDaiSmartTokenRelay;
58         ethToDaiConversionPath[6] = dai;
59         bancorConverterAddress.quickConvert.value(msg.value)(ethToDaiConversionPath, msg.value, _minReturn);
60         dai.transfer(msg.sender, dai.balanceOf(address(this)));
61         
62     }
63 }