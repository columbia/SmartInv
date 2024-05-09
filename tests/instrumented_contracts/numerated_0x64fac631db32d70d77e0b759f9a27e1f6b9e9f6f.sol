1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TON {
6     string public name = 'TON';
7     string public symbol = 'TON';
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 1000000000000000000000000000;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     function TON() public {
18         balanceOf[msg.sender] = totalSupply;
19     }
20 
21     function _transfer(address _from, address _to, uint _value) internal {
22         require(_to != 0x0);
23         require(balanceOf[_from] >= _value);
24         require(balanceOf[_to] + _value >= balanceOf[_to]);
25         uint previousBalances = balanceOf[_from] + balanceOf[_to];
26         balanceOf[_from] -= _value;
27         balanceOf[_to] += _value;
28         Transfer(_from, _to, _value);
29         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
30     }
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         _transfer(msg.sender, _to, _value);
34         return true;
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);     // Check allowance
39         allowance[_from][msg.sender] -= _value;
40         _transfer(_from, _to, _value);
41         return true;
42     }
43 
44     function approve(address _spender, uint256 _value) public
45         returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
52         public
53         returns (bool success) {
54         tokenRecipient spender = tokenRecipient(_spender);
55         if (approve(_spender, _value)) {
56             spender.receiveApproval(msg.sender, _value, this, _extraData);
57             return true;
58         }
59     }
60 }