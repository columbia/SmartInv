1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-30
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 
9 contract TokenERC20 {
10     string public name ;
11     string public symbol;
12     uint8 public constant decimals = 18;  // 18 是建议的默认值
13     uint256 public totalSupply;
14 	
15 	uint256 private constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
16 
17     mapping (address => uint256) public balanceOf;  // 
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Burn(address indexed from, uint256 value);
23 	
24 	event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 	function TokenERC20(string tokenName, string tokenSymbol) public {
27 		totalSupply = INITIAL_SUPPLY;
28         balanceOf[msg.sender] = totalSupply;
29         name = tokenName;
30         symbol = tokenSymbol;
31     }
32 
33 
34     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43 		return true;
44     }
45 
46     function transfer(address _to, uint256 _value) public returns (bool) {
47         _transfer(msg.sender, _to, _value);
48 		return true;
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);     // Check allowance
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) public
59         returns (bool success) {
60 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
61         allowance[msg.sender][_spender] = _value;
62 		Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69             spender.receiveApproval(msg.sender, _value, this, _extraData);
70             return true;
71         }
72     }
73 
74     function burn(uint256 _value) public returns (bool success) {
75         require(balanceOf[msg.sender] >= _value);
76         balanceOf[msg.sender] -= _value;
77         totalSupply -= _value;
78         Burn(msg.sender, _value);
79         return true;
80     }
81 
82     function burnFrom(address _from, uint256 _value) public returns (bool success) {
83         require(balanceOf[_from] >= _value);
84         require(_value <= allowance[_from][msg.sender]);
85         balanceOf[_from] -= _value;
86         allowance[_from][msg.sender] -= _value;
87         totalSupply -= _value;
88         Burn(_from, _value);
89         return true;
90     }
91 }