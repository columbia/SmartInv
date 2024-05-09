1 pragma solidity ^0.4.13;
2 
3 /*
4 
5   Copyright 2018 AICT Foundation.
6   https://www.aict.io/
7 
8 */
9 
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 contract Ownable {
24   address public owner;
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a / b;
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract ICTA is ERC20,Ownable{
73 	using SafeMath for uint256;
74 	string public constant name="ICTA";
75 	string public constant symbol="ICTA";
76 	string public constant version = "0";
77 	uint256 public constant decimals = 9;
78 	uint256 public constant MAX_SUPPLY=500000000*10**decimals;
79 	uint256 public airdropSupply;
80     struct epoch  {
81         uint256 lockEndTime;
82         uint256 lockAmount;
83     }
84 
85     mapping(address=>epoch[]) public lockEpochsMap;
86     mapping(address => uint256) balances;
87 	mapping (address => mapping (address => uint256)) allowed;
88 	
89 
90 	function ICTA()public{
91 		totalSupply = 500000000 ;
92 		airdropSupply = 0;
93 		totalSupply=MAX_SUPPLY;
94 		balances[msg.sender] = MAX_SUPPLY;
95 		Transfer(0x0, msg.sender, MAX_SUPPLY);
96 	}
97 
98 
99 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
100 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
101 		_;
102 	}
103 
104   	function transfer(address _to, uint256 _value) public  returns (bool)
105  	{
106 		require(_to != address(0));
107 
108 		epoch[] storage epochs = lockEpochsMap[msg.sender];
109 		uint256 needLockBalance = 0;
110 		for(uint256 i = 0;i<epochs.length;i++)
111 		{
112 			if( now < epochs[i].lockEndTime )
113 			{
114 				needLockBalance=needLockBalance.add(epochs[i].lockAmount);
115 			}
116 		}
117 
118 		require(balances[msg.sender].sub(_value)>=needLockBalance);
119 		balances[msg.sender] = balances[msg.sender].sub(_value);
120 		balances[_to] = balances[_to].add(_value);
121 		Transfer(msg.sender, _to, _value);
122 		return true;
123   	}
124 
125   	function balanceOf(address _owner) public constant returns (uint256 balance) 
126   	{
127 		return balances[_owner];
128   	}
129 
130   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
131   	{
132 		require(_to != address(0));
133 
134 		epoch[] storage epochs = lockEpochsMap[_from];
135 		uint256 needLockBalance = 0;
136 		for(uint256 i = 0;i<epochs.length;i++)
137 		{
138 
139 			if( now < epochs[i].lockEndTime )
140 			{
141 				needLockBalance = needLockBalance.add(epochs[i].lockAmount);
142 			}
143 		}
144 
145 		require(balances[_from].sub(_value)>=needLockBalance);
146 
147 		uint256 _allowance = allowed[_from][msg.sender];
148 
149 		balances[_from] = balances[_from].sub(_value);
150 		balances[_to] = balances[_to].add(_value);
151 		allowed[_from][msg.sender] = _allowance.sub(_value);
152 		Transfer(_from, _to, _value);
153 		return true;
154   	}
155 
156   	function approve(address _spender, uint256 _value) public returns (bool) 
157   	{
158 		allowed[msg.sender][_spender] = _value;
159 		Approval(msg.sender, _spender, _value);
160 		return true;
161   	}
162 
163   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
164   	{
165 		return allowed[_owner][_spender];
166   	}
167 
168 	function lockBalance(address user, uint256 lockAmount,uint256 lockEndTime) internal
169 	{
170 		 epoch[] storage epochs = lockEpochsMap[user];
171 		 epochs.push(epoch(lockEndTime,lockAmount));
172 	}
173 
174     function airdrop(address [] _holders,uint256 paySize) external
175     	onlyOwner 
176 	{
177 		uint256 unfreezeAmount=paySize.div(5);
178         uint256 count = _holders.length;
179         assert(paySize.mul(count) <= balanceOf(msg.sender));
180         for (uint256 i = 0; i < count; i++) {
181             transfer(_holders [i], paySize);
182 
183             lockBalance(_holders [i],unfreezeAmount,now+10368000);
184 
185             lockBalance(_holders [i],unfreezeAmount,now+10368000+2592000);
186 
187             lockBalance(_holders [i],unfreezeAmount,now+10368000+2592000+2592000);
188 
189             lockBalance(_holders [i],unfreezeAmount,now+10368000+2592000+2592000+2592000);
190 
191             lockBalance(_holders [i],unfreezeAmount,now+10368000+2592000+2592000+2592000+2592000);
192             
193 			airdropSupply = airdropSupply.add(paySize);
194         }
195     }
196 
197     function airdrop2(address [] _holders,uint256 paySize) external
198     	onlyOwner 
199 	{
200 		uint256 unfreezeAmount=paySize.div(10);
201         uint256 count = _holders.length;
202         assert(paySize.mul(count) <= balanceOf(msg.sender));
203         for (uint256 i = 0; i < count; i++) {
204             transfer(_holders [i], paySize);
205 
206             lockBalance(_holders [i],unfreezeAmount,now+5184000);
207 
208             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000);
209 
210             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000);
211 
212             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000);
213 
214             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000);
215 
216             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000+2592000);
217 
218             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000+2592000+2592000);
219 
220             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000+2592000+2592000+2592000);
221 
222             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000+2592000+2592000+2592000+2592000);
223 
224             lockBalance(_holders [i],unfreezeAmount,now+5184000+2592000+2592000+2592000+2592000+2592000+2592000+2592000+2592000+2592000);
225             
226 			airdropSupply = airdropSupply.add(paySize);
227         }
228     }    
229 
230     function burn(uint256 _value) public {
231         require(_value > 0);
232 
233         address burner = msg.sender;
234         balances[burner] = balances[burner].sub(_value);
235         totalSupply = totalSupply.sub(_value);
236     }
237 	
238 }