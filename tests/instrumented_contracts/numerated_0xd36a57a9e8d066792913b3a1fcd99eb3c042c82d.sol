1 pragma solidity ^0.4.26;
2 
3 contract BaseToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function _transfer(address _from, address _to, uint _value) internal {
16         require(_to != address(0));
17         require(balanceOf[_from] >= _value);
18         require(balanceOf[_to] + _value > balanceOf[_to]);
19         uint previousBalances = balanceOf[_from] + balanceOf[_to];
20         balanceOf[_from] -= _value;
21         balanceOf[_to] += _value;
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23         emit Transfer(_from, _to, _value);
24     }
25 
26     function transfer(address _to, uint256 _value) public {
27         _transfer(msg.sender, _to, _value);
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value <= allowance[_from][msg.sender]);
32         allowance[_from][msg.sender] -= _value;
33         _transfer(_from, _to, _value);
34         return true;
35     }
36 
37     function approve(address _spender, uint256 _value) public returns (bool success) {
38         allowance[msg.sender][_spender] = _value;
39         emit Approval(msg.sender, _spender, _value);
40         return true;
41     }
42 }
43 contract BurnToken is BaseToken {
44     event Burn(address indexed from, uint256 value);
45 
46     function burn(uint256 _value) public returns (bool success) {
47         require(balanceOf[msg.sender] >= _value);
48         balanceOf[msg.sender] -= _value;
49         totalSupply -= _value;
50         emit Burn(msg.sender, _value);
51         return true;
52     }
53 
54     function burnFrom(address _from, uint256 _value) public returns (bool success) {
55         require(balanceOf[_from] >= _value);
56         require(_value <= allowance[_from][msg.sender]);
57         balanceOf[_from] -= _value;
58         allowance[_from][msg.sender] -= _value;
59         totalSupply -= _value;
60         emit Burn(_from, _value);
61         return true;
62     }
63 }
64 contract StandardToken is BaseToken {
65     constructor(
66         uint256 _initialAmount,
67         string _tokenName,
68         uint8 _decimalUnits,
69         string _tokenSymbol
70     ) public {
71         balanceOf[msg.sender] = _initialAmount;               // Give the creator all initial tokens
72         totalSupply = _initialAmount;                        // Update total supply
73         name = _tokenName;                                   // Set the name for display purposes
74         decimals = _decimalUnits;                            // Amount of decimals for display purposes
75         symbol = _tokenSymbol;                               // Set the symbol for display purposes
76     }
77 }