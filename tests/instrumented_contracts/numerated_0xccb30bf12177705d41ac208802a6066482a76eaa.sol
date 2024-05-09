1 pragma solidity ^0.4.24;
2 
3 contract DiaOracle {
4             address owner;
5 
6         struct CoinInfo {
7                 uint256 price;
8                 uint256 supply;
9                 uint256 lastUpdateTimestamp;
10                 string symbol;
11         }
12 
13         mapping(string => CoinInfo) diaOracles;
14 
15         event newCoinInfo(
16                 string name,
17                 string symbol,
18                 uint256 price,
19                 uint256 supply,
20                 uint256 lastUpdateTimestamp
21         );
22     
23         constructor() public {
24                 owner = msg.sender;
25         }
26 
27         function changeOwner(address newOwner) public {
28                 require(msg.sender == owner);
29                 owner = newOwner;
30         }
31     
32         function updateCoinInfo(string name, string symbol, uint256 newPrice, uint256 newSupply, uint256 newTimestamp) public {
33                 require(msg.sender == owner);
34                 diaOracles[name] = (CoinInfo(newPrice, newSupply, newTimestamp, symbol));
35                 emit newCoinInfo(name, symbol, newPrice, newSupply, newTimestamp);
36         }
37     
38         function getCoinInfo(string name) public view returns (uint256, uint256, uint256, string) {
39                 return (
40                         diaOracles[name].price,
41                         diaOracles[name].supply,
42                         diaOracles[name].lastUpdateTimestamp,
43                         diaOracles[name].symbol
44                 );
45         }
46 }
47 
48 contract DiaAssetEurOracle {
49     DiaOracle oracle;
50     address owner;
51     
52     constructor() public {
53         owner = msg.sender;
54     }
55     
56     function setOracleAddress(address _address) public {
57         require(msg.sender == owner);
58         oracle = DiaOracle(_address);
59     }
60     
61     function getAssetEurRate(string asset) constant public returns (uint256) {
62         (uint ethPrice,,,) = oracle.getCoinInfo(asset);
63         (uint eurPrice,,,) = oracle.getCoinInfo("EUR");
64         return (ethPrice * 100000 / eurPrice);
65     }
66     
67 }