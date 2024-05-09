1 pragma solidity ^0.5.7;
2 
3 /* NASH TOKEN FIRST EDITION
4 THE NEW WORLD BLOCKCHAIN PROJECT
5 CREATED 2019-04-18 BY DAO DRIVER ETHEREUM (c)*/
6 
7 library SafeMath {
8     
9     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns(uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract owned {
35     address payable internal owner;
36     address payable internal newOwner;
37     address payable internal found;
38     address payable internal feedr;
39     
40     modifier onlyOwner {
41         require(owner == msg.sender);
42         _;
43     }
44 
45     function changeOwner(address payable _owner) onlyOwner public {
46         require(_owner != address(0));
47         newOwner = _owner;
48     }
49 
50     function confirmOwner() public {
51         require(newOwner == msg.sender);
52         owner = newOwner;
53         delete newOwner;
54     }
55 }
56 
57 contract ERC20Basic {
58     modifier onlyPayloadSize(uint size) {
59         require(msg.data.length >= size + 4);
60         _;
61     }
62     function totalSupply() public view returns(uint256);
63     function balanceOf(address who) public view returns(uint256);
64     function transfer(address payable to, uint256 value) public returns(bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public view returns(uint256);
70     function transferFrom(address payable from, address payable to, uint256 value) public returns(bool);
71     function approve(address spender, uint256 value) public returns(bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract TokenBasic is ERC20Basic, owned {
76     using SafeMath for uint256;
77     mapping(address => uint256) internal balances;
78     uint256 internal totalSupply_;
79     uint256 internal activeSupply_;
80     mapping(uint256 => uint256) public sum_;
81     mapping(address => uint256) public pdat_;
82     uint256 public pnr_;
83 
84     function totalSupply() public view returns(uint256) {
85         return totalSupply_;
86     }
87 
88     function activeSupply() public view returns(uint256) {
89         return activeSupply_;
90     }
91 
92     function transfer(address payable _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {
93         require(_to != address(0));
94         require(_value <= balances[msg.sender]);
95         require(_to != found);
96         uint256 div1 = 0;
97         uint256 div2 = 0;
98         if (msg.sender != found) {
99             if (pdat_[msg.sender] < pnr_) {
100                 for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
101                     div1 = div1.add(sum_[i].mul(balances[msg.sender]));
102                 }
103             }
104         }
105         if (pdat_[_to] < pnr_ && balances[_to] > 0) {
106             for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
107                 div2 = div2.add(sum_[i].mul(balances[_to]));
108             }
109         }
110         
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         
114         pdat_[_to] = pnr_;
115         
116         emit Transfer(msg.sender, _to, _value);
117         
118         if (msg.sender == found) {
119             activeSupply_ = activeSupply_.add(_value);
120         } else {
121             pdat_[msg.sender] = pnr_;
122             if (div1 > 0) {
123                 msg.sender.transfer(div1);
124             }
125         }
126         if (div2 > 0) {
127             _to.transfer(div2);
128         }
129         return true;
130     }
131 
132     function balanceOf(address _owner) public view returns(uint256) {
133         return balances[_owner];
134     }
135 }
136 
137 contract TokenStandard is ERC20, TokenBasic {
138     
139     mapping(address => mapping(address => uint256)) internal allowed;
140     function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool) {
141         require(_to != address(0));
142         require(_to != found);
143         require(_value <= balances[_from]);
144         require(_value <= allowed[_from][msg.sender]);
145         uint256 div1 = 0;
146         uint256 div2 = 0;
147         if (_from != found) {
148             if (pdat_[_from] < pnr_) {
149                 for (uint256 i = pnr_; i >= pdat_[_from]; i = i.sub(1)) {
150                     div1 = div1.add(sum_[i].mul(balances[_from]));
151                 }
152             }
153         }
154         if (pdat_[_to] < pnr_ && balances[_to] > 0) {
155             for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
156                 div2 = div2.add(sum_[i].mul(balances[_to]));
157             }
158         }
159         
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         
164         pdat_[_to] = pnr_;
165         
166         emit Transfer(_from, _to, _value);
167         if (_from == found) {
168             activeSupply_ = activeSupply_.add(_value);
169         } else {
170             pdat_[_from] = pnr_;
171             if (div1 > 0) {
172                 _from.transfer(div1);
173             }
174         }
175         if (div2 > 0) {
176             _to.transfer(div2);
177         }
178         return true;
179     }
180     function approve(address _spender, uint256 _value) public returns(bool) {
181         allowed[msg.sender][_spender] = _value;
182         emit Approval(msg.sender, _spender, _value);
183         return true;
184     }
185     function allowance(address _owner, address _spender) public view returns(uint256) {
186         return allowed[_owner][_spender];
187     }
188     function increaseApproval(address _spender, uint _addrdedValue) public returns(bool) {
189         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addrdedValue);
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
194         uint oldValue = allowed[msg.sender][_spender];
195         if (_subtractedValue > oldValue) {
196             allowed[msg.sender][_spender] = 0;
197         } else {
198             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199         }
200         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 }
204 contract ANASH is TokenStandard {
205     string public constant name = "NASH TOKEN";
206     string public constant symbol = "NASH";
207     uint8 public constant decimals = 2;
208     uint256 internal constant premined = 20000000000;
209     function() payable external {
210         if (feedr == msg.sender) {
211             require(msg.value >= 1);
212             sum_[pnr_] = msg.value.div(activeSupply_);
213             pnr_ = pnr_.add(1);
214         } else {
215             require(balances[msg.sender] > 0);
216             uint256 div1 = 0;
217             uint256 cont = 0;
218             if (pdat_[msg.sender] < pnr_) {
219                 for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
220                     div1 = div1.add(sum_[i].mul(balances[msg.sender]));
221                     cont = cont.add(1);
222                     if(cont > 80){break;}
223                 }
224             }
225             pdat_[msg.sender] = pnr_;
226             div1 = div1.add(msg.value);
227             if (div1 > 0) {
228                 msg.sender.transfer(div1);
229             }
230         }
231     }
232     constructor() public {
233         pnr_ = 1;
234         owner = msg.sender;
235         found = 0xfB538A7365d47183692E1866fC0b32308F15BAFD;
236         feedr = 0xCebaa747868135CC4a0d9A4f982849161f3a4CE7;
237         totalSupply_ = premined;
238         activeSupply_ = 0;
239         balances[found] = balances[found].add(premined);
240         emit Transfer(address(0), found, premined);
241     }
242 }