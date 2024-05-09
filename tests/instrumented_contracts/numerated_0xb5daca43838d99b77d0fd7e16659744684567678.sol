1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28 }
29 
30 interface tokenRecipient {
31     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
32 }
33 
34 contract CAECToken {
35     using SafeMath for uint256;
36     string public name = "CarEasyChain";
37     string public symbol = "CAEC";
38     uint8 public decimals = 18;
39     uint256 public totalSupply = 10000000000 ether;
40 
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Burn(address indexed from, uint256 value);
45 
46     function CAECToken() public {
47         balanceOf[msg.sender] = totalSupply;
48     }
49 
50     function () external payable {
51 
52     }
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55         require(_to != 0x0);
56         require(balanceOf[_from] >= _value);
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         balanceOf[_from] -= _value;
60         balanceOf[_to] += _value;
61         Transfer(_from, _to, _value);
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     function transfer(address _to, uint256 _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81 
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         balanceOf[msg.sender] -= _value;
93         totalSupply -= _value;
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) public returns (bool success) {
99         require(balanceOf[_from] >= _value);
100         require(_value <= allowance[_from][msg.sender]);
101         balanceOf[_from] -= _value;
102         allowance[_from][msg.sender] -= _value;
103         totalSupply -= _value;
104         Burn(_from, _value);
105         return true;
106     }
107 }