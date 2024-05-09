1 pragma solidity ^0.4.16;
 
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
 
3 contract TokenERC20 {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;  // 18 
7     uint256 public totalSupply;
 
8     mapping (address => uint256) public balanceOf;  //
9     mapping (address => mapping (address => uint256)) public allowance;
 
10     event Transfer(address indexed from, address indexed to, uint256 value);
 
11     event Burn(address indexed from, uint256 value);
 
 
12     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
13         totalSupply = initialSupply * 10 ** uint256(decimals);
14         balanceOf[msg.sender] = totalSupply;
15         name = tokenName;
16         symbol = tokenSymbol;
17     }
 
 
18     function _transfer(address _from, address _to, uint _value) internal {
19         require(_to != 0x0);
20         require(balanceOf[_from] >= _value);
21         require(balanceOf[_to] + _value > balanceOf[_to]);
22         uint previousBalances = balanceOf[_from] + balanceOf[_to];
23         balanceOf[_from] -= _value;
24         balanceOf[_to] += _value;
25         Transfer(_from, _to, _value);
26         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
27     }
 
28     function transfer(address _to, uint256 _value) public returns (bool) {
29         _transfer(msg.sender, _to, _value);
30         return true;
31     }
 
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
33         require(_value <= allowance[_from][msg.sender]);     // Check allowance
34         allowance[_from][msg.sender] -= _value;
35         _transfer(_from, _to, _value);
36         return true;
37     }
 
38     function approve(address _spender, uint256 _value) public
39         returns (bool success) {
40         allowance[msg.sender][_spender] = _value;
41         return true;
42     }
 
43     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
44         tokenRecipient spender = tokenRecipient(_spender);
45         if (approve(_spender, _value)) {
46             spender.receiveApproval(msg.sender, _value, this, _extraData);
47             return true;
48         }
49     }
 
50     function burn(uint256 _value) public returns (bool success) {
51         require(balanceOf[msg.sender] >= _value);
52         balanceOf[msg.sender] -= _value;
53         totalSupply -= _value;
54         Burn(msg.sender, _value);
55         return true;
56     }
 
57     function burnFrom(address _from, uint256 _value) public returns (bool success) {
58         require(balanceOf[_from] >= _value);
59         require(_value <= allowance[_from][msg.sender]);
60         balanceOf[_from] -= _value;
61         allowance[_from][msg.sender] -= _value;
62         totalSupply -= _value;
63         Burn(_from, _value);