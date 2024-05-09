1 pragma solidity ^ 0.4 .24;
2 
3 contract TurboContract {
4 	event Consume(
5 		uint256 value
6 	);
7 	event Supercharge(
8 		uint256 indexed index,
9 		address indexed addr,
10 		uint256 value
11 	);
12 	event Raise(
13 		uint256 indexed index,
14 		address indexed addr,
15 		uint256 value
16 	);
17 	event AirdDrop(
18 		address indexed addr,
19 		uint256 value
20 	);
21 	event Popularize(
22 		address indexed addr,
23 		uint256 value
24 	);
25 	event Develop(
26 		address indexed addr,
27 		uint256 value
28 	);
29 	
30 }
31 
32 contract BaseContract is TurboContract {
33 	using SafeMath
34 	for * ;
35 
36 	address public manager; //初始管理员
37 
38 	mapping(uint256 => uint256) public superchargeTotal; //增压数量
39 
40 	mapping(uint256 => uint256) public raiseTotal; //认筹数量
41 
42 	uint256 public airDropTotal; //空投数量
43 
44 	uint256 public popularizeTotal; //推广数量
45 
46 	uint256 public developTotal; //发展数量
47 
48 	uint256 public consumeTotal; //销毁数量
49 
50 	TurboInterface constant private turboToken = TurboInterface(0x414310e2d38306d9b861f1646356f70c74ada812);
51 
52 	function BaseContract() {
53 		manager = msg.sender;
54 	}
55 
56 	function consume(uint256 value_)
57 	isManager()
58 	public {
59 		//cfg代币余额不足的不能续约
60 		require(turboToken.balanceOf(msg.sender) >= value_, "You don't have enough Turbo.");
61 		if(!turboToken.consume(msg.sender, value_)) {
62 			require(false, "error");
63 		}
64 		consumeTotal = consumeTotal.add(value_);
65 		emit Consume(
66 			value_
67 		);
68 	}
69 
70 	function supercharge(uint256 index_, uint256 value_, address addr_)
71 	isManager()
72 	public {
73 		superchargeTotal[index_] = superchargeTotal[index_].add(value_);
74 		emit Supercharge(
75 			index_,
76 			addr_,
77 			value_
78 		);
79 	}
80 
81 	function raise(uint256 index_, uint256 value_, address addr_)
82 	isManager()
83 	public {
84 		raiseTotal[index_] = raiseTotal[index_].add(value_);
85 		emit Raise(
86 			index_,
87 			addr_,
88 			value_
89 		);
90 	}
91 
92 	function airdDrop(uint256 value_, address addr_)
93 	isManager()
94 	public {
95 		airDropTotal = airDropTotal.add(value_);
96 		emit AirdDrop(
97 			addr_,
98 			value_
99 		);
100 	}
101 
102 	function popularize(uint256 value_, address addr_)
103 	isManager()
104 	public {
105 		popularizeTotal = popularizeTotal.add(value_);
106 		emit Popularize(
107 			addr_,
108 			value_
109 		);
110 	}
111 
112 	function develop(uint256 value_, address addr_)
113 	isManager()
114 	public {
115 		developTotal = developTotal.add(value_);
116 		emit Develop(
117 			addr_,
118 			value_
119 		);
120 	}
121 
122 	function kill()
123 	isManager()
124 	public {
125 		selfdestruct(msg.sender);
126 	}
127 
128 	modifier isManager() {
129 		require(msg.sender == manager, "Not the manager");
130 		_;
131 	}
132 
133 }
134 
135 interface TurboInterface {
136 
137 	function balanceOf(address _addr) returns(uint256);
138 
139 	function transfer(address _to, uint256 _value) returns(bool);
140 
141 	function approve(address _spender, uint256 _value) returns(bool);
142 
143 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
144 
145 	function consume(address _from, uint256 _value) returns(bool success);
146 }
147 
148 library SafeMath {
149 
150 	function mul(uint256 a, uint256 b)
151 	internal
152 	pure
153 	returns(uint256 c) {
154 		if(a == 0) {
155 			return 0;
156 		}
157 		c = a * b;
158 		require(c / a == b, "mul failed");
159 		return c;
160 	}
161 
162 	function sub(uint256 a, uint256 b)
163 	internal
164 	pure
165 	returns(uint256 c) {
166 		require(b <= a, "sub failed");
167 		c = a - b;
168 		require(c <= a, "sub failed");
169 		return c;
170 	}
171 
172 	function add(uint256 a, uint256 b)
173 	internal
174 	pure
175 	returns(uint256 c) {
176 		c = a + b;
177 		require(c >= a, "add failed");
178 		return c;
179 	}
180 
181 }