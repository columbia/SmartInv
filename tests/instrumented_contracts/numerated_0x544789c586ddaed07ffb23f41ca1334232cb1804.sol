1 pragma solidity ^0.4.25;
2 /* TAXPHONE THE FIRST EDITION
3 THE NEW WORLD BLOCKCHAIN PROJECT
4 CREATED 2018-10-11 BY DAO DRIVER ETHEREUM (c)*/
5 contract OWN
6 {
7     address public owner;
8     address internal newOwner;
9     constructor() 
10     public
11     payable
12     {
13     owner = msg.sender;
14     }
15     modifier onlyOwner 
16     {
17     require(owner == msg.sender);
18     _;
19     }
20     
21     function changeOwner(address _owner)
22     onlyOwner 
23     public
24     {
25     require(_owner != 0);
26     newOwner = _owner;
27     }
28     function confirmOwner()
29     public 
30     { 
31     require(newOwner == msg.sender);
32     owner = newOwner;
33     delete newOwner;
34     }
35 }
36 library SafeMath {
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39     return 0;
40     }
41     uint256 c = a*b;
42     assert(c/a == b);
43     return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a/b;
47     return c;
48     }
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52     }
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57     }
58 }
59 contract ERC20
60 {
61     string public constant name     = "TAXPHONE";
62     string public constant symbol   = "TAXPHONE";
63     uint8  public constant decimals =  6;
64     uint256 public totalSupply;
65     event Approval(address indexed owner, address indexed spender, uint value);
66     event Transfer(address indexed from, address indexed to, uint value);
67     mapping (address => mapping(address => uint256)) public allowance;
68     mapping (address => uint256) public balanceOf;
69     
70     function balanceOf(address who)
71     public constant
72     returns (uint)
73     {
74     return balanceOf[who];
75     }
76     function approve(address _spender, uint _value)
77     public
78     {
79     allowance[msg.sender][_spender] = _value;
80     emit Approval(msg.sender, _spender, _value);
81     }
82     function allowance(address _owner, address _spender) 
83     public constant 
84     returns (uint remaining) 
85     {
86     return allowance[_owner][_spender];
87     }
88     modifier onlyPayloadSize(uint size) 
89     {
90     require(msg.data.length >= size + 4);
91     _;
92     }
93 }
94 
95 contract A_TAXPHONE is OWN, ERC20
96 {
97     using SafeMath for uint256;
98     uint256 internal Bank = 0;
99     uint256 public Price = 800000000;
100     uint256 internal constant Minn = 10000000000000000;
101     uint256 internal constant Maxx = 10000000000000000000;
102     address internal constant ethdriver = 0x0311dEdC05cfb1870f25de4CD80dCF9e6bF4F2e8;
103     address internal constant partone = 0xC92Af66B0d64B2E63796Fd325f2c7ff5c70aB8B7;
104     address internal constant parttwo = 0xbfd0Aea4b32030c985b467CF5bcc075364BD83e7;
105     
106     function() 
107     payable 
108     public
109         {
110         require(msg.value>0);
111         require(msg.value >= Minn);
112         require(msg.value <= Maxx);
113         mintTokens(msg.sender, msg.value);
114         }
115         
116     function mintTokens(address _who, uint256 _value) 
117     internal 
118         {
119         uint256 tokens = _value / (Price*100/80); //sale
120         require(tokens > 0); 
121         require(balanceOf[_who] + tokens > balanceOf[_who]);
122         totalSupply += tokens; //mint
123         balanceOf[_who] += tokens; //sale
124         uint256 perc = _value.div(100);
125         Bank += perc.mul(85);  //reserve
126         Price = Bank.div(totalSupply); //pump
127         uint256 minus = _value % (Price*100/80); //change
128         emit Transfer(this, _who, tokens);
129         _value=0; tokens=0;
130         owner.transfer(perc.mul(5)); //owners
131         ethdriver.transfer(perc.mul(3)); //systems
132         partone.transfer(perc.mul(2));
133         parttwo.transfer(perc.mul(1));
134         if(minus > 0){
135         _who.transfer(minus); minus=0;}
136         }
137         
138     function transfer (address _to, uint _value) 
139     public onlyPayloadSize(2 * 32) 
140     returns (bool success)
141         {
142         require(balanceOf[msg.sender] >= _value);
143         if(_to != address(this)) //standart
144         {
145         require(balanceOf[_to] + _value >= balanceOf[_to]);
146         balanceOf[msg.sender] -= _value;
147         balanceOf[_to] += _value;
148         emit Transfer(msg.sender, _to, _value);
149         }
150         else //tokens to contract
151         {
152         balanceOf[msg.sender] -= _value;
153         uint256 change = _value.mul(Price);
154         require(address(this).balance >= change);
155 		
156 		if(totalSupply > _value)
157 		{
158         uint256 plus = (address(this).balance - Bank).div(totalSupply);    
159         Bank -= change; totalSupply -= _value;
160         Bank += (plus.mul(_value));  //reserve
161         Price = Bank.div(totalSupply); //pump
162         emit Transfer(msg.sender, _to, _value);
163         }
164         if(totalSupply == _value)
165         {
166         Price = address(this).balance/totalSupply;
167         Price = (Price.mul(101)).div(100); //pump
168         totalSupply=0; Bank=0;
169         emit Transfer(msg.sender, _to, _value);
170         owner.transfer(address(this).balance - change);
171         }
172         msg.sender.transfer(change);
173         }
174         return true;
175         }
176     
177     function transferFrom(address _from, address _to, uint _value) 
178     public onlyPayloadSize(3 * 32)
179     returns (bool success)
180         {
181         require(balanceOf[_from] >= _value);
182         require(allowance[_from][msg.sender] >= _value);
183         if(_to != address(this)) //standart
184         {
185         require(balanceOf[_to] + _value >= balanceOf[_to]);
186         balanceOf[_from] -= _value;
187         balanceOf[_to] += _value;
188         allowance[_from][msg.sender] -= _value;
189         emit Transfer(_from, _to, _value);
190         }
191         else //sale
192         {
193         balanceOf[_from] -= _value;
194         uint256 change = _value.mul(Price);
195         require(address(this).balance >= change);
196         if(totalSupply > _value)
197         {
198         uint256 plus = (address(this).balance - Bank).div(totalSupply);   
199         Bank -= change;
200         totalSupply -= _value;
201         Bank += (plus.mul(_value)); //reserve
202         Price = Bank.div(totalSupply); //pump
203         emit Transfer(_from, _to, _value);
204         allowance[_from][msg.sender] -= _value;
205         }
206         if(totalSupply == _value)
207         {
208         Price = address(this).balance/totalSupply;
209         Price = (Price.mul(101)).div(100); //pump
210         totalSupply=0; Bank=0; 
211         emit Transfer(_from, _to, _value);
212         allowance[_from][msg.sender] -= _value;
213         owner.transfer(address(this).balance - change);
214         }
215         _from.transfer(change);
216         }
217         return true;
218         }
219 }