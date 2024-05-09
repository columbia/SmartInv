1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract TokenERC20 {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
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
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
34         require(_value <= allowance[_from][msg.sender]);     // Check allowance
35         allowance[_from][msg.sender] -= _value;
36         _transfer(_from, _to, _value);
37         return true;
38     }
39 
40     function approve(address _spender, uint256 _value) public
41         returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 
46     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
47         tokenRecipient spender = tokenRecipient(_spender);
48         if (approve(_spender, _value)) {
49             spender.receiveApproval(msg.sender, _value, this, _extraData);
50             return true;
51         }
52     }
53 
54     function burn(uint256 _value) public returns (bool success) {
55         require(balanceOf[msg.sender] >= _value);
56         balanceOf[msg.sender] -= _value;
57         totalSupply -= _value;
58         Burn(msg.sender, _value);
59         return true;
60     }
61 
62     function burnFrom(address _from, uint256 _value) public returns (bool success) {
63         require(balanceOf[_from] >= _value);
64         require(_value <= allowance[_from][msg.sender]);
65         balanceOf[_from] -= _value;
66         allowance[_from][msg.sender] -= _value;
67         totalSupply -= _value;
68         Burn(_from, _value);
69         return true;
70     }
71 }