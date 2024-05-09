1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 contract NEWTOKEN{
4     string public name='NEWTOKEN';
5     string public symbol='NT';
6     uint8 public decimals = 18;
7     uint256 public totalSupply=15800000000000000000000000000;
8     mapping (address => uint256) public balanceOf;
9     mapping (address => mapping (address => uint256)) public allowance;
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Burn(address indexed from, uint256 value);
12     function omec(
13         uint256 initialSupply,
14         string tokenName,
15         string tokenSymbol
16     ) public {
17         totalSupply = initialSupply * 10 ** uint256(decimals);
18         balanceOf[msg.sender] = totalSupply;
19         name = tokenName;
20         symbol = tokenSymbol;
21     }
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value >= balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         emit Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32     function transfer(address _to, uint256 _value) public {
33         _transfer(msg.sender, _to, _value);
34     }
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
36         require(_value <= allowance[_from][msg.sender]);
37         allowance[_from][msg.sender] -= _value;
38         _transfer(_from, _to, _value);
39         return true;
40     }
41     function approve(address _spender, uint256 _value) public
42         returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44         return true;
45     }
46     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
47         public
48         returns (bool success) {
49         tokenRecipient spender = tokenRecipient(_spender);
50         if (approve(_spender, _value)) {
51             spender.receiveApproval(msg.sender, _value, this, _extraData);
52             return true;
53         }
54     }
55     function burn(uint256 _value) public returns (bool success) {
56         require(balanceOf[msg.sender] >= _value);
57         balanceOf[msg.sender] -= _value;
58         totalSupply -= _value;
59         emit Burn(msg.sender, _value);
60         return true;
61     }
62     function burnFrom(address _from, uint256 _value) public returns (bool success) {
63         require(balanceOf[_from] >= _value);
64         require(_value <= allowance[_from][msg.sender]);
65         balanceOf[_from] -= _value;
66         allowance[_from][msg.sender] -= _value;
67         totalSupply -= _value;
68         emit Burn(_from, _value);
69         return true;
70     }
71 }