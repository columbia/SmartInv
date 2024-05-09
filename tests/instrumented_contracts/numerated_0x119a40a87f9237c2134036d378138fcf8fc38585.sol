1 /**
2  * 2020.4.15 lim
3  */
4 
5 pragma solidity ^0.4.17;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 
41 contract Ownable {
42     
43     address public owner;
44 
45     function Ownable() public {
46         owner = msg.sender;
47     }
48     
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) public onlyOwner {
55         if (newOwner != address(0)) {
56             owner = newOwner;
57         }
58     }
59 
60 }
61 
62 contract ERC20 {
63     uint public _totalSupply;
64     function totalSupply() public constant returns (uint);
65     function balanceOf(address who) public constant returns (uint);
66     function transfer(address to, uint value) public;
67     
68     function approve(address spender, uint value) public;
69     function transferFrom(address from, address to, uint value) public;
70     function allowance(address owner, address spender) public constant returns (uint);
71     event Transfer(address indexed from, address indexed to, uint value);
72     event Approval(address indexed owner, address indexed spender, uint value);
73 }
74 
75 
76 contract PZSHToken is Ownable, ERC20 {
77     
78     using SafeMath for uint;
79     
80     string public name;
81     string public symbol;
82     uint public decimals;
83     uint public basisPointsRate = 0;
84     uint public maximumFee = 0;
85     uint public constant MAX_UINT = 2**256 - 1;
86     
87     mapping(address => uint) public balances;
88     mapping (address => mapping (address => uint)) public allowed;
89    
90     event Issue(uint amount);
91     event Redeem(uint amount);
92 
93     function PZSHToken(uint _initialSupply, string _name) public {
94         _totalSupply = _initialSupply * 10**6;
95         name = _name;
96         symbol = _name;
97         decimals = 6;
98         balances[owner] = _totalSupply;
99     }
100     
101     //array of holder address
102     address[] public holders = [owner];
103     //map of holder address
104     mapping(address => uint) public holdersMap;
105     
106     /**
107     * @dev Fix for the ERC20 short address attack.
108     */
109     modifier onlyPayloadSize(uint size) {
110         require(!(msg.data.length < size + 4));
111         _;
112     }
113     
114     function totalSupply() public constant returns (uint) {
115         
116         return _totalSupply;
117     }
118     
119     function balanceOf(address _owner) public constant returns (uint balance) {
120         return balances[_owner];
121     }
122     
123     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
124         uint fee = (_value.mul(basisPointsRate)).div(10000);
125         if (fee > maximumFee) {
126             fee = maximumFee;
127         }
128         uint sendAmount = _value.sub(fee);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(sendAmount);
131         if (fee > 0) {
132             balances[owner] = balances[owner].add(fee);
133             Transfer(msg.sender, owner, fee);
134         }
135         if(holdersMap[_to] == 0){
136             holdersMap[_to] = 1;
137             holders.push(_to);
138         }
139         Transfer(msg.sender, _to, sendAmount);
140     }
141 
142     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
143 
144         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
145 
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148     }
149     
150     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
151         var _allowance = allowed[_from][msg.sender];
152         
153         uint fee = (_value.mul(basisPointsRate)).div(10000);
154         if (fee > maximumFee) {
155             fee = maximumFee;
156         }
157         if (_allowance < MAX_UINT) {
158             allowed[_from][msg.sender] = _allowance.sub(_value);
159         }
160         uint sendAmount = _value.sub(fee);
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(sendAmount);
163         if (fee > 0) {
164             balances[owner] = balances[owner].add(fee);
165             Transfer(_from, owner, fee);
166         }
167         if(holdersMap[_to] == 0){
168             holdersMap[_to] = 1;
169             holders.push(_to);
170         }
171         Transfer(_from, _to, sendAmount);
172     }
173 
174     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
175         return allowed[_owner][_spender];
176     }
177     
178     function getRate(uint amount) public constant returns (uint){
179         return amount.div(_totalSupply.div(10**6));
180     }
181     
182     function issue(uint amount) public onlyOwner {
183         require(_totalSupply + amount > _totalSupply);
184         require(balances[owner] + amount > balances[owner]);
185 
186         balances[owner] += amount;
187         _totalSupply += amount;
188         Issue(amount);
189     }
190 
191     function redeem(uint amount) public onlyOwner {
192         require(_totalSupply >= amount);
193         require(balances[owner] >= amount);
194 
195         _totalSupply -= amount;
196         balances[owner] -= amount;
197         Redeem(amount);
198     }
199     
200     function holdersNum() public constant returns (uint){
201         return holders.length;
202     }
203     
204     function holdersAddress(uint num) public constant returns (address){
205         require(holders.length >= num - 1);
206         require(num >= 1);
207         return holders[num];
208     }
209     
210     //reward all address
211     function award(uint amount) public onlyOwner {
212         require(_totalSupply + amount > _totalSupply);
213         require(balances[owner] + amount > balances[owner]);
214         
215         uint avg = amount.div(_totalSupply.sub(balances[owner]).div(10**6));
216         if(avg == 0){
217             return;
218         }
219         uint realityRise = 0;
220         for(uint i = 2; i < holders.length; i++){
221             address add = holders[i];
222             if(balances[add] < 10**8){
223                 continue;
224             }
225             uint rise = avg.mul(balances[add].div(10**6));
226             if(rise == 0){
227                 continue;
228             }
229             balances[add] += rise;
230             realityRise += rise;
231             Transfer(owner, add, rise);
232         }
233         if(realityRise > 0){
234             _totalSupply += realityRise;
235             Issue(realityRise);
236         }
237     }
238     
239 
240 }