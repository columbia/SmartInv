1 pragma solidity ^0.4.25;
2 /* NEXT LEVEL CLUB CRYPTO-BANK THE FIRST EDITION
3 THE NEW WORLD ECONOMY PROJECT
4 CREATED 2018-10-04 BY DAO DRIVER ETHEREUM (c)
5 0xB453AA2Cdc2F9241d2c451053DA8268B34b4227f */
6 contract OWN
7 {
8     address public owner;
9     address internal newOwner;
10     
11     constructor() 
12     public
13     payable
14     {
15     owner = msg.sender;
16     }
17     
18     modifier onlyOwner 
19     {
20     require(owner == msg.sender);
21     _;
22     }
23     
24     function changeOwner(address _owner)
25     onlyOwner 
26     public
27     {
28     require(_owner != 0);
29     newOwner = _owner;
30     }
31     
32     function confirmOwner()
33     public 
34     { 
35     require(newOwner == msg.sender);
36     owner = newOwner;
37     delete newOwner;
38     }
39 }
40 library SafeMath {
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43     return 0;
44     }
45     uint256 c = a*b;
46     assert(c/a == b);
47     return c;
48     }
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a/b;
51     return c;
52     }
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56     }
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61     }
62 }
63 contract ERC20
64 {
65     string public constant name     = "NEXT LEVEL CLUB";
66     string public constant symbol   = "NLCLUB";
67     uint8  public constant decimals =  6;
68     uint256 public totalSupply;
69     
70     event Approval(address indexed owner, address indexed spender, uint value);
71     event Transfer(address indexed from, address indexed to, uint value);
72 
73     mapping (address => mapping(address => uint256)) public allowance;
74     mapping (address => uint256) public balanceOf;
75     
76     function balanceOf(address who)
77     public constant
78     returns (uint)
79     {
80     return balanceOf[who];
81     }
82     
83     function approve(address _spender, uint _value)
84     public
85     {
86     allowance[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     }
89     
90     function allowance(address _owner, address _spender) 
91     public constant 
92     returns (uint remaining) 
93     {
94     return allowance[_owner][_spender];
95     }
96     
97     modifier onlyPayloadSize(uint size) 
98     {
99     require(msg.data.length >= size + 4);
100     _;
101     }
102 }
103 
104 contract A_NEXT_LEVEL is OWN, ERC20
105 {
106     using SafeMath for uint256;
107     uint256 internal Bank = 0;
108     uint256 public Price = 800000000;
109     uint256 internal constant Minn = 10000000000000000;
110     uint256 internal constant Maxx = 10000000000000000000;
111     address internal constant ethdriver = 0xB453AA2Cdc2F9241d2c451053DA8268B34b4227f;
112     
113     function() 
114     payable 
115     public
116         {
117         require(msg.value>0);
118         require(msg.value >= Minn);
119         require(msg.value <= Maxx);
120         mintTokens(msg.sender, msg.value);
121         }
122         
123     function mintTokens(address _who, uint256 _value) 
124     internal 
125         {
126         uint256 tokens = _value / (Price*10/8); //sale
127         require(tokens > 0); 
128         require(balanceOf[_who] + tokens > balanceOf[_who]);
129         totalSupply += tokens; //mint
130         balanceOf[_who] += tokens; //sale
131         uint256 perc = _value.div(100);
132         Bank += perc.mul(85);  //reserve
133         Price = Bank.div(totalSupply); //pump
134         uint256 minus = _value % (Price*10/8); //change
135         require(minus > 0);
136         emit Transfer(this, _who, tokens);
137         _value=0; tokens=0;
138         owner.transfer(perc.mul(5)); //owners
139         ethdriver.transfer(perc.mul(5)); //systems
140         _who.transfer(minus); minus=0;
141         }
142         
143     function transfer (address _to, uint _value) 
144     public onlyPayloadSize(2 * 32) 
145     returns (bool success)
146         {
147         require(balanceOf[msg.sender] >= _value);
148         if(_to != address(this)) //standart
149         {
150         require(balanceOf[_to] + _value >= balanceOf[_to]);
151         balanceOf[msg.sender] -= _value;
152         balanceOf[_to] += _value;
153         emit Transfer(msg.sender, _to, _value);
154         }
155         else //tokens to contract
156         {
157         balanceOf[msg.sender] -= _value;
158         uint256 change = _value.mul(Price);
159         require(address(this).balance >= change);
160 		
161 		if(totalSupply > _value)
162 		{
163         uint256 plus = (address(this).balance - Bank).div(totalSupply);    
164         Bank -= change; totalSupply -= _value;
165         Bank += (plus.mul(_value));  //reserve
166         Price = Bank.div(totalSupply); //pump
167         emit Transfer(msg.sender, _to, _value);
168         }
169         if(totalSupply == _value)
170         {
171         Price = address(this).balance/totalSupply;
172         Price = (Price.mul(101)).div(100); //pump
173         totalSupply=0; Bank=0;
174         emit Transfer(msg.sender, _to, _value);
175         owner.transfer(address(this).balance - change);
176         }
177         msg.sender.transfer(change);
178         }
179         return true;
180         }
181     
182     function transferFrom(address _from, address _to, uint _value) 
183     public onlyPayloadSize(3 * 32)
184     returns (bool success)
185         {
186         require(balanceOf[_from] >= _value);
187         require(allowance[_from][msg.sender] >= _value);
188         if(_to != address(this)) //standart
189         {
190         require(balanceOf[_to] + _value >= balanceOf[_to]);
191         balanceOf[_from] -= _value;
192         balanceOf[_to] += _value;
193         allowance[_from][msg.sender] -= _value;
194         emit Transfer(_from, _to, _value);
195         }
196         else //sale
197         {
198         balanceOf[_from] -= _value;
199         uint256 change = _value.mul(Price);
200         require(address(this).balance >= change);
201         if(totalSupply > _value)
202         {
203         uint256 plus = (address(this).balance - Bank).div(totalSupply);   
204         Bank -= change;
205         totalSupply -= _value;
206         Bank += (plus.mul(_value)); //reserve
207         Price = Bank.div(totalSupply); //pump
208         emit Transfer(_from, _to, _value);
209         allowance[_from][msg.sender] -= _value;
210         }
211         if(totalSupply == _value)
212         {
213         Price = address(this).balance/totalSupply;
214         Price = (Price.mul(101)).div(100); //pump
215         totalSupply=0; Bank=0; 
216         emit Transfer(_from, _to, _value);
217         allowance[_from][msg.sender] -= _value;
218         owner.transfer(address(this).balance - change);
219         }
220         _from.transfer(change);
221         }
222         return true;
223         }
224 }