1 pragma solidity ^0.4.25;
2 /* TLCLUB CRYPTO-BANK THE FIRST EDITION
3 THE NEW ECONOMY PROJECT
4 CREATED 2018-10-04 BY DAO DRIVER ETHEREUM (c)*/
5 contract OWN
6 {
7     address public owner;
8     address internal newOwner;
9     
10     constructor() 
11     public
12     payable
13     {
14     owner = msg.sender;
15     }
16     
17     modifier onlyOwner 
18     {
19     require(owner == msg.sender);
20     _;
21     }
22     
23     function changeOwner(address _owner)
24     onlyOwner 
25     public
26     {
27     require(_owner != 0);
28     newOwner = _owner;
29     }
30     
31     function confirmOwner()
32     public 
33     { 
34     require(newOwner == msg.sender);
35     owner = newOwner;
36     delete newOwner;
37     }
38 }
39 library SafeMath {
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42     return 0;
43     }
44     uint256 c = a*b;
45     assert(c/a == b);
46     return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a/b;
50     return c;
51     }
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55     }
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60     }
61 }
62 contract ERC20
63 {
64     string public constant name     = "TLIFE";
65     string public constant symbol   = "TLF";
66     uint8  public constant decimals =  6;
67     uint256 public totalSupply;
68     
69     event Approval(address indexed owner, address indexed spender, uint value);
70     event Transfer(address indexed from, address indexed to, uint value);
71 
72     mapping (address => mapping(address => uint256)) public allowance;
73     mapping (address => uint256) public balanceOf;
74     
75     function balanceOf(address who)
76     public constant
77     returns (uint)
78     {
79     return balanceOf[who];
80     }
81     
82     function approve(address _spender, uint _value)
83     public
84     {
85     allowance[msg.sender][_spender] = _value;
86     emit Approval(msg.sender, _spender, _value);
87     }
88     
89     function allowance(address _owner, address _spender) 
90     public constant 
91     returns (uint remaining) 
92     {
93     return allowance[_owner][_spender];
94     }
95     
96     modifier onlyPayloadSize(uint size) 
97     {
98     require(msg.data.length >= size + 4);
99     _;
100     }
101 }
102 
103 contract TLIFE is OWN, ERC20
104 {
105     using SafeMath for uint256;
106     uint256 internal Bank = 0;
107     uint256 public Price = 800000000;
108     uint256 internal constant Minn = 10000000000000000;
109     uint256 internal constant Maxx = 10000000000000000000;
110     address internal constant ethdriver = 0x61585C21E0C0c5875EaB1bc707476BD0a28f157b;
111    
112     function() 
113     payable 
114     public
115         {
116         require(msg.value>0);
117         require(msg.value >= Minn);
118         require(msg.value <= Maxx);
119         mintTokens(msg.sender, msg.value);
120         }
121         
122     function mintTokens(address _who, uint256 _value) 
123     internal 
124         {
125         uint256 tokens = _value / (Price*10/8); //sale
126         require(tokens > 0); 
127         require(balanceOf[_who] + tokens > balanceOf[_who]);
128         totalSupply += tokens; //mint
129         balanceOf[_who] += tokens; //sale
130         uint256 perc = _value.div(100);
131         Bank += perc.mul(85);  //reserve
132         Price = Bank.div(totalSupply); //pump
133         uint256 minus = _value % (Price*10/8); //change
134         require(minus > 0);
135         emit Transfer(this, _who, tokens);
136         _value=0; tokens=0;
137         owner.transfer(perc.mul(5)); //owners
138         ethdriver.transfer(perc.mul(5)); //systems
139         _who.transfer(minus); minus=0;
140         }
141         
142     function transfer (address _to, uint _value) 
143     public onlyPayloadSize(2 * 32) 
144     returns (bool success)
145         {
146         require(balanceOf[msg.sender] >= _value);
147         if(_to != address(this)) //standart
148         {
149         require(balanceOf[_to] + _value >= balanceOf[_to]);
150         balanceOf[msg.sender] -= _value;
151         balanceOf[_to] += _value;
152         emit Transfer(msg.sender, _to, _value);
153         }
154         else //tokens to contract
155         {
156         balanceOf[msg.sender] -= _value;
157         uint256 change = _value.mul(Price);
158         require(address(this).balance >= change);
159 		
160 		if(totalSupply > _value)
161 		{
162         uint256 plus = (address(this).balance - Bank).div(totalSupply);    
163         Bank -= change; totalSupply -= _value;
164         Bank += (plus.mul(_value));  //reserve
165         Price = Bank.div(totalSupply); //pump
166         emit Transfer(msg.sender, _to, _value);
167         }
168         if(totalSupply == _value)
169         {
170         Price = address(this).balance/totalSupply;
171         Price = (Price.mul(101)).div(100); //pump
172         totalSupply=0; Bank=0;
173         emit Transfer(msg.sender, _to, _value);
174         owner.transfer(address(this).balance - change);
175         }
176         msg.sender.transfer(change);
177         }
178         return true;
179         }
180     
181     function transferFrom(address _from, address _to, uint _value) 
182     public onlyPayloadSize(3 * 32)
183     returns (bool success)
184         {
185         require(balanceOf[_from] >= _value);
186         require(allowance[_from][msg.sender] >= _value);
187         if(_to != address(this)) //standart
188         {
189         require(balanceOf[_to] + _value >= balanceOf[_to]);
190         balanceOf[_from] -= _value;
191         balanceOf[_to] += _value;
192         allowance[_from][msg.sender] -= _value;
193         emit Transfer(_from, _to, _value);
194         }
195         else //sale
196         {
197         balanceOf[_from] -= _value;
198         uint256 change = _value.mul(Price);
199         require(address(this).balance >= change);
200         if(totalSupply > _value)
201         {
202         uint256 plus = (address(this).balance - Bank).div(totalSupply);   
203         Bank -= change;
204         totalSupply -= _value;
205         Bank += (plus.mul(_value)); //reserve
206         Price = Bank.div(totalSupply); //pump
207         emit Transfer(_from, _to, _value);
208         allowance[_from][msg.sender] -= _value;
209         }
210         if(totalSupply == _value)
211         {
212         Price = address(this).balance/totalSupply;
213         Price = (Price.mul(101)).div(100); //pump
214         totalSupply=0; Bank=0; 
215         emit Transfer(_from, _to, _value);
216         allowance[_from][msg.sender] -= _value;
217         owner.transfer(address(this).balance - change);
218         }
219         _from.transfer(change);
220         }
221         return true;
222         }
223 }