1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-19
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-19
7 */
8 
9 pragma solidity ^0.4.16;
10  
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12  
13 contract DOGZ {
14     string public name;
15     string public symbol;
16     uint8 public decimals = 18;  // 18 是建议的默认值
17     uint256 public totalSupply;
18  
19     mapping (address => uint256) public balanceOf;  // 
20     mapping (address => mapping (address => uint256)) public allowance;
21  
22     event Transfer(address indexed from, address indexed to, uint256 value);
23  
24     event Burn(address indexed from, uint256 value);
25  
26  
27     function DOGZ(uint256 initialSupply, string tokenName, string tokenSymbol) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);
29         balanceOf[msg.sender] = totalSupply;
30         name = tokenName;
31         symbol = tokenSymbol;
32     }
33  
34  
35     function _transfer(address _from, address _to, uint _value) internal {
36         require(_to != 0x0);
37         require(balanceOf[_from] >= _value);
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value;
42         Transfer(_from, _to, _value);
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44     }
45  
46     function transfer(address _to, uint256 _value) public {
47         _transfer(msg.sender, _to, _value);
48     }
49  
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);     // Check allowance
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56  
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         return true;
61     }
62  
63     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
64         tokenRecipient spender = tokenRecipient(_spender);
65         if (approve(_spender, _value)) {
66             spender.receiveApproval(msg.sender, _value, this, _extraData);
67             return true;
68         }
69     }
70  
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73         balanceOf[msg.sender] -= _value;
74         totalSupply -= _value;
75         Burn(msg.sender, _value);
76         return true;
77     }
78  
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);
81         require(_value <= allowance[_from][msg.sender]);
82         balanceOf[_from] -= _value;
83         allowance[_from][msg.sender] -= _value;
84         totalSupply -= _value;
85         Burn(_from, _value);
86         return true;
87     }
88 }