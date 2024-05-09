1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to relinquish control of the contract.
37      * @notice Renouncing to ownership will leave the contract without an owner.
38      * It will not be possible to call the functions with the `onlyOwner`
39      * modifier anymore.
40      */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47      * @dev Allows the current owner to transfer control of the contract to a newOwner.
48      * @param _newOwner The address to transfer ownership to.
49      */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55      * @dev Transfers control of the contract to a newOwner.
56      * @param _newOwner The address to transfer ownership to.
57      */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 /**
66  * @title Currency exchange rate contract
67  */
68 contract CurrencyExchangeRate is Ownable {
69 
70     struct Currency {
71         uint256 exRateToEther; // Exchange rate: currency to Ether
72         uint8 exRateDecimals;  // Exchange rate decimals
73     }
74 
75     Currency[] public currencies;
76 
77     event CurrencyExchangeRateAdded(
78         address indexed setter, uint256 index, uint256 rate, uint256 decimals
79     );
80 
81     event CurrencyExchangeRateSet(
82         address indexed setter, uint256 index, uint256 rate, uint256 decimals
83     );
84 
85     constructor() public {
86         // Add Ether to index 0
87         currencies.push(
88             Currency ({
89                 exRateToEther: 1,
90                 exRateDecimals: 0
91             })
92         );
93         // Add USD to index 1
94         currencies.push(
95             Currency ({
96                 exRateToEther: 30000,
97                 exRateDecimals: 2
98             })
99         );
100     }
101 
102     function addCurrencyExchangeRate(
103         uint256 _exRateToEther, 
104         uint8 _exRateDecimals
105     ) external onlyOwner {
106         emit CurrencyExchangeRateAdded(
107             msg.sender, currencies.length, _exRateToEther, _exRateDecimals);
108         currencies.push(
109             Currency ({
110                 exRateToEther: _exRateToEther,
111                 exRateDecimals: _exRateDecimals
112             })
113         );
114     }
115 
116     function setCurrencyExchangeRate(
117         uint256 _currencyIndex,
118         uint256 _exRateToEther, 
119         uint8 _exRateDecimals
120     ) external onlyOwner {
121         emit CurrencyExchangeRateSet(
122             msg.sender, _currencyIndex, _exRateToEther, _exRateDecimals);
123         currencies[_currencyIndex].exRateToEther = _exRateToEther;
124         currencies[_currencyIndex].exRateDecimals = _exRateDecimals;
125     }
126 }