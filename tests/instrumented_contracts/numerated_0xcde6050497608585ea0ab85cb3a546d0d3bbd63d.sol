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
42 contract Bitbose is owned {
43     using SafeMath for uint256;
44 
45     // Token Variables Initialization
46     string public constant name = "Bitbose";
47     string public constant symbol = "BOSE";
48     uint8 public constant decimals = 18;
49 
50     uint256 public totalSupply;
51     uint256 public constant initialSupply = 300000000 * (10 ** uint256(decimals));
52 
53     address public marketingReserve;
54     address public bountyReserve;
55     address public teamReserve;
56 
57     uint256 marketingToken;
58     uint256 bountyToken;
59     uint256 teamToken;
60 
61     mapping (address => bool) public frozenAccount;
62     mapping (address => uint256) public balanceOf;
63 
64     event Burn(address indexed _from,uint256 _value);
65     event FrozenFunds(address _account, bool _frozen);
66     event Transfer(address indexed _from,address indexed _to,uint256 _value);
67 
68     function Bitbose() public {
69         totalSupply = initialSupply;
70         balanceOf[msg.sender] = initialSupply;
71 
72         bountyTransfers();
73     }
74 
75     function bountyTransfers() internal {
76         marketingReserve = 0x0093126Cc5Db9BaFe75EdEB19F305E724E28213D;
77         bountyReserve = 0x00E3b0794F69015fc4a8635F788A41F11d88Aa07;
78         teamReserve = 0x004f678A05E41D2df20041D70dd5aca493369904;
79 
80         marketingToken = ( totalSupply * 12 ) / 100;
81         bountyToken = ( totalSupply * 2 ) / 100;
82         teamToken = ( totalSupply * 16 ) / 100;
83 
84         balanceOf[msg.sender] = totalSupply - marketingToken - teamToken - bountyToken;
85         balanceOf[teamReserve] = teamToken;
86         balanceOf[bountyReserve] = bountyToken;
87         balanceOf[marketingReserve] = marketingToken;
88 
89         Transfer(msg.sender, marketingReserve, marketingToken);
90         Transfer(msg.sender, bountyReserve, bountyToken);
91         Transfer(msg.sender, teamReserve, teamToken);
92     }
93 
94     function _transfer(address _from,address _to,uint256 _value) internal {
95         require(balanceOf[_from] > _value);
96         require(!frozenAccount[_from]);
97         require(!frozenAccount[_to]);
98 
99         balanceOf[_from] = balanceOf[_from].sub(_value);
100         balanceOf[_to] = balanceOf[_to].add(_value);
101         Transfer(_from, _to, _value);
102     }
103 
104     function transfer(address _to,uint256 _value) public {
105         _transfer(msg.sender, _to, _value);
106     }
107 
108     function freezeAccount(address _account, bool _frozen) public onlyOwner {
109         frozenAccount[_account] = _frozen;
110         FrozenFunds(_account, _frozen);
111     }
112 
113     function burnTokens(uint256 _value) public onlyOwner returns (bool success) {
114         require(balanceOf[msg.sender] > _value);
115 
116         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
117         totalSupply = totalSupply.sub(_value);
118         Burn(msg.sender,_value);
119 
120         return true;
121     }
122 
123     function newTokens(address _owner, uint256 _value) public onlyOwner {
124         balanceOf[_owner] = balanceOf[_owner].add(_value);
125         totalSupply = totalSupply.add(_value);
126         Transfer(0, this, _value);
127         Transfer(this, _owner, _value);
128     }
129 
130     function escrowAmount(address _account, uint256 _value) public onlyOwner {
131         _transfer(msg.sender, _account, _value);
132         freezeAccount(_account, true);
133     }
134 
135     function () public {
136         revert();
137     }
138 
139 }