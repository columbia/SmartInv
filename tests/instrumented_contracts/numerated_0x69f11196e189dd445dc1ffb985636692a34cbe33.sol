1 pragma solidity ^0.4.21;
2 
3 interface BancorConverter {
4     // _path is actually IERC20Token[] type
5     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
6 }
7 
8 contract BancorHandler {
9     // State variables
10     uint256 public MAX_UINT = 2**256 -1;
11     BancorConverter public exchange;
12     // address public bancorQuickConvertAddress = address(0xcf1cc6ed5b653def7417e3fa93992c3ffe49139b);
13 
14     // Constructor
15     function BancorHandler(address _exchange) public {
16         exchange = BancorConverter(_exchange);
17     }
18 
19     // Public functions
20     function getAvailableAmount(
21         address[21] orderAddresses, // conversion path (max length 21)
22         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
23         uint256 exchangeFee, // ignore
24         uint8 v, // ignore
25         bytes32 r, // ignore
26         bytes32 s // ignore
27     ) external returns (uint256) {
28         // Just return a massive number, as there's nothing else we can do here
29         return MAX_UINT;
30     }
31 
32     function performBuy(
33         address[21] orderAddresses, // conversion path (max length 21)
34         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
35         uint256 exchangeFee, // ignore
36         uint256 amountToFill, // ignore
37         uint8 v, // ignore
38         bytes32 r, // ignore
39         bytes32 s // ignore
40     ) external payable returns (uint256) {
41         return trade(orderAddresses, orderValues);
42     }
43 
44     function performSell(
45         address[21] orderAddresses, // conversion path (max length 21)
46         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
47         uint256 exchangeFee, // ignore
48         uint256 amountToFill, // ignore
49         uint8 v, // ignore
50         bytes32 r, // ignore
51         bytes32 s // ignore
52     ) external returns (uint256) {
53         return trade(orderAddresses, orderValues);
54     }
55 
56     function trade(
57         address[21] orderAddresses, // conversion path (max length 21)
58         uint256[6] orderValues // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
59     ) internal returns (uint256) {
60         // Find the length of the conversion path
61         uint256 len = 0;
62         for(; len < orderAddresses.length; len++) {
63             if(orderAddresses[len] == 0) {
64                 break;
65             }
66         }
67         // Create an array of that length
68         address[] memory conversionPath = new address[](len);
69 
70         // Move the contents from orderAddresses to conversionPath
71         for(uint256 i = 0; i < len; i++) {
72             conversionPath[i] = orderAddresses[i];
73         }
74 
75         return exchange.quickConvert.value(msg.value)(conversionPath, orderValues[0], orderValues[1]);
76     }
77 
78     function() public payable {
79         // require(msg.sender == bancorQuickConvertAddress);
80     }
81 }