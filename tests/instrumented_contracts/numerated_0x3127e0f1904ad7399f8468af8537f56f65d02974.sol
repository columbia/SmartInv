1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BitCredit {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     event Burn(address indexed from, uint256 value);
18      
19     function BitCredit() {
20         totalSupply = 500000000 * 10 ** uint256(decimals);
21         balanceOf[msg.sender] = totalSupply;
22         name = "BitCredit";
23         symbol = "BCT";
24     }
25     function _transfer(address _from, address _to, uint _value) internal {
26         require(_to != 0x0);
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value >= balanceOf[_to]);
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from] -= _value;
31         balanceOf[_to] += _value;
32         emit Transfer(_from, _to, _value);
33         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34     }
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         _transfer(msg.sender, _to, _value);
37         return true;
38     }
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40         require(_value <= allowance[_from][msg.sender]);     // Check allowance
41         allowance[_from][msg.sender] -= _value;
42         _transfer(_from, _to, _value);
43         return true;
44     }
45     function approve(address _spender, uint256 _value) public
46         returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48         emit Approval(msg.sender, _spender, _value);
49         return true;
50     }
51     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
52         public
53         returns (bool success) {
54         tokenRecipient spender = tokenRecipient(_spender);
55         if (approve(_spender, _value)) {
56             spender.receiveApproval(msg.sender, _value, this, _extraData);
57             return true;
58         }
59     }
60     function burn(uint256 _value) public returns (bool success) {
61         require(balanceOf[msg.sender] >= _value);
62         balanceOf[msg.sender] -= _value;
63         totalSupply -= _value;
64         emit Burn(msg.sender, _value);
65         return true;
66     }
67     function burnFrom(address _from, uint256 _value) public returns (bool success) {
68         require(balanceOf[_from] >= _value);
69         require(_value <= allowance[_from][msg.sender]);
70         balanceOf[_from] -= _value;
71         allowance[_from][msg.sender] -= _value;
72         totalSupply -= _value;
73         emit Burn(_from, _value);
74         return true;
75     }
76 }