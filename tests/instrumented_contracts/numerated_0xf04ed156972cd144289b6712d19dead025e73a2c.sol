1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 
23 contract FUS is owned {
24     string public name = 'FusChain';
25     string public symbol = 'FUS';
26     uint8 public decimals = 18;
27     // 10000w  100000000 * 1000000000000000000
28     uint public totalSupply = 100000000000000000000000000;
29 
30     mapping (address => uint) public balanceOf;
31     mapping (address => mapping (address => uint)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint value);
34 
35     function FUS() public {
36         balanceOf[msg.sender] = totalSupply;
37     }
38 
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50     function transfer(address _to, uint _value) public {
51         _transfer(msg.sender, _to, _value);
52     }
53 
54     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);  
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint _value) public returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66     function () payable public {
67         uint etherAmount = msg.value;
68         owner.transfer(etherAmount);
69     }
70 }