1 pragma solidity ^0.4.19;
2 
3 contract AppCoins {
4     mapping (address => mapping (address => uint256)) public allowance;
5     function balanceOf (address _owner) public view returns (uint256);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
7 }
8 
9 contract AppCoinsIABInterface {
10     function division(uint numerator, uint denominator) public view returns (uint);
11     function buy(string _packageName, string _sku, uint256 _amount, address _addr_appc, address _dev, address _appstore, address _oem, bytes2 _countryCode) public view returns (bool);
12 }
13 
14 contract AppCoinsIAB is AppCoinsIABInterface {
15 
16     uint public dev_share = 85;
17     uint public appstore_share = 10;
18     uint public oem_share = 5;
19 
20     mapping (address => bool) allowedAddresses;
21     address owner;
22 
23     modifier onlyAllowedAddress(string _funcName) {
24         if(!allowedAddresses[msg.sender]){
25             emit Error(_funcName, "Operation can only be performed by allowed Addresses");
26             return;
27         }
28         _;
29     }
30 
31     modifier onlyOwner(string _funcName) {
32         if(owner != msg.sender){
33             emit Error(_funcName, "Operation can only be performed by contract owner");
34             return;
35         }
36         _;
37     }
38 
39 
40     event Buy(string packageName, string _sku, uint _amount, address _from, address _dev, address _appstore, address _oem, bytes2 countryCode);
41     event Error(string func, string message);
42     event OffChainBuy(address _wallet, bytes32 _rootHash);
43 
44     function AppCoinsIAB() public {
45         owner = msg.sender;
46     }
47 
48     function addAllowedAddress(address _account) public onlyOwner("addAllowedAddress"){
49         allowedAddresses[_account] = true;
50     }
51 
52     function removeAllowedAddress(address _account) public onlyOwner("removeAllowedAddress") {
53         allowedAddresses[_account] = false;
54     }
55 
56     function informOffChainBuy(address[] _walletList, bytes32[] _rootHashList) public onlyAllowedAddress("informOffChainTransaction") {
57         if(_walletList.length != _rootHashList.length){
58             emit Error("informOffChainTransaction", "Wallet list and Roothash list must have the same lengths");
59             return;
60         }
61         for(uint i = 0; i < _walletList.length; i++){
62             emit OffChainBuy(_walletList[i],_rootHashList[i]);
63         }
64     }
65 
66     function division(uint _numerator, uint _denominator) public view returns (uint) {
67         uint quotient = _numerator / _denominator;
68         return quotient;
69     }
70 
71 
72     function buy(string _packageName, string _sku, uint256 _amount, address _addr_appc, address _dev, address _appstore, address _oem, bytes2 _countryCode) public view returns (bool) {
73         require(_addr_appc != 0x0);
74         require(_dev != 0x0);
75         require(_appstore != 0x0);
76         require(_oem != 0x0);
77 
78         AppCoins appc = AppCoins(_addr_appc);
79         uint256 aux = appc.allowance(msg.sender, address(this));
80         if(aux < _amount){
81             emit Error("buy","Not enough allowance");
82             return false;
83         }
84 
85         uint[] memory amounts = new uint[](3);
86         amounts[0] = division(_amount * dev_share, 100);
87         amounts[1] = division(_amount * appstore_share, 100);
88         amounts[2] = division(_amount * oem_share, 100);
89 
90         appc.transferFrom(msg.sender, _dev, amounts[0]);
91         appc.transferFrom(msg.sender, _appstore, amounts[1]);
92         appc.transferFrom(msg.sender, _oem, amounts[2]);
93 
94         emit Buy(_packageName, _sku, _amount, msg.sender, _dev, _appstore, _oem, _countryCode);
95 
96         return true;
97     }
98 }