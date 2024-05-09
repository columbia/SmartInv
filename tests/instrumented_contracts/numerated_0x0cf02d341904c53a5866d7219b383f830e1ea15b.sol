1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;                            //碳汇链 carbon credit chain
7 
8     string public symbol;
9     uint8 public decimals = 18;  
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;  //碳汇链 carbon credit chain
13 
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20 
21     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);
23         balanceOf[msg.sender] = totalSupply;
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
27 
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value > balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public {
41         _transfer(msg.sender, _to, _value);
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(_value <= allowance[_from][msg.sender]);     // Check allowance
46         allowance[_from][msg.sender] -= _value;
47         _transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
58         tokenRecipient spender = tokenRecipient(_spender);
59         if (approve(_spender, _value)) {
60             spender.receiveApproval(msg.sender, _value, this, _extraData);
61             return true;
62         }
63     }
64 
65     function burn(uint256 _value) public returns (bool success) {
66         require(balanceOf[msg.sender] >= _value);
67         balanceOf[msg.sender] -= _value;
68         totalSupply -= _value;
69         Burn(msg.sender, _value);
70         return true;
71     }
72 
73     function burnFrom(address _from, uint256 _value) public returns (bool success) {
74         require(balanceOf[_from] >= _value);
75         require(_value <= allowance[_from][msg.sender]);
76         balanceOf[_from] -= _value;
77         allowance[_from][msg.sender] -= _value;
78         totalSupply -= _value;
79         Burn(_from, _value);
80         return true;
81     }
82 }