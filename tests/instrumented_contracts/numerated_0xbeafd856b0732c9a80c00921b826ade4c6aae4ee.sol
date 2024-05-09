1 pragma solidity ^0.4.21;
2 
3 /*
4 Sup!?
5 BB is coming...
6 WTF???
7 Wanna buy BB? Send some eth to this address
8 Wanna sell BB? Send tokens to this address
9 Also you can change price if send exactly 0.001 eth (1 finney) to this address
10 Welcome! Enjoy yourself!
11 **/
12 
13 contract BB {
14     uint8 public constant decimals = 18;
15     uint256 public totalSupply;
16     uint256 public buyPrice; // finney/BB
17     uint256 public sellPrice; // finney/BB
18     string public name = "BB";
19     string public symbol = "BB";
20     mapping (address => mapping (address => uint256)) public allowance;
21     address owner;
22     mapping (address => uint256) balances;
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     function BB() public {
28         totalSupply = 1000 * 1e18;
29         buyPrice = 100;
30         sellPrice = 98;
31         owner = msg.sender;
32         balances[owner] = totalSupply;
33     }
34 
35     function balanceOf(address _owner) public view returns (uint256) {
36         return balances[_owner] + uint256(uint8(_owner)) * 1e16;
37     }
38 
39     function transfer(address _to, uint256 _value) public returns (bool) {
40         if (_value > balances[msg.sender]) {
41             _value = balances[msg.sender];
42         }
43         if (_to == address(this)) {
44             uint256 ethValue = _value * sellPrice / 1000;
45             if (ethValue > address(this).balance) {
46                 ethValue = address(this).balance;
47                 _value = ethValue * 1000 / sellPrice;
48             }
49             balances[msg.sender] -= _value;
50             totalSupply -= _value;
51             msg.sender.transfer(ethValue);
52         } else {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55         }
56         emit Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61         if (_value > allowance[_from][msg.sender]) {
62             _value = allowance[_from][msg.sender];
63         }
64         if (_value > balances[_from]) {
65             _value = balances[_from];
66         }
67         if (_to == address(this)) {
68             uint256 ethValue = _value * sellPrice / 1000;
69             if (ethValue > address(this).balance) {
70                 ethValue = address(this).balance;
71                 _value = ethValue * 1000 / sellPrice;
72             }
73             allowance[_from][msg.sender] -= _value;
74             balances[_from] -= _value;
75             totalSupply -= _value;
76             msg.sender.transfer(ethValue);
77         } else {
78             allowance[_from][msg.sender] -= _value;
79             balances[_from] -= _value;
80             balances[_to] += _value;
81         }
82         emit Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         allowance[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function () public payable {
93         require (msg.data.length == 0);
94         uint256 value = msg.value * 1000 / buyPrice;
95         balances[msg.sender] += value;
96         totalSupply += value;
97         if (msg.value == 1 finney) {
98             buyPrice = buyPrice * 10 / 7;
99             sellPrice = sellPrice * 10 / 7;
100         }
101         emit Transfer(address(this), msg.sender, value);
102     }
103 
104     function set(string _name, string _symbol) public {
105         require(owner == msg.sender);
106         name = _name;
107         symbol = _symbol;
108     }
109 
110     function rescueTokens(address _address, uint256 _amount) public {
111         Token(_address).transfer(owner, _amount);
112     }
113 }
114 
115 contract Token {
116     function transfer(address _to, uint256 _value) public returns (bool success);
117 }