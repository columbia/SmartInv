1 pragma solidity ^ 0.4.24;
2 
3 contract TokenName {
4 	event Transfer(address indexed from, address indexed to, uint256 value);
5     event Approval(address indexed owner, address indexed spender, uint256 value);
6     event Consume(address indexed from, uint256 value);
7 }
8 
9 contract BaseContract is TokenName{
10 	using SafeMath
11 	for * ;
12 	
13 	string public name = "FK token";
14     string public symbol = "FK";
15     uint8 public decimals = 18;
16     uint256 public totalSupply = 900000000000000000000000000;
17     mapping (address => uint256) public balance;
18     mapping (address => mapping (address => uint256)) public allowance;
19     address public manager;
20     address public releaseAddress = 0x2458f120fc75d7d5d3b07c074a096eb0eacd16d3;
21     uint256 public createTime;
22     uint256 public takeTotal = 0;
23 	function BaseContract(
24         ) {
25         manager = msg.sender;
26         balance[msg.sender] = 100000000000000000000000000;
27         createTime = now;
28     }
29     
30     function transfer(address _to, uint256 _value) public returns (bool success){
31     	require(_to != 0x0, "invalid addr");
32     	if(msg.sender == releaseAddress){
33     		uint256 _releaseTotal = releaseTotal();
34     		if(_releaseTotal != takeTotal){
35 				balance[msg.sender] = balance[msg.sender].add(_releaseTotal.sub(takeTotal));
36 				takeTotal = _releaseTotal;
37     		}
38 		}
39         balance[msg.sender] = balance[msg.sender].sub(_value);
40         balance[_to] = balance[_to].add(_value);
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44     
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         require(_spender != 0x0, "invalid addr");
47 		require(_value > 0, "invalid value");
48         allowance[msg.sender][_spender] = _value;
49         emit Approval(msg.sender,_spender,_value);
50         return true;
51     }
52     
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54      	require(_from != 0x0, "invalid addr");
55         require(_to != 0x0, "invalid addr");
56         balance[_from] = balance[_from].sub(_value);
57         balance[_to] = balance[_to].add(_value);
58         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
59         emit Transfer(_from, _to, _value);
60         return true;
61     }
62      
63     function consume(uint256 _value) public returns (bool success){
64      	require(msg.sender == manager, "invalid addr");
65      	balance[msg.sender] = balance[msg.sender].sub(_value);
66      	emit Consume(msg.sender, _value);
67      	return true;
68     }
69     
70     function releaseTotal()
71     public
72     view
73     returns(uint256){
74     	uint256 _now = now;
75     	uint256 _time = _now.sub(createTime);
76     	uint256 _years = _time/31536000;
77     	uint256 _release = 200000000000000000000000000;
78     	uint256 _total = 0;
79     	for(uint256 i = 0; i <= _years; i++){
80     		if(i != 0 && i%2 == 0){
81     			_release = _release/2;
82     		}
83     		if(i == _years){
84     			_total = _total.add((_time.sub(i.mul(31536000))/86400).mul(_release/365));
85     		}else{
86     			_total = _total.add(_release);
87     		}
88     	}
89     	if(_total >= 800000000000000000000000000){
90     		_total = 800000000000000000000000000;
91     	}
92     	return _total;
93     }
94     
95     function release()
96     public
97 	view
98 	returns(uint256){
99     	uint256 _now = now;
100     	uint256 _time = _now.sub(createTime);
101     	uint256 _count = _time/63072000;
102     	uint256 _release = 200000000000000000000000000;
103     	for(uint256 i = 0; i < _count; i++){
104     		_release = _release/2;
105     	}
106     	return _release/365;
107     }
108     
109     function balanceOf(address _addr)
110 	public
111 	view
112 	returns(uint256) {
113 		if(_addr == releaseAddress){
114 			return balance[_addr].add(releaseTotal().sub(takeTotal));
115 		}
116 		return balance[_addr];
117 	}
118     
119 }
120 
121 library SafeMath {
122 	
123 	function mul(uint256 a, uint256 b)
124 	internal
125 	pure
126 	returns(uint256 c) {
127 		if(a == 0) {
128 			return 0;
129 		}
130 		c = a * b;
131 		require(c / a == b, "mul failed");
132 		return c;
133 	}
134 
135 	function sub(uint256 a, uint256 b)
136 	internal
137 	pure
138 	returns(uint256 c) {
139 		require(b <= a, "sub failed");
140 		c = a - b;
141 		require(c <= a, "sub failed");
142 		return c;
143 	}
144 
145 	function add(uint256 a, uint256 b)
146 	internal
147 	pure
148 	returns(uint256 c) {
149 		c = a + b;
150 		require(c >= a, "add failed");
151 		return c;
152 	}
153 
154 }