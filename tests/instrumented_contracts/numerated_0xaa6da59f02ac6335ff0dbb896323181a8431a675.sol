1 pragma solidity ^0.4.16;
2 
3 contract owned {
4   address public owner;
5 
6   function owned() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) onlyOwner public {
16     owner = newOwner;
17   }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23   string public name;
24   string public symbol;
25   uint8 public decimals = 18; // 18 = equal to ETH and wei
26   uint256 public totalSupply;
27 
28   mapping (address => uint256) public balanceOf;
29   mapping (address => mapping (address => uint256)) public allowance;
30 
31   event Transfer(address indexed from, address indexed to, uint256 value);
32   event Burn(address indexed from, uint256 value);
33   event CollectPayment(address indexed from, address indexed to, uint256 value);
34 
35   function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
36     totalSupply = initialSupply * (10 ** uint256(decimals));
37     balanceOf[this] = totalSupply; // give contract all initial tokens
38     name = tokenName;
39     symbol = tokenSymbol;
40   }
41 
42   function _transfer(address _from, address _to, uint _value) internal {
43     require(_to != 0x0);
44     require(balanceOf[_from] >= _value); // sender has enough
45     require(balanceOf[_to] + _value > balanceOf[_to]); // no overflows
46     uint previousBalances = balanceOf[_from] + balanceOf[_to];
47     balanceOf[_from] -= _value;
48     balanceOf[_to] += _value;
49     Transfer(_from, _to, _value);
50     assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51   }
52 
53   function transfer(address _to, uint256 _value) public {
54     _transfer(msg.sender, _to, _value);
55   }
56 
57   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58     require(_value <= allowance[_from][msg.sender]);
59     allowance[_from][msg.sender] -= _value;
60     _transfer(_from, _to, _value);
61     return true;
62   }
63 
64   function approve(address _spender, uint256 _value) public returns (bool success) {
65     allowance[msg.sender][_spender] = _value;
66     return true;
67   }
68 
69   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
70     tokenRecipient spender = tokenRecipient(_spender);
71     if (approve(_spender, _value)) {
72       spender.receiveApproval(msg.sender, _value, this, _extraData);
73       return true;
74     }
75   }
76 
77   function burn(uint256 _value) public returns (bool success) {
78     require(balanceOf[msg.sender] >= _value);
79     balanceOf[msg.sender] -= _value;
80     totalSupply -= _value;
81     Burn(msg.sender, _value);
82     return true;
83   }
84 
85   function burnFrom(address _from, uint256 _value) public returns (bool success) {
86     require(balanceOf[_from] >= _value);
87     require(_value <= allowance[_from][msg.sender]);
88     balanceOf[_from] -= _value;
89     allowance[_from][msg.sender] -= _value;
90     totalSupply -= _value;
91     Burn(_from, _value);
92     return true;
93   }
94 
95 }
96 
97 contract BizCoin is owned, TokenERC20 {
98 
99   uint256 public sendOnRequest = 10000 * (10 ** uint256(decimals));
100 
101   mapping (address => bool) public hasRequested;
102 
103   // set initial to 2,000,000 so there can be max 200 requests
104   function BizCoin(uint256 initialSupply, string tokenName, string tokenSymbol) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
105 
106   function _transfer(address _from, address _to, uint _value) internal {
107     require(_to != 0x0);
108     require(balanceOf[_from] >= _value); // sender has enough
109     require(balanceOf[_to] + _value > balanceOf[_to]); // no overflows
110     uint previousBalances = balanceOf[_from] + balanceOf[_to];
111     balanceOf[_from] -= _value;
112     balanceOf[_to] += _value;
113     Transfer(_from, _to, _value);
114     assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
115   }
116 
117   function request() public {
118     require(hasRequested[msg.sender] == false);
119     hasRequested[msg.sender] = true;
120     _transfer(this, msg.sender, sendOnRequest);
121   }
122 
123   function () payable public {
124     request();
125   }
126 
127 }