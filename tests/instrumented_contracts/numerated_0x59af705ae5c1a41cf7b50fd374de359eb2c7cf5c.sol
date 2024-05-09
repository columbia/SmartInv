1 pragma solidity ^0.4.10;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_to != address(0));
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function balanceOf(address _owner) public constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68 
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71 
72     uint256 _allowance = allowed[_from][msg.sender];
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = _allowance.sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89   }
90 
91   function increaseApproval (address _spender, uint _addedValue)
92     returns (bool success) {
93     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95     return true;
96   }
97 
98   function decreaseApproval (address _spender, uint _subtractedValue)
99     returns (bool success) {
100     uint oldValue = allowed[msg.sender][_spender];
101     if (_subtractedValue > oldValue) {
102       allowed[msg.sender][_spender] = 0;
103     } else {
104       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
105     }
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110 }
111 
112 contract CccTokenIco is StandardToken {
113     using SafeMath for uint256;
114     string public name = "Crypto Credit Card Token";
115     string public symbol = "CCCR";
116     uint8 public constant decimals = 6;
117     
118     uint256 public cntMembers = 0;
119     uint256 public totalSupply = 200000000 * (uint256(10) ** decimals);
120     uint256 public totalRaised;
121 
122     uint256 public startTimestamp;
123     uint256 public durationSeconds = uint256(86400 * 7 * 11);
124 
125     uint256 public minCap = 3000000 * (uint256(10) ** decimals);
126     uint256 public maxCap = 200000000 * (uint256(10) ** decimals);
127     
128     uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(460);
129 
130     address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;
131     address public teama = 0xfc6851324e2901b3ea6170a90Cc43BFe667D617A;
132     address public teamb = 0x21f0F5E81BEF4dc696C6BF0196c60a1aC797f953;
133     address public teamc = 0xE8726942a46E6C6B3C1F061c14a15c0053A97B6b;
134     address public founder = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;
135     address public baseowner;
136 
137     event LogTransfer(address sender, address to, uint amount);
138     event Clearing(address to, uint256 amount);
139 
140     function CccTokenIco(
141     ) 
142     {
143         cntMembers = 0;
144         startTimestamp = now - 14 days;
145         baseowner = msg.sender;
146         balances[baseowner] = totalSupply;
147         Transfer(0x0, baseowner, totalSupply);
148     }
149 
150     function bva(address partner, uint256 value, uint256 rate, address adviser) isIcoOpen payable public 
151     {
152       uint256 tokenAmount = calculateTokenAmount(value);
153       if(msg.value != 0)
154       {
155         tokenAmount = calculateTokenCount(msg.value,avgRate);
156       }else
157       {
158         require(msg.sender == stuff);
159         avgRate = avgRate.add(rate).div(2);
160       }
161       if(msg.value != 0)
162       {
163         Clearing(teama, msg.value.mul(7).div(100));
164         teama.transfer(msg.value.mul(7).div(100));
165         Clearing(teamb, msg.value.mul(12).div(1000));
166         teamb.transfer(msg.value.mul(12).div(1000));
167         Clearing(teamc, msg.value.mul(9).div(1000));
168         teamc.transfer(msg.value.mul(9).div(1000));
169         Clearing(stuff, msg.value.mul(9).div(1000));
170         stuff.transfer(msg.value.mul(9).div(1000));
171         Clearing(founder, msg.value.mul(70).div(100));
172         founder.transfer(msg.value.mul(70).div(100));
173         if(partner != adviser)
174         {
175           Clearing(adviser, msg.value.mul(20).div(100));
176           adviser.transfer(msg.value.mul(20).div(100));
177         }else
178         {
179           Clearing(founder, msg.value.mul(20).div(100));
180           founder.transfer(msg.value.mul(20).div(100));
181         } 
182       }
183       totalRaised = totalRaised.add(tokenAmount);
184       balances[baseowner] = balances[baseowner].sub(tokenAmount);
185       balances[partner] = balances[partner].add(tokenAmount);
186       Transfer(baseowner, partner, tokenAmount);
187       cntMembers = cntMembers.add(1);
188     }
189     
190     function() isIcoOpen payable public
191     {
192       if(msg.value != 0)
193       {
194         uint256 tokenAmount = calculateTokenCount(msg.value,avgRate);
195         Clearing(teama, msg.value.mul(7).div(100));
196         teama.transfer(msg.value.mul(7).div(100));
197         Clearing(teamb, msg.value.mul(12).div(1000));
198         teamb.transfer(msg.value.mul(12).div(1000));
199         Clearing(teamc, msg.value.mul(9).div(1000));
200         teamc.transfer(msg.value.mul(9).div(1000));
201         Clearing(stuff, msg.value.mul(9).div(1000));
202         stuff.transfer(msg.value.mul(9).div(1000));
203         Clearing(founder, msg.value.mul(90).div(100));
204         founder.transfer(msg.value.mul(90).div(100));
205         totalRaised = totalRaised.add(tokenAmount);
206         balances[baseowner] = balances[baseowner].sub(tokenAmount);
207         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
208         Transfer(baseowner, msg.sender, tokenAmount);
209         cntMembers = cntMembers.add(1);
210       }
211     }
212 
213     function calculateTokenAmount(uint256 count) constant returns(uint256) 
214     {
215         uint256 icoDeflator = getIcoDeflator();
216         return count.mul(icoDeflator).div(100);
217     }
218 
219     function calculateTokenCount(uint256 weiAmount, uint256 rate) constant returns(uint256) 
220     {
221         if(rate==0)revert();
222         uint256 icoDeflator = getIcoDeflator();
223         return weiAmount.div(rate).mul(icoDeflator).div(100);
224     }
225 
226     function getIcoDeflator() constant returns (uint256)
227     {
228         if (now <= startTimestamp + 15 days) 
229         {
230             return 138;
231         }else if (now <= startTimestamp + 29 days) 
232         {
233             return 123;
234         }else if (now <= startTimestamp + 43 days) 
235         {
236             return 115;
237         }else 
238         {
239             return 109;
240         }
241     }
242 
243     function finalize(uint256 weiAmount) isIcoFinished isStuff payable public
244     {
245       if(msg.sender == founder)
246       {
247         founder.transfer(weiAmount);
248       }
249     }
250 
251     function transfer(address _to, uint _value) isIcoFinished returns (bool) 
252     {
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) 
257     {
258         return super.transferFrom(_from, _to, _value);
259     }
260 
261     modifier isStuff() 
262     {
263         require(msg.sender == stuff || msg.sender == founder);
264         _;
265     }
266 
267     modifier isIcoOpen() 
268     {
269         require(now >= startTimestamp);//15.11-29.11 pre ICO
270         require(now <= startTimestamp + 14 days || now >= startTimestamp + 19 days);//gap 29.11-04.12
271         require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);//04.12-02.02 ICO
272         require(totalRaised <= maxCap);
273         _;
274     }
275 
276     modifier isIcoFinished() 
277     {
278         require(now >= startTimestamp);
279         require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));
280         _;
281     }
282 
283 }