1 pragma solidity ^0.4.16;
2 
3 contract TokenERC20 {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;  // 18 是建议的默认值
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;  //
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event Burn(address indexed from, uint256 value);
15 
16 
17     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = tokenName;
21         symbol = tokenSymbol;
22     }
23 
24 
25     function _transfer(address _from, address _to, uint _value) internal {
26         require(_to != 0x0);
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value > balanceOf[_to]);
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from] -= _value;
31         balanceOf[_to] += _value;
32         Transfer(_from, _to, _value);
33         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34     }
35 
36     function transfer(address _to, uint256 _value) public returns (bool) {
37         _transfer(msg.sender, _to, _value);
38         return true;
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);     // Check allowance
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
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