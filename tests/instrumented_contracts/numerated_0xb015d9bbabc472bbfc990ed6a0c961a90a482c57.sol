1 pragma solidity ^0.4.19;
2 
3 contract AppCoins {
4     mapping (address => mapping (address => uint256)) public allowance;
5     function balanceOf (address _owner) public constant returns (uint256);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
7 }
8 
9 contract AppCoinsIABInterface {
10     function division(uint numerator, uint denominator) public constant returns (uint);
11     function buy(uint _amount, string _sku, address _addr_appc, address _dev, address _appstore, address _oem) public constant returns (bool);
12 }
13 
14 contract AppCoinsIAB is AppCoinsIABInterface {
15     uint public dev_share = 85;
16     uint public appstore_share = 10;
17     uint public oem_share = 5;
18 
19     event Buy(uint _amount, string _sku, address _from, address _dev, address _appstore, address _oem);
20 
21     function division(uint numerator, uint denominator) public constant returns (uint) {
22         uint _quotient = numerator / denominator;
23         return _quotient;
24     }
25 
26     function buy(uint256 _amount, string _sku, address _addr_appc, address _dev, address _appstore, address _oem) public constant returns (bool) {
27         require(_addr_appc != 0x0);
28         require(_dev != 0x0);
29         require(_appstore != 0x0);
30         require(_oem != 0x0);
31 
32         AppCoins appc = AppCoins(_addr_appc);
33         uint256 aux = appc.allowance(msg.sender, address(this));
34         require(aux >= _amount);
35 
36         uint[] memory amounts = new uint[](3);
37         amounts[0] = division(_amount * dev_share, 100);
38         amounts[1] = division(_amount * appstore_share, 100);
39         amounts[2] = division(_amount * oem_share, 100);
40 
41         appc.transferFrom(msg.sender, _dev, amounts[0]);
42         appc.transferFrom(msg.sender, _appstore, amounts[1]);
43         appc.transferFrom(msg.sender, _oem, amounts[2]);
44 
45         Buy(_amount, _sku, msg.sender, _dev, _appstore, _oem);
46 
47         return true;
48     }
49 }