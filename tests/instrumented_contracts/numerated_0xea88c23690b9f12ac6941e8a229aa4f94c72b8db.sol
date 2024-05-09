1 pragma solidity ^0.4.15;
2 
3 contract generic_holder {
4     address owner;
5     
6     modifier onlyowner {
7         require(msg.sender == owner);
8         _;
9     }
10     
11     // constructor
12     function generic_holder() {
13         owner = msg.sender;
14     }
15     
16     function change_owner(address new_owner) external onlyowner {
17         owner = new_owner;
18     }
19     
20     function execute(address _to, uint _value, bytes _data) external onlyowner payable returns (bool){
21         return _to.call.value(_value)(_data);
22     }
23 
24     function send(address _to) external onlyowner payable returns (bool){
25         return _to.call.gas(300000).value(msg.value)();
26     }
27     
28     function get_owner() constant returns (address) {
29         return owner;
30     }
31     
32 }