1 1 pragma solidity ^0.4.16;
2  
3 2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4  
5 3 contract TokenERC20 {
6 4     string public name;
7 5     string public symbol;
8 6     uint8 public decimals = 18;  // 18 
9 7     uint256 public totalSupply;
10  
11 8     mapping (address => uint256) public balanceOf;  //
12 9     mapping (address => mapping (address => uint256)) public allowance;
13  
14 10     event Transfer(address indexed from, address indexed to, uint256 value);
15  
16 11     event Burn(address indexed from, uint256 value);
17  
18  
19 12     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
20 13         totalSupply = initialSupply * 10 ** uint256(decimals);
21 14         balanceOf[msg.sender] = totalSupply;
22 15         name = tokenName;
23 16         symbol = tokenSymbol;
24 17     }
25  
26  
27 18     function _transfer(address _from, address _to, uint _value) internal {
28 19         require(_to != 0x0);
29 20         require(balanceOf[_from] >= _value);
30 21         require(balanceOf[_to] + _value > balanceOf[_to]);
31 22         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32 23         balanceOf[_from] -= _value;
33 24         balanceOf[_to] += _value;
34 25         Transfer(_from, _to, _value);
35 26         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36 27     }
37  
38 28     function transfer(address _to, uint256 _value) public returns (bool) {
39 29         _transfer(msg.sender, _to, _value);
40 30         return true;
41 31     }
42  
43 32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44 33         require(_value <= allowance[_from][msg.sender]);     // Check allowance
45 34         allowance[_from][msg.sender] -= _value;
46 35         _transfer(_from, _to, _value);
47 36         return true;
48 37     }
49  
50 38     function approve(address _spender, uint256 _value) public
51 39         returns (bool success) {
52 40         allowance[msg.sender][_spender] = _value;
53 41         return true;
54 42     }
55  
56 43     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
57 44         tokenRecipient spender = tokenRecipient(_spender);
58 45         if (approve(_spender, _value)) {
59 46             spender.receiveApproval(msg.sender, _value, this, _extraData);
60 47             return true;
61 48         }
62 49     }
63  
64 50     function burn(uint256 _value) public returns (bool success) {
65 51         require(balanceOf[msg.sender] >= _value);
66 52         balanceOf[msg.sender] -= _value;
67 53         totalSupply -= _value;
68 54         Burn(msg.sender, _value);
69 55         return true;
70 56     }
71  
72 57     function burnFrom(address _from, uint256 _value) public returns (bool success) {
73 58         require(balanceOf[_from] >= _value);
74 59         require(_value <= allowance[_from][msg.sender]);
75 60         balanceOf[_from] -= _value;
76 61         allowance[_from][msg.sender] -= _value;
77 62         totalSupply -= _value;
78 63         Burn(_from, _value);