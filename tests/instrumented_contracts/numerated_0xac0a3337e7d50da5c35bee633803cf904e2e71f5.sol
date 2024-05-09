1 pragma solidity ^0.4.13;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract SpaceICOToken {
34 	using SafeMath for uint256;
35 	string public name = "SpaceICO Token";
36     string public symbol = "SIO";
37     uint256 public decimals = 18;
38 
39     uint256 private saleStart;
40     uint256 private saleEnd;
41 
42     uint256 private constant TOTAL_SUPPLY = 50000000 * 1 ether;
43     uint256 private constant SOFT_CAP = 500 * 1 ether;
44 
45 	mapping (address => uint) balances;
46     mapping(address => mapping (address => uint256)) allowed;
47 
48 	address private owner;
49 
50     function getSaleStart() constant returns (uint256) {
51         return saleStart;
52     }
53 
54     function getSaleEnd() constant returns (uint256) {
55         return saleEnd;
56     }
57 
58  
59     function getCurrentPrice() constant returns (uint price) {
60         //Token price, ETH: 0,002
61         price = 500 * 1 ether;
62     }
63 
64     function softCapReached() constant returns (bool) {
65         return this.balance > SOFT_CAP;
66     }
67 
68     function inSalePeriod() constant returns (bool) {
69         return now > saleStart && now < saleEnd;
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         balance = balances[_owner];
74     }
75 
76 	function SpaceICOToken(uint _saleStart) {
77         owner = msg.sender;
78         if (_saleStart == 0) {
79             saleStart = 1508025600; //Beginning: 10.15.2017
80             saleEnd = 1509408000; //End: 10.31.2017
81         } else {
82             saleStart = _saleStart;
83             saleEnd = _saleStart + 17 days;
84         }
85 
86         balances[owner] = 50000000 * 10 ** decimals;
87 	}
88 
89     function transfer(address _to, uint256 _value) returns (bool) {
90         require(_to != address(0));
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
100         require(now > saleEnd + 14 days);
101 
102         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
103 
104             balances[_from] = balances[_from].sub(_amount);
105             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
106             balances[_to] = balances[_to].add(_amount);
107 
108             return true;
109         } else {
110             return false;
111         }
112     }
113 
114     function approve(address _spender, uint _amount) returns (bool success) {
115         allowed[msg.sender][_spender] = _amount;
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) constant returns (uint remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123     function() payable {
124         buyTokens();
125     }
126 
127     function buyTokens() payable {
128         require(msg.value > 0);
129         require(inSalePeriod());
130 
131         uint amountInWei = msg.value;
132 
133         uint price = getCurrentPrice();
134         uint tokenAmount = price * amountInWei / 1 ether;
135         
136         transfer(msg.sender, tokenAmount);        
137 
138         //Raise event
139         BuyToken(msg.sender, amountInWei, 0);
140     }
141 
142     function refund() {
143         if (softCapReached() == false && now > saleEnd) {
144 
145             uint tokenAmount = balanceOf(msg.sender);
146             uint amount = tokenAmount.div(1 ether);
147             
148             msg.sender.transfer(amount);
149             Refund();
150         }
151     }
152 
153     function withdraw() {
154         require(msg.sender == owner);
155 
156         if (softCapReached() == true && now > saleEnd) {
157             msg.sender.transfer(this.balance);
158         }
159     }
160 
161 	event Transfer(address indexed _from, address indexed _to, uint _value);
162     event Approval(address indexed _owner, address indexed _spender, uint _value);
163     event BuyToken(address indexed _purchaser, uint256 _value, uint256 _amount);
164     event Refund();
165 }