1 pragma solidity ^0.4.13;
2 
3 contract Coin900ExchangeCoin {
4     address public owner;
5     string  public name;
6     string  public symbol;
7     uint8   public decimals;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /* This notifies clients about the amount burnt */
17     event Burn(address indexed from, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function Coin900ExchangeCoin() {
21       owner = 0xA8961BF80a4A8Cb9Df61bD211Dc78DF8FF48e528;
22       name = 'Coin900 Exchange Coin';
23       symbol = 'CXC';
24       decimals = 18;
25       totalSupply = 100000000000000000000000000;  // 1e26
26       balanceOf[owner] = 100000000000000000000000000;
27     }
28 
29     /* Send coins */
30     function transfer(address _to, uint256 _value) returns (bool success) {
31       require(balanceOf[msg.sender] > _value);
32 
33       balanceOf[msg.sender] -= _value;
34       balanceOf[_to] += _value;
35       Transfer(msg.sender, _to, _value);
36       return true;
37     }
38 
39     /* Allow another contract to spend some tokens in your behalf */
40     function approve(address _spender, uint256 _value) returns (bool success) {
41       allowance[msg.sender][_spender] = _value;
42       return true;
43     }
44 
45     /* A contract attempts to get the coins */
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47       require(balanceOf[_from] > _value);
48       require(allowance[_from][msg.sender] > _value);
49 
50       balanceOf[_from] -= _value;
51       balanceOf[_to] += _value;
52       allowance[_from][msg.sender] -= _value;
53       Transfer(_from, _to, _value);
54       return true;
55     }
56 
57     function burn(uint256 _value) returns (bool success) {
58       require(balanceOf[msg.sender] > _value);
59 
60       balanceOf[msg.sender] -= _value;
61       totalSupply -= _value;
62       Burn(msg.sender, _value);
63       return true;
64     }
65 
66     function burnFrom(address _from, uint256 _value) returns (bool success) {
67       require(balanceOf[_from] > _value);
68       require(msg.sender == owner);
69 
70       balanceOf[_from] -= _value;
71       totalSupply -= _value;
72       Burn(_from, _value);
73       return true;
74     }
75 
76     function setName(string _newName) returns (bool success) {
77       require(msg.sender == owner);
78       name = _newName;
79       return true;
80     }
81 
82     function setSymbol(string _newSymbol) returns (bool success) {
83       require(msg.sender == owner);
84       symbol = _newSymbol;
85       return true;
86     }
87 
88     function setDecimals(uint8 _newDecimals) returns (bool success) {
89       require(msg.sender == owner);
90       decimals = _newDecimals;
91       return true;
92     }
93 }