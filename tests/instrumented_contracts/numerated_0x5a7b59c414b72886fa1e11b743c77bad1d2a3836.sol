1 pragma solidity >= 0.4.22 < 0.6.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5       // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
6       // benefit is lost if 'b' is also tested.
7       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
8       if (a == 0) {
9         return 0;
10       }
11       c = a * b;
12       assert(c / a == b);
13       return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17       // assert(b > 0); // Solidity automatically throws when dividing by 0
18       // uint256 c = a / b;
19       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20       return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24       assert(b <= a);
25       return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29       c = a + b;
30       assert(c >= a);
31       return c;
32     }
33 }
34 
35 contract Token {
36     using SafeMath for uint256;
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39     mapping(address => uint256) balances;
40 	mapping(address => bool) public frozenAccount;
41     uint256 totalSupply_;
42     mapping (address => mapping (address => uint256)) internal allowed;
43 
44     function totalSupply() public view returns (uint256) {
45       return totalSupply_;
46     }
47 
48     function balanceOf(address _owner) public view returns (uint256) {
49       return balances[_owner];
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool) {
53       require(_value <= balances[msg.sender]);
54       require(_to != address(0));
55       balances[msg.sender] = balances[msg.sender].sub(_value);
56       balances[_to] = balances[_to].add(_value);
57       emit Transfer(msg.sender, _to, _value);
58       return true;
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
62       require(_value <= balances[_from], "Not enough balance");
63       //require(_value <= allowed[_from][msg.sender]);
64       //require(_to != address(0));
65       balances[_from] = balances[_from].sub(_value);
66       balances[_to] = balances[_to].add(_value);
67       //allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
68       emit Transfer(_from, _to, _value);
69       return true;
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool) {
73       allowed[msg.sender][_spender] = _value;
74       emit Approval(msg.sender, _spender, _value);
75       return true;
76     }
77 
78     function allowance(address _owner,address _spender) public view returns (uint256) {
79       return allowed[_owner][_spender];
80     }
81 
82     function increaseApproval(address _spender, uint256 _addedValue)
83         public returns (bool) {
84       allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
85       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86       return true;
87     }
88 
89     function decreaseApproval(address _spender, uint256 _subtractedValue)
90         public returns (bool) {
91       uint256 oldValue = allowed[msg.sender][_spender];
92       if (_subtractedValue >= oldValue) {
93         allowed[msg.sender][_spender] = 0;
94       } else {
95         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
96       }
97 
98       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99       return true;
100     }
101 }
102 
103 contract Stablecoin is Token {
104     string public name = 'Mundo Gold Tethered';
105     string public symbol = 'MGT';
106     uint256 public decimals = 4;
107     address payable public owner;
108     uint256 public totalSupplyLimit_;
109     event BuyToken(address from, address to, uint256 value);
110     event SellToken(address from, address to , uint256 value);
111     event Minted(address to, uint256 value);
112     event Burn(address burner, uint256 value);
113 	event FrozenFunds(address target, bool frozen);
114 
115     modifier onlyOwner {
116       require(msg.sender == owner);
117       _;
118     }
119 
120     constructor (//uint256 _STOEndTime
121         )  public Token() {
122       //require(_STOEndTime > 0);
123       totalSupplyLimit_ = 2500000000000;
124       owner = msg.sender;
125       mint(owner, totalSupplyLimit_);
126     }
127 
128     function mint(address _to, uint256 _value) public
129         returns (bool)
130     {
131       if (totalSupplyLimit_ >= totalSupply_ + _value) {
132         balances[_to] = balances[_to].add(_value);
133         totalSupply_ = totalSupply_.add(_value);
134         emit Minted(_to, _value);
135         return true;
136       }
137       return false;
138     }
139 
140     /* If the transfer request comes from the STO, it only checks that the
141     investor is in the whitelist
142     * If the transfer request comes from a token holder, it checks that:
143     * a) Both are on the whitelist
144     * b) Seller's sale lockup period is over
145     * c) Buyer's purchase lockup is over
146     */
147     function verifyTransfer(uint256 _value)
148         public pure returns (bool) {
149       require(_value >= 0);
150       return true;
151     }
152 
153     function burnTokens(address _investor, uint256 _value) public {
154       balances[_investor] = balances[_investor].sub(_value);
155       totalSupply_ = totalSupply_.sub(_value);
156       emit Burn(owner, _value);
157     }
158 
159     function buyTokens(address _investor, uint256 _amount) public {
160       //require(_investor != address(0));
161       //require(_amount > 0);
162       emit BuyToken(owner, _investor, _amount);
163       transferFrom(owner, _investor, _amount);
164     }
165 
166     function sellTokens(address _investor, uint256 _amount) public {
167       //require(_investor != address(0));
168       //require(_amount > 0);
169       emit SellToken(_investor, owner, _amount);
170       //transferFrom(_investor, owner, _amount);
171       burnTokens(_investor, _amount);
172     }
173 
174     /// @notice Override the functions to not allow token transfers until the end
175     function transfer(address _to, uint256 _value) public returns(bool) {
176       //require(verifyTransfer( owner, _to, _value ));
177         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
178       return super.transfer(_to, _value);
179     }
180 
181     /// @notice Override the functions to not allow token transfers until the end
182     function transferFrom(address _from, address _to, uint256 _value) public
183         returns(bool) {
184         require(!frozenAccount[_from]);                     // Check if sender is frozen
185       //require(verifyTransfer(_from, _to, _value));
186       return super.transferFrom(_from, _to, _value);
187     }
188 
189     /// @notice Override the functions to not allow token transfers until the end
190     function approve(address _spender, uint256 _value) public returns(bool) {
191       return super.approve(_spender, _value);
192     }
193 
194     /// @notice Override the functions to not allow token transfers until the end
195     function increaseApproval(address _spender, uint _addedValue) public
196         returns(bool success) {
197       return super.increaseApproval(_spender, _addedValue);
198     }
199 
200     /// @notice Override the functions to not allow token transfers until the end
201     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool success) {
202       return super.decreaseApproval(_spender, _subtractedValue);
203     }
204 
205     function emergencyExtract() external onlyOwner {
206       owner.transfer(address(this).balance);
207     }
208     
209     function freezeAccount(address target, bool freeze) onlyOwner public {
210         frozenAccount[target] = freeze;
211         emit FrozenFunds(target, freeze);
212     }
213 	
214 	function kill() onlyOwner() public{
215 	    selfdestruct(msg.sender);
216     }
217 }