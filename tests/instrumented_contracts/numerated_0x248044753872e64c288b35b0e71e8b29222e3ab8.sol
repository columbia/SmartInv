1 pragma solidity ^0.4.13;
2 
3 contract HunterCoin {
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
20     function HunterCoin() {
21       balanceOf[msg.sender] = 210000;
22       totalSupply = 210000;
23       name = 'Hunter Coin';
24       symbol = 'HTC';
25       decimals = 100;
26       owner = msg.sender;
27     }
28 
29     function mintToken(address target, uint256 amount) returns (uint256 mintedAmount) {
30       balanceOf[target] += amount;
31       totalSupply += amount;
32       Transfer(owner, target, amount);
33       return amount;
34     }
35 
36     /* Send coins */
37     function transfer(address _to, uint256 _value) returns (bool success) {
38       require(balanceOf[msg.sender] > _value);
39 
40       balanceOf[msg.sender] -= _value;
41       balanceOf[_to] += _value;
42       Transfer(msg.sender, _to, _value);
43       return true;
44     }
45 
46     /* Allow another contract to spend some tokens in your behalf */
47     function approve(address _spender, uint256 _value) returns (bool success) {
48       allowance[msg.sender][_spender] = _value;
49       return true;
50     }
51 
52     /* A contract attempts to get the coins */
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54       require(balanceOf[_from] > _value);
55       require(balanceOf[_to] + _value > balanceOf[_to]);
56       require(_value < allowance[_from][msg.sender]);
57 
58       balanceOf[_from] -= _value;
59       balanceOf[_to] += _value;
60       allowance[_from][msg.sender] -= _value;
61       Transfer(_from, _to, _value);
62       return true;
63     }
64 
65     function burn(uint256 _value) returns (bool success) {
66       require(balanceOf[msg.sender] > _value);
67 
68       balanceOf[msg.sender] -= _value;
69       totalSupply -= _value;
70       Burn(msg.sender, _value);
71       return true;
72     }
73 
74     function burnFrom(address _from, uint256 _value) returns (bool success) {
75       require(balanceOf[_from] > _value);
76       require(_value < allowance[_from][msg.sender]);
77 
78       balanceOf[_from] -= _value;
79       totalSupply -= _value;
80       Burn(_from, _value);
81       return true;
82     }
83 }