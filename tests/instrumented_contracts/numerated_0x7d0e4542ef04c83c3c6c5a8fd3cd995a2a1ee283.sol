1 pragma solidity ^ 0.4.16;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
11 		// assert(b > 0); // Solidity automatically throws when dividing by 0
12 		uint256 c = a / b;
13 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
14 		return c;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract owned {
30     address public owner;
31 
32     function owned() {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         if (msg.sender != owner) {
38             revert();
39         }
40         _;
41     }
42 }
43 
44 contract GexCrypto is owned {
45     using SafeMath for uint256;
46 
47     // Token Variables Initialization
48     string public constant name = "GexCrypto";
49     string public constant symbol = "GEX";
50     uint8 public constant decimals = 18;
51 
52     uint256 public totalSupply;
53     uint256 public constant initialSupply = 400000000 * (10 ** uint256(decimals));
54 
55     address public reserveAccount;
56     address public generalBounty;
57     address public russianBounty;
58 
59     uint256 reserveToken;
60     uint256 bountyToken;
61 
62     mapping (address => bool) public frozenAccount;
63     mapping (address => uint256) public balanceOf;
64 
65     event Burn(address indexed _from,uint256 _value);
66     event FrozenFunds(address _account, bool _frozen);
67     event Transfer(address indexed _from,address indexed _to,uint256 _value);
68 
69     function GexCrypto() {
70         totalSupply = initialSupply;
71         balanceOf[msg.sender] = initialSupply;
72 
73         bountyTransfers();
74     }
75 
76     function bountyTransfers() internal {
77         reserveAccount = 0x0058106dF1650Bf1AdcB327734e0FbCe1996133f;
78         generalBounty = 0x00667a9339FDb56A84Eea687db6B717115e16bE8;
79         russianBounty = 0x00E76A4c7c646787631681A41ABa3514A001f4ad;
80         reserveToken = ( totalSupply * 13 ) / 100;
81         bountyToken = ( totalSupply * 2 ) / 100;
82 
83         balanceOf[msg.sender] = totalSupply - reserveToken - bountyToken;
84         balanceOf[russianBounty] = bountyToken / 2;
85         balanceOf[generalBounty] = bountyToken / 2;
86         balanceOf[reserveAccount] = reserveToken;
87 
88         Transfer(msg.sender,reserveAccount,reserveToken);
89         Transfer(msg.sender,generalBounty,bountyToken);
90         Transfer(msg.sender,russianBounty,bountyToken);
91     }
92 
93     function _transfer(address _from,address _to,uint256 _value) internal {
94         require(balanceOf[_from] > _value);
95         require(!frozenAccount[_from]);
96         require(!frozenAccount[_to]);
97 
98         balanceOf[_from] = balanceOf[_from].sub(_value);
99         balanceOf[_to] = balanceOf[_to].add(_value);
100         Transfer(_from, _to, _value);
101     }
102 
103     function transfer(address _to,uint256 _value) {
104         _transfer(msg.sender, _to, _value);
105     }
106 
107     function freezeAccount(address _account, bool _frozen) onlyOwner {
108         frozenAccount[_account] = _frozen;
109         FrozenFunds(_account, _frozen);
110     }
111 
112     function burnTokens(uint256 _value) onlyOwner returns (bool success) {
113         require(balanceOf[msg.sender] > _value);
114 
115         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
116         totalSupply = totalSupply.sub(_value);
117         Burn(msg.sender,_value);
118 
119         return true;
120     }
121 
122     function newTokens(address _owner, uint256 _value) onlyOwner {
123         balanceOf[_owner] = balanceOf[_owner].add(_value);
124         totalSupply = totalSupply.add(_value);
125         Transfer(0, this, _value);
126         Transfer(this, _owner, _value);
127     }
128 
129     function escrowAmount(address _account, uint256 _value) onlyOwner {
130         _transfer(msg.sender, _account, _value);
131         freezeAccount(_account, true);
132     }
133 
134     function () {
135         revert();
136     }
137 
138 }