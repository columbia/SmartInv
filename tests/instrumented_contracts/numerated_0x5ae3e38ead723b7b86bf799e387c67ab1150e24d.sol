1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-13
3 */
4 
5 pragma solidity ^0.4.16;
6 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
7 contract DAO{
8     string public name='DAO';
9     string public symbol='DAO';
10     uint8 public decimals = 18;
11     uint256 public totalSupply=10000000000000000000000000;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16     constructor (
17         uint256 initialSupply,
18         string tokenName,
19         string tokenSymbol
20     ) public {
21         totalSupply = initialSupply * 10 ** uint256(decimals);
22         balanceOf[msg.sender] = totalSupply;
23         name = tokenName;
24         symbol = tokenSymbol;
25     }
26     function _transfer(address _from, address _to, uint _value) internal {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value >= balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         emit Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36     function transfer(address _to, uint256 _value) public {
37         _transfer(msg.sender, _to, _value);
38     }
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40         require(_value <= allowance[_from][msg.sender]);
41         allowance[_from][msg.sender] -= _value;
42         _transfer(_from, _to, _value);
43         return true;
44     }
45     function approve(address _spender, uint256 _value) public
46         returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48         return true;
49     }
50     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
51         public
52         returns (bool success) {
53         tokenRecipient spender = tokenRecipient(_spender);
54         if (approve(_spender, _value)) {
55             spender.receiveApproval(msg.sender, _value, this, _extraData);
56             return true;
57         }
58     }
59     function burn(uint256 _value) public returns (bool success) {
60         require(balanceOf[msg.sender] >= _value);
61         balanceOf[msg.sender] -= _value;
62         totalSupply -= _value;
63         emit Burn(msg.sender, _value);
64         return true;
65     }
66     function burnFrom(address _from, uint256 _value) public returns (bool success) {
67         require(balanceOf[_from] >= _value);
68         require(_value <= allowance[_from][msg.sender]);
69         balanceOf[_from] -= _value;
70         allowance[_from][msg.sender] -= _value;
71         totalSupply -= _value;
72         emit Burn(_from, _value);
73         return true;
74     }
75 }