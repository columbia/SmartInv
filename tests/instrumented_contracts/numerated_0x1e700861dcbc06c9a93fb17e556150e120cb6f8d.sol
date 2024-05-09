1 pragma solidity ^0.4.11;
2 
3 /* The Schmeckle */
4 
5 contract TheSchmeckle {
6 
7     string public standard = 'CoRToken';
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12     uint256 public sellPrice;
13     uint256 public buyPrice;
14 
15     function TheSchmeckle() {
16         totalSupply = 1000000000;
17         balanceOf[this] = totalSupply;
18         name = 'Schmeckle';
19         symbol = 'SHM';
20         decimals = 0;
21         sellPrice = 100000000000000;
22         buyPrice = 100000000000000;
23     }
24 
25     mapping (address => uint256) public balanceOf;  
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) revert();
31         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(msg.sender, _to, _value);
35     }
36 
37     function buy() payable {
38         uint amount = msg.value / buyPrice;
39         if (balanceOf[this] < amount) revert();
40         balanceOf[msg.sender] += amount;
41         balanceOf[this] -= amount;
42         Transfer(this, msg.sender, amount);
43     }
44 
45     function sell(uint256 amount) {
46         if (balanceOf[msg.sender] < amount ) revert();
47         balanceOf[this] += amount;
48         balanceOf[msg.sender] -= amount;
49         if (!msg.sender.send(amount * sellPrice)) {
50             revert();
51         } else {
52             Transfer(msg.sender, this, amount);
53         }
54     }
55     
56     function () {
57         revert();
58     }
59 }