1 pragma solidity ^0.4.23;
2 
3 contract AroundTheWorldTravel // @HUADONG.ChainFull.Co.Ltd
4 {
5 
6     address public admin_address = 0xf2F62C02C97371Cf49302484c196172724580C95;
7     address public account_address = 0xf2F62C02C97371Cf49302484c196172724580C95;
8     mapping(address => uint256) balances;
9     string public name = "Around The World Travel 1";
10     string public symbol = "ATWT1";
11     uint8 public decimals = 18;
12     uint256 initSupply = 1000000000;
13     uint256 public totalSupply = 0;
14     constructor() 
15     payable 
16     public
17     {
18         totalSupply = mul(initSupply, 10**uint256(decimals));
19         balances[account_address] = totalSupply;
20 
21         
22     }
23 
24     function balanceOf( address _addr ) public view returns ( uint )
25     {
26         return balances[_addr];
27     }
28 
29     event Transfer(
30         address indexed from, 
31         address indexed to, 
32         uint256 value
33     ); 
34 
35     function transfer(
36         address _to, 
37         uint256 _value
38     ) 
39     public 
40     returns (bool) 
41     {
42         require(_to != address(0));
43         require(_value <= balances[msg.sender]);
44 
45         balances[msg.sender] = sub(balances[msg.sender],_value);
46 
47             
48 
49         balances[_to] = add(balances[_to], _value);
50         emit Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     
55     mapping (address => mapping (address => uint256)) internal allowed;
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61 
62     function transferFrom(
63         address _from,
64         address _to,
65         uint256 _value
66     )
67     public
68     returns (bool)
69     {
70         require(_to != address(0));
71         require(_value <= balances[_from]);
72         require(_value <= allowed[_from][msg.sender]);
73 
74         balances[_from] = sub(balances[_from], _value);
75         
76         
77         balances[_to] = add(balances[_to], _value);
78         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
79         emit Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(
84         address _spender, 
85         uint256 _value
86     ) 
87     public 
88     returns (bool) 
89     {
90         allowed[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(
96         address _owner,
97         address _spender
98     )
99     public
100     view
101     returns (uint256)
102     {
103         return allowed[_owner][_spender];
104     }
105 
106     function increaseApproval(
107         address _spender,
108         uint256 _addedValue
109     )
110     public
111     returns (bool)
112     {
113         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
114         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 
118     function decreaseApproval(
119         address _spender,
120         uint256 _subtractedValue
121     )
122     public
123     returns (bool)
124     {
125         uint256 oldValue = allowed[msg.sender][_spender];
126 
127         if (_subtractedValue > oldValue) {
128             allowed[msg.sender][_spender] = 0;
129         } 
130         else 
131         {
132             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
133         }
134         
135         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137     }
138 
139     
140     
141 
142      
143     
144     
145     modifier admin_only()
146     {
147         require(msg.sender==admin_address);
148         _;
149     }
150 
151     function setAdmin( address new_admin_address ) 
152     public 
153     admin_only 
154     returns (bool)
155     {
156         require(new_admin_address != address(0));
157         admin_address = new_admin_address;
158         return true;
159     }
160 
161     
162     function withDraw()
163     public
164     admin_only
165     {
166         require(address(this).balance > 0);
167         admin_address.transfer(address(this).balance);
168     }
169 
170     function () external payable
171     {
172                 
173         
174         
175            
176     }
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