1 contract OraclizeI {
2     function getPrice(string _datasource, uint _gas_limit) returns (uint _dsprice);
3     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
4 }
5 contract OraclizeAddrResolverI {
6     function getAddress() returns (address _addr);
7 }
8 
9 
10 contract USDOracle {
11     OraclizeAddrResolverI OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
12 
13     function USDOracle() {
14     }
15 
16     function initialize() public {
17         var oraclize = OraclizeI(OAR.getAddress());
18         oraclize.query.value(msg.value)(0, "URL", "http://example.com");
19     }
20 
21     function getPriceProxy() constant returns (uint) {
22         var oraclize = OraclizeI(OAR.getAddress());
23         return oraclize.getPrice("URL", 200000);
24     }
25 
26     function oneCentOfWei() constant returns (uint) {
27         var oraclize = OraclizeI(OAR.getAddress());
28         var price = oraclize.getPrice("URL", 200000);
29         var one_cent_of_wei = price - tx.gasprice * 200000;
30         return one_cent_of_wei;
31     }
32 
33     function WEI() constant returns (uint) {
34         // 1 USD in WEI
35         return oneCentOfWei() * 100;
36     }
37 
38     function USD() constant returns (uint) {
39         // 1 ETH in USD
40         return 1 ether / oneCentOfWei();
41     }
42 }