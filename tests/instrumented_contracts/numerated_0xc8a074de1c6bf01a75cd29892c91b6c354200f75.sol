1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract FrontToken {
8 
9 
10     string public name = "FrontierCoin";      //  token name
11     string public symbol = "FRONT";           //  token symbol
12     uint256 public decimals = 6;            //  token digit
13 
14     /**
15     * @dev Integer division of two numbers, truncating the quotient.
16     */
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42     uint256 public totalSupply = 0;
43     bool feed = false;
44     uint256 constant valueFounder = 100000000000000000;
45     uint256 constant valuePub = 100000000000000000;
46     address owner = 0x0;
47     bool public crowdsaleClosed = false;
48     token tokenReward;
49     uint256 public amountRaised;
50     uint256 public tpe;
51 
52     function SetTPE(uint256 _value) public isOwner {
53         tpe = _value;
54     }
55 
56     function ToggleFeed(bool enabled) public isOwner {
57         feed = enabled;
58     }
59 
60     modifier isOwner {
61         assert(owner == msg.sender);
62         _;
63     }
64 
65     modifier validAddress {
66         assert(0x0 != msg.sender);
67         _;
68     }
69 
70     function ChangeOwner(address _newOwner) public {
71         owner = _newOwner;
72     }
73 
74     function FrontToken() public {
75         owner = msg.sender;
76         totalSupply = valueFounder + valuePub;
77         balanceOf[msg.sender] = valueFounder;
78         balanceOf[this] = valuePub;
79         Transfer(0x0, msg.sender, valueFounder);
80         Transfer(0x0, this, valuePub);
81         tokenReward = token(this);
82         tpe = 10000000;
83     }
84 
85     function ToggleCrowdsale(bool enabled) public isOwner {
86         crowdsaleClosed = enabled;
87     }
88 
89     function () payable public {
90         require(!crowdsaleClosed);
91         uint ethAmount = msg.value;
92         uint256 tokens = ethAmount * tpe / 0.000001 ether;
93         balanceOf[msg.sender] += tokens;
94         amountRaised += ethAmount;
95         Transfer(this, msg.sender, tokens);
96     }
97 
98     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
99         if(feed) {
100             uint256 fee = div(_value, 97);
101             uint256 newValue = _value - fee;
102             require(balanceOf[msg.sender] >= newValue);
103             require(balanceOf[_to] + newValue >= balanceOf[_to]);
104             balanceOf[msg.sender] -= newValue;
105             balanceOf[_to] += newValue;
106             Transfer(msg.sender, _to, newValue);
107             balanceOf[owner] += fee;
108             Transfer(msg.sender, owner, fee);
109         }
110         else {
111             require(balanceOf[msg.sender] >= _value);
112             require(balanceOf[_to] + _value >= balanceOf[_to]);
113             balanceOf[msg.sender] -= _value;
114             balanceOf[_to] += _value;
115             Transfer(msg.sender, _to, _value);
116         }
117         return true;
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
121         require(balanceOf[_from] >= _value);
122         require(balanceOf[_to] + _value >= balanceOf[_to]);
123         require(allowance[_from][msg.sender] >= _value);
124         balanceOf[_to] += _value;
125         balanceOf[_from] -= _value;
126         allowance[_from][msg.sender] -= _value;
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
132         require(_value == 0 || allowance[msg.sender][_spender] == 0);
133         allowance[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function setName(string _name) isOwner public {
139         name = _name;
140     }
141     function setSymbol(string _symbol) isOwner public {
142         symbol = _symbol;
143     }
144 
145     function burn(uint256 _value) public {
146         require(balanceOf[msg.sender] >= _value);
147         balanceOf[msg.sender] -= _value;
148         balanceOf[0x0] += _value;
149         Transfer(msg.sender, 0x0, _value);
150     }
151 
152     function ethReverse(uint256 _value) isOwner public {
153         owner.transfer(_value);
154     }
155 
156     event Transfer(address indexed _from, address indexed _to, uint256 _value);
157     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
158 }