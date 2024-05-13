1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 import "./Exchange.sol";
6 import "../interfaces/IExchangeFactory.sol";
7 
8 /**
9  * @title ExchangeFactory contract for Elastic Swap.
10  * @author Elastic DAO
11  * @notice The ExchangeFactory provides the needed functionality to create new Exchange's that represent
12  * a single token pair.  Additionally it houses records of all deployed Exchange's for validation and easy
13  * lookup.
14  */
15 contract ExchangeFactory is Ownable, IExchangeFactory {
16     mapping(address => mapping(address => address))
17         public exchangeAddressByTokenAddress;
18     mapping(address => bool) public isValidExchangeAddress;
19 
20     address private feeAddress_;
21 
22     // events
23     event NewExchange(address indexed creator, address indexed exchangeAddress);
24     event SetFeeAddress(address indexed feeAddress);
25 
26     constructor(address _feeAddress) {
27         require(_feeAddress != address(0), "ExchangeFactory: INVALID_ADDRESS");
28         feeAddress_ = _feeAddress;
29     }
30 
31     /**
32      * @notice called to create a new erc20 token pair exchange
33      * @param _name The human readable name of this pair (also used for the liquidity token name)
34      * @param _symbol Shortened symbol for trading pair (also used for the liquidity token symbol)
35      * @param _baseToken address of the ERC20 base token in the pair. This token can have a fixed or elastic supply
36      * @param _quoteToken address of the ERC20 quote token in the pair. This token is assumed to have a fixed supply.
37      */
38     function createNewExchange(
39         string memory _name,
40         string memory _symbol,
41         address _baseToken,
42         address _quoteToken
43     ) external {
44         require(_baseToken != _quoteToken, "ExchangeFactory: IDENTICAL_TOKENS");
45         require(
46             _baseToken != address(0) && _quoteToken != address(0),
47             "ExchangeFactory: INVALID_TOKEN_ADDRESS"
48         );
49         require(
50             exchangeAddressByTokenAddress[_baseToken][_quoteToken] ==
51                 address(0),
52             "ExchangeFactory: DUPLICATE_EXCHANGE"
53         );
54 
55         Exchange exchange =
56             new Exchange(
57                 _name,
58                 _symbol,
59                 _baseToken,
60                 _quoteToken,
61                 address(this)
62             );
63 
64         exchangeAddressByTokenAddress[_baseToken][_quoteToken] = address(
65             exchange
66         );
67         isValidExchangeAddress[address(exchange)] = true;
68 
69         emit NewExchange(msg.sender, address(exchange));
70     }
71 
72     function setFeeAddress(address _feeAddress) external onlyOwner {
73         require(
74             _feeAddress != address(0) && _feeAddress != feeAddress_,
75             "ExchangeFactory: INVAlID_FEE_ADDRESS"
76         );
77         feeAddress_ = _feeAddress;
78         emit SetFeeAddress(_feeAddress);
79     }
80 
81     function feeAddress() public view virtual override returns (address) {
82         return feeAddress_;
83     }
84 }
