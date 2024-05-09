1 pragma solidity ^0.4.23;
2 
3 contract CoinEthp // @eachvar
4 {
5     address public admin_address = 0xFbAbB7b67030e4BE471A095244898B651411b6A5; 
6     address public account_address = 0xFbAbB7b67030e4BE471A095244898B651411b6A5; 
7     
8     mapping(address => uint256) balances;
9     
10     string public name = "Ethernet protocol"; // @eachvar
11     string public symbol = "ETHP"; // @eachvar
12     uint8 public decimals = 18; // @eachvar
13     uint256 initSupply = 210000000; // @eachvar
14     uint256 public totalSupply = 0; // @eachvar
15 
16     constructor() 
17     payable 
18     public
19     {
20         totalSupply = mul(initSupply, 10**uint256(decimals));
21         balances[account_address] = totalSupply;
22 
23         
24     }
25 
26     function balanceOf( address _addr ) public view returns ( uint )
27     {
28         return balances[_addr];
29     }
30 
31     event Transfer(
32         address indexed from, 
33         address indexed to, 
34         uint256 value
35     ); 
36 
37     function transfer(
38         address _to, 
39         uint256 _value
40     ) 
41     public 
42     returns (bool) 
43     {
44         require(_to != address(0));
45         require(_value <= balances[msg.sender]);
46 
47         balances[msg.sender] = sub(balances[msg.sender],_value);
48 
49             
50 
51         balances[_to] = add(balances[_to], _value);
52         emit Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     
57     mapping (address => mapping (address => uint256)) internal allowed;
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 
64     function transferFrom(
65         address _from,
66         address _to,
67         uint256 _value
68     )
69     public
70     returns (bool)
71     {
72         require(_to != address(0));
73         require(_value <= balances[_from]);
74         require(_value <= allowed[_from][msg.sender]);
75 
76         balances[_from] = sub(balances[_from], _value);
77         
78         
79         balances[_to] = add(balances[_to], _value);
80         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(
86         address _spender, 
87         uint256 _value
88     ) 
89     public 
90     returns (bool) 
91     {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(
98         address _owner,
99         address _spender
100     )
101     public
102     view
103     returns (uint256)
104     {
105         return allowed[_owner][_spender];
106     }
107 
108     function increaseApproval(
109         address _spender,
110         uint256 _addedValue
111     )
112     public
113     returns (bool)
114     {
115         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
116         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117         return true;
118     }
119 
120     function decreaseApproval(
121         address _spender,
122         uint256 _subtractedValue
123     )
124     public
125     returns (bool)
126     {
127         uint256 oldValue = allowed[msg.sender][_spender];
128 
129         if (_subtractedValue > oldValue) {
130             allowed[msg.sender][_spender] = 0;
131         } 
132         else 
133         {
134             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
135         }
136         
137         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138         return true;
139     }
140 
141     
142     
143 
144      
145     
146     
147     modifier admin_only()
148     {
149         require(msg.sender==admin_address);
150         _;
151     }
152 
153     function setAdmin( address new_admin_address ) 
154     public 
155     admin_only 
156     returns (bool)
157     {
158         require(new_admin_address != address(0));
159         admin_address = new_admin_address;
160         return true;
161     }
162 
163 
164     function withDraw()
165     public
166     admin_only
167     {
168         require(address(this).balance > 0);
169         admin_address.transfer(address(this).balance);
170     }
171 
172     function () external payable
173     {
174                 
175         
176         
177            
178     }
179 
180 
181     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
182     {
183         if (a == 0) 
184         {
185             return 0;
186         }
187 
188         c = a * b;
189         assert(c / a == b);
190         return c;
191     }
192 
193     function div(uint256 a, uint256 b) internal pure returns (uint256) 
194     {
195         return a / b;
196     }
197 
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
199     {
200         assert(b <= a);
201         return a - b;
202     }
203 
204     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
205     {
206         c = a + b;
207         assert(c >= a);
208         return c;
209     }
210 
211 }