1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath 
8 {
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
13     {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c  / a == b);
19         return c;
20     }
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) 
25     {
26         return a  / b;
27     }
28     /**
29     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
32     {
33         assert(b <= a);
34         return a - b;
35     }
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
40     {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract Owner
48 {
49     address internal owner;
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54     function changeOwner(address newOwner) public onlyOwner returns(bool)
55     {
56         owner = newOwner;
57         return true;
58     }
59 }
60 
61 contract EagleEvent {
62 	event onEventDeposit (
63 		address indexed who,
64 		uint256 indexed value
65 	);
66 	
67 	event onEventWithdraw (
68 		address indexed who,
69 		address indexed to,
70 		uint256 indexed value
71 	);
72 	
73 	event onEventWithdrawLost (
74 		address indexed from,
75 		address indexed to,
76 		uint256 indexed value
77 	);
78 	
79 	event onEventReport (
80 		address indexed from,
81 		address indexed to
82 	);
83 	
84 	event onEventVerify (
85 		address indexed from
86 	);
87 	
88 	event onEventReset (
89 		address indexed from
90 	);
91 	
92 	event onEventUnlock (
93 		address indexed from
94 	);
95 }
96 
97 contract Eagle is Owner, EagleEvent
98 {
99 	//State
100 	enum State {
101 		Normal, Report, Verify, Lock
102 	}
103 	using SafeMath for uint256;
104 	uint256 public constant withdraw_fee = 600000000000000;  // 0.0006eth for every withdraw
105 	uint256 public constant withdraw_fee_lost = 10000000000000000; // 0.01eth for withdraw after lost
106 	uint256 public constant report_lock = 100000000000000000; // 0.1eth for report, cost for some malicious attacks.
107 	//core data
108 	mapping(address => uint256) public balances;
109 	mapping(address => State) public states;
110 	mapping(address => uint) public verifytimes;
111 	mapping(address => address) public tos;
112 	mapping(address => bytes) public signs;
113 	
114 	constructor() public
115 	{
116 		owner = msg.sender;
117 	}
118 	
119 	function getbalance(address _owner) public view returns(uint256)
120 	{
121 		return balances[_owner];
122 	}
123 	
124 	function getstate(address _owner) public view returns(State)
125 	{
126 		return states[_owner];
127 	}
128 	
129 	function getverifytime(address _owner) public view returns(uint)
130 	{
131 		return verifytimes[_owner];
132 	}
133 	
134 	//deposit
135 	function () public payable
136 	{
137 		require(states[msg.sender] == State.Normal);
138 		balances[msg.sender] = balances[msg.sender].add(msg.value);
139 		emit onEventDeposit(msg.sender, msg.value.div(100000000000000));
140 	}
141 	
142 	//withdraw
143 	function withdraw(address _to, uint256 _value) public
144 	{
145 		require(states[msg.sender] != State.Lock);
146 		require(balances[msg.sender] >= _value.add(withdraw_fee));
147 		balances[msg.sender] = balances[msg.sender].sub(_value.add(withdraw_fee));
148 		_to.transfer(_value);
149 		owner.transfer(withdraw_fee);
150 		emit onEventWithdraw(msg.sender, _to, _value.div(100000000000000));
151 	}
152 	
153 	//withdraw for loss
154 	function withdrawloss(address _from, address _to) public
155 	{
156 		require(_to == msg.sender);
157 		require(tos[_from] == _to);
158 		require(states[_from] == State.Verify);
159 		require(states[_to] == State.Normal);
160 		//check verify time
161 		require(now >= verifytimes[_from] + 5 days);
162 		require(balances[_from] >= withdraw_fee_lost);
163 		
164 		emit onEventWithdrawLost(_from, _to, balances[_from].div(100000000000000));
165 		
166 		owner.transfer(withdraw_fee_lost);
167 		balances[_to] = balances[_to].add(balances[_from]).sub(withdraw_fee_lost);
168 		balances[_from] = 0;
169 		states[_from] = State.Normal;
170 		verifytimes[_from] = 0;
171 		tos[_from] = 0;
172 	}
173 	
174 	//report 
175 	function report(address _from, address _to, bytes _sign) public
176 	{
177 		require(_to == msg.sender);
178 		require(states[_from] == State.Normal);
179 		require(balances[_to] >= report_lock);
180 		require(states[_to] == State.Normal);
181 		signs[_from] = _sign;
182 		tos[_from] = _to;
183 		states[_from] = State.Report;
184 		states[_to] = State.Lock;
185 		
186 		emit onEventReport(_from, _to);
187 	}
188 	
189 	//verify
190 	function verify(address _from, bytes _id) public
191 	{
192 		require(states[_from] == State.Report);
193 		bytes memory signedstr = signs[_from];
194 		bytes32 hash = keccak256(_id);
195 		hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
196 		bytes32 r;
197 		bytes32 s;
198 		uint8 v;
199 		address addr;
200 		if (signedstr.length != 65) {
201 			addr = 0;
202 		} else {
203 			assembly {
204 				r := mload(add(signedstr, 32))
205 				s := mload(add(signedstr, 64))
206 				v := and(mload(add(signedstr, 65)), 255)
207 			}
208 			if(v < 27) {
209 				v += 27;
210 			}
211 			if(v != 27 && v != 28) {
212 				addr = 0;
213 			} else {
214 				addr = ecrecover(hash, v, r, s);
215 			}
216 		}
217 		require(addr == _from);
218 		verifytimes[_from] = now;
219 		states[_from] = State.Verify;
220 		states[tos[_from]] = State.Normal;
221 		
222 		emit onEventVerify(_from);
223 	}
224 	
225 	// reset the user's state for some malicious attacks
226 	function resetState(address _from) public onlyOwner
227 	{
228 		require(states[_from] == State.Report || states[_from] == State.Lock);
229 		if(states[_from] == State.Report) {
230 			states[_from] = State.Normal;
231 			verifytimes[_from] = 0;
232 			tos[_from] = 0;
233 			emit onEventReset(_from);
234 		} else if(states[_from] == State.Lock) {
235 			states[_from] = State.Normal;
236 			balances[_from] = balances[_from].sub(report_lock);
237 			owner.transfer(report_lock);
238 			emit onEventUnlock(_from);
239 		}
240 	}
241 }