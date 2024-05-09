1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
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
42 contract Firetoken is owned {
43     using SafeMath for uint256;
44 
45     // Token Variables Initialization
46     string public constant name = "Firetoken";
47     string public constant symbol = "FPWR";
48     uint8 public constant decimals = 18;
49 
50     uint256 public totalSupply;
51     uint256 public constant initialSupply = 18000000 * (10 ** uint256(decimals));
52 
53     address public marketingReserve;
54     address public devteamReserve;
55     address public bountyReserve;
56     address public teamReserve;
57 
58     uint256 marketingToken;
59     uint256 devteamToken;
60     uint256 bountyToken;
61     uint256 teamToken;
62 
63     mapping (address => bool) public frozenAccount;
64     mapping (address => uint256) public balanceOf;
65 
66     event Burn(address indexed _from,uint256 _value);
67     event FrozenFunds(address _account, bool _frozen);
68     event Transfer(address indexed _from,address indexed _to,uint256 _value);
69 
70     function Firetoken() public {
71         totalSupply = initialSupply;
72         balanceOf[msg.sender] = initialSupply;
73 
74         bountyTransfers();
75     }
76 
77     function bountyTransfers() internal {
78         marketingReserve = 0x00Fe8117437eeCB51782b703BD0272C14911ECdA;
79         bountyReserve = 0x0089F23EeeCCF6bd677C050E59697D1f6feB6227;
80         teamReserve = 0x00FD87f78843D7580a4c785A1A5aaD0862f6EB19;
81         devteamReserve = 0x005D4Fe4DAf0440Eb17bc39534929B71a2a13F48;
82 
83         marketingToken = ( totalSupply * 10 ) / 100;
84         bountyToken = ( totalSupply * 10 ) / 100;
85         teamToken = ( totalSupply * 26 ) / 100;
86         devteamToken = ( totalSupply * 10 ) / 100;
87 
88         balanceOf[msg.sender] = totalSupply - marketingToken - teamToken - devteamToken - bountyToken;
89         balanceOf[teamReserve] = teamToken;
90         balanceOf[devteamReserve] = devteamToken;
91         balanceOf[bountyReserve] = bountyToken;
92         balanceOf[marketingReserve] = marketingToken;
93 
94         Transfer(msg.sender, marketingReserve, marketingToken);
95         Transfer(msg.sender, bountyReserve, bountyToken);
96         Transfer(msg.sender, teamReserve, teamToken);
97         Transfer(msg.sender, devteamReserve, devteamToken);
98     }
99 
100     function _transfer(address _from,address _to,uint256 _value) internal {
101         require(balanceOf[_from] > _value);
102         require(!frozenAccount[_from]);
103         require(!frozenAccount[_to]);
104 
105         balanceOf[_from] = balanceOf[_from].sub(_value);
106         balanceOf[_to] = balanceOf[_to].add(_value);
107         Transfer(_from, _to, _value);
108     }
109 
110     function transfer(address _to,uint256 _value) public {
111         _transfer(msg.sender, _to, _value);
112     }
113 
114     function freezeAccount(address _account, bool _frozen) public onlyOwner {
115         frozenAccount[_account] = _frozen;
116         FrozenFunds(_account, _frozen);
117     }
118 
119     function burnTokens(uint256 _value) public onlyOwner returns (bool success) {
120         require(balanceOf[msg.sender] > _value);
121 
122         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
123         totalSupply = totalSupply.sub(_value);
124         Burn(msg.sender,_value);
125 
126         return true;
127     }
128 
129     function newTokens(address _owner, uint256 _value) public onlyOwner {
130         balanceOf[_owner] = balanceOf[_owner].add(_value);
131         totalSupply = totalSupply.add(_value);
132         Transfer(0, this, _value);
133         Transfer(this, _owner, _value);
134     }
135 
136     function escrowAmount(address _account, uint256 _value) public onlyOwner {
137         _transfer(msg.sender, _account, _value);
138         freezeAccount(_account, true);
139     }
140 
141     function () public {
142         revert();
143     }
144 
145 }