1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22           return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 contract Kcoin is IERC20{
50 
51     using SafeMath for uint256;
52 
53     uint public initialSupply = 150000000000e18; // crowdsale
54 
55     string public constant symbol = "24K";
56     string public constant name = "24Kcoin";
57     uint8 public constant decimals = 18;
58     uint public totalSupply = 1500000000000e18;
59 
60     uint256 public constant Rate1 = 5000; //month March rate 1 Eth
61     uint256 public constant Rate2 = 5000; //month April rate 1 Eth
62     uint256 public constant Rate3 = 4500; //month May rate 1 Eth
63     uint256 public constant Rate4 = 4000; //month June rate 1 Eth
64     uint256 public constant Rate5 = 3500; //month July rate 1 Eth
65     uint256 public constant Rate6 = 3000; //month August rate 1 Eth
66 	uint256 public constant Rate7 = 2500; //month September rate 1 Eth
67 	uint256 public constant Rate8 = 2000; //month October rate 1 Eth
68 	uint256 public constant Rate9 = 1500; //month November rate 1 Eth
69 	uint256 public constant Rate10= 1000; //month December rate 1 Eth
70 
71 
72     uint256 public constant Start1 = 1519862400; //start 03/01/18 12:00 AM UTC time to Unix time stamp
73     uint256 public constant Start2 = 1522540800; //start 04/01/18 12:00 AM UTC time to Unix time stamp
74     uint256 public constant Start3 = 1525132800; //start 05/01/18 12:00 AM UTC time to Unix time stamp
75     uint256 public constant Start4 = 1527811200; //start 06/01/18 12:00 AM UTC time to Unix time stamp
76     uint256 public constant Start5 = 1530403200; //start 07/01/18 12:00 AM UTC time to Unix time stamp
77     uint256 public constant Start6 = 1533081600; //start 08/01/18 12:00 AM UTC time to Unix time stamp
78 	uint256 public constant Start7 = 1535760000; //start 09/01/18 12:00 AM UTC time to Unix time stamp
79 	uint256 public constant Start8 = 1538352000; //start 10/01/18 12:00 AM UTC time to Unix time stamp
80 	uint256 public constant Start9 = 1541030400; //start 11/01/18 12:00 AM UTC time to Unix time stamp
81 	uint256 public constant Start10= 1543622400; //start 12/01/18 12:00 AM UTC time to Unix time stamp
82 
83 	
84     uint256 public constant End1 = 1522540799; //End 03/31/18 11:59 PM UTC time to Unix time stamp
85     uint256 public constant End2 = 1525132799; //End 04/30/18 11:59 PM UTC time to Unix time stamp
86     uint256 public constant End3 = 1527811199; //End 05/31/18 11:59 PM UTC time to Unix time stamp
87     uint256 public constant End4 = 1530403199; //End 06/30/18 11:59 PM UTC time to Unix time stamp
88     uint256 public constant End5 = 1533081599; //End 07/31/18 11:59 PM UTC time to Unix time stamp
89     uint256 public constant End6 = 1535759999; //End 08/31/18 11:59 PM UTC time to Unix time stamp
90 	
91 	uint256 public constant End7 = 1538351940; //End 09/30/18 11:59 PM UTC time to Unix time stamp
92 	uint256 public constant End8 = 1540943940; //End 10/30/18 11:59 PM UTC time to Unix time stamp
93 	uint256 public constant End9 = 1543622340; //End 11/30/18 11:59 PM UTC time to Unix time stamp
94 	uint256 public constant End10= 1546300740; //End 12/31/18 11:59 PM UTC time to Unix time stamp
95 	
96 	
97     address public owner;
98 
99     mapping(address => uint256) balances;
100     mapping(address => mapping(address => uint256)) allowed;
101 
102     event Burn(address indexed from, uint256 value);
103 
104     function() public payable {
105         buyTokens();
106     }
107 
108     function Kcoin() public {
109         //TODO
110         balances[msg.sender] = totalSupply;
111         owner = msg.sender;
112     }
113     function buyTokens() public payable {
114 
115         require(msg.value > 0);
116 
117         uint256 weiAmount = msg.value;
118         uint256 tokens1 = weiAmount.mul(Rate1); //make sure to check which rate tier we are in
119         uint256 tokens2 = weiAmount.mul(Rate2);
120         uint256 tokens3 = weiAmount.mul(Rate3);
121         uint256 tokens4 = weiAmount.mul(Rate4);
122         uint256 tokens5 = weiAmount.mul(Rate5);
123         uint256 tokens6 = weiAmount.mul(Rate6);
124 		uint256 tokens7 = weiAmount.mul(Rate7);
125 		uint256 tokens8 = weiAmount.mul(Rate8);
126 		uint256 tokens9 = weiAmount.mul(Rate9);
127 		uint256 tokens10= weiAmount.mul(Rate10);
128 
129         //send tokens from ICO contract address
130         if (now >= Start1 && now <= End1) //we can send tokens at rate 1
131         {
132             balances[msg.sender] = balances[msg.sender].add(tokens1);
133             initialSupply = initialSupply.sub(tokens1);
134             //transfer(msg.sender, tokens1);
135         }
136         if (now >= Start2 && now <= End2) //we can send tokens at rate 2
137         {
138             balances[msg.sender] = balances[msg.sender].add(tokens2);
139             initialSupply = initialSupply.sub(tokens2);
140         }
141         if (now >= Start3 && now <= End3) //we can send tokens at rate 3
142         {
143             balances[msg.sender] = balances[msg.sender].add(tokens3);
144             initialSupply = initialSupply.sub(tokens3);
145         }
146         if (now >= Start4 && now <= End4) //we can send tokens at rate 4
147         {
148             balances[msg.sender] = balances[msg.sender].add(tokens4);
149             initialSupply = initialSupply.sub(tokens4);
150         }
151         if (now >= Start5 && now <= End5) //we can send tokens at rate 5
152         {
153             balances[msg.sender] = balances[msg.sender].add(tokens5);
154             initialSupply = initialSupply.sub(tokens5);
155         }
156         if (now >= Start6 && now <= End6) //we can send tokens at rate 6
157         {
158             balances[msg.sender] = balances[msg.sender].add(tokens6);
159             initialSupply = initialSupply.sub(tokens6);
160         }
161 		        if (now >= Start7 && now <= End7) //we can send tokens at rate 7
162         {
163             balances[msg.sender] = balances[msg.sender].add(tokens7);
164             initialSupply = initialSupply.sub(tokens7);
165         }
166 		        if (now >= Start8 && now <= End8) //we can send tokens at rate 8
167         {
168             balances[msg.sender] = balances[msg.sender].add(tokens8);
169             initialSupply = initialSupply.sub(tokens8);
170         }
171 		        if (now >= Start9 && now <= End9) //we can send tokens at rate 9
172         {
173             balances[msg.sender] = balances[msg.sender].add(tokens9);
174             initialSupply = initialSupply.sub(tokens9);
175         }
176 		        if (now >= Start10 && now <= End10) //we can send tokens at rate 10
177         {
178             balances[msg.sender] = balances[msg.sender].add(tokens10);
179             initialSupply = initialSupply.sub(tokens10);
180         }
181 		
182 
183         owner.transfer(msg.value);
184     }
185 
186    function totalSupply() public constant returns (uint256 ) {
187         //TODO
188         return totalSupply;
189     }
190 
191     function balanceOf(address _owner) public constant returns (uint256 balance) {
192         //TODO
193         return balances[_owner];
194     }
195 
196      function transfer(address _to, uint256 _value) public returns (bool success) {
197         //TODO
198         require(
199             balances[msg.sender] >= _value
200             && _value > 0
201         );
202         balances[msg.sender] = balances[msg.sender].sub(_value);
203         balances[_to] += balances[_to].add(_value);
204         Transfer(msg.sender, _to, _value);
205         return true;
206     }
207 
208      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
209         //TODO
210         require(
211             allowed[_from][msg.sender] >= _value
212             && balances[_from] >= _value
213             && _value > 0
214         );
215         balances[_from] = balances[_from].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218         Transfer(_from, _to, _value);
219         return true;
220     }
221 
222    function burn(uint256 _value) public returns (bool success) {
223         require(balances[msg.sender] >= _value);   // Check if the sender has enough
224         balances[msg.sender] -= _value;            // Subtract from the sender
225         totalSupply -= _value;                      // Updates totalSupply
226         Burn(msg.sender, _value);
227         return true;
228     }
229 
230 	 function burnFrom(address _from, uint256 _value) public returns (bool success) {
231         require(balances[_from] >= _value);                // Check if the targeted balance is enough
232         require(_value <= allowed[_from][msg.sender]);    // Check allowance
233         balances[_from] -= _value;                         // Subtract from the targeted balance
234         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
235         totalSupply -= _value;                              // Update totalSupply
236         Burn(_from, _value);
237         return true;
238     }
239 
240   function approve(address _spender, uint256 _value) public returns (bool success){
241         //TODO
242         allowed[msg.sender][_spender] = _value;
243         Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247      function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
248         //TODO
249         return allowed[_owner][_spender];
250     }
251 
252     event Transfer(address indexed _from, address indexed _to, uint256 _value);
253     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
254 }