1 pragma solidity ^0.4.24;
2 /*
3 DRIVER ETHEREUM CRYPTO-BANK THE FIRST EDITION
4 ETHDRIVER.COM THE NEW WORLD ECONOMY PROJECT
5 CREATED 2018-09-26 DAO DRIVER ETHEREUM (c)
6 0x476371DD2bB73e800631F5Acfea5b5c0178aA605
7 */
8 contract OWN 
9 {
10     address public owner;
11     address internal newOwner;
12     
13     constructor() 
14     public
15     payable
16     {
17     owner = msg.sender;
18     }
19     
20     modifier onlyOwner 
21     {
22     require(owner == msg.sender);
23     _;
24     }
25     
26     function changeOwner(address _owner)
27     onlyOwner 
28     public
29     {
30     require(_owner != 0);
31     newOwner = _owner;
32     }
33     
34     function confirmOwner()
35     public 
36     { 
37     require(newOwner == msg.sender);
38     owner = newOwner;
39     delete newOwner;
40     }
41 }
42 
43 library SafeMath {
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46     return 0;
47     }
48     uint256 c = a*b;
49     assert(c/a == b);
50     return c;
51     }
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a/b;
54     return c;
55     }
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59     }
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64     }
65 }
66 
67 contract ERC20
68 {
69     string public constant name     = "FIRST DRIVER";
70     string public constant symbol   = "DRIVER";
71     uint8  public constant decimals =  6;
72     uint256 public totalSupply;
73     
74     event Approval(address indexed owner, address indexed spender, uint value);
75     event Transfer(address indexed from, address indexed to, uint value);
76 
77     mapping (address => mapping(address => uint256)) public allowance;
78     mapping (address => uint256) public balanceOf;
79     
80     function balanceOf(address who)
81     public constant
82     returns (uint)
83     {
84     return balanceOf[who];
85     }
86     
87     function approve(address _spender, uint _value)
88     public
89     {
90     allowance[msg.sender][_spender] = _value;
91     emit Approval(msg.sender, _spender, _value);
92     }
93     
94     function allowance(address _owner, address _spender) 
95     public constant 
96     returns (uint remaining) 
97     {
98     return allowance[_owner][_spender];
99     }
100     
101     modifier onlyPayloadSize(uint size) 
102     {
103     require(msg.data.length >= size + 4);
104     _;
105     }
106 }
107 
108 contract DRIVER_ETHEREUM is OWN, ERC20
109 {
110     using SafeMath for uint256;
111     uint256 internal Bank = 0;
112     uint256 public Price = 800000000;
113     uint256 internal constant Minn = 10000000000000000;
114     uint256 internal constant Maxx = 10000000000000000000;
115     address internal constant ethdriver = 0x476371DD2bB73e800631F5Acfea5b5c0178aA605;
116     
117     function() 
118     payable 
119     public
120         {
121         require(msg.value>0);
122         require(msg.value >= Minn);
123         require(msg.value <= Maxx);
124         mintTokens(msg.sender, msg.value);
125         }
126         
127     function mintTokens(address _who, uint256 _value) 
128     internal 
129         {
130         uint256 tokens = _value / (Price*10/8); //sale
131         require(tokens > 0); 
132         require(balanceOf[_who] + tokens > balanceOf[_who]);
133         totalSupply += tokens; //mint
134         balanceOf[_who] += tokens; //sale
135         uint256 perc = _value.div(100);
136         Bank += perc.mul(85);  //reserve
137         Price = Bank.div(totalSupply); //pump
138         uint256 minus = _value % (Price*10/8); //change
139         require(minus > 0);
140         emit Transfer(this, _who, tokens);
141         _value=0; tokens=0;
142         owner.transfer(perc.mul(5)); //owners
143         ethdriver.transfer(perc.mul(5)); //systems
144         _who.transfer(minus); minus=0;
145         }
146         
147     function transfer (address _to, uint _value) 
148     public onlyPayloadSize(2 * 32) 
149     returns (bool success)
150         {
151         require(balanceOf[msg.sender] >= _value);
152         
153         if(_to != address(this)) //standart
154         {
155         require(balanceOf[_to] + _value >= balanceOf[_to]);
156         balanceOf[msg.sender] -= _value;
157         balanceOf[_to] += _value;
158         emit Transfer(msg.sender, _to, _value);
159         }
160         else //tokens to contract
161         {
162         balanceOf[msg.sender] -= _value;
163         uint256 change = _value.mul(Price);
164         require(address(this).balance >= change);
165 		
166 		if(totalSupply > _value)
167 		{
168         uint256 plus = (address(this).balance - Bank).div(totalSupply);    
169         Bank -= change; totalSupply -= _value;
170         Bank += (plus.mul(_value));  //reserve
171         Price = Bank.div(totalSupply); //pump
172         emit Transfer(msg.sender, _to, _value);
173         }
174         
175         if(totalSupply == _value)
176         {
177         Price = address(this).balance/totalSupply;
178         Price = (Price.mul(101)).div(100); //pump
179         totalSupply=0; Bank=0;
180         emit Transfer(msg.sender, _to, _value);
181         owner.transfer(address(this).balance - change);
182         }
183         msg.sender.transfer(change);
184         }
185         return true;
186         }
187     
188     function transferFrom(address _from, address _to, uint _value) 
189     public onlyPayloadSize(3 * 32)
190     returns (bool success)
191         {
192         require(balanceOf[_from] >= _value);
193         require(allowance[_from][msg.sender] >= _value);
194         
195         if(_to != address(this)) //standart
196         {
197         require(balanceOf[_to] + _value >= balanceOf[_to]);
198         balanceOf[_from] -= _value;
199         balanceOf[_to] += _value;
200         allowance[_from][msg.sender] -= _value;
201         emit Transfer(_from, _to, _value);
202         }
203         else //sale
204         {
205         balanceOf[_from] -= _value;
206         uint256 change = _value.mul(Price);
207         require(address(this).balance >= change);
208         
209         if(totalSupply > _value)
210         {
211         uint256 plus = (address(this).balance - Bank).div(totalSupply);   
212         Bank -= change;
213         totalSupply -= _value;
214         Bank += (plus.mul(_value)); //reserve
215         Price = Bank.div(totalSupply); //pump
216         emit Transfer(_from, _to, _value);
217         allowance[_from][msg.sender] -= _value;
218         }
219         if(totalSupply == _value)
220         {
221         Price = address(this).balance/totalSupply;
222         Price = (Price.mul(101)).div(100); //pump
223         totalSupply=0; Bank=0; 
224         emit Transfer(_from, _to, _value);
225         allowance[_from][msg.sender] -= _value;
226         owner.transfer(address(this).balance - change);
227         }
228         _from.transfer(change);
229         }
230         return true;
231         }
232 }