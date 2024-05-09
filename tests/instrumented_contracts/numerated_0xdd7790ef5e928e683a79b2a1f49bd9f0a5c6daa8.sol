1 pragma solidity 0.4.24;
2 
3 
4 contract Ownable {
5     address public owner;
6     event OwnershipRenounced(address indexed previousOwner);
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(
19         address newOwner
20     )
21         public
22         onlyOwner
23     {
24         require(newOwner != address(0));
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27     }
28 
29     function renounceOwnership()
30         public
31         onlyOwner
32     {
33         emit OwnershipRenounced(owner);
34         owner = address(0);
35     }
36 }
37 
38 library SafeMath {
39     function mul(
40         uint256 a, 
41         uint256 b
42     )
43         internal
44         pure
45         returns (uint256 c)
46     {
47         if (a == 0) {
48             return 0;
49         }
50         c = a * b;
51         require(c / a == b);
52         return c;
53     }
54 
55     function div(
56         uint256 a, 
57         uint256 b
58     )
59         internal
60         pure
61         returns (uint256)
62     {
63         return a / b;
64     }
65 
66     function sub(
67         uint256 a, 
68         uint256 b
69     )
70         internal
71         pure
72         returns (uint256)
73     {
74         require(b <= a);
75         return a - b;
76     }
77 
78     function add(
79         uint256 a,
80         uint256 b
81     )
82         internal
83         pure
84         returns (uint256 c)
85     {
86         c = a + b;
87         require(c >= a);
88         return c;
89     }
90 }
91 
92 contract ERC20Basic {
93     function totalSupply() public view returns (uint256);
94     function balanceOf(address who) public view returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     function burn(uint256 value) public returns (bool);
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Burn(address indexed from, uint256 value);
99 }
100 
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105     function burnFrom(address from, uint256 value) public returns (bool);
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 contract BasicToken is ERC20Basic {
112     using SafeMath for uint256;
113     mapping(address => uint256) internal balances;
114     uint256 internal totalSupply_;
115 
116     function totalSupply()
117         public
118         view
119         returns (uint256)
120     {
121         return totalSupply_;
122     }
123 
124     function transfer(
125         address _to, 
126         uint256 _value
127     )
128         public
129         returns (bool)
130     {
131         require(_to != address(0));
132         require(_value <= balances[msg.sender]);
133 
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     function burn(
141         uint256 _value
142     )
143         public
144         returns (bool)
145     {
146         require(balances[msg.sender] >= _value);
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         totalSupply_ = totalSupply_.sub(_value);
149         emit Burn(msg.sender, _value);
150         emit Transfer(msg.sender, address(0), _value);
151         return true;
152     }
153 
154     function balanceOf(
155         address _owner
156     )
157         public
158         view
159         returns (uint256)
160     {
161         return balances[_owner];
162     }
163 }
164 
165 
166 contract StandardToken is ERC20, BasicToken {
167     mapping (address => mapping (address => uint256)) internal allowed;
168 
169     function transferFrom(
170         address _from, 
171         address _to, 
172         uint256 _value
173     )
174         public
175         returns (bool)
176     {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     function burnFrom(
189         address _from, 
190         uint256 _value
191     )
192         public
193         returns (bool)
194     {
195         require(balances[_from] >= _value);
196         require(_value <= allowed[_from][msg.sender]);
197         balances[_from] = balances[_from].sub(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         totalSupply_ = totalSupply_.sub(_value);
200         emit Burn(_from, _value);
201         return true;
202     }
203 
204     function approve(
205         address _spender, 
206         uint256 _value
207     )
208         public
209         returns (bool)
210     {
211         allowed[msg.sender][_spender] = _value;
212         emit Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216     function allowance(
217         address _owner, 
218         address _spender
219     )
220         public
221         view
222         returns (uint256)
223     {
224         return allowed[_owner][_spender];
225     }
226 
227     function increaseApproval(
228         address _spender, 
229         uint _addedValue
230     )
231         public
232         returns (bool)
233     {
234         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 
239     function decreaseApproval(
240         address _spender, 
241         uint _subtractedValue
242     )
243         public
244         returns (bool)
245     {
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255 }
256 
257 contract CoAlphaToken is StandardToken, Ownable {
258     string public name = "CoAlphaToken";
259     string public symbol = "CAL";
260     uint8 public decimals = 2;
261     uint public initialSupply = 2000000000*(10**uint256(decimals));
262 
263     constructor() public {
264         totalSupply_ = initialSupply;
265         balances[msg.sender] = initialSupply;
266     }
267 }