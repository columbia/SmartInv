1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
11 		uint256 c = a / b;
12 		return c;
13 	}
14 
15 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 }
26 
27 
28 contract owned {
29     address public owner;
30 
31     function owned() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         if (msg.sender != owner) {
37             revert();
38         }
39         _;
40     }
41 }
42 
43 contract BasicToken is owned {
44     using SafeMath for uint256;
45 
46     // Token Variables Initialization
47     string public constant name = "Valorem";
48     string public constant symbol = "VLR";
49     uint8 public constant decimals = 18;
50 
51     uint256 public totalSupply;
52     uint256 constant initialSupply = 200000000 * (10 ** uint256(decimals));
53 
54     address public reserveAccount;
55     address public bountyAccount;
56 
57     uint256 reserveToken;
58     uint256 bountyToken;
59 
60     mapping (address => bool) public frozenAccount;
61     mapping (address => uint256) public balanceOf;
62 
63     event Burn(address indexed _from,uint256 _value);
64     event FrozenFunds(address _account, bool _frozen);
65     event Transfer(address indexed _from,address indexed _to,uint256 _value);
66 
67     function BasicToken () {
68         totalSupply = initialSupply;
69         balanceOf[msg.sender] = initialSupply;
70 
71         bountyTransfers();
72     }
73 
74     function bountyTransfers() internal {
75         reserveAccount = 0x000f1505CdAEb27197FB652FB2b1fef51cdc524e;
76         bountyAccount = 0x00892214999FdE327D81250407e96Afc76D89CB9;
77 
78         reserveToken = ( totalSupply * 25 ) / 100;
79         bountyToken = ( reserveToken * 7 ) / 100;
80 
81         balanceOf[msg.sender] = totalSupply - reserveToken;
82         balanceOf[bountyAccount] = bountyToken;
83         reserveToken = reserveToken - bountyToken;
84         balanceOf[reserveAccount] = reserveToken;
85 
86         Transfer(msg.sender,reserveAccount,reserveToken);
87         Transfer(msg.sender,bountyAccount,bountyToken);
88     }
89 
90     function _transfer(address _from,address _to,uint256 _value) internal {
91         require(balanceOf[_from] > _value);
92         require(!frozenAccount[_from]);
93         require(!frozenAccount[_to]);
94 
95         balanceOf[_from] = balanceOf[_from].sub(_value);
96         balanceOf[_to] = balanceOf[_to].add(_value);
97         Transfer(_from, _to, _value);
98     }
99 
100     function transfer(address _to,uint256 _value) {
101         _transfer(msg.sender, _to, _value);
102     }
103 
104     function freezeAccount(address _account, bool _frozen) onlyOwner {
105         frozenAccount[_account] = _frozen;
106         FrozenFunds(_account, _frozen);
107     }
108 
109     function burnTokens(uint256 _value) onlyOwner returns (bool success) {
110         require(balanceOf[msg.sender] > _value);
111 
112         balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
113         totalSupply = totalSupply.sub(_value);
114         Burn(msg.sender,_value);
115 
116         return true;
117     }
118 
119     function newTokens(address _owner, uint256 _value) onlyOwner {
120         balanceOf[_owner] = balanceOf[_owner].add(_value);
121         totalSupply = totalSupply.add(_value);
122         Transfer(this, _owner, _value);
123     }
124 
125     function escrowAmount(address _account, uint256 _value) onlyOwner {
126         _transfer(msg.sender, _account, _value);
127         freezeAccount(_account, true);
128     }
129 
130     function () {
131         revert();
132     }
133 
134 }