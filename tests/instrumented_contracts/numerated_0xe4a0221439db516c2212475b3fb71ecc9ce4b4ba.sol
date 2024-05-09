1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   function Ownable () public{
11     owner = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newOwner The address to transfer ownership to.
25    */
26   function transferOwnership(address newOwner) onlyOwner {
27     if (newOwner != address(0)) {
28       owner = newOwner;
29     }
30   }
31 }
32 
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal constant returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 
61 contract ERC20 {
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65 	uint256 public totalSupply;
66 
67     function balanceOf(address who) public constant returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72 
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract Propthereum is Ownable, ERC20{
78     using SafeMath for uint256;
79 
80     //ERC20
81     string public name = "Propthereum";
82     string public symbol = "PTC";
83     uint8 public decimals;
84     uint256 public totalSupply;
85 
86     //ICO
87     //State values
88     uint256 public ethRaised;
89     
90     uint256[7] public saleStageStartDates = [1510934400,1511136000,1511222400,1511827200,1512432000,1513036800,1513641600];
91 
92     //The prices for each stage. The number of tokens a user will receive for 1ETH.
93     uint16[6] public tokens = [1800,1650,1500,1450,1425,1400];
94 
95     // This creates an array with all balances
96     mapping (address => uint256) private balances;
97     mapping (address => mapping (address => uint256)) public allowed;
98 
99     address public constant WITHDRAW_ADDRESS = 0x35528E0c694D3c3B3e164FFDcC1428c076B9467d;
100 
101     function Propthereum() public {
102 		owner = msg.sender;
103         decimals = 18;
104         totalSupply = 360000000 * 10**18;
105         balances[address(this)] = totalSupply;
106 	}
107 
108     function balanceOf(address who) public constant returns (uint256) {
109         return balances[who];
110     }
111 
112 	function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114 
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117 
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_to != address(0));
124         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
125 
126         balances[_from] = balances[_from].sub(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129 
130         Transfer(_from,_to, _value);
131         return true;
132     }
133 
134     function approve(address _spender, uint256 _amount) public returns (bool success) {
135 		require(_spender != address(0));
136         require(allowed[msg.sender][_spender] == 0 || _amount == 0);
137 
138         allowed[msg.sender][_spender] = _amount;
139         Approval(msg.sender, _spender, _amount);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144 		require(_owner != address(0));
145         return allowed[_owner][_spender];
146     }
147 
148     //ICO
149     function getPreSaleStart() public constant returns (uint256) {
150         return saleStageStartDates[0];
151     }
152 
153     function getPreSaleEnd() public constant returns (uint256) {
154         return saleStageStartDates[1];
155     }
156 
157     function getSaleStart() public constant returns (uint256) {
158         return saleStageStartDates[1];
159     }
160 
161     function getSaleEnd() public constant returns (uint256) {
162         return saleStageStartDates[6];
163     }
164 
165     function inSalePeriod() public constant returns (bool) {
166         return (now >= getSaleStart() && now <= getSaleEnd());
167     }
168 
169     function inpreSalePeriod() public constant returns (bool) {
170         return (now >= getPreSaleStart() && now <= getPreSaleEnd());
171     }
172 
173     function() public payable {
174         buyTokens();
175     }
176 
177     function buyTokens() public payable {
178         require(msg.value > 0);
179         require(inSalePeriod() == true || inpreSalePeriod()== true );
180         require(msg.sender != address(0));
181 
182         uint index = getStage();
183         uint256 amount = tokens[index];
184         amount = amount.mul(msg.value);
185         balances[msg.sender] = balances[msg.sender].add(amount);
186         uint256 total_amt =  amount.add((amount.mul(30)).div(100));
187         balances[owner] = balances[owner].add((amount.mul(30)).div(100));
188         balances[address(this)] = balances[address(this)].sub(total_amt);
189         ethRaised = ethRaised.add(msg.value);
190     }
191 
192     function transferEth() public onlyOwner {
193         WITHDRAW_ADDRESS.transfer(this.balance);
194     }
195 
196    function burn() public onlyOwner {
197         require (now > getSaleEnd());
198         //Burn outstanding
199         totalSupply = totalSupply.sub(balances[address(this)]);
200         balances[address(this)] = 0;
201     }
202 
203   function getStage() public constant returns (uint256) {
204         for (uint8 i = 1; i < saleStageStartDates.length; i++) {
205             if (now < saleStageStartDates[i]) {
206                 return i -1;
207             }
208         }
209 
210         return saleStageStartDates.length - 1;
211     }
212 
213     event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);
214     event Transfer(address indexed _from, address indexed _to, uint256 _value);
215     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
216     event Withdraw(address indexed _owner, uint256 _value);
217 }