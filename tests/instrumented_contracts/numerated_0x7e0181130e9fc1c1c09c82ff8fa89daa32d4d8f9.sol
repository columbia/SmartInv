1 pragma solidity ^0.4.23;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = 0x318d9e2fFEC1A7Cd217F77f799deBAd1e9064556;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) {
12             revert();
13         }
14         _;
15     }
16 }
17 
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a / b;
27 		return c;
28 	}
29 
30 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31 		assert(b <= a);
32 		return a - b;
33 	}
34 
35 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
36 		uint256 c = a + b;
37 		assert(c >= a);
38 		return c;
39 	}
40 }
41 
42 contract NGTToken is owned {
43     using SafeMath for uint256;
44 
45     string public constant name = "NextGenToken";
46     string public constant symbol = "NGT";
47     uint8 public constant decimals = 18;
48 
49     uint256 public totalSupply;
50     uint256 public constant initialSupply = 2200000000 * (10 ** uint256(decimals));
51 
52     address public fundingReserve;
53     address public bountyReserve;
54     address public teamReserve;
55     address public advisorReserve;
56 
57     uint256 fundingToken;
58     uint256 bountyToken;
59     uint256 teamToken;
60     uint256 advisorToken;
61 
62     mapping (address => bool) public frozenAccount;
63     mapping (address => uint256) public balanceOf;
64     mapping (address => mapping (address => uint256)) public allowance;
65 
66     event Burn(address indexed _from,uint256 _value);
67     event FrozenFunds(address _account, bool _frozen);
68     event Transfer(address indexed _from,address indexed _to,uint256 _value);
69 
70     constructor() public {
71         totalSupply = initialSupply;
72         balanceOf[owner] = initialSupply;
73 
74         bountyTransfers();
75     }
76 
77     function bountyTransfers() internal {
78         fundingReserve = 0xb0F1D6798d943b9B58E3186390eeE71A57211678;
79         bountyReserve = 0x45273112b7C14727D6080b5337300a81AC5c3255;
80         teamReserve = 0x53ec41c8356bD4AEb9Fde2829d57Ee2370DA5Dd7;
81         advisorReserve = 0x28E1E401A0C7b09bfe6C2220f04236037Fd75454;
82 
83         fundingToken = ( totalSupply * 25 ) / 100;
84         teamToken = ( totalSupply * 12 ) / 100;
85         bountyToken = ( totalSupply * 15 ) / 1000;
86         advisorToken = ( totalSupply * 15 ) / 1000;
87 
88         balanceOf[msg.sender] = totalSupply - fundingToken - teamToken - bountyToken - advisorToken;
89         balanceOf[teamReserve] = teamToken;
90         balanceOf[bountyReserve] = bountyToken;
91         balanceOf[fundingReserve] = fundingToken;
92         balanceOf[advisorReserve] = advisorToken;
93 
94         Transfer(msg.sender, fundingReserve, fundingToken);
95         Transfer(msg.sender, bountyReserve, bountyToken);
96         Transfer(msg.sender, teamReserve, teamToken);
97         Transfer(msg.sender, advisorReserve, advisorToken);
98     }
99 
100     function _transfer(address _from,address _to,uint256 _value) internal {
101         require(balanceOf[_from] >= _value);
102         require(!frozenAccount[_from]);
103         require(!frozenAccount[_to]);
104 
105         balanceOf[_from] = balanceOf[_from].sub(_value);
106         balanceOf[_to] = balanceOf[_to].add(_value);
107         emit Transfer(_from, _to, _value);
108     }
109 
110     function transfer(address _to,uint256 _value) public {
111         _transfer(msg.sender, _to, _value);
112     }
113 
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
115         require(_value <= allowance[_from][msg.sender]);     // Check allowance
116         allowance[_from][msg.sender] -= _value;
117         _transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function approve(address _spender, uint256 _value) public onlyOwner returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     function freezeAccount(address _account, bool _frozen) public onlyOwner {
127         frozenAccount[_account] = _frozen;
128         emit FrozenFunds(_account, _frozen);
129     }
130 
131     function burnTokens(uint256 _value) public onlyOwner returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);
133         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
134         totalSupply = totalSupply.sub(_value);
135         emit Burn(msg.sender,_value);
136         return true;
137     }
138 
139     function newTokens(address _owner, uint256 _value) public onlyOwner {
140         balanceOf[_owner] = balanceOf[_owner].add(_value);
141         totalSupply = totalSupply.add(_value);
142         emit Transfer(0, this, _value);
143         emit Transfer(this, _owner, _value);
144     }
145 
146     function escrowAmount(address _account, uint256 _value) public onlyOwner {
147         _transfer(msg.sender, _account, _value);
148         freezeAccount(_account, true);
149     }
150 
151     function () public {
152         revert();
153     }
154 
155 }