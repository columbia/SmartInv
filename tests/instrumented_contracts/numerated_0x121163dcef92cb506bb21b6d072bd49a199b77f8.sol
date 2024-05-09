1 pragma solidity ^0.4.23;
2 
3 
4 contract Owned {
5     address public owner;
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; }
22 
23 
24 contract TokenBase is Owned {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     uint public totalSupply;
29     uint public tokenUnit = 10 ** uint(decimals);
30     uint public kUnit = 1000 * tokenUnit;
31     uint public foundingTime;
32 
33     mapping (address => uint) public balanceOf;
34     mapping (address => mapping (address => uint)) public allowance;
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37 
38     constructor() public {
39         foundingTime = now;
40     }
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     function transfer(address _to, uint _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint _value) public returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 }
77 
78 contract TRE is TokenBase {
79     uint public initialSupply = 0;
80     uint public reserveSupply = 10000000 * kUnit;
81 
82     constructor() public {
83         totalSupply = initialSupply;
84         balanceOf[msg.sender] = initialSupply;
85         name = "Tre Chain";
86         symbol = "TRE";
87     }
88 
89     function releaseReserve(uint value) onlyOwner public {
90         require(reserveSupply >= value);
91         balanceOf[owner] += value;
92         totalSupply += value;
93         reserveSupply -= value;
94         emit Transfer(0, this, value);
95         emit Transfer(this, owner, value);
96     }
97 
98 }