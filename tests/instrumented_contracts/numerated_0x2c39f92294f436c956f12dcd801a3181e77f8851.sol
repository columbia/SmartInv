1 pragma solidity ^0.4.11;
2 
3 contract SpeculateCoin { 
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     address public owner;
8     bool public start;
9     uint256 public transactions;
10     mapping (address => uint256) public balanceOf;
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     
13     function Start() {
14         if (msg.sender != owner) { return; }
15         start = true;
16     }
17     
18     function SpeculateCoin() {
19         balanceOf[this] = 2100000000000000;
20         name = "SpeculateCoin";     
21         symbol = "SPC";
22         owner = msg.sender;
23         decimals = 8;
24         transactions = 0;
25         start = false;
26     }
27 
28     function transfer(address _to, uint256 _value) {
29         if (balanceOf[msg.sender] < _value) return;
30         if (balanceOf[_to] + _value < balanceOf[_to]) return;
31         balanceOf[msg.sender] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(msg.sender, _to, _value);
34     }
35     
36     function() payable {
37         if(msg.value == 0) { return; }
38         uint256 price = 100 + (transactions * 100);
39         uint256 amount = msg.value / price;
40         if (start == false || amount < 100000000 || amount > 1000000000000 || balanceOf[this] < amount) {
41             msg.sender.transfer(msg.value);
42             return; 
43         }
44         owner.transfer(msg.value);
45         balanceOf[msg.sender] += amount;     
46         balanceOf[this] -= amount;
47         Transfer(this, msg.sender, amount);
48         transactions = transactions + 1;
49     }
50 }