1 pragma solidity ^0.4.18;
2 
3 
4 contract Refund {
5 
6     address owner;
7 
8     function Refund() {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     mapping (address => uint256) public balances;
18 
19     function add_addys(address[] _addys, uint256[] _values) onlyOwner {
20         for (uint i = 0; i < _addys.length ; i++) {
21             balances[_addys[i]] += (_values[i]);
22         }
23     }
24 
25     function refund() {
26         uint256 eth_to_withdraw = balances[msg.sender];
27         balances[msg.sender] = 0;
28         msg.sender.transfer(eth_to_withdraw);
29     }
30 
31     function direct_refunds(address[] _addys, uint256[] _values) onlyOwner {
32         for (uint i = 0; i < _addys.length ; i++) {
33             uint256 to_refund = (_values[i]);
34             balances[_addys[i]] = 0;
35             _addys[i].transfer(to_refund);
36         }
37     }
38 
39     function change_specific_addy(address _addy, uint256 _val) onlyOwner {
40         balances[_addy] = (_val);
41     }
42 
43     function () payable {}
44 
45     function withdraw_ether() onlyOwner {
46         owner.transfer(this.balance);
47     }
48 }