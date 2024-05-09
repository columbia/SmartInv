1 pragma solidity ^0.4.23;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract AlkonCoin {
6     string public name = "Alkon Coin";
7     string public symbol = "AKC";
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 2100000000000000000000000000;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     constructor() public {
19         balanceOf[msg.sender] = totalSupply;
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != address(0));
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value >= balanceOf[_to]);
26         balanceOf[_from] -= _value;
27         balanceOf[_to] += _value;
28         emit Transfer(_from, _to, _value);
29     }
30 
31     function transfer(address _to, uint256 _value) public {
32         _transfer(msg.sender, _to, _value);
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
36         require(_value <= allowance[_from][msg.sender]);
37         allowance[_from][msg.sender] -= _value;
38         _transfer(_from, _to, _value);
39         return true;
40     }
41 
42     function approve(address _spender, uint256 _value) public returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44         return true;
45     }
46 
47     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
48         tokenRecipient spender = tokenRecipient(_spender);
49         if (approve(_spender, _value)) {
50             spender.receiveApproval(msg.sender, _value, this, _extraData);
51             return true;
52         }
53     }
54 
55     function burn(uint256 _value) public returns (bool success) {
56         require(balanceOf[msg.sender] >= _value);
57         balanceOf[msg.sender] -= _value;
58         totalSupply -= _value;
59         emit Burn(msg.sender, _value);
60         return true;
61     }
62 
63     function burnFrom(address _from, uint256 _value) public returns (bool success) {
64         require(balanceOf[_from] >= _value);
65         require(_value <= allowance[_from][msg.sender]);
66         balanceOf[_from] -= _value;
67         allowance[_from][msg.sender] -= _value;
68         totalSupply -= _value;
69         emit Burn(_from, _value);
70         return true;
71     }
72 }