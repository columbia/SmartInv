1 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
2 
3 contract GlobalIdolCoin {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 8;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event Burn(address indexed from, uint256 value);
15 
16     function TokenERC20(
17         uint256 initialSupply,
18         string tokenName,
19         string tokenSymbol
20     ) public {
21         totalSupply = 100000000000000000;
22         initialSupply = totalSupply;
23         balanceOf[msg.sender] = totalSupply;
24         name = "GlobalIdolCoin";
25         symbol = "GIC";
26         tokenName = name;
27         tokenSymbol = symbol;
28         
29         
30     }
31 
32     function _transfer(address _from, address _to, uint _value) internal {
33         require(_to != 0x0);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         uint previousBalances = balanceOf[_from] + balanceOf[_to];
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(_from, _to, _value);
40         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42 
43     function transfer(address _to, uint256 _value) public {
44         _transfer(msg.sender, _to, _value);
45     }
46 
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= allowance[_from][msg.sender]);
50         allowance[_from][msg.sender] -= _value;
51         _transfer(_from, _to, _value);
52         return true;
53     }
54 
55  
56     function approve(address _spender, uint256 _value) public
57         returns (bool success) {
58         allowance[msg.sender][_spender] = _value;
59         return true;
60     }
61 
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, this, _extraData);
68             return true;
69         }
70     }
71 
72     function burn(uint256 _value) public returns (bool success) {
73         require(balanceOf[msg.sender] >= _value);
74         balanceOf[msg.sender] -= _value;
75         totalSupply -= _value;
76         Burn(msg.sender, _value);
77         return true;
78     }
79 
80 
81     function burnFrom(address _from, uint256 _value) public returns (bool success) {
82         require(balanceOf[_from] >= _value);
83         require(_value <= allowance[_from][msg.sender]);
84         balanceOf[_from] -= _value;
85         allowance[_from][msg.sender] -= _value;
86         totalSupply -= _value;
87         Burn(_from, _value);
88         return true;
89     }
90 }