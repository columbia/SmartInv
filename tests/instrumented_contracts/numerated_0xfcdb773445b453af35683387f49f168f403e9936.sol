1 pragma solidity ^0.4.23;
2 
3 contract CoinMed // @eachvar
4 {
5     address public admin_address = 0x6e68FfF2dC3Bf3aa0e9aCECAae9A3ffE52Fc48ae; // @eachvar
6     address public account_address = 0x6e68FfF2dC3Bf3aa0e9aCECAae9A3ffE52Fc48ae; // @eachvar 
7     mapping(address => uint256) balances;
8     
9     string public name = "Med Chain"; // @eachvar
10     string public symbol = "MED"; // @eachvar
11     uint8 public decimals = 18; // @eachvar
12     uint256 initSupply = 210000000; // @eachvar
13     uint256 public totalSupply = 0; // @eachvar
14 
15     constructor() 
16     payable 
17     public
18     {
19         totalSupply = mul(initSupply, 10**uint256(decimals));
20         balances[account_address] = totalSupply;
21     }
22 
23     function balanceOf( address _addr ) public view returns ( uint )
24     {
25         return balances[_addr];
26     }
27 
28     event Transfer(
29         address indexed from, 
30         address indexed to, 
31         uint256 value
32     ); 
33 
34     function transfer(
35         address _to, 
36         uint256 _value
37     ) 
38     public 
39     returns (bool) 
40     {
41         require(_to != address(0));
42         require(_value <= balances[msg.sender]);
43 
44         balances[msg.sender] = sub(balances[msg.sender],_value);
45 
46             
47 
48         balances[_to] = add(balances[_to], _value);
49         emit Transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53     
54     mapping (address => mapping (address => uint256)) internal allowed;
55     event Approval(
56         address indexed owner,
57         address indexed spender,
58         uint256 value
59     );
60 
61     function transferFrom(
62         address _from,
63         address _to,
64         uint256 _value
65     )
66     public
67     returns (bool)
68     {
69         require(_to != address(0));
70         require(_value <= balances[_from]);
71         require(_value <= allowed[_from][msg.sender]);
72 
73         balances[_from] = sub(balances[_from], _value);
74         
75         
76         balances[_to] = add(balances[_to], _value);
77         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
78         emit Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function approve(
83         address _spender, 
84         uint256 _value
85     ) 
86     public 
87     returns (bool) 
88     {
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(
95         address _owner,
96         address _spender
97     )
98     public
99     view
100     returns (uint256)
101     {
102         return allowed[_owner][_spender];
103     }
104 
105     function increaseApproval(
106         address _spender,
107         uint256 _addedValue
108     )
109     public
110     returns (bool)
111     {
112         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
113         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117     function decreaseApproval(
118         address _spender,
119         uint256 _subtractedValue
120     )
121     public
122     returns (bool)
123     {
124         uint256 oldValue = allowed[msg.sender][_spender];
125 
126         if (_subtractedValue > oldValue) {
127             allowed[msg.sender][_spender] = 0;
128         } 
129         else 
130         {
131             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
132         }
133         
134         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138     
139     
140 
141      
142     
143     
144     modifier admin_only()
145     {
146         require(msg.sender==admin_address);
147         _;
148     }
149 
150     function setAdmin( address new_admin_address ) 
151     public 
152     admin_only 
153     returns (bool)
154     {
155         require(new_admin_address != address(0));
156         admin_address = new_admin_address;
157         return true;
158     }
159 
160     
161     function withDraw()
162     public
163     admin_only
164     {
165         require(address(this).balance > 0);
166         admin_address.transfer(address(this).balance);
167     }
168 
169     function () external payable
170     {
171                 
172         
173         
174            
175     }
176 
177 
178     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
179     {
180         if (a == 0) 
181         {
182             return 0;
183         }
184 
185         c = a * b;
186         assert(c / a == b);
187         return c;
188     }
189 
190     function div(uint256 a, uint256 b) internal pure returns (uint256) 
191     {
192         return a / b;
193     }
194 
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
196     {
197         assert(b <= a);
198         return a - b;
199     }
200 
201     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
202     {
203         c = a + b;
204         assert(c >= a);
205         return c;
206     }
207 
208 }